% Purpose: Declare GPU variables
%
% By Huiqing Wang.  h.wang6@tue.nl
%% recording
% Gprec=gpuArray(prec);
% GgVM=gpuArray(gVM);
% Gkth=gpuArray(kth);
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
Grx=gpuArray(rx);
Gsx=gpuArray(sx);
Gry=gpuArray(ry);
Gsy=gpuArray(sy);
%%
GmapB=gpuArray(mapB);
GvmapB=gpuArray(vmapB);
GvmapM=gpuArray(vmapM);
GvmapP=gpuArray(vmapP);
% Gnx=gpuArray(nx); %% no need for free field, all included in upwind flux
% Gny=gpuArray(ny);

%%
Gdu=gpuArray(zeros(Nfp*Nfaces,K));
Gdv=gpuArray(zeros(Nfp*Nfaces,K));
Gdp=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxu=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxv=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxp=gpuArray(zeros(Nfp*Nfaces,K));
% Gux=gpuArray(zeros(Np,K));
% Gvy=gpuArray(zeros(Np,K));
% Gpx=gpuArray(zeros(Np,K));
% Gpy=gpuArray(zeros(Np,K));
GLIFT=gpuArray(LIFT);
GFscale=gpuArray(Fscale);
%% ADER
GU=gpuArray(U);
GV=gpuArray(V);
GP=gpuArray(P);
Gu=gpuArray(U);
Gv=gpuArray(V);
Gp=gpuArray(P);
Gtp=gpuArray(P);


%% BC
% GmapS=gpuArray(mapS);
% GvmapS=gpuArray(vmapS);
% GmapCN=gpuArray(mapCN);
% GvmapCN=gpuArray(vmapCN);
% GmapIM=gpuArray(mapIM);
% GvmapIM=gpuArray(vmapIM);
%% upwind flux const
Gcn1s=gpuArray(cn1s);
Gcn1n2=gpuArray(cn1n2);
Gn1rho=gpuArray(n1rho);
Gn2rho=gpuArray(n2rho);
Gcn2s=gpuArray(cn2s);
Gcsn1rho=gpuArray(csn1rho);
Gcsn2rho=gpuArray(csn2rho);

% ux=zeros(Np,K); 
% vy=zeros(Np,K); 
% px=zeros(Np,K); 
% py=zeros(Np,K); 
% du = zeros(Nfp*Nfaces,K); 
% dv = zeros(Nfp*Nfaces,K); 
% dp = zeros(Nfp*Nfaces,K); 
% fluxu = zeros(Nfp*Nfaces,K); 
% fluxv = zeros(Nfp*Nfaces,K); 
% fluxp = zeros(Nfp*Nfaces,K); 