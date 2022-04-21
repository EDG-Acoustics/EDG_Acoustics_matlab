%%
% Copyright 2022 Building Acoustics group
% of Department of the Built Environment, Eindhoven University of Technology
% Licensed under the Apache License, version 2.0. See LICENSE for details.

%% 3D wave simulation with ADER-DG and uniform time stepping
% needs input mesh from GMSH(version 3.06)
% Coded by : Dr. Ir. H.Wang  h.wang6@tue.nl
% Building Acoustics group of Department of the Built Environment;Eindhoven University of Technology

%% Initialization
clear all; warning off;
close all;
% gpuDevice(2)
addpath(genpath('./DG_source'))w

%% Simulation and computation parameters
rho0=1.2; c0=343; fmax=500;
Globals3D;
tol = 1e-8;  op_record=1;
xs = 27.995; ys = 5.6; zs=1.2;  % sound source location
halfwidth=0.17;  % half band width of initial Gaussian sound pulse
num_bc=3; % number of reflective impedance boundary conditions
Tnum_bc=0; % number of transmissive boundary conditions
useGPU = false;  % use gpu for computations or not, if true all arrays are converted to gpuArray


%% Set spatial polynomial order and time integrationi order
CFLfac=0.9; % CFL constant
orderT=5;% time order
N=5;  % spatial order
totime =0.05; %total simulation time: physical time = totime/c0;


%% Load Mesh and setup
filename = 'CoarseMesh'; %% CoarseMesh or FineMesh
msh_file = strcat('./mesh/',filename,'.msh');
mesh_T = load_gmsh_QT(msh_file);
Setup_mesh3D;
StartUp3Dmy_local;


%% Set initial condition
P=exp(-log(2)*( ((x-xs).^2 + (y-ys).^2 + (z-zs).^2)/halfwidth^2));
U= zeros(Np, K); V = zeros(Np, K); W = zeros(Np, K);


%% Set time steps and time interval
Gdt1 = setArrayType(dtscale*CFLfac*(1/c0)/(2*N+1), useGPU); %with timescale considered
dt1=gather(Gdt1);
time = 0;
nTimeLevels = floor(floor(totime/Gdt1/c0))


%% Set locations where the acoustic pressure are to be recorded (as an example)
nrec=9;
rec_x=[25.795;24.395;22.195;20.795;18.595;17.195;14.995;13.595;11.395];
rec_y=5.6*ones(nrec,1);
nrec=11;
rec_x=[rec_x;25.795;24.395;];
rec_y=[rec_y;7.4;7.4;];
rec_z=1.2*ones(nrec,1);


%% Recording setup
% Find in which element that coordinate is found:
if op_record~=0
    [gVM, kth] = Sample3D(rec_x, rec_y, rec_z);
%gVM is the interpolating matrix you can multiply times the solution of the acoustics variables of the kth element and record in time (t):
    prec=zeros(length(rec_x),nTimeLevels);% urec=zeros(length(rec_x),nTimeLevels);
end

%% Setup system matrices
Setup_upwind3D; %% pre-calculate some constants
SetupMultiImp1st;  % set multipole parameter values in impedance boundary condition

GPUdec3DRandTADER_local; % convert all variables as GPU array


%%
Gu=GU;Gp=GP;Gv=GV;Gw=GW;
fprintf('\n')
for GtimeLevel = 1:GnTimeLevels  % main time marching loop
        time_step_starttime = tic();

        for m=1:orderT
         time_substep_starttime = tic();
%%
         Gdu(:)=Gu(GvmapM)-Gu(GvmapP);
         Gdv(:)=Gv(GvmapM)-Gv(GvmapP);
         Gdw(:)=Gw(GvmapM)-Gw(GvmapP);
         Gdp(:)=Gp(GvmapM)-Gp(GvmapP);
         %% hard wall boundary condition
         Gdu(GmapS)=2*Gu(GvmapS);
         Gdv(GmapS)=2*Gv(GvmapS);
         Gdw(GmapS)=2*Gw(GvmapS);
         Gdp(GmapS)=0;
             %%    calculation of interior fluxes
        Gfluxu=Gcn1s.*Gdu + Gcn1n2.*Gdv + Gcn1n3.*Gdw + Gn1rho.*Gdp;
        Gfluxv=Gcn1n2.*Gdu + Gcn2s.*Gdv + Gcn2n3.*Gdw + Gn2rho.*Gdp;
        Gfluxw=Gcn1n3.*Gdu + Gcn2n3.*Gdv + Gcn3s.*Gdw + Gn3rho.*Gdp;
        Gfluxp=Gcsn1rho.*Gdu + Gcsn2rho.*Gdv + Gcsn3rho.*Gdw -Gc0/2*Gdp;
    %%    calculation of boundary fluxes
        Gun1=Gnx(GmapIM1).*Gu(GvmapIM1)+Gny(GmapIM1).*Gv(GvmapIM1)+Gnz(GmapIM1).*Gw(GvmapIM1);
        Gou1=Gun1+Gp(GvmapIM1)/(Grho0*Gc0);
        GRin1=GR1*Gou1; % delta(t)
        for Gi_Rpole=1:GRn_expan_R1
            GRin1=GRin1+GRA1(Gi_Rpole)*GRphi1(:,Gi_Rpole);
        end

        Gfluxu(GmapIM1)=Gnx(GmapIM1).*Gp(GvmapIM1)/Grho0-Gc0*Gnx(GmapIM1)/2.*(Gou1+GRin1);
        Gfluxv(GmapIM1)=Gny(GmapIM1).*Gp(GvmapIM1)/Grho0-Gc0*Gny(GmapIM1)/2.*(Gou1+GRin1);
        Gfluxw(GmapIM1)=Gnz(GmapIM1).*Gp(GvmapIM1)/Grho0-Gc0*Gnz(GmapIM1)/2.*(Gou1+GRin1);
        Gfluxp(GmapIM1)=Gc0^2*Grho0*(Gun1-0.5*(Gou1-GRin1));
%
        Gun2=Gnx(GmapIM2).*Gu(GvmapIM2)+Gny(GmapIM2).*Gv(GvmapIM2)+Gnz(GmapIM2).*Gw(GvmapIM2);
        Gou2=Gun2+Gp(GvmapIM2)/(Grho0*Gc0);
        GRin2=GR2*Gou2;
        for Gi_Rpole=1:GRn_expan_R2
            GRin2=GRin2+GRA2(Gi_Rpole)*GRphi2(:,Gi_Rpole);
        end

        Gfluxu(GmapIM2)=Gnx(GmapIM2).*Gp(GvmapIM2)/Grho0-Gc0*Gnx(GmapIM2)/2.*(Gou2+GRin2);
        Gfluxv(GmapIM2)=Gny(GmapIM2).*Gp(GvmapIM2)/Grho0-Gc0*Gny(GmapIM2)/2.*(Gou2+GRin2);
        Gfluxw(GmapIM2)=Gnz(GmapIM2).*Gp(GvmapIM2)/Grho0-Gc0*Gnz(GmapIM2)/2.*(Gou2+GRin2);
        Gfluxp(GmapIM2)=Gc0^2*Grho0*(Gun2-0.5*(Gou2-GRin2));

        Gun3=Gnx(GmapIM3).*Gu(GvmapIM3)+Gny(GmapIM3).*Gv(GvmapIM3)+Gnz(GmapIM3).*Gw(GvmapIM3);
        Gou3=Gun3+Gp(GvmapIM3)/(Grho0*Gc0);
        GRin3=GR3*Gou3; % delta(t)
        for Gi_Rpole=1:GRn_expan_R3
            GRin3=GRin3+GRA3(Gi_Rpole)*GRphi3(:,Gi_Rpole);
        end
%         %% Impose R and T flux on medium 3 side
        Gfluxu(GmapIM3)=Gnx(GmapIM3).*Gp(GvmapIM3)/Grho0-Gc0*Gnx(GmapIM3)/2.*(Gou3+GRin3);
        Gfluxv(GmapIM3)=Gny(GmapIM3).*Gp(GvmapIM3)/Grho0-Gc0*Gny(GmapIM3)/2.*(Gou3+GRin3);
        Gfluxw(GmapIM3)=Gnz(GmapIM3).*Gp(GvmapIM3)/Grho0-Gc0*Gnz(GmapIM3)/2.*(Gou3+GRin3);
        Gfluxp(GmapIM3)=Gc0^2*Grho0*(Gun3-0.5*(Gou3-GRin3));
%
%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % compute physical spatial derivatives using the chain rule
        % The main cost come from volume integral evaluation, such as terms
        % Grx.*(GDr*Gu), Gsx.*(GDs*Gu), etc. in the following
        physical_spatial_derivatives_startime = tic();
        Gtp=Gp;
        Gp = -Gc0^2*Grho0*(Grx.*(GDr*Gu)+Gsx.*(GDs*Gu)+Gtx.*(GDt*Gu)+Gry.*(GDr*Gv)+Gsy.*(GDs*Gv)+Gty.*(GDt*Gv)+Grz.*(GDr*Gw)+Gsz.*(GDs*Gw)+Gtz.*(GDt*Gw))...
            + GLIFT*(GFscale.*Gfluxp);
        Gu = -1/Grho0*(Grx.*(GDr*Gtp)+Gsx.*(GDs*Gtp)+Gtx.*(GDt*Gtp)) + GLIFT*(GFscale.*Gfluxu);
        Gv = -1/Grho0*(Gry.*(GDr*Gtp)+Gsy.*(GDs*Gtp)+Gty.*(GDt*Gtp)) + GLIFT*(GFscale.*Gfluxv);
        Gw = -1/Grho0*(Grz.*(GDr*Gtp)+Gsz.*(GDs*Gtp)+Gtz.*(GDt*Gtp)) + GLIFT*(GFscale.*Gfluxw);
        physical_spatial_derivatives_time = toc(physical_spatial_derivatives_startime);
        fprintf('Physical spatial derivatives: ......................... %fs\n', physical_spatial_derivatives_time);

        matrix_matrix_multiplication_startime = tic();
        ZZ = Grx.*(GDr*Gu);
        matrix_matrix_multiplication_time = toc(matrix_matrix_multiplication_startime);
        fprintf('Matrix matrix multiplication: ......................... %fs\n', matrix_matrix_multiplication_time);

%% time integration updates
        GU =GU+Gdt1^(m)/factorial(m)*Gu;
        GV =GV+Gdt1^(m)/factorial(m)*Gv;
        GW =GW+Gdt1^(m)/factorial(m)*Gw;
        GP =GP+Gdt1^(m)/factorial(m)*Gp;

        for Gi_Rpole=1:GRn_expan_R1
            GRphi1(:,Gi_Rpole)=Gou1-GRlambda1(Gi_Rpole)*GRphi1(:,Gi_Rpole);
        end
        GRPHI1 =GRPHI1+Gdt1^(m)/factorial(m)*GRphi1;%

        for Gi_Rpole=1:GRn_expan_R2
            GRphi2(:,Gi_Rpole)=Gou2-GRlambda2(Gi_Rpole)*GRphi2(:,Gi_Rpole);
        end
        GRPHI2 =GRPHI2+Gdt1^(m)/factorial(m)*GRphi2;

        for Gi_Rpole=1:GRn_expan_R3
            GRphi3(:,Gi_Rpole)=Gou3-GRlambda3(Gi_Rpole)*GRphi3(:,Gi_Rpole);
        end
        GRPHI3 =GRPHI3+Gdt1^(m)/factorial(m)*GRphi3;

        time_substep_time = toc(time_substep_starttime);
        fprintf('Time substep: ......................................... %fs\n', time_substep_time);

        end
    Gu=GU;Gp=GP;Gv=GV;Gw=GW;
    GRphi1=GRPHI1;     GRphi3=GRPHI3; GRphi2=GRPHI2;
    Gtime = (Gtime+Gdt1*Gc0);
    Gprec(:,GtimeLevel) = diag(GgVM*Gp(:,Gkth));

    time_step_time = toc(time_step_starttime);
    fprintf('Time step: ............................................ %fs\n', time_step_time);

    fprintf('\nGtime: %fs\n\n', Gtime)

end

% Convert arrays to cpu arrays
prec=setArrayType(Gprec, false); %% output of the whole simulation
time=setArrayType(Gtime, false);
