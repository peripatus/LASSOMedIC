

function vol_scaled = volResize(v,Snew,option)

% resizes 3D volumes using interp3 and linear interpolation
% usage: vol_scaled = volResize(v,Snew,option)
% v ....... original volume
% Snew .... size of new volume
% option ...  'nearest', 'linear', 'spline', 'cubic'   

Sold = size(v);

dx = (Sold(1)-1)/(Snew(1)-1);
dy = (Sold(2)-1)/(Snew(2)-1);
dz = (Sold(3)-1)/(Snew(3)-1);


[xi,yi,zi] = meshgrid(1:dy:Sold(2),1:dx:Sold(1),1:dz:Sold(3));

if nargin==2
    vol_scaled = interp3(v,xi,yi,zi);
else
    vol_scaled = interp3(v,xi,yi,zi,option);
end