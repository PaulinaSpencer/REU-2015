%This detects SURF POI and calculates the description vector for all of the
%images in the Caltech 101 data set.  Now all we need is to add the
%matching section

close all; clear all; clc;
CurrentDir = 'C:\Users\Paulina\Desktop\Desktop Folders\REU 2015\SURF'; 
ImgFolderDir = strcat(CurrentDir, '\101_ObjectCategories') ;
Caltech101 = dir(ImgFolderDir)  ;
lengthData = length(Caltech101) ; %why 104. 102 b/c matlab starts counting at 1?


for i = 3:lengthData 
    CurrentFolder = Caltech101(i).name 
    FolderLocation =  strcat(ImgFolderDir, '\', CurrentFolder, '\*.jpg') %The folder we want the images from
    SpecificDir = dir(FolderLocation) ;
    lengthCurrentDir = length(SpecificDir) ;
    cd(strcat(ImgFolderDir, '\', CurrentFolder)); %change directory since images in different folders have the same name
    
    %Now go through the directory one image at a time
    for k = 1:lengthCurrentDir 
    IMGname = SpecificDir(k).name 
    I = imread(IMGname) ; %load image
    imshow(I)%just to make sure the correct type of image is loading.... 
    if ndims(I)>2 %If RGB img convert to grayscale
    I = rgb2gray(I) ; 
    end
    points = detectSURFFeatures(I) ; %extracts POI
    
    if points.Count>0 %won't run if no SURF Features are detected
    figure(1) ; imshow(I); hold on 
    [features,validPoints] = extractFeatures(I,points) ; %gets description vectors
    plot(validPoints.selectStrongest(10), 'showOrientation',true)  ; %plots most prominent SURF features, with orientation
    title(IMGname)
    hold off
    else
        disp('no SURF POI')
    end
    
    %matching/categorizing will go here
    
    end
end


