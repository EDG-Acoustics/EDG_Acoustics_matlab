% Purpose: Declare GPU variables
%
% By Huiqing Wang.  h.wang6@tue.nl
%% recording
if op_record~=0
Gprec=gpuArray(prec);
GgVM=gpuArray(gVM);
Gkth=gpuArray(kth);
end
%% time integration
Grkf84a=gpuArray(rkf84a);
Grkf84b=gpuArray(rkf84b);
Grk4a=gpuArray(rk4a);
Grk4b=gpuArray(rk4b);
INTRK=gpuArray(1);
GtimeLevel=gpuArray(1);
GnTimeLevels=gpuArray(nTimeLevels);
Gdt=gpuArray(dt);
Gtime=gpuArray(time);
%% constants
Gc0=gpuArray(c0);
Grho0=gpuArray(rho0);


%% grad
GDr=gpuArray(Dr);
GDs=gpuArray(Ds);
GDt=gpuArray(Dt);

Grx=gpuArray(rx);
Gsx=gpuArray(sx);
Gtx=gpuArray(tx);

Gry=gpuArray(ry);
Gsy=gpuArray(sy);
Gty=gpuArray(ty);

Grz=gpuArray(rz);
Gsz=gpuArray(sz);
Gtz=gpuArray(tz);

%% routine
% GmapB=gpuArray(mapB);
% GvmapB=gpuArray(vmapB);
GvmapM=gpuArray(vmapM);
GvmapP=gpuArray(vmapP);
Gnx=gpuArray(nx);
Gny=gpuArray(ny);
Gnz=gpuArray(nz);
%%
Gdu=gpuArray(zeros(Nfp*Nfaces,K));
Gdv=gpuArray(zeros(Nfp*Nfaces,K));
Gdw=gpuArray(zeros(Nfp*Nfaces,K));
Gdp=gpuArray(zeros(Nfp*Nfaces,K));

Gfluxu=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxv=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxw=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxp=gpuArray(zeros(Nfp*Nfaces,K));

% Gux=gpuArray(zeros(Np,K));
% Gvy=gpuArray(zeros(Np,K));
% % Gwz=gpuArray(zeros(Np,K));
% 
% Gpx=gpuArray(zeros(Np,K));
% Gpy=gpuArray(zeros(Np,K));
% % Gpz=gpuArray(zeros(Np,K));

GLIFT=gpuArray(LIFT);
GFscale=gpuArray(Fscale);

%% ADER
GU=gpuArray(U);
GV=gpuArray(V);
GW=gpuArray(W);
GP=gpuArray(P);
Gu=gpuArray(U);
Gv=gpuArray(V);
Gw=gpuArray(W);
Gp=gpuArray(P);
Gtp=gpuArray(P);

%% upwind flux const
Gcn1s=gpuArray(cn1s);
Gcn1n2=gpuArray(cn1n2);
Gcn1n3=gpuArray(cn1n3);
Gcn2s=gpuArray(cn2s);
Gcn2n3=gpuArray(cn2n3);
Gcn3s=gpuArray(cn3s);

Gn1rho=gpuArray(n1rho);
Gn2rho=gpuArray(n2rho);
Gn3rho=gpuArray(n3rho);

Gcsn1rho=gpuArray(csn1rho);
Gcsn2rho=gpuArray(csn2rho);
Gcsn3rho=gpuArray(csn3rho);

%% BC
GmapCN=gpuArray(mapCN);
GvmapCN=gpuArray(vmapCN);
GmapS=gpuArray(mapS);
GvmapS=gpuArray(vmapS);
GmapIM=gpuArray(mapIM);
GvmapIM=gpuArray(vmapIM);
for i=1:num_bc
    eval(['Gun',num2str(i),'=gpuArray(zeros(size(mapIM',num2str(i),')));']);
    eval(['Gou',num2str(i),'=gpuArray(zeros(size(mapIM',num2str(i),')));']);
    eval(['GRin',num2str(i),'=gpuArray(zeros(size(mapIM',num2str(i),')));']);
end
for i=1:num_bc
    eval(['GmapIM',num2str(i),'=gpuArray(mapIM',num2str(i),');']);
    eval(['GvmapIM',num2str(i),'=gpuArray(vmapIM',num2str(i),');']);
end

for i=1:Tnum_bc
    eval(['GTun',num2str(i),'=gpuArray(zeros(size(mapT',num2str(i),')));']);
    eval(['GTou',num2str(i),'=gpuArray(zeros(size(mapT',num2str(i),')));']);
    eval(['GTRin',num2str(i),'=gpuArray(zeros(size(mapT',num2str(i),')));']);
    eval(['GTin',num2str(i),'=gpuArray(zeros(size(mapT',num2str(i),')));']);
end
for i=1:Tnum_bc
    eval(['GmapT',num2str(i),'=gpuArray(mapT',num2str(i),');']);
    eval(['GvmapT',num2str(i),'=gpuArray(vmapT',num2str(i),');']);
    eval(['GvmapTP',num2str(i),'=gpuArray(vmapTP',num2str(i),');']);
end    
%% impedance
 if exist('R')
GR=gpuArray(R);
 end
  if exist('T')
GT=gpuArray(T);
  end
for i=1:num_bc
    eval(['GR',num2str(i),'=gpuArray(R',num2str(i),');']);
end
%% R impedance 1st
Gi_Rpole=gpuArray(1);
for i=1:num_bc
    eval(['GRA',num2str(i),'=gpuArray(RA',num2str(i),');']);
    eval(['GRlambda',num2str(i),'=gpuArray(Rlambda',num2str(i),');']);
    eval(['GRn_expan_R',num2str(i),'=gpuArray(Rn_expan_R',num2str(i),');']);
    eval(['GRphi',num2str(i),'=gpuArray(zeros(length(vmapIM',num2str(i),'),Rn_expan_R',num2str(i),'));']);
    eval(['GRPHI',num2str(i),'=GRphi',num2str(i),';']);
end
if  Rn_expan_R~=0
    GRA=gpuArray(RA);
    GRlambda=gpuArray(Rlambda);

    Gi_Rpole=gpuArray(1);
    GRn_expan_R=gpuArray(Rn_expan_R);
    GRphi1=gpuArray(zeros(length(vmapIM),Rn_expan_R));
    GRPHI1=GRphi1;
    if transmission==1
        GRphi3=gpuArray(zeros(length(vmapS),Rn_expan_R));
        GRPHI3=GRphi3;
    end
else
    Gi_Rpole=gpuArray(1);
    GRn_expan_R=gpuArray(Rn_expan_R);
end


