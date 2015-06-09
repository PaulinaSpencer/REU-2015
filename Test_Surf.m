%I'm only putting this in the github to make sure I'm doing this right.....
%so disregard this - or fiddle with it if you want

close all; 

% 
% I = imread('einstein.jpg') ; 
% bw = rgb2gray(I) ; 
% points = detectSURFFeatures(bw) ; 
% figure(10) ; imshow(bw); hold on 
% plot(points.selectStrongest(20))
% hold off
% 
% %% 
% original = imread('einstein.jpg')  ; 
% original = rgb2gray(original) ; 
% figure(1) ; imshow(original) 
%  
% scale = 1.3; 
% J = imresize(original,scale) ; 
% theta = 31; 
% distorted = imrotate(J,theta) ; 
% figure(2) ; imshow(distorted) 
% 
% ptsOriginal = detectSURFFeatures(original) ; 
% ptsDistorted = detectSURFFeatures(distorted) ; 
% 
% [featuresOriginal, validPtsOriginal] = extractFeatures(original, ptsOriginal) ; 
% [featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted) ; 
% %valid points are points that might have been too close to the border 
% 
% indexPairs = matchFeatures(featuresOriginal, featuresDistorted) ; 
% 
% matchedOriginal = validPtsOriginal(indexPairs(:,1)) ; 
% matchedDistorted = validPtsDistorted(indexPairs(:,2)) ; 
% 
% figure() ; 
% showMatchedFeatures(original, distorted, matchedOriginal,matchedDistorted)
% title('matched!') ; 
% 
% %remove false matches
% [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity') ; 
% figure(); 
% showMatchedFeatures(original,distorted, inlierOriginal,inlierDistorted)
% title('matching! (inlier pts only)')
% legend('ptsOriginal','ptsDistorted') 
% 
% %%
% I = imread('datmagicshape.jpg') ; I = rgb2gray(I) ; 
% corners = detectFASTFeatures(I, 'MinContrast', 0.5) ; 
% J = insertMarker(I,corners,'circle') ; 
% figure() ; imshow(J) ; 
% 
% I = imread('street.jpg') ; I = rgb2gray(I) ; 
% corners = detectFASTFeatures(I, 'MinContrast', 0.2) ; 
% J = insertMarker(I,corners,'circle') ; 
% figure() ; imshow(J) ; 
% 
% I = imread('SAS.jpg') ; I = rgb2gray(I) ; 
% corners = detectFASTFeatures(I, 'MinContrast', 0.2) ; 
% J = insertMarker(I,corners,'circle') ; 
% figure() ; imshow(J) ; 

img = imread('einstein.jpg') ; 
%img = rgb2gray(img) ; 
[fv, hv] = extractHOGFeatures(img) ;
figure() ; imshow(img) ; hold on; plot(hv)
