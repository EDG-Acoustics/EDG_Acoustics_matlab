%% Single precision loss
%
% Study the effect of using single precision during computing. Specifically
% looking into van der Monde matrix and derived matrices.
%
% Artur Palha


%% Initialization
clear all; warning off;
close all;
% gpuDevice(2)
addpath(genpath('../DG_source'))

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
msh_file = strcat('../mesh/',filename,'.msh');
mesh_T = load_gmsh_QT(msh_file);
Setup_mesh3D;

%% Setup operation build

% Definition of constants
Np = (N+1)*(N+2)*(N+3)/6; Nfp = (N+1)*(N+2)/2; Nfaces=4; NODETOL = 1e-7;

% Compute nodal set
[x,y,z] = Nodes3D(N); [r,s,t] = xyztorst(x,y,z);


%% Build reference element matrices (double precision)
V = Vandermonde3D(N,r,s,t); invV = inv(V);
MassMatrix = invV'*invV;
[Dr,Ds,Dt] = Dmatrices3D(N, r, s, t, V);

% calculate geometric factors
[rx,sx,tx,ry,sy,ty,rz,sz,tz,J] = GeometricFactors3D(x,y,z,Dr,Ds,Dt);


%% Build element matrices (single precision from double precision)
% Simply convert from the original double precision matrices
V_single = single(V);
invV_single = single(invV);
MassMatrix_single = single(MassMatrix);
Dr_single = single(Dr);
Ds_single = single(Ds);
Dt_single = single(Dt);
rx_single = single(rx);
sx_single = single(sx);
tx_single = single(tx);
ry_single = single(ry);
sy_single = single(sy);
ty_single = single(ty);
rz_single = single(rz);
sz_single = single(sz);
tz_single = single(tz);
J_single = single(J);


%% Build element matrices (single precision from single precision)
% Compute the matrices using single precision
V_single_from_single = Vandermonde3D(N,single(r), single(s), single(t)); 
invV_single_from_single = inv(V_single_from_single);
MassMatrix_single_from_single = invV_single_from_single'*invV_single_from_single;
[Dr_single_from_single, Ds_single_from_single, Dt_single_from_single] = Dmatrices3D(N, single(r), single(s), single(t), V_single_from_single);

% calculate geometric factors
[rx_single_from_single, sx_single_from_single, tx_single_from_single, ...
    ry_single_from_single, sy_single_from_single, ty_single_from_single, ...
    rz_single_from_single, sz_single_from_single, tz_single_from_single, ...
    J_single_from_single] = GeometricFactors3D(single(x), single(y), single(z), ...
    Dr_single_from_single, Ds_single_from_single, Dt_single_from_single);


%% Compare the results

%% Van der Monde matrix
figure()

% Single
subplot(1, 3, 1)
surf(V - V_single)

% Single from single
subplot(1, 3, 2)
surf(V - V_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(V_single - V_single_from_single)

sgtitle('V')


%% Inverse van der Monde matrix
figure()

% Single
subplot(1, 3, 1)
surf(invV - invV_single)

% Single from single
subplot(1, 3, 2)
surf(invV - invV_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(invV_single - invV_single_from_single)

sgtitle('V^{-1}')


%% Mass Matrix
figure()

% Single
subplot(1, 3, 1)
surf(MassMatrix - MassMatrix_single)

% Single from single
subplot(1, 3, 2)
surf(MassMatrix - MassMatrix_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(MassMatrix_single - MassMatrix_single_from_single)

sgtitle('M')


%% Dr
figure()

% Single
subplot(1, 3, 1)
surf(Dr - Dr_single)

% Single from single
subplot(1, 3, 2)
surf(Dr - Dr_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(Dr_single - Dr_single_from_single)

sgtitle('Dr')


%% Ds
figure()

% Single
subplot(1, 3, 1)
surf(Ds - Ds_single)

% Single from single
subplot(1, 3, 2)
surf(Ds - Ds_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(Ds_single - Ds_single_from_single)

sgtitle('Ds')


%% Dt
figure()

% Single
subplot(1, 3, 1)
surf(Dt - Dt_single)

% Single from single
subplot(1, 3, 2)
surf(Dt - Dt_single_from_single)

% Single from single
subplot(1, 3, 3)
surf(Dt_single - Dt_single_from_single)

sgtitle('Dt')


%% rx
figure()

% Single
semilogy(abs(rx - rx_single))
hold on

% Single from single
semilogy(abs(rx - rx_single_from_single))

% Single from single
semilogy(abs(rx_single - rx_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('rx')


%% sx
figure()

% Single
semilogy(abs(sx - sx_single))
hold on

% Single from single
semilogy(abs(sx - sx_single_from_single))

% Single from single
semilogy(abs(sx_single - sx_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('sx')


%% tx
figure()

% Single
semilogy(abs(tx - tx_single))
hold on

% Single from single
semilogy(abs(tx - tx_single_from_single))

% Single from single
semilogy(abs(tx_single - tx_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('tx')


%% ry
figure()

% Single
semilogy(abs(ry - ry_single))
hold on

% Single from single
semilogy(abs(ry - ry_single_from_single))

% Single from single
semilogy(abs(ry_single - ry_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('ry')


%% sy
figure()

% Single
semilogy(abs(sy - sy_single))
hold on

% Single from single
semilogy(abs(sy - sy_single_from_single))

% Single from single
semilogy(abs(sy_single - sy_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('sy')


%% ty
figure()

% Single
semilogy(abs(ty - ty_single))
hold on

% Single from single
semilogy(abs(ty - ty_single_from_single))

% Single from single
semilogy(abs(ty_single - ty_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('ty')


%% rz
figure()

% Single
semilogy(abs(rz - rz_single))
hold on

% Single from single
semilogy(abs(rz - rz_single_from_single))

% Single from single
semilogy(abs(rz_single - rz_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('rz')


%% sz
figure()

% Single
semilogy(abs(sz - sz_single))
hold on

% Single from single
semilogy(abs(sz - sz_single_from_single))

% Single from single
semilogy(abs(sz_single - sz_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('sy')


%% tz
figure()

% Single
semilogy(abs(tz - tz_single))
hold on

% Single from single
semilogy(abs(tz - tz_single_from_single))

% Single from single
semilogy(abs(tz_single - tz_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('tz')


%% J
figure()

% Single
semilogy(abs(J - J_single))
hold on

% Single from single
semilogy(abs(J - J_single_from_single))

% Single from single
semilogy(abs(J_single - J_single_from_single))

legend('single vs double', 'single from single vs double', 'single from single vs single')
title('J')

