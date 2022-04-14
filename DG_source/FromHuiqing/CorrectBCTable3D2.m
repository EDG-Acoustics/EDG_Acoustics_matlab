function BCType = CorrectBCTable3D2(EToV,BCType,tri_,BCcode)
% Purpose: correct BC table
%
% By Huiqing Wang.  h.wang6@tue.nl
Globals3D;


tri_=sort(tri_,2);
VNUM = [1 2 3;1 2 4; 2 3 4; 1 3 4];  % the numbering is NOT according to the numbering in code tiConnect3D
for indexl=1:4
    Face=sort(EToV(:,VNUM(indexl,:)),2);

    K_=ismember(Face,tri_,'rows');
    
    BCType(K_,indexl)=BCcode;
end

return