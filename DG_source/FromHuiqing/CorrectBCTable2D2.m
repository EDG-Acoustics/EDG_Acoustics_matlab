function BCType = CorrectBCTable2D2(EToV,BCType,mapnodes,BCcode)
% used for one interface with two different boundary conditions
% function BCType = CorrectBCTable(EToV,BCType,mapnodes,BCcode);
% Purpose: Setup BCType for boundary conditions in 2D
% By Huiqing Wang.

Globals2D;

% mapnodes=sort(mapnodes,2);
VNUM = [1 2;2 3;3 1]; % face orientations

for l=1:3
    Face=EToV(:,VNUM(l,:));
    K_=ismember(Face,mapnodes,'rows');
    BCType(K_,l)=BCcode;

end

return


