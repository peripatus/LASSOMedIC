function fOpt = getfOptROC(spec,sens,p_spec,p_sens,lambda)

   
    % distance to ROC line 
    Q1 = [0,0];  
    Q2 = [1,1];

    nlambda =length(lambda);
    for li = 1:nlambda
        P=[1-spec(li),sens(li)]; 
        d(li) = det([Q2-Q1;P-Q1])/norm(Q2-Q1); 
    end

    % exclude lambda where there are no weights
    if max(d(:))==0
        fOpt =1;    
    else
       fd = find(d==max(d(:)));

       if length(fd) == 1
           fOpt = fd;
       else
       AUC = zeros(1,length(fd));
       figure
       hold on
       for fi = 1:length(fd)
            [~,~,~,AUC(fi)] = perfcurve([-ones(size(p_spec(:,1)))',ones(size(p_sens(:,1)))'],[p_spec(:,fd(fi))',p_sens(:,fd(fi))'],1);
       end
            fOpt = fd(AUC==max(AUC));
            fOpt = fOpt(1);
       end
    end
end


