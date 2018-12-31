%Simple script to quickly demo use of CalCamArm.m

%path to images of checkerboards
imageFolder = './Example Data/Images/Calibration';
%loading arm transformations
load('./Example Data/Calibration_21-Apr-2016 17:22:35.mat');
%checkerboard square widths in mm
squareSize = 27.5;
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
%%%[-1 0 0 0;0 -1 0 0;0 0 1 0;0 0 0 1]

trplot(eye(4),'frame','B','color','b','length',0.5);
hold on;
trplot(inv(TBase),'frame','K','color','r','length',0.5);
hold off;


m=inv(TBase);
R=tr2rt(m);
Q=Quaternion(R);
S=transl(m);

% TBase =
% 
%    -0.9999    0.0101   -0.0107   -0.2116
%     0.0145    0.7825   -0.6225    0.4159
%     0.0021   -0.6225   -0.7826    0.2042
%          0         0         0    1.0000
         

% KB=inv(TBase)
% 
% KB =
% 
%    -0.9999    0.0145    0.0021   -0.2181
%     0.0101    0.7825   -0.6225   -0.1962
%    -0.0107   -0.6225   -0.7826    0.4164
%          0         0         0    1.0000
%          
         
%% Q
% 0.0033708 < 0.0065251, 0.94406, -0.3297 >

%% S    -0.2181    -0.1962     0.4164