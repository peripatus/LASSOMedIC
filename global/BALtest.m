
load('/Volumes/Macintosh HD 2/ProjectF/Data/2012_HIRODAI_2/REST/FC/FC_Hirodai/ROITBL/ROITBL_BAL.mat')

%%
thresh = 0.5;
test = MAP;
test(test>=thresh) =1;
test(test<thresh) = 0;

foverlap  = sum(test,4)>1;

vol = zeros(size(squeeze(test(:,:,:,1))));
for mi = 1:size(test,4)
    vol=vol+squeeze(test(:,:,:,mi)).*mi;
end
vol(foverlap) = 0;

figure
slice(vol,30,30,30)
%%
img = load_nii('BAL80.nii');
img.img = vol;

save_nii(img,['BAL',num2str(thresh*100),'.nii'])

%%
img.img(img.img(:)>=138) = 0; % exclude cerebellum
save_nii(img,['BAL',num2str(thresh*100),'_noCereb.nii'])
