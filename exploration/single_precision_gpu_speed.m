%% Single precision gpu speed
%
% Study the speedup effect of using single precision with gpus during computing. 
%
% Artur Palha

close all; clear all

%% Input parameters
n = 1000;  % size of arrays
n_loops = 10;  % number of loops in for loop


%% Pre-computations
% Generate CPU arrays
A_double = rand(n);  % generate the array in double precision
A_single = single(A_double);  % get a single copy

B_double = rand(n);  % generate the array in double precision
B_single = single(B_double);  % get a single copy

C_double = zeros(n);  % double precision solution matrix
C_single = zeros(n, 'single');  % single precision solution matrix

% GPU versions
A_gpu_double = gpuArray(A_double);
A_gpu_single = gpuArray(A_single);

B_gpu_double = gpuArray(B_double);
B_gpu_single = gpuArray(B_single);

B_gpu_double = gpuArray(B_double);
B_gpu_single = gpuArray(B_single);


%% First code snippet to check single vs double precision speed
gpu = gpuDevice;

for pass = 1:2
    % Select precision
    if (pass==1)
        disp('Single precision:')
        prec = 'single';
    else
        disp('Double precision:')
        prec = 'double';
    end
    
    % Initialize CPU matrices
    A_cpu = randn(n, prec);
    B_cpu = randn(n, prec);
    C_cpu = zeros(n, prec);

    % Convert to GPU
    A_gpu = gpuArray(A_cpu);
    B_gpu = gpuArray(B_cpu);
    C_gpu = gpuArray(C_cpu);

    % Do computational loop
    for kIdx = 1:n_loops
        C_gpu = A_gpu * G_gpu + C_gpu;
    end

    wait(gpu);    % ensure it has completed
end


total_time_double = toc(start_time_double);

whos


%% Second code snippet to check single vs double precision speed

close all; clear all

N = 1e6;

gpu = gpuDevice;

for pass = 1:2
    disp(' ')
    if (pass==1)
        disp('Single precision:')
        prec = 'single';
    else
        disp('Double precision:')
        prec = 'double';
    end
    disp(' ')
    disp('GPU')

    for M = [1e5 1e6 1e7]
        parallel.gpu.rng('default');
        tic
        e4 = 0;
        for m = 1:M:N
            n  = min(M,N-m+1);
            x  = gpuArray.randn(1,n, prec);
            e4 = e4 + sum(x.^4);
        end
        e4 = e4 / N;
        wait(gpu);    % ensure it has completed)
        fprintf(' ave = %f, elapsed time = %f \n',e4,toc)
    end

    disp(' ')
    disp('CPU')

    for M = [1e4 1e5 1e6 1e7]
        rng('default');
        tic
        e4 = 0;
        for m = 1:M:N
            n  = min(M,N-m+1);
            y  = randn(1,n, prec);
            e4 = e4 + sum(y.^4);
        end
        e4 = e4 / N;
        fprintf(' ave = %f, elapsed time = %f \n',e4,toc)
    end
end

disp(' ')
whos
