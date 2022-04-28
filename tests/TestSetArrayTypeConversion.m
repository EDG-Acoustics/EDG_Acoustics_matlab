%%
% Copyright 2022 Netherlands eScience Center and Building Acoustics group 
% % of Department of the Built Environment, Eindhoven University of Technology
% Licensed under the Apache License, version 2.0. See LICENSE for details.

%% Tests setArrayType conversion (tests all possible combinations)

classdef TestSetArrayTypeConversion < matlab.unittest.TestCase
    %% Set the properties to use in the tests
    properties(TestParameter)
        % Parameters to span
        hardwareTypeOriginal = {'gpu','cpu'};
        typeOriginal = {'double', 'single', 'uint32', 'int32', 'uint64', 'int64'};

        hardwareTypeDestination = {'gpu', 'cpu'};
        typeConversion = {'double', 'single'};
    end

    properties
        TestData;
    end


    %%
    methods(TestMethodSetup)
        function setPath(testCase)
        % This function is ran once per test bundle execution
        % In this case we add the DG kernel code to path to be able to access it
        % and save the original path to be able to go back to the original state
        % before the test.
            % Setup path
            testCase.TestData.originalPath = path();  % get the original path
            addpath(genpath('../DG_source'))  % add DG_source to path
        
            % Check if gpus are available
            testCase.TestData.hasGPU = (gpuDeviceCount() > 0);  % flag if there are gpus or not, to skip some of the tests
        
            % Setup warnings to show warning if gpus are not available
            testCase.TestData.originalWarningState = warning();  % get original warning state
            warning('on');  % set all warnings on
        end
    end
    

    %% 
    methods(TestMethodTeardown)
        function resetPath(testCase)
        % This function is ran once per test bundle execution
        % In this case we remove the DG kernel code from the path to revert to the
        % initial state
            % Return original path
            path(testCase.TestData.originalPath);  % returns the original state  
                                                   % instead of of removing DG_source,
                                                   % because it may have already
                                                   % been there and we do not want
                                                   % to break the original state
        
           
           % Return warning state
           warning(testCase.TestData.originalWarningState);
        end
    end


    %%
    methods (Test)
        function testArrayTypeConversion(testCase, hardwareTypeOriginal, typeOriginal, ...
                hardwareTypeDestination, typeConversion)
            arraySize = 10;

            if strcmp(hardwareTypeOriginal, 'gpu')
                testCase.assumeTrue(testCase.TestData.hasGPU, 'No GPU detected.');  % only runs this test if the computer has a gpu (test will be incomplete)
                A = gpuArray(reshape(typecast(rand(arraySize^2, 1), typeOriginal), arraySize, []));
            else
                A = reshape(typecast(rand(arraySize^2, 1), typeOriginal), arraySize, []);
            end
            
            if strcmp(typeConversion, 'single')
                setSingle = true;
                if isfloat(A)
                    typeDestination = 'single';
                else
                    typeDestination = [typeOriginal(1:end-2), '32'];
                end
            else
                setSingle = false;
                if isfloat(A)
                    typeDestination = 'double';
                else
                    typeDestination = [typeOriginal(1:end-2), '64'];
                end
            end

            if strcmp(hardwareTypeDestination, 'gpu')
                testCase.assumeTrue(testCase.TestData.hasGPU, 'No GPU detected.');  % only runs this test if the computer has a gpu (test will be incomplete)
                setGPU = true;
            else
                setGPU = false;
            end
                
            A_new = setArrayType(A, setGPU, setSingle);

            testCase.verifyEqual(underlyingType(A_new), typeDestination);
            testCase.verifyEqual(isgpuarray(A_new), setGPU);
        end
    end
end





%% Tests setArrayType conversion to gpu and cpu arrays

function tests = arrayTypeConversionTest()  % the name must be the same as the file
% Main test driver function
% This function defines all the tests to run as all the test functions in
% this file and runs them
    tests = functiontests(localfunctions);
end


function setupOnce(testCase)  % do not change function name
% This function is ran once per test bundle execution
% In this case we add the DG kernel code to path to be able to access it
% and save the original path to be able to go back to the original state
% before the test.
    % Setup path
    testCase.TestData.originalPath = path();  % get the original path
    addpath(genpath('../DG_source'))  % add DG_source to path

    % Check if gpus are available
    testCase.TestData.hasGPU = (gpuDeviceCount() > 0);  % flag if there are gpus or not, to skip some of the tests

    % Setup warnings to show warning if gpus are not available
    testCase.TestData.originalWarningState = warning();  % get original warning state
    warning('on');  % set all warnings on
end


function teardownOnce(testCase)  % do not change function name
% This function is ran once per test bundle execution
% In this case we remove the DG kernel code from the path to revert to the
% initial state
    % Return original path
    path(testCase.TestData.originalPath);  % returns the original state  
                                           % instead of of removing DG_source,
                                           % because it may have already
                                           % been there and we do not want
                                           % to break the original state

   
   % Return warning state
   warning(testCase.TestData.originalWarningState);
end


function testFloatConversion(testCase)
% Test if a float input array is correctly converted to the hardware and
% type requested
    A = rand(10);  % a cpu array
    newA = setArrayType(A, false);  % convert cpu array to cpu array, nothing should change
    
    verifyEqual(testCase, isgpuarray(newA), false);  % new array must be cpu array
    verifyEqual(testCase, newA, A);  % new array must be equal to original array
end


function testCPU2GPUConversion(testCase)
% Test if an input cpu array is converted to gpu array without changes in
% the array
    testCase.assumeTrue(testCase.TestData.hasGPU, 'No GPU detected.');  % only runs this test if the computer has a gpu (test will be incomplete)

    A = rand(10);  % a cpu array
    newA = setArrayType(A, true);  % convert cpu array to cpu array, only type should change
    
    verifyEqual(testCase, isgpuarray(newA), true);  % new array must be gpu array
    verifyEqual(testCase, newA, gather(A));  % new array must be equal to original array
end


function testGPU2GPUConversion(testCase)
% Test if an input gpu array is kept as a gpu array without changes
    testCase.assumeTrue(testCase.TestData.hasGPU, 'No GPU detected.');  % only runs this test if the computer has a gpu (test will be incomplete)
    
    A = rand(10, 'gpuArray');  % a gpu array
    newA = setArrayType(A, true);  % convert gpu array to gpu array, nothing should change
    
    verifyEqual(testCase, isgpuarray(newA), true);  % new array must be gpu array
    verifyEqual(testCase, gather(newA), gather(A));  % new array must be equal to original array
end


function testGPU2CPUConversion(testCase)
% Test if an input gpu array is converted to cpu array without changes in
% the array
    testCase.assumeTrue(testCase.TestData.hasGPU, 'No GPU detected.');  % only runs this test if the computer has a gpu (test will be incomplete)

    A = rand(10, 'gpuArray');  % a gpu array
    newA = setArrayType(A, false);  % convert gpu array to cpu array, only type should change
    
    verifyEqual(testCase, isgpuarray(newA), false);  % new array must be cpu array
    verifyEqual(testCase, newA, gather(A));  % new array must be equal to original array
end
