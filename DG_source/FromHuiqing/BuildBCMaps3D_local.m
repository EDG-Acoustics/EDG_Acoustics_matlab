% function BuildBCMaps3D()
% 
% % function BuildBCMaps3D
% % Purpose: Build specialized nodal maps for various types of boundary conditions,
% %           specified in BCType. 
% 
% Globals3D;

% create label of face nodes with boundary types from BCType
bct    = BCType';
bnodes = ones(Nfp, 1)*bct(:)'; bnodes = bnodes(:);
% find location of boundary nodes in face and volume node lists
% mapI = find(bnodes==In);           vmapI = vmapM(mapI);
% mapO = find(bnodes==Out);	   vmapO = vmapM(mapO);
% mapW = find(bnodes==Wall);         vmapW = vmapM(mapW);
% mapF = find(bnodes==Far);          vmapF = vmapM(mapF);
% mapC = find(bnodes==Cyl);          vmapC = vmapM(mapC);
% mapD = find(bnodes==Dirichlet);    vmapD = vmapM(mapD);
% mapN = find(bnodes==Neuman);       vmapN = vmapM(mapN);

mapS = find(bnodes==Slip);         vmapS = vmapM(mapS);
mapCN = find(bnodes==CNRBC);       vmapCN = vmapM(mapCN);
mapIM = find(bnodes==Impedance);   vmapIM = vmapM(mapIM);
for i=1:num_bc
    eval(['mapIM',num2str(i),' = find(bnodes==Impedance',num2str(i),');']);
    eval(['vmapIM',num2str(i),' = vmapM(mapIM',num2str(i),');']);
end

for i=1:Tnum_bc
    eval(['mapT',num2str(i),' = find(bnodes==Trans',num2str(i),');']);
    eval(['vmapT',num2str(i),' = vmapM(mapT',num2str(i),');']);
    eval(['vmapTP',num2str(i),' = vmapP(mapT',num2str(i),');']);
end
%%%%%%%%%local%%%%%%%%%


