
function [B,subM] = getMarkerAll(subjects,markers)

%% usage: B = getMarker(subjects,markers)
%% input: subjects ... cellarray with subjectsID
%%        markers ..... cellarray with markers to extract 
%% output: B = biomarker values
%% submarkers

load('Data','Data')

%markers = Data.features;

[~,tic,ticAll] = intersect(subjects,Data.subjects.all,'stable');
%[s,tic,ticAll] = intersect(subjects,Data.subjects.all,'stable');


if isempty(tic)
    display('subject not found')
    return
end
%%

for fi = 1:length(markers)
    eval(['B.',markers{fi},'(tic,:)=Data.',markers{fi},'(ticAll,:);'])
    subM{fi} = eval(['Data.features.',markers{fi},';']);
end


