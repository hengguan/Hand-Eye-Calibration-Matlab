function [TBase, TEnd, cameraParams, TBaseStd, TEndStd, pixelErr]=calibrateKUKA(filename,squareSize)
% Script to find transformation
%% Initialize variables.
clc;
delimiter = ',';
formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
fullName=sprintf('../Calibration/%s',filename);
fileID = fopen(fullName,'r');
%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
armMat=zeros(4,4);
poseMatrix = [dataArray{1:end-1}];

for pose=1:size(poseMatrix,1)
    if(pose~=poseMatrix(pose,1)) % the order is not correct
         error('Please check the calibration file is arranged in order starting from pose 1');
    return 
    end
%% Construct the Rotation Matrix:
R = rotz(deg2rad(poseMatrix(pose,5)))*roty(deg2rad(poseMatrix(pose,6)))*rotx(deg2rad(poseMatrix(pose,7)));
%% Construct the translation: (given in mm)
T = [poseMatrix(pose,2)/1000, poseMatrix(pose,3)/1000, poseMatrix(pose,4)/1000];
%% Construct the Matrix

Tr =[R T';zeros(1,3) 1];
 armMat(:,:,pose)=Tr;
end
%% path to images of checkerboards
imageFolder = '../Calibration/Images';
%run calibration
[TBase, TEnd, cameraParams, TBaseStd, TEndStd, pixelErr] = CalCamArm(imageFolder, armMat, squareSize,'maxBaseOffset',1);
%print results
fprintf('\nFinal camera to arm base transform is\n')
disp(TBase);

fprintf('Final end effector to checkerboard transform is\n')
disp(TEnd);

fprintf('Final camera matrix is\n')
disp(cameraParams.IntrinsicMatrix');

fprintf('Final camera radial distortion parameters are\n')
disp(cameraParams.RadialDistortion);

fprintf('Final camera tangential distortion parameters are\n')
disp(cameraParams.TangentialDistortion);
end



