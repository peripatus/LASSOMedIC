

clear
%% load your matrix here (mvalues = (NSubjects x NFeatures), label = logical(NSubjects,1) , depressed1 or non-depressed -1)

load featureMatrix/FCclosep001STDAge_sc1SFRnetMean


if size(mvalues,2)==2
    plotFlag = 'true';
else
    plotFlag = 'false';
end

label = double(label);
N1 = sum(label==0);
N2 = sum(label==1);

label(label==0) = -1; %% <<< for svmtrain, the labels have to be -1, 1

for shufflei =1:10%%  best practice for small datasets is to shuffle the data and see how stable the results are
    Ncross= 10; %(10 fold cross validation)
     
         % number subjects according to Ncross
         subN1 = rem(1:N1,Ncross)+1;
         subN2 = rem(1:N2,Ncross)+1;
         
        rng(shufflei)
        subN1 = subN1(randperm(N1));
        rng(shufflei)
        subN2 = subN2(randperm(N2));
        
         for crossi = 1:Ncross
             %  crossi
               [trainIdx, testIdx] = getCVidx(subN1,subN2,crossi);
                mtrain = mvalues(trainIdx,:);
                labeltrain = label(trainIdx);
             %   base=mean(mtrain(label(trainIdx)==-1,:));
	     %    scale = std(mtrain(label(trainIdx)==-1,:));
           %     mtrain = (mtrain-base)/scale; %% normalisation of the data with mean and std of training data!!
             
                svmStruct = svmtrain(mtrain,labeltrain,'showplot',plotFlag);
            %   svmStruct = svmtrain(mtrain,labeltrain,'kernel_function','rbf','showplot','true');
            %   svmStruct = svmtrain(mtrain,labeltrain,'kernel_function','polynomial','polyorder',3);%,'showplot','true');

               mtest = (mvalues(testIdx,:));
	       %mtest = (mvalues(testIdx,:)) - repmat(base,[length(testIdx),1]))./repmat(scale, [length(testIdx),1]) ; 
                              
		pred(testIdx) = svmclassify(svmStruct, mtest); 
               
               z{shufflei}{crossi}=compSVMMargin(svmStruct,mtest,tmp);
               pp{shufflei}{crossi} = 1./(1+exp(-z{shufflei}{crossi}));
            
        %     svm{crossi} = svmStruct;
          end
         clear LL
    accuracy(shufflei)= mean((pred-label)==0); %% percentage correctly predicted 
    sensitivity(shufflei) = mean(pred(label==1)==1);% percentage correctly predicted patients
    specificity(shufflei)=  mean(pred(label==-1)==-1);% percentage correctly predicted controls
end

display(['sensitivity =', num2str(mean(sensitivity)),'+/-',num2str(std(sensitivity))])
display(['specificity =', num2str(mean(specificity)),'+/-',num2str(std(specificity))])
display(['accuracy =', num2str(mean(accuracy)),'+/-',num2str(std(accuracy))])

%%%%%