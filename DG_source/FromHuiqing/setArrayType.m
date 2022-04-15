function newA = setArrayType(A, setGPU)
% SETARRAYTYPE Sets the type of the array as GPU array or CPU array.
%
%   Converts array A from a type of array (GPU or CPU) to another type of
%   array (GPU or CPU). If the input array already has the requested type,
%   nothing is done, and the original array is returned.
%
%   USAGE
%   -----
%       newA = setArrayType(A, useGPU);
%
%   INPUTS
%   ------
%       A: Array to redefine as gpu or cpu array.
%           (type: numeric, size: size(A))
%
%   OPTIONAL
%   --------
%       setGPU: Flags that sets the output array as GPU (true) type or CPU
%           type (false).
%           <DEFAULT>: true (CPU type)
%           (type: logical, size: single value)
%
%   OUTPUTS
%   -------
%       newA: Array A as new type of array.
%           (type: numeric, size: size(A))
%

    % Set default array type as gpu
    if ~exist('setGPU')
        setGPU = false;
    end

    % Check inputs

    % Check convertion flag type
    if (~islogical(setGPU) || ~isequal(size(setGPU), [1, 1]))
        error('edg_A:setArrayType:setGPUError', 'setArrayType :: setGPU must be a a single value logical.');
    end

    % Check input array type
    if ~isnumeric(A)
        error('edg_A:setArrayType:ATypeError', 'setArrayType :: input array must be numeric.');
    end


        
    % Convert the input array if not already the requested type
    if (setGPU && ~isgpuarray(A))
        newA = gpuArray(A);

    elseif (~setGPU && isgpuarray(A))
        newA = gather(A);

    else
        newA = A;
    end
end

