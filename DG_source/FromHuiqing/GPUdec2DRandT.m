% Purpose: Declare GPU variables
%
% By Huiqing Wang.  h.wang6@tue.nl
%% recording
Gprec=gpuArray(prec);
GgVM=gpuArray(gVM);
Gkth=gpuArray(kth);
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
% GDt=gpuArray(Dt);

Grx=gpuArray(rx);
Gsx=gpuArray(sx);
% Gtx=gpuArray(tx);

Gry=gpuArray(ry);
Gsy=gpuArray(sy);
% Gty=gpuArray(ty);

% Grz=gpuArray(rz);
% Gsz=gpuArray(sz);
% Gtz=gpuArray(tz);

%% routine
% GmapB=gpuArray(mapB);
% GvmapB=gpuArray(vmapB);
GvmapM=gpuArray(vmapM);
GvmapP=gpuArray(vmapP);
Gnx=gpuArray(nx);
Gny=gpuArray(ny);
% Gnz=gpuArray(nz);
%%
Gdu=gpuArray(zeros(Nfp*Nfaces,K));
Gdv=gpuArray(zeros(Nfp*Nfaces,K));
% Gdw=gpuArray(zeros(Nfp*Nfaces,K));
Gdp=gpuArray(zeros(Nfp*Nfaces,K));

Gu=gpuArray(u);
Gv=gpuArray(v);
% Gw=gpuArray(w);
Gp=gpuArray(p);

Gfluxu=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxv=gpuArray(zeros(Nfp*Nfaces,K));
% Gfluxw=gpuArray(zeros(Nfp*Nfaces,K));
Gfluxp=gpuArray(zeros(Nfp*Nfaces,K));

Gux=gpuArray(zeros(Np,K));
Gvy=gpuArray(zeros(Np,K));
% Gwz=gpuArray(zeros(Np,K));

Gpx=gpuArray(zeros(Np,K));
Gpy=gpuArray(zeros(Np,K));
% Gpz=gpuArray(zeros(Np,K));

GLIFT=gpuArray(LIFT);
GFscale=gpuArray(Fscale);

Grhsu=gpuArray(zeros(Np,K));
Grhsv=gpuArray(zeros(Np,K));
% Grhsw=gpuArray(zeros(Np,K));
Grhsp=gpuArray(zeros(Np,K));
Gresu=gpuArray(zeros(Np,K));
Gresv=gpuArray(zeros(Np,K));
% Gresw=gpuArray(zeros(Np,K));
Gresp=gpuArray(zeros(Np,K));


%% upwind flux const
Gcn1s=gpuArray(cn1s);
Gcn1n2=gpuArray(cn1n2);
% Gcn1n3=gpuArray(cn1n3);
Gcn2s=gpuArray(cn2s);
% Gcn2n3=gpuArray(cn2n3);
% Gcn3s=gpuArray(cn3s);

Gn1rho=gpuArray(n1rho);
Gn2rho=gpuArray(n2rho);
% Gn3rho=gpuArray(n3rho);

Gcsn1rho=gpuArray(csn1rho);
Gcsn2rho=gpuArray(csn2rho);
% Gcsn3rho=gpuArray(csn3rho);

%% BC
Gun=gpuArray(zeros(size(mapIM)));
% Gun=gpuArray(zeros(size(nx)));
Goutgoing=Gun;
Gincoming=Gun;
GoutCNRBC=gpuArray(zeros(size(mapCN)));
% GinCNRBC=GoutCNRBC;
% 
GmapCN=gpuArray(mapCN);
GvmapCN=gpuArray(vmapCN);
GmapS=gpuArray(mapS);
GvmapS=gpuArray(vmapS);
 if exist('vmapSP')
   GvmapSP=gpuArray(vmapSP);
 end
GmapIM=gpuArray(mapIM);
GvmapIM=gpuArray(vmapIM);
 if exist('vmapIMP')
   GvmapIMP=gpuArray(vmapIMP);
 end

%% impedance
 if exist('R')
GR=gpuArray(R);
 end
  if exist('T')
GT=gpuArray(T);
 end
%% impedance 2nd
% if exist('n_expan_C')
if n_expan_C ~=0
    GB=gpuArray(B);
    GC=gpuArray(C);
    Galpha=gpuArray(alpha);
    Gbeta=gpuArray(beta);

    Gi_Cpole=gpuArray(1);
    Gn_expan_C=gpuArray(n_expan_C);
    Gkexi1=gpuArray(zeros(length(vmapIM),n_expan_C));
    Greskexi1=Gkexi1;
    Gkexi2=Gkexi1;
    Greskexi2=Gkexi1;
else
    Gn_expan_C=gpuArray(0);
    Gi_Cpole=gpuArray(1);
end
%% R impedance 1st
if  Rn_expan_R~=0
    GRA=gpuArray(RA);
    GRlambda=gpuArray(Rlambda);

    Gi_Rpole=gpuArray(1);
    GRn_expan_R=gpuArray(Rn_expan_R);
    GRphi1=gpuArray(zeros(length(vmapIM),Rn_expan_R));
    GRresphi1=GRphi1;
    GRphi3=gpuArray(zeros(length(vmapS),Rn_expan_R));
    GRresphi3=GRphi3;
else
    Gi_Rpole=gpuArray(1);
    GRn_expan_R=gpuArray(Rn_expan_R);
end

%% T impedance 1st
if  Tn_expan_R~=0
    GTA=gpuArray(TA);
    GTlambda=gpuArray(Tlambda);

    Gi_Rpole=gpuArray(1);
    GTn_expan_R=gpuArray(Tn_expan_R);
    GTphi1=gpuArray(zeros(length(vmapIM),Tn_expan_R));
    GTresphi1=GTphi1;
    GTphi3=gpuArray(zeros(length(vmapS),Tn_expan_R));
    GTresphi3=GTphi3;
else
    Gi_Rpole=gpuArray(1);
    GTn_expan_R=gpuArray(Tn_expan_R);
end
