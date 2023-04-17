
%% version from 24/05/2019
BCType = zeros(K,3);
BCType = CorrectBCTable2D2(EToV,BCType,nodes_CNRBC,CNRBC);
BCType = CorrectBCTable2D2(EToV,BCType,nodes_impedance,Impedance);
BCType = CorrectBCTable2D2(EToV,BCType,nodes_slip,Slip);

BuildBCMaps2D;
vmapSP=vmapP(mapS);
vmapIMP=vmapP(mapIM);