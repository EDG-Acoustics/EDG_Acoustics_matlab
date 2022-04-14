VXO = mesh_T.POS(:,1)';
VYO = mesh_T.POS(:,2)';
Nv=length(VXO);
K = mesh_T.nbTriangles;
EToV = mesh_T.TRIANGLES([1:K],[1:3]); 
%EToV=EToV(find(EToV(:,4)==1),1:3);
BClines=mesh_T.LINES([1:mesh_T.nbLines],:);
%%%%%%%%%%%%%
%% used for local
k1=find(mesh_T.TRIANGLES(:,4)==1);
k2=find(mesh_T.TRIANGLES(:,4)==2);
K1=length(k1);
K2=length(k2);

%%%%%%%%%%%%%%%
clear mesh_T;

nodes_slip= BClines(find(BClines(:,3)==11),1:2);
nodes_CNRBC= BClines(find(BClines(:,3)==12),1:2);
nodes_impedance= BClines(find(BClines(:,3)==13),1:2);

% nodes_per1= BClines(find(BClines(:,3)==21),1:2);
% nodes_per2= BClines(find(BClines(:,3)==22),1:2);
% nodes_per3= BClines(find(BClines(:,3)==23),1:2);
% nodes_per4= BClines(find(BClines(:,3)==24),1:2);



[VXY,EToV,pix]=fixmesh([VXO' VYO'],EToV);
VX = VXY(:,1)';
VY = VXY(:,2)';
[pdummy,II]=sort(pix);  % pdummy= pix(II) pdummy(j)= pix(II(j)). pdummy is [1:NV].
nodes_slip=II(nodes_slip);
nodes_CNRBC=II(nodes_CNRBC);
nodes_impedance=II(nodes_impedance);

% nodes_per1=II(nodes_per1);
% nodes_per2=II(nodes_per2);
% nodes_per3=II(nodes_per3);
% nodes_per4=II(nodes_per4);

% VX(II)
% pix(nodes_CNRBC)
% VXN=VXY(:,1)';
% VX(pix)=VXN
if Nv~=length(VX)
    disp('number of vertices has changed by fixmesh')
    Nv = length(VX);
end
if K~=length(EToV(:,1));
    disp('number of elements has changed by fixmesh')
    K=length(EToV(:,1));
end

% triplot(EToVi,VX_T,VY_T)
% axis equal




% nodes_slip= unique([BClines(find(BClines(:,3)==11),1);BClines(find(BClines(:,3)==11),2)]);
% nodes_CNRBC= unique([BClines(find(BClines(:,3)==12),1);BClines(find(BClines(:,3)==12),2)]);
% nodes_impedance= unique([BClines(find(BClines(:,3)==13),1);BClines(find(BClines(:,3)==13),2)]);