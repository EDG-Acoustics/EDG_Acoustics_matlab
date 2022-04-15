% Purpose: Declare GPU variables
%
% By Huiqing Wang.  h.wang6@tue.nl
%% recording
if op_record~=0
Gprec=setArrayType(prec, useGPU);
GgVM=setArrayType(gVM, useGPU);
Gkth=setArrayType(kth, useGPU);
end
%% time integration
Grkf84a=setArrayType(rkf84a, useGPU);
Grkf84b=setArrayType(rkf84b, useGPU);
Grk4a=setArrayType(rk4a, useGPU);
Grk4b=setArrayType(rk4b, useGPU);
INTRK=setArrayType(1, useGPU);
GtimeLevel=setArrayType(1, useGPU);
GnTimeLevels=setArrayType(nTimeLevels, useGPU);
Gdt=setArrayType(dt, useGPU);
Gtime=setArrayType(time, useGPU);
%% constants
Gc0=setArrayType(c0, useGPU);
Grho0=setArrayType(rho0, useGPU);


%% grad
GDr=setArrayType(Dr, useGPU);
GDs=setArrayType(Ds, useGPU);
GDt=setArrayType(Dt, useGPU);

Grx=setArrayType(rx, useGPU);
Gsx=setArrayType(sx, useGPU);
Gtx=setArrayType(tx, useGPU);

Gry=setArrayType(ry, useGPU);
Gsy=setArrayType(sy, useGPU);
Gty=setArrayType(ty, useGPU);

Grz=setArrayType(rz, useGPU);
Gsz=setArrayType(sz, useGPU);
Gtz=setArrayType(tz, useGPU);

%% routine
% GmapB=setArrayType(mapB, useGPU);
% GvmapB=setArrayType(vmapB, useGPU);
GvmapM=setArrayType(vmapM, useGPU);
GvmapP=setArrayType(vmapP, useGPU);
Gnx=setArrayType(nx, useGPU);
Gny=setArrayType(ny, useGPU);
Gnz=setArrayType(nz, useGPU);
%%
Gdu=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gdv=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gdw=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gdp=setArrayType(zeros(Nfp*Nfaces,K), useGPU);

Gfluxu=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gfluxv=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gfluxw=setArrayType(zeros(Nfp*Nfaces,K), useGPU);
Gfluxp=setArrayType(zeros(Nfp*Nfaces,K), useGPU);

% Gux=setArrayType(zeros(Np,K), useGPU);
% Gvy=setArrayType(zeros(Np,K), useGPU);
% % Gwz=setArrayType(zeros(Np,K), useGPU);
% 
% Gpx=setArrayType(zeros(Np,K), useGPU);
% Gpy=setArrayType(zeros(Np,K), useGPU);
% % Gpz=setArrayType(zeros(Np,K), useGPU);

GLIFT=setArrayType(LIFT, useGPU);
GFscale=setArrayType(Fscale, useGPU);

%% ADER
GU=setArrayType(U, useGPU);
GV=setArrayType(V, useGPU);
GW=setArrayType(W, useGPU);
GP=setArrayType(P, useGPU);
Gu=setArrayType(U, useGPU);
Gv=setArrayType(V, useGPU);
Gw=setArrayType(W, useGPU);
Gp=setArrayType(P, useGPU);
Gtp=setArrayType(P, useGPU);

%% upwind flux const
Gcn1s=setArrayType(cn1s, useGPU);
Gcn1n2=setArrayType(cn1n2, useGPU);
Gcn1n3=setArrayType(cn1n3, useGPU);
Gcn2s=setArrayType(cn2s, useGPU);
Gcn2n3=setArrayType(cn2n3, useGPU);
Gcn3s=setArrayType(cn3s, useGPU);

Gn1rho=setArrayType(n1rho, useGPU);
Gn2rho=setArrayType(n2rho, useGPU);
Gn3rho=setArrayType(n3rho, useGPU);

Gcsn1rho=setArrayType(csn1rho, useGPU);
Gcsn2rho=setArrayType(csn2rho, useGPU);
Gcsn3rho=setArrayType(csn3rho, useGPU);

%% BC
GmapCN=setArrayType(mapCN, useGPU);
GvmapCN=setArrayType(vmapCN, useGPU);
GmapS=setArrayType(mapS, useGPU);
GvmapS=setArrayType(vmapS, useGPU);
GmapIM=setArrayType(mapIM, useGPU);
GvmapIM=setArrayType(vmapIM, useGPU);
for i=1:num_bc
    eval(['Gun',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU);']);
    eval(['Gou',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU);']);
    eval(['GRin',num2str(i),'=setArrayType(zeros(size(mapIM',num2str(i),')), useGPU);']);
end
for i=1:num_bc
    eval(['GmapIM',num2str(i),'=setArrayType(mapIM',num2str(i),', useGPU);']);
    eval(['GvmapIM',num2str(i),'=setArrayType(vmapIM',num2str(i),', useGPU);']);
end

for i=1:Tnum_bc
    eval(['GTun',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU);']);
    eval(['GTou',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU);']);
    eval(['GTRin',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU);']);
    eval(['GTin',num2str(i),'=setArrayType(zeros(size(mapT',num2str(i),')), useGPU);']);
end
for i=1:Tnum_bc
    eval(['GmapT',num2str(i),'=setArrayType(mapT',num2str(i),', useGPU);']);
    eval(['GvmapT',num2str(i),'=setArrayType(vmapT',num2str(i),', useGPU);']);
    eval(['GvmapTP',num2str(i),'=setArrayType(vmapTP',num2str(i),', useGPU);']);
end    
%% impedance
 if exist('R')
GR=setArrayType(R, useGPU);
 end
  if exist('T')
GT=setArrayType(T, useGPU);
  end
for i=1:num_bc
    eval(['GR',num2str(i),'=setArrayType(R',num2str(i),', useGPU);']);
end
%% R impedance 1st
Gi_Rpole=setArrayType(1, useGPU);
for i=1:num_bc
    eval(['GRA',num2str(i),'=setArrayType(RA',num2str(i),', useGPU);']);
    eval(['GRlambda',num2str(i),'=setArrayType(Rlambda',num2str(i),', useGPU);']);
    eval(['GRn_expan_R',num2str(i),'=setArrayType(Rn_expan_R',num2str(i),', useGPU);']);
    eval(['GRphi',num2str(i),'=setArrayType(zeros(length(vmapIM',num2str(i),'),Rn_expan_R',num2str(i),'), useGPU);']);
    eval(['GRPHI',num2str(i),'=GRphi',num2str(i),';']);
end
if  Rn_expan_R~=0
    GRA=setArrayType(RA, useGPU);
    GRlambda=setArrayType(Rlambda, useGPU);

    Gi_Rpole=setArrayType(1, useGPU);
    GRn_expan_R=setArrayType(Rn_expan_R, useGPU);
    GRphi1=setArrayType(zeros(length(vmapIM),Rn_expan_R), useGPU);
    GRPHI1=GRphi1;
    if transmission==1
        GRphi3=setArrayType(zeros(length(vmapS),Rn_expan_R), useGPU);
        GRPHI3=GRphi3;
    end
else
    Gi_Rpole=setArrayType(1, useGPU);
    GRn_expan_R=setArrayType(Rn_expan_R, useGPU);
end


