
function [BAlabelvol,BAnom, Vsize_new, c_new]= JHUvol(template,opt)

%% adjust size and center of template to that of MNI atlas
%
%[BAlabels,BAnom, Vsize]= MNIvol(template, opt)
% input:    template ... file name of mask
%             atlas .... white matter(1) or tract(2)
%                opt ... interpolation option (default: linear)
% output:   BAlabels ... 3D volume of mask size with entries indicating the
% brain areas
%           BAnom ... nomeclature for labels
%       Vsize_new ... voxelsize of produced MNImask (= voxelsize of template)


datapath = '/Users/yu/matlab_misc/fsl/data/atlases/JHU/';
source = {'JHU-WhiteMatter-labels-2mm.nii' % already done
         'JHU-ICBM-tracts-maxprob-thr0-2mm.nii'};
     
list = {'JHUwhiteLabels'
         'JHUtractLabels'}

%% load indexed volume (voxelsize 2x2x2)
bfile = [datapath, source{atlas}];
[vol3D, Vdim, Vsize] = load_analyze_to_left(bfile);

%% load list of brainareas
load(['/Volumes/Macintosh HD 2/ProjectF/Data/2012_HIRODAI_2/Analysis/atlas/', list{atlas}],'BAnom')

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
        else
            %brain_t = volResize(brain_t,Vdim_new);
            vol3D = volResize(double(vol3D),Vdim_new);
        end
    else
          Vdim_new=Vdim;
    end
                
    
     % center of non scaled MNI (vol3D)
     origin(1) = Vdim(1)-origin(1)+1;
     
     % center of scaled MNI (vol3D)
     c_new = [origin(1)*Vsize(1)/Vsize_new(1),origin(2)*Vsize(2)/Vsize_new(2),origin(3)*Vsize(3)/Vsize_new(3)];
     
     if sum(Vdim_new) > sum(VdimT)
         dd = ceil(c_new-centerT); 
         vol3D = vol3D(dd(1)+1:dd(1)+VdimT(1),dd(2)+1:dd(2)+VdimT(2),dd(3)+1:dd(3)+VdimT(3));
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
        vol3D = tmp(istart(1):iend(1),istart(2):iend(2),istart(3):iend(3));
        vol3D = vol3D(1:VdimT(1),1:VdimT(2),1:VdimT(3));
        
     end

%      template.img = vol3D;
%      save_nii(template,'test')
%      pause
%      
     
    %% relabel voxels according to number in Nom_L
    vol3D = ceil(vol3D); 
    vol3D(vol3D > 9170) =  9170;
 
    BAlabelvol=vol3D;
%    BAnom = ROI;
   
    