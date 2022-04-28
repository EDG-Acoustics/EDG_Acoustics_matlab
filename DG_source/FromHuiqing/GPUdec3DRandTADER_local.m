% Purpose: Declare GPU variables
%
% By Huiqing Wang.  h.wang6@tue.nl
%% recording
if op_record~=0
Gprec=setArrayType(prec, useGPU, useSingle);
GgVM=setArrayType(gVM, useGPU, useSingle);
Gkth=setArrayType(kth, useGPU, useSingle);
end
%% time integration
Grkf84a=setArrayType(rkf84a, useGPU, useSingle);
Grkf84b=setArrayType(rkf84b, useGPU, useSingle);
Grk4a=setArrayType(rk4a, useGPU, useSingle);
Grk4b=setArrayType(rk4b, useGPU, useSingle);
INTRK=setArrayType(1, useGPU, useSingle);
GtimeLevel=setArrayType(1, useGPU, useSingle);
GnTimeLevels=setArrayType(nTimeLevels, useGPU, useSingle);
Gdt=setArrayType(dt, useGPU, useSingle);
Gtime=setArrayType(time, useGPU, useSingle);
%% constants
Gc0=setArrayType(c0, useGPU, useSingle);
Grho0=setArrayType(rho0, useGPU, useSingle);


%% grad
GDr=setArrayType(Dr, useGPU, useSingle);
GDs=setArrayType(Ds, useGPU, useSingle);
GDt=setArrayType(Dt, useGPU, useSingle);

Grx=setArrayType(rx, useGPU, useSingle);
Gsx=setArrayType(sx, useGPU, useSingle);
Gtx=setArrayType(tx, useGPU, useSingle);

Gry=setArrayType(ry, useGPU, useSingle);
Gsy=setArrayType(sy, useGPU, useSingle);
Gty=setArrayType(ty, useGPU, useSingle);

Grz=setArrayType(rz, useGPU, useSingle);
Gsz=setArrayType(sz, useGPU, useSingle);
Gtz=setArrayType(tz, useGPU, useSingle);

%% routine
% GmapB=setArrayType(mapB, useGPU, useSingle);
% GvmapB=setArrayType(vmapB, useGPU, useSingle);
GvmapM=setArrayType(vmapM, useGPU, useSingle);
GvmapP=setArrayType(vmapP, useGPU, useSingle);
Gnx=setArrayType(nx, useGPU, useSingle);
Gny=setArrayType(ny, useGPU, useSingle);
Gnz=setArrayType(nz, useGPU, useSingle);
%%
Gdu=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gdv=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gdw=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gdp=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);

Gfluxu=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gfluxv=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gfluxw=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);
Gfluxp=setArrayType(zeros(Nfp*Nfaces,K), useGPU, useSingle);

% Gux=setArrayType(zeros(Np,K), useGPU, useSingle);
% Gvy=setArrayType(zeros(Np,K), useGPU, useSingle);
% % Gwz=setArrayType(zeros(Np,K), useGPU, useSingle);
% 
% Gpx=setArrayType(zeros(Np,K), useGPU, useSingle);
% Gpy=setArrayType(zeros(Np,K), useGPU, useSingle);
% % Gpz=setArrayType(zeros(Np,K), useGPU, useSingle);

GLIFT=setArrayType(LIFT, useGPU, useSingle);
GFscale=setArrayType(Fscale, useGPU, useSingle);

%% ADER
GU=setArrayType(U, useGPU, useSingle);
GV=setArrayType(V, useGPU, useSingle);
GW=setArrayType(W, useGPU, useSingle);
GP=setArrayType(P, useGPU, useSingle);
Gu=setArrayType(U, useGPU, useSingle);
Gv=setArrayType(V, useGPU, useSingle);
Gw=setArrayType(W, useGPU, useSingle);
Gp=setArrayType(P, useGPU, useSingle);
Gtp=setArrayType(P, useGPU, useSingle);

%% upwind flux const
Gcn1s=setArrayType(cn1s, useGPU, useSingle);
Gcn1n2=setArrayType(cn1n2, useGPU, useSingle);
Gcn1n3=setArrayType(cn1n3, useGPU, useSingle);
Gcn2s=setArrayType(cn2s, useGPU, useSingle);
Gcn2n3=setArrayType(cn2n3, useGPU, useSingle);
Gcn3s=setArrayType(cn3s, useGPU, useSingle);

Gn1rho=setArrayType(n1rho, useGPU, useSingle);
Gn2rho=setArrayType(n2rho, useGPU, useSingle);
Gn3rho=setArrayType(n3rho, useGPU, useSingle);

Gcsn1rho=setArrayType(csn1rho, useGPU, useSingle);
Gcsn2rho=setArrayType(csn2rho, useGPU, useSingle);
Gcsn3rho=setArrayType(csn3rho, useGPU, useSingle);

%% BC
GmapCN=setArrayType(mapCN, useGPU, useSingle);
GvmapCN=setArrayType(vmapCN, useGPU, useSingle);
GmapS=setArrayType(mapS, useGPU, useSingle);
GvmapS=setArrayType(vmapS, useGPU, useSingle);
GmapIM=setArrayType(mapIM, useGPU, useSingle);
GvmapIM=setArrayType(vmapIM, useGPU, useSingle);
for i=1:num_bc
    eval(['Gun',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU, useSingle);']);
    eval(['Gou',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU, useSingle);']);
    eval(['GRin',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU, useSingle);']);
end
for i=1:num_bc
    eval(['GmapIM',num2str(i),'=setArrayType(mapIM',num2str(i),', useGPU, useSingle);']);
    eval(['GvmapIM',num2str(i),'=setArrayType(vmapIM',num2str(i),', useGPU, useSingle);']);
end

for i=1:Tnum_bc
    eval(['GTun',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU, useSingle);']);
    eval(['GTou',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU, useSingle);']);
    eval(['GTRin',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU, useSingle);']);
    eval(['GTin',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU, useSingle);']);
end
for i=1:Tnum_bc
    eval(['GmapT',num2str(i),'=setArrayType(mapT',num2str(i),', useGPU, useSingle);']);
    eval(['GvmapT',num2str(i),'=setArrayType(vmapT',num2str(i),', useGPU, useSingle);']);
    eval(['GvmapTP',num2str(i),'=setArrayType(vmapTP',num2str(i),', useGPU, useSingle);']);
end    
%% impedance
 if exist('R')
GR=setArrayType(R, useGPU, useSingle);
 end
  if exist('T')
GT=setArrayType(T, useGPU, useSingle);
  end
for i=1:num_bc
    eval(['GR',num2str(i),'=setArrayType(R',num2str(i),', useGPU, useSingle);']);
end
%% R impedance 1st
Gi_Rpole=setArrayType(1, useGPU, useSingle);
for i=1:num_bc
    eval(['GRA',num2str(i),'=setArrayType(RA',num2str(i),', useGPU, useSingle);']);
    eval(['GRlambda',num2str(i),'=setArrayType(Rlambda',num2str(i),', useGPU, useSingle);']);
    eval(['GRn_expan_R',num2str(i),'=setArrayType(Rn_expan_R',num2str(i),', useGPU, useSingle);']);
    eval(['GRphi',num2str(i),'=setArrayType(zeros(length(vmapIM',num2str(i),'),Rn_expan_R',num2str(i),'), useGPU, useSingle);']);
    eval(['GRPHI',num2str(i),'=GRphi',num2str(i),';']);
end
if  Rn_expan_R~=0
    GRA=setArrayType(RA, useGPU, useSingle);
    GRlambda=setArrayType(Rlambda, useGPU, useSingle);

    Gi_Rpole=setArrayType(1, useGPU, useSingle);
    GRn_expan_R=setArrayType(Rn_expan_R, useGPU, useSingle);
    GRphi1=setArrayType(zeros(length(vmapIM),Rn_expan_R), useGPU, useSingle);
    GRPHI1=GRphi1;
    if transmission==1
        GRphi3=setArrayType(zeros(length(vmapS),Rn_expan_R), useGPU, useSingle);
        GRPHI3=GRphi3;
    end
else
    Gi_Rpole=setArrayType(1, useGPU, useSingle);
    GRn_expan_R=setArrayType(Rn_expan_R, useGPU, useSingle);
end


