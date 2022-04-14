%% limiting reflection ( instantaneous response to the excitation)
R1=0; R2=0;R3=0;R=0.8944;
%% real pole
% load(['foamN1fmax500.mat'],'A','lambda');
% Rlambda1=lambda;RA1=A;
% load(['carpetN1fmax500.mat'],'A','lambda');
% Rlambda2=lambda;RA2=A;
% load(['ceilingN1fmax500.mat'],'A','lambda');
% Rlambda3=lambda;RA3=A;

% load(['foamN1fmax500.mat'],'A','lambda');
Rlambda1=2.843988875912554e+03;RA1=2.849308439512733e+03;
% load(['carpetN1fmax500.mat'],'A','lambda');
Rlambda2=1.509502512409186e+04;RA2=1.505778842079319e+04;
% load(['ceilingN1fmax500.mat'],'A','lambda');
Rlambda3=1.435194820157478e+03;RA3=1.366327945491475e+03;
% % load(['JCAL_Rnew_N5_d0.08alg_interior-point.mat'],'A','lambda')
% % load(['JCAL_Rnew_N5_d0.01alg_interior-point.mat'],'A','lambda')
% RA=A;
% Rlambda=lambda;
% % load(['JCAL_Tnew_N5_d0.04alg_interior-point.mat'],'A','lambda')
% load(['JCAL_Tnew2_N5_d0.04alg_interior-point.mat'],'A','lambda')
% % load(['JCAL_Tnew_N5_d0.08alg_interior-point.mat'],'A','lambda')
% % load(['JCAL_Tnew_N4_d0.01alg_interior-point.mat'],'A','lambda')
% TA=A;
% Tlambda=lambda;
% Rlambda1=8000;RA1=6400;
% Rlambda2=Rlambda1;RA2=RA1;
% Rlambda3=Rlambda1;RA3=RA1;

Rn_expan_R1=length(Rlambda1);
Rn_expan_R2=length(Rlambda2);
Rn_expan_R3=length(Rlambda3);

%% declaration
if exist('Rlambda')
    Rn_expan_R=length(Rlambda);
%     phi=zeros(length(vmapIM),n_expan_R);
%      resphi=zeros(length(vmapIM),n_expan_R);
else
    Rn_expan_R=0;
end

if exist('Tlambda')
    Tn_expan_R=length(Tlambda);
    
%     phi=zeros(length(vmapIM),n_expan_R);
%      resphi=zeros(length(vmapIM),n_expan_R);
else
    Tn_expan_R=0;
end

if exist('B')
    n_expan_C=length(alpha);
    
%    kexi1=zeros(length(vmapIM),n_expan_C);
%     reskexi1=zeros(length(vmapIM),n_expan_C);
%     kexi2=zeros(length(vmapIM),n_expan_C);
%     reskexi2=zeros(length(vmapIM),n_expan_C);
else
    n_expan_C=0;
end
%%
% n_expan_real=length(lambda);
% phi=zeros(length(vmapIM),n_expan_real);
% resphi=zeros(length(vmapIM),n_expan_real);