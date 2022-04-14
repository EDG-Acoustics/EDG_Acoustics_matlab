% Purpose: compute time step size
%
% By Huiqing Wang.  h.wang6@tue.nl
%% orginal
% dtscale = dtscale3D;
% precision_DG = 1;
% CFL = CFL_DG_values(precision_DG,N);
% dt = dtscale*CFL*(1/c0); %with timescale considered 

% for N=5:8
%     CFL = CFL_DG_values(precision_DG,N);
%     N
%     dt = dtscale*CFL*(1/c0)*0.9
% end

%% new
dtscale = dtscale2Dmy;
dt = dtscale*CFLfac*(1/c0)/N/N; %with timescale considered 