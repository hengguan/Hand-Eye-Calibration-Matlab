function [TBase, TEnd, cameraParams, TBaseStd, TEndStd, pixelErr]=calibrateKUKA(filenum,squareSize)
% Script to find transformation
%% Initialize variables.
clc;
delimiter = ',';
formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.

% fileID = fopen(fullName,'r');
%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
%% Close the text file.
% fclose(fileID);
armMat=zeros(4,4);
dataArray=zeros(filenum,7);
% poseMatrix = [dataArray{1:end-1}];

for count=1:filenum+1
    fullName=sprintf('calibration20171108/poses/poses%02d.txt',count-1);
    list = load(fullName);
    dataArray(count,:)=list;
end
poseMatrix = dataArray;
for pose=1:size(poseMatrix,1)
    if(pose~=poseMatrix(pose,1)+1) % the order is not correct
         error('Please check the calibration file is arranged in order starting from pose 1');
    return 
    end
%% Construct the Rotation Matrix:
R = rotz(poseMatrix(pose,5))*roty(poseMatrix(pose,6))*rotx(poseMatrix(pose,7));
%% Construct the translation: (given in mm)
T = [poseMatrix(pose,2), poseMatrix(pose,3), poseMatrix(pose,4)];
%% Construct the Matrix

Tr =[R T';zeros(1,3) 1];
 armMat(:,:,pose)=Tr;
end
%% path to images of checkerboards
imageFolder = 'calibration20171108/Images';
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