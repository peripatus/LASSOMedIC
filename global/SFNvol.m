
function [BAlabelvol,BAnom, Vsize_new, c_new]= SFNvol(template,opt)

%% overlapping areas are discarded!!

%% adjust size and center of template to that of MNI atlas
%
%[BAlabels,BAnom, Vsize]= BALvol(template, opt)
% input:    template ... file name of mask
%                opt ... interpolation option (default:'nearest')
% output:   BAlabelvol3D... 4D(!!) volume of mask size with entries indicating the
% brain areas
%           BAnom ... nomeclature for labels
%       Vsize_new ... voxelsize of produced mask (= voxelsize of template)


%% load indexed volume (voxelsize 2x2x2)
load('ROITBL_SFN','MAP')
MAP = round(MAP);
Nmaps = size(MAP,4); 

vol3D= zeros(size(MAP,1),size(MAP,2),size(MAP,3));
for di = 1:size(MAP,4)
    vol3D = vol3D+squeeze(MAP(:,:,:,di).*di);
    vol3D(vol3D(:)>di) = 0;
end

Vdim = size(vol3D);
Vsize=[2,2,2];


bfile = 'sfr_template.nii';
%[vol3D(:,:,:,si), Vdim, Vsize] = load_analyze_to_left(bfile);
                
%% load list of brainareas
load('ROITBL_SFN','ROI')

%% load data to be masked
[~, VdimT, Vsize_new] = load_analyze_to_left(template);

template = load_nii(template);
centerT = template.hdr.hist.originator(1:3);  %clear template

% reshape to adjust to size of data
    tmp = load_nii(bfile);
    origin = tmp.hdr.hist.originator(1:3);  clear tmp
    
    % make template to manipulate and retrieve origin , obsolete
   % brain_t = zeros(Vdim);
   % brain_t(origin(1),origin(2),origin(3)) = 1; 
                
    % flip first dimension
   % brain_t = brain_t(end:-1:1,:,:);
    
    % rescale if necessary
    if Vsize(1) ~= Vsize_new(1)
        % resize voxels 
        Vdim_new = round(Vdim.*Vsize./Vsize_new);
        if nargin>1
            %brain_t = volResize(brain_t,Vdim_new,'linear');
            vol3D = volResize(double(vol3D),Vdim_new,opt);
            clear tmp
        else
            %brain_t = volResize(brain_t,Vdim_new);
            vol3D = volResize(vol3D,Vdim_new,'nearest');
        end
    else
          Vdim_new=Vdim;
    end
                
    
     % center of non scaled MNI (vol3D(:,:,:,si))
     origin(1) = Vdim(1)-origin(1)+1;
     
     % center of scaled MNI (vol3D(:,:,:,si))
     c_new = [origin(1)*Vsize(1)/Vsize_new(1),origin(2)*Vsize(2)/Vsize_new(2),origin(3)*Vsize(3)/Vsize_new(3)];
     
     if sum(Vdim_new) > sum(VdimT)
         dd = ceil(c_new-centerT); 
         vol3D= vol3D(dd(1)+1:dd(1)+VdimT(1),dd(2)+1:dd(2)+VdimT(2),dd(3)+1:dd(3)+VdimT(3));
     else
     
        % shift from center in template
        shift = centerT - c_new;
        shift = floor(abs(shift)).*sign(shift);
        shifta = abs(shift);
        
        % shift center of scaled MNI to center of template
        % VdimT
        tmp = zeros(Vdim_new(1)+2*shifta(1),Vdim_new(2)+2*shifta(2),Vdim_new(3)+2*shifta(3));
        tmp(shifta(1)+1:shifta(1)+Vdim_new(1),shifta(2)+1:shifta(2)+Vdim_new(2),shifta(3)+1:shifta(3)+Vdim_new(3)) = vol3D;
        istart= shifta+1+shift;
        iend = shifta+Vdim_new+shift;
        vol3D= tmp(istart(1):iend(1),istart(2):iend(2),istart(3):iend(3));
        vol3D= vol3D(1:VdimT(1),1:VdimT(2),1:VdimT(3));
     end

%      template.img = vol3D(:,:,:,si);
%      save_nii(template,'test')
%      pause
%      
     
    %% relabel voxels according to number in Nom_L
    vol3D= ceil(vol3D);
%    vol3D(:,:,:,si)(vol3D(:,:,:,si) > Nmaps) =  0;
   % BAlabelvol = zeros(size(vol3D(:,:,:,si)));
%     
%     for bi = 1:length(ROI)
%         vol3D(:,:,:,si)(vol3D(:,:,:,si) == ROI(bi).ID) = bi;
%     end
    BAlabelvol=vol3D;
   
   
     for ri = 1:length(ROI)
        BAnom(ri).Nom_L = ROI{ri}.name;
        BAnom(ri).ID= ri;
    end