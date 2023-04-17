function dtscale = dtscale2Dmy;

% function dtscale = dtscale2D;
% Purpose : Compute minimum length
%           for grid to choose timestep

Globals2D;

%% minimum length mine
p=[VX;VY]'; 
d12=p(EToV(:,2),:)-p(EToV(:,1),:);
d13=p(EToV(:,3),:)-p(EToV(:,1),:);
d23=p(EToV(:,3),:)-p(EToV(:,2),:);
length_edge=[sqrt(d12(:,1).^2+d12(:,2).^2),...
    sqrt(d13(:,1).^2+d13(:,2).^2),...
    sqrt(d23(:,1).^2+d23(:,2).^2)];
dtscale=min(length_edge(:));
return;