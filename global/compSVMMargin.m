function Z = compSVMMargin(svmStruct,X,Y)
%COMPSVMMARGIN Summary of this function goes here
%   Detailed explanation goes here

%
% Scaling input data
%
A=svmStruct.ScaleData.scaleFactor;
B=svmStruct.ScaleData.shift;
XX=repmat(A,[size(X,1),1]).*(X+repmat(B,[size(X,1),1]));

%
% Compute Margin
%
Alpha=svmStruct.Alpha;
b=svmStruct.Bias;
S=svmStruct.SupportVectors;
Z=XX*S'*Alpha+b;

for n=1:length(Z)
   if(sign(Z(n))~=0)
       if(sign(Z(n))~=sign(Y(n)))
           Z=-Z;
       end
       break;
   end
end

end

