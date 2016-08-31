
function [BA, area, stat] = getBrainAreas(BAnom, BAlabelvol,features,ind)


%% usage:
%%
%% [BA, area, stat] = getBrainAreas(BAnom, BAlabelvol,features,ind);
%% 
%% input: BAlabelvol ... 3D volume with brain area labels
%%        features ..... variable provided with mvalues
%%        ind  ......... feature indices 
%% output: BA ... Brain area for each voxel
%%         area ... struct (string!)
%%         area.noarea .... number of voxels for which no area could be assigned
%%         area.BA ... Brainareas for which voxels were selected
%%         area.ind ... indices of voxels in that area
%%         BA.Vselected ... number of selected voxels in each brainarea of area.BA
%%         BA.Vall ..... number of all voxels in each brainarea of area.BA
%%         BA.* : xx (xx%)    .... Brainarea: #selected voxels (percentage of associated brain area)
%%         stat ... selected voxels in each brain area in % of all voxels in that brain area


BAlabelvol_s = BAlabelvol(features);
areaNr = BAlabelvol_s(ind);
[~,iind] = sort(areaNr);
indsort = ind(iind);

stat.N = hist(BAlabelvol_s(BAlabelvol_s~=0),1:length(BAnom));
stat.Nind = hist(areaNr,1:length(BAnom));
fb = find(stat.Nind);

statind = cumsum([0, stat.Nind(fb)]);

area.noarea = sum(areaNr==0);
stat.Nind(1) = stat.Nind(1)-area.noarea; % correct first bin for zero entries
area.BAnum = fb;
for bi = 1:length(fb);    
    area.BA{bi}= BAnom(fb(bi)).Nom_L;       
    area.ind{bi} = indsort(1+statind(bi):statind(bi+1)); % indices (of features) belonging to brainarea bi
    area.Vselected(bi)=stat.Nind(fb(bi));
    area.Vall(bi) = stat.N(fb(bi));
    statstr = [num2str(stat.Nind(fb(bi))),' (',num2str(area.Vselected(bi)/area.Vall(bi)*100),'%)'];
 %   ['area.',BAnom(fb(bi)).Nom_L,'= statstr;']
    BAnom(fb(bi)).Nom_L = strrep(BAnom(fb(bi)).Nom_L,'-','');
    eval(['area.',BAnom(fb(bi)).Nom_L,'= statstr;']);  % << change to string!! 
end


BA = cell(1,length(areaNr));
for ai = 1:length(areaNr)
    if areaNr(ai)~=0
        BA{ai} = BAnom(areaNr(ai)).Nom_L;
    end
end
stat = stat.Nind(fb)./stat.N(fb)*100;


