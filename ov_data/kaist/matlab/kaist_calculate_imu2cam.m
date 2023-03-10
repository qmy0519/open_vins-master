
clear all;
close all;


% stereoParams.mat
% load their stereo parameters
% looks like they used the matlab calibration tool to get it.
% https://www.mathworks.com/help/vision/ref/stereoparameters.html#d117e94134
load ../raw/stereoParams.mat
stereoParams = toStruct(stereoParams);

% transform between the left (stereo pair base) and the right camera
% the units of the stereo parameters are millimeters
% need to get R_1to2 and p_1in2
R_2to1 = stereoParams.RotationOfCamera2;
p_2in1 = stereoParams.TranslationOfCamera2'/1000;
T_LtoR = [...
    R_2to1' p_2in1;
    0 0 0 1
];

% Use this computed output if you do not have the toolbox
% TODO: can we manually read in the stereParams.mat? (probs not)
% T_LtoR = [...
%     1.0000   -0.0021   -0.0036   -0.4751;
%     0.0021    1.0000    0.0046   -0.0011;
%     0.0036   -0.0046    1.0000    0.0020;
%          0         0         0    1.0000;
% ];


% Vehicle2Stereo.txt
% Stereo camera (based on left camera) extrinsic calibration parameter from vehicle
% NOTE: This was taken from the Urban28 dataset
% NOTE: The sample_with_img.tar.gz has different calibration (shouldn't be used)
% WHAT????? THEIR POSITION IS INCORRECTLY THE OPOSITE DIRECTION????
p_LinV = [1.64239; 0.247401; 1.58411];
R_LtoV = [-0.00680499 -0.0153215 0.99985; -0.999977 0.000334627 -0.00680066; -0.000230383 -0.999883 -0.0153234];
T_VtoL = [...
    R_LtoV' -R_LtoV'*p_LinV;
    0 0 0 1
];


% Vehicle2IMU.txt
% IMU extrinsic calibration parameter from vehicle
p_IinV = [-0.07; 0; 1.7];
R_ItoV = [1 0 0; 0 1 0; 0 0 1];
T_VtoI = [...
    R_ItoV' -R_ItoV'*p_IinV;
    0 0 0 1
];


% calculate the transform between the camneras and the IMU
T_LtoI = T_VtoI*inv(T_VtoL);
T_RtoI = T_VtoI*inv(T_LtoR*T_VtoL);


% print it out
fprintf('T_C0toI = \n');
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_LtoI(1,1),T_LtoI(1,2),T_LtoI(1,3),T_LtoI(1,4));
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_LtoI(2,1),T_LtoI(2,2),T_LtoI(2,3),T_LtoI(2,4));
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_LtoI(3,1),T_LtoI(3,2),T_LtoI(3,3),T_LtoI(3,4));
fprintf('%.5f,%.5f,%.5f,%.5f\n',T_LtoI(4,1),T_LtoI(4,2),T_LtoI(4,3),T_LtoI(4,4));

fprintf('T_C1toI = \n');
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_RtoI(1,1),T_RtoI(1,2),T_RtoI(1,3),T_RtoI(1,4));
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_RtoI(2,1),T_RtoI(2,2),T_RtoI(2,3),T_RtoI(2,4));
fprintf('%.5f,%.5f,%.5f,%.5f,\n',T_RtoI(3,1),T_RtoI(3,2),T_RtoI(3,3),T_RtoI(3,4));
fprintf('%.5f,%.5f,%.5f,%.5f\n',T_RtoI(4,1),T_RtoI(4,2),T_RtoI(4,3),T_RtoI(4,4));

