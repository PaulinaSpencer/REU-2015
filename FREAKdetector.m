%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Filename:     FREAKdetector.m      %%%
%%% Created by:   Marisa Huffman       %%%
%%% Adapted by:                        %%%
%%% Supported by: NCSU REU 2015        %%%
%%% Advisers:                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% function [features, valid_corners, bw] = FREAKdetector(I)
%
% This function takes in an image matrix of an rgb or grayscale image and 
% uses FAST and FREAK to detect the features.
%
% This function has the following input parameters:
% ~ I: Image matrix - can save an image to a variable with 
%      imread('imageEx.jpg')
%
% This function has the following output parameters:
% ~ features - binary string descriptor from extracting features with
%              FREAK
% ~ valid_corners - corner points detected using FREAK
% ~ bw - black and white matrix of the passed in rgb matrix
%
% This function does not call any outside functions. 
%
% This function contains no subfunctions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [features, valid_corners, bw] = FREAKdetector(I)
% I - passed in image matrix
bw = rgb2gray(I); 
% Converts image to grayscale and saves it into a 2d matrix bw
corners = detectFASTFeatures(bw); 
% Detects corners using the FAST feature detector

% %%%%%% FIGURE 1
% figure(1);
% imshow(bw); hold on;
% % Creates a new figure and shows the grayscale image
% plot(corners.selectStrongest(400));
% title('FAST features');
% % Plots the strongest 400 corners detected with the FAST method over the
% % grayscale image
% hold off;

[features, valid_corners] = extractFeatures(bw, corners, 'Method', 'FREAK');
% Determines the sampling pairs and the most "important" features using the
% FREAK method

%%%%%%% FIGURE 2
% figure(2);
% imshow(bw); hold on;
% % Creates a second figure and prints the grayscale image
% plot(valid_corners.selectStrongest(200), 'showOrientation',true);
% title('FREAK features');
% % Plots the strongest 200 points that FREAK saw as important
% hold off;

end