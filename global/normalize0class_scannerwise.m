
function [nmvalues,scale,base] = normalize0class_scannerwise(mvalues,label, scanner)

%% usage [nmvalues,scale,base] = normalize0class(mvalues,label);
%% normalize using mean and std of observations which are labeled 0
%% base, scale .. cell arrays with 
%% Usage: nmvalues = normalize0class(mvalues,label);

scNR = unique(scanner(:)');

label(label==-1) = 0;

nmvalues = zeros(size(mvalues));
base = cell(1,max(scNR));
scale = base;

%% binaries
binary = [];
    
for fbi = 1:size(mvalues,2)
    if (sum(abs(unique(mvalues(:,fbi)))) == 2) || (sum(abs(unique(mvalues(:,fbi)))) == 1)
        binary = [binary,fbi];        
    end    
end

for sci = scNR
    fn = find((label(:) +scanner(:))==sci);
    fp = find((label(:) +scanner(:))==(sci+1));
    
    if ~isempty(fn)
        [nmvalues(fn,:), scale{sci}, base{sci}] = normalize_feature(mvalues(fn,:),'stdeach','each');
        scale{sci}(scale{sci}==0) = 1;
        scale{sci}(binary) = 1;
        base{sci}(binary) = 0;
    
        nmvalues(fp, :) = (mvalues(fp, :) - repmat(base{sci},[length(fp),1]))./repmat(scale{sci}, [length(fp),1]) ; 
    end
end

nmvalues(:,binary) = mvalues(:,binary);
