%%
% Copyright 2022 Netherlands eScience Center and Department of the Built
% Environment, Eindhoven University of Technology
% Licensed under the Apache License, version 2.0. See LICENSE for details.


function newA = setArrayType(A, setGPU, setSingle)
% SETARRAYTYPE Sets the type of the array as GPU array or CPU array.
%
%   Converts array A from a type of array (GPU or CPU and double or single) to 
%   another type of array (GPU or CPU and double or single). If the input array
%   already has the requested type, nothing is done, and the original array is 
%   returned.
%
%   USAGE
%   -----
%       newA = setArrayType(A, useGPU);
%
%   INPUTS
%   ------
%       A: Array to redefine as gpu or cpu array.
%           (type: numeric, size: size(A))
%       setGPU: Flag that sets the output array as GPU (true) type or CPU
%           type (false).
%           []: keep CPU/GPU as A
%           (type: logical or [], size: single value)
%       setSingle: Flag that sets the output array as single (true) type or
%           double type (false).
%           []: keep single/double as A
%           (type: logical or [], size: single value)
%
%   OUTPUTS
%   -------
%       newA: Array A as new type of array.
%           (type: numeric, size: size(A))
%
    % Check input array type
    if ~isnumeric(A)
        error('edg_A:setArrayType:ATypeError', 'setArrayType :: input array must be numeric.');
    end

    % Check convertion flag type (GPU/CPU)
    if ~isempty(setGPU)
        if (~islogical(setGPU) || ~isequal(size(setGPU), [1, 1]))
            error('edg_A:setArrayType:setGPUError', 'setArrayType :: setGPU must be a a single value logical or empty array.');
        end
    end

    % Check convertion flag type (single/double)
    if ~isempty(setSingle)
        if (~islogical(setSingle) || ~isequal(size(setSingle), [1, 1]))
            error('edg_A:setArrayType:setSingleError', 'setArrayType :: setsinge must be a a single value logical or empty array.');
        end
    end

    % Determine the conversion function
    setAFunction = setExplicitTypeRequest(A, setGPU, setSingle);
    
    % Make the conversion
    newA = setAFunction(A);
end


function setAFunction = setExplicitTypeRequest(A, setGPU, setSingle)
% SETEXPLICITTYPEREQUEST Explicitly sets the type request function.
%
%   For default values [] the target types depend on the input array A.
%   This function takes that into account and sets the types accordingly.
%
%   USAGE
%   -----
%       setArrayFunction = setExplicitTypeRequest(A, setGPU, setSingle);
%
%   INPUTS
%   ------
%       A: Array to redefine as gpu or cpu array.
%           (type: numeric, size: size(A))
%       setGPU: Flag that sets the output array as GPU (true) type or CPU
%           type (false).
%           []: keep CPU/GPU as A
%           (type: logical or [], size: single value)
%       setSingle: Flag that sets the output array as single (true) type or
%           double type (false).
%           []: keep single/double as A
%           (type: logical or [], size: single value)
%
%   OUTPUTS
%   -------
%       setAFunction: The function to set the output array from the
%       input array A. This may be gpuArray, gather, identity, uint32,
%       int32, int64, uint64, etc. This depends on the input array A and on
%       the setGPU and setSingle flags.
%           Examples: 
%               A is a gpu array and setGPU is [] and setSingle is [] then setArrayFunction will be @(x) gpuArray(x)
%               A is cpu array and setGPU is [] and setSingle is [] then setArrayFunction will be @(x) gather(x)
%               A is gpu array and setGPU is false and setSingle is [] then setArrayFunction will be @(x) gather(x) 
%               A is a single gpu array and setGPU is false and setSingle is false then setArrayFunction will be @(x) double(gather(x))
%               A is int64 cpu array and setGPU is true and setSingle is true then setArrayFunction will be @(x) gpuArray(in32(x))
%           (type: function_handle, size: single value)

    % setAFunction to set the conversion of the input array A is the
    % composition of two functions. One to convert the floating type
    % (single/double) and another to convert the hardware type of the array
    % (gpu/cpu).

    % First determine double/single conversion function

    if isfloat(A)
        if isempty(setSingle)
            setTypeFunction = @(x) x;  % keep the same type of A since setSingle is []

        elseif setSingle
            if isa(A, 'single')
                setTypeFunction = @(x) x;  % keep the same type of A since A is already single

            else
                setTypeFunction = @(x) single(x);  % convert to single since A is double and we want single
            end

        else
            if isa(A, 'single')
                setTypeFunction = @(x) double(x);  % convert to double since A is single and we want double

            else
                setTypeFunction = @(x) x;  % keep the same type of A since A is already double
            end
        end

    else
        % Integer type A
        if isempty(setSingle)
            setTypeFunction = @(x) x;  % keep the same type of A since setSingle is []

        elseif setSingle
            if isa(A, 'uint32') || isa(A, 'int32')
                setTypeFunction = @(x) x;  % keep the same type of A since A is already int32 or uint32

            elseif isa(A, 'uint64')
                setTypeFunction = @(x) uint32(x);  % convert to uint32 since A is uint64 and we want single precision

            elseif isa(A, 'int64')
                setTypeFunction = @(x) int32(x);  % convert to int32 since A is int64 and we want single precision

            else
                error('edg_A:setArrayType:typeError', 'setArrayType :: invalid type of input array.');
            end

        else
            if isa(A, 'uint32')
                setTypeFunction = @(x) uint64(x);  % convert to uint64 since A is uint32 and we want double precision

            elseif isa(A, 'int32')
                setTypeFunction = @(x) int64(x);  % convert to int64 since A is int32 and we want double precision
            
            else 
                setTypeFunction = @(x) x;  % keep the same type of A since A is already double precision
            end
        end
    end

    % Then determine gpu/cpu conversion function
    if isgpuarray(A)
        if isempty(setGPU)
            setHardwareFunction = @(x) x;  % keep the same hardware type for input array A

        elseif setGPU
            setHardwareFunction = @(x) x;  % input array A is already GPU array

        else
            setHardwareFunction = @(x) gather(x);  % input array A must be converted to CPU array
        end

    else
        if isempty(setGPU)
            setHardwareFunction = @(x) x;  % keep the same hardware type for input array A

        elseif setGPU
            setHardwareFunction = @(x) gpuArray(x);  % input array A must be converted to GPU array

        else
            setHardwareFunction = @(x) x;  % input array A is already a CPU array
        end
    end

    % Put the two conversion functions together
    % Just do a small optimization to minimize memory on the GPU when
    % converting to CPU and type at the same time and vice versa.
    if isgpuarray(A)
        setAFunction = @(x) setTypeFunction(setHardwareFunction(x));
        
    else
        setAFunction = @(x) setHardwareFunction(setTypeFunction(x));
    end
end