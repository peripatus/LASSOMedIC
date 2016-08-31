 function mw = weightgroups(m,bins)
 % usage:   mw = weightgroups(m,bins)
 % input:   m ...
 %          bins ... nr of items per group
 %          mw ... values weigthed by sqrt(nr of items) in each group
 
     nn = [0 cumsum(bins)];
         %% weight voxels with sqrt(N)
        for bi = 1:length(bins)
            mw(:,nn(bi)+1:nn(bi+1)) = m(:,nn(bi)+1:nn(bi+1))./sqrt(bins(bi));        
        end        
  