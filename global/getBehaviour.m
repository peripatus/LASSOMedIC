
function B = getBehaviour(subjects)

%% usage: B = getBehaviour(subjects);
%% input: subjects ... cellarray with subjectsID
%% ... separate matrices for N and D
%% output: B ... struct with biomarker values
%%         markers ... struct with biomarker details

load('/Volumes/Macintosh HD 2/ProjectF/Data/2012_HIRODAI_2/Datainfo/Data','Data')

markers = Data.features;

%% fMRI behaviour results
[~,tic,~] = intersect(Data.subjects.all,subjects);

if isempty(tic)
    display('subject not found')
    return
end
%%

label = ~cellfun(@isempty,strfind(subjects,'D'));

subjectsD = (label==1);
subjectsN = (label==0);


% D only data
B.drugD = Data.drug(tic(subjectsD),:);
B.drugN = Data.drug(tic(subjectsN),:);

B.responseD = Data.Treatmentresponse(tic(subjectsD),:);
B.responseN = Data.Treatmentresponse(tic(subjectsN),:);


%%

B.sexD = Data.sex(tic(subjectsD),:);
B.sexN = Data.sex(tic(subjectsN),:);

B.ageD = Data.age(tic(subjectsD));
B.ageN = Data.age(tic(subjectsN));

B.JARTD = Data.IQ(tic(subjectsD),:);
B.JARTN = Data.IQ(tic(subjectsN),:);

B.MINID = Data.MINI(tic(subjectsD),:);
B.MININ = Data.MINI(tic(subjectsN),:);

B.CharacterD = Data.Character(tic(subjectsD),:);
B.CharacterN = Data.Character(tic(subjectsN),:);


B.DiathesisD =  Data.diathesis(tic(subjectsD),:);
B.DiathesisN = Data.diathesis(tic(subjectsN),:);

B.GeneticPolyD = Data.GeneticPoly(tic(subjectsD),:);
B.GeneticPolyN = Data.GeneticPoly(tic(subjectsN),:);

% 6w data

B.severityD = Data.severity(tic(subjectsD),:);
B.severityN = Data.severity(tic(subjectsN),:);

B.severityD6 = Data.severity6w(tic(subjectsD),:);
B.severityN6 = Data.severity6w(tic(subjectsN),:);

B.CharacterBBD = Data.CharacterBB(tic(subjectsD),:);
B.CharacterBBN = Data.CharacterBB(tic(subjectsN),:);

B.CharacterBBD6 = Data.CharacterBB6w(tic(subjectsD),:);
B.CharacterBBN6 = Data.CharacterBB6w(tic(subjectsN),:);

B.AnhD = Data.Anh(tic(subjectsD),:);
B.AnhN = Data.Anh(tic(subjectsN),:);

B.AnhD6 = Data.Anh6w(tic(subjectsD),:);
B.AnhN6 = Data.Anh6w(tic(subjectsN),:);

B.MoodD6 = Data.Mood6w(tic(subjectsD),:);
B.MoodN6 = Data.Mood6w(tic(subjectsN),:);

B.AnxietyD = Data.Anxiety(tic(subjectsD),:);
B.AnxietyN = Data.Anxiety(tic(subjectsN),:);

B.AnxietyD6 = Data.Anxiety6w(tic(subjectsD),:);
B.AnxietyN6 = Data.Anxiety6w(tic(subjectsN),:);


B.BloodMarkersD = Data.BloodMarkers(tic(subjectsD),:);
B.BloodMarkersN = Data.BloodMarkers(tic(subjectsN),:);

B.BloodMarkersD6 = Data.BloodMarkers6w(tic(subjectsD),:);
B.BloodMarkersN6 = Data.BloodMarkers6w(tic(subjectsN),:);


B.BrainvolRatioD = Data.BrainvolRatio(tic(subjectsD),:);
B.BrainvolRatioN = Data.BrainvolRatio(tic(subjectsN),:);

B.BrainvolRatioD6 = Data.BrainvolRatio6w(tic(subjectsD),:);
B.BrainvolRatioN6 = Data.BrainvolRatio6w(tic(subjectsN),:);

% task performance 
% Tasks = Data.features.TaskPerformance; 
% 
% for ti = 1:2
%     eval(['B.TaskPerformance',Tasks{ti},'D= Data.TaskPerformance(tic(subjectsD),ti);'])
%     eval(['B.TaskPerformance',Tasks{ti},'N= Data.TaskPerformance(tic(subjectsN),ti);'])
% 
%     eval(['B.TaskPerformance',Tasks{ti},'D6= Data.TaskPerformance6w(tic(subjectsD),ti);'])
%     eval(['B.TaskPerformance',Tasks{ti},'N6= Data.TaskPerformance6w(tic(subjectsN),ti);'])
% 
% end

% reaction time
load('/Volumes/Macintosh HD 2/ProjectF/Data/2012_HIRODAI_2/DataInfo/ReactionTimes')

[~,sbjN] = intersect(RT.subjects,subjects(subjectsN));
[~,sbjD] = intersect(RT.subjects,subjects(subjectsD));

B.responseSemD = RT.responseSem(sbjD);
B.responseSemN = RT.responseSem(sbjN);
B.responseSemD6 = RT.responseSem6w(sbjD);
B.responseSemN6 = RT.responseSem6w(sbjN);

B.mRTSemD = RT.mRTSem(sbjD);
B.mRTSemN = RT.mRTSem(sbjN);
B.mRTSemD6 = RT.mRTSem6w(sbjD);
B.mRTSemN6 = RT.mRTSem6w(sbjN);

B.responsePhonD = RT.responsePhon(sbjD);
B.responsePhonN = RT.responsePhon(sbjN);
B.responsePhonD6 = RT.responsePhon6w(sbjD);
B.responsePhonN6 = RT.responsePhon6w(sbjN);

B.mRTPhonD = RT.mRTPhon(sbjD);
B.mRTPhonN = RT.mRTPhon(sbjN);
B.mRTPhonD6 = RT.mRTPhon6w(sbjD);
B.mRTPhonN6 = RT.mRTPhon6w(sbjN);

