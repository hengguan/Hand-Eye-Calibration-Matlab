function [TBase, TEnd, cameraParams, TBaseStd, TEndStd, pixelErr]=calibrateKinova(poseNum, squareSize)
% Script to find transformation
%% Initialize variables.
clc;
delimiter = ',';
posesMat=zeros(4,4);
formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
for count=1:poseNum+1
    filename=sprintf('poses%02d.txt',count-1);
    fullName=sprintf('examples/calib1211/poses/%s',filename);
    fileID = fopen(fullName,'r');
    % fin=fopen('*.txt','r'); %��txt�ļ�
    list = load(fullName);
    % sprintf('calibration20171108/poses/%s',filename);
    posesMat(:,:,count)=list;
    % poses.append(list);
end
%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
%% Close the text file.
% fclose(fileID);
% armMat=zeros(4,4);
% poseMatrix = [dataArray{1:end-1}];

% for pose=1:size(poseMatrix,1)
%     if(pose~=poseMatrix(pose,1)) % the order is not correct
%          error('Please check the calibration file is arranged in order starting from pose 1');
%     return 
%     end
%% Construct the Rotation Matrix:
%     R = rotz(deg2rad(poseMatrix(pose,5)))*roty(deg2rad(poseMatrix(pose,6)))*rotx(deg2rad(poseMatrix(pose,7)));
%% Construct the translation: (given in mm)
%     T = [poseMatrix(pose,2)/1000, poseMatrix(pose,3)/1000, poseMatrix(pose,4)/1000];
%% Construct the Matrix

%     Tr =[R T';zeros(1,3) 1];
%     armMat(:,:,pose)=Tr;
% end
%% path to images of checkerboards
imageFolder = 'examples/calib1211/Images';
%run calibration
[TBase, InvTB, TEnd, InvTE, cameraParams, TBaseStd, TEndStd, pixelErr] = CalCamArmEIH(imageFolder, posesMat, squareSize,'maxBaseOffset',1);
%print results
fprintf('\nFinal arm end effector to camera transform is\n')
disp(TBase);

fprintf('\nFinal camera to arm end effector transform is\n')
disp(InvTB);

fprintf('Final checkerboard to arm base transform is\n')
disp(TEnd);

fprintf('Final arm base to checkerboard transform is\n')
disp(InvTE);

fprintf('Final camera matrix is\n')
disp(cameraParams.IntrinsicMatrix);

fprintf('Final camera radial distortion parameters are\n')
disp(cameraParams.RadialDistortion);

fprintf('Final camera tangential distortion parameters are\n')
disp(cameraParams.TangentialDistortion);
end
