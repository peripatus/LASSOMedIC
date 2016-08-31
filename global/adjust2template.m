
function roi_new= adjust2template(roi,template)

%% adjust size and center of template to that of MNI atlas
%
%[BAlabels,BAnom, Vsize]= MNIvol(roi_org,template)
% input:      roi_org ... original image file
%            template ... file name of mask
%                opt ... interpolation option (default: linear)
% output:   BAlabels ... 3D volume of mask size with entries indicating the
% brain areas
%           BAnom ... nomeclature for labels
%       Vsize_new ... voxelsize of produced MNImask (= voxelsize of template)

%% load template data
[~, VdimT, Vsize_new] = load_analyze_to_left(template); % fMRI image

%% assign header of template to new roi
roi_new = load_nii(template);
centerT = roi_new.hdr.hist.originator(1:3);  % get center

% load roi
tmp = load_nii(roi); % roifile
origin = tmp.hdr.hist.originator(1:3);  clear tmp    
[vol3D, Vdim, Vsize] = load_analyze_to_left(roi);
        
% rescale if necessary    
% resize v?oxels 
Vdim_new = round(Vdim.*Vsize./Vsize_new);
if nargin>1
    vol3D = volResize(double(vol3D),Vdim_new);
else
    vol3D = volResize(double(vol3D),Vdim_new);
end

% center of non scaled template (vol3D)
origin(1) = Vdim(1)-origin(1)+1;
     
% center of scaled template (vol3D)
c_new = [origin(1)*Vsize(1)/Vsize_new(1),origin(2)*Vsize(2)/Vsize_new(2),origin(3)*Vsize(3)/Vsize_new(3)];
     

if sum(Vdim_new) > sum(VdimT)
    dd = ceil(c_new-centerT); 
    % zeropadd if necessary
    
    if dd(1)<0
        vol3D = cat(1,zeros(abs(dd(1)),size(vol3D,2),size(vol3D,3)),vol3D);
        dd(1)= 0;
    end
    if dd(2)<0
        vol3D = cat(2,zeros(size(vol3D,1),abs(dd(2)),size(vol3D,3)),vol3D);
         dd(2)= 0;
    end
    if  dd(3)<0
        vol3D = cat(3,zeros(size(vol3D,1),size(vol3D,2),abs(dd(3))),vol3D);
         dd(3)= 0;
    end
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
        vol3D = vol3D(1:min(VdimT(1),Vdim_new(1)),1:min(VdimT(2),Vdim_new(2)),1:min(VdimT(3),Vdim_new(3)));
     
end
    
    roi_new.img = vol3D;
     save_nii(roi_new,'test')