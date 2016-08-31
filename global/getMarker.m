
function [B,submarkers,subjectsD,subjectsN,Ball] = getMarker(subjects,markers)

%% usage: [B,submarkers,subjectsD,subjectsN] = getMarker(subjects,markers)
%% input: subjects ... cellarray with subjectsID
%%        markers ..... cellarray with markers to extract 
%% output: B ... struct with biomarker values
%% ... separate matrices for N and D

load('Data','Data')

%markers = Data.features;
label = ~cellfun(@isempty,strfind(subjects,'D'));

subjectsD = find(label==1);
subjectsN = find(label==0);


%% fMRI behaviour results
[~,ticSD,ticAllD] = intersect(subjects(subjectsD),Data.subjects.all,'stable');
[~,ticSN,ticAllN] = intersect(subjects(subjectsN),Data.subjects.all,'stable');
[~,ticSall,ticAll] = intersect(subjects,Data.subjects.all,'stable');


if isempty(tic)
    display('subject not found')
    return
end
%%

for fi = 1:length(markers)
    eval(['B.',markers{fi},'D(ticSD,:)=Data.',markers{fi},'(ticAllD,:);'])
    eval(['B.',markers{fi},'N(ticSN,:)=Data.',markers{fi},'(ticAllN,:);'])
    eval(['Ball.',markers{fi},'All(ticSall,:)=Data.',markers{fi},'(ticAll,:);'])
    
    submarkers{fi} = eval(['Data.features.',markers{fi},';']);
end

subjectsD = subjects(subjectsD);
subjectsN = subjects(subjectsN);


