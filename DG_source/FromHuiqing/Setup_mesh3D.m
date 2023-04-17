% Purpose: read GMSH mesh
%
% By Huiqing Wang.  h.wang6@tue.nl
VX = mesh_T.POS(:,1)';
VY = mesh_T.POS(:,2)';
VZ = mesh_T.POS(:,3)';
Nv = length(VX);
K = mesh_T.nbTets;
EToV = mesh_T.TETS([1:K],[1:4]); 
BCtris=mesh_T.TRIANGLES([1:mesh_T.nbTriangles],:);
tri_CNRBC= BCtris(find(BCtris(:,4)==12),1:3);
tri_slip= BCtris(find(BCtris(:,4)==11),1:3);
tri_impedance= BCtris(find(BCtris(:,4)==33),1:3);

tri_impedance1= BCtris(find(BCtris(:,4)==13),1:3);
tri_impedance2= BCtris(find(BCtris(:,4)==14),1:3);
tri_impedance3= BCtris(find(BCtris(:,4)==15),1:3);

tri_trans1= BCtris(find(BCtris(:,4)==23),1:3);
tri_trans2= BCtris(find(BCtris(:,4)==24),1:3);
tri_trans3= BCtris(find(BCtris(:,4)==25),1:3);
% for i=1:num_bc
% tri_real{i}= BCtris(find(BCtris(:,4)==20+i),1:3);
% end

clear mesh_T;


if Nv~=length(VX)
    error('number of vertices has changed by fixmesh')
    Nv = length(VX);
end
if K~=length(EToV(:,1));
    error('number of elements has changed by fixmesh')
    K=length(EToV(:,1));
end




