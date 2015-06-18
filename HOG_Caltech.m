close all; clear all; 
%This is an example from the c.  It shows how to classify digits usnig the hog features
%and multiclass SVM classifier.  
% http://www.mathworks.com/help/vision/examples/digit-classification-using-hog-features.html

%make one giant for loop for each set of images at line 20ish


% Location of the compressed data set
url = 'http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz';
% Store the output in a temporary folder
outputFolder = fullfile(tempdir, 'caltech101'); % define output folder

if ~exist(outputFolder, 'dir') % download only once
    disp('Downloading 126MB Caltech101 data set...');
    untar(url, outputFolder);
end
rootFolder = fullfile(outputFolder, '101_ObjectCategories');

imgSets = [ imageSet(fullfile(rootFolder, 'airplanes'))]%, ...
           % imageSet(fullfile(rootFolder, 'ferry')), ...
           % imageSet(fullfile(rootFolder, 'laptop')) ];
        
{ imgSets.Description } % display all labels on one line
[imgSets.Count]         % show the corresponding count of images

[trainingSets, validationSets] = partition(imgSets, 0.3, 'randomize');

airplanes = read(trainingSets,1);
%ferry     = read(trainingSets(2),1);
%laptop    = read(trainingSets(3),1);

figure

subplot(1,3,1);
imshow(airplanes)
% subplot(1,3,2);
% imshow(ferry)
% subplot(1,3,3);
% imshow(laptop)




% Load training and test data using imageSet.
% syntheticDir   = fullfile(toolboxdir('vision'), 'visiondata','digits','synthetic');
% handwrittenDir = fullfile(toolboxdir('vision'), 'visiondata','digits','handwritten');

% imageSet recursively scans the directory tree containing the images.
% trainingSet = imageSet(syntheticDir,   'recursive');
% testSet     = imageSet(handwrittenDir, 'recursive');

% Show training and test samples
% figure;
% 
% subplot(2,3,1);
% imshow(trainingSet(2).ImageLocation{3});
% 
% subplot(2,3,2);
% imshow(trainingSet(4).ImageLocation{23});
% 
% subplot(2,3,3);
% imshow(trainingSet(9).ImageLocation{4});
% 
% subplot(2,3,4);
% imshow(testSet(2).ImageLocation{2});
% 
% subplot(2,3,5);
% imshow(testSet(4).ImageLocation{5});
% 
% subplot(2,3,6);
% imshow(testSet(9).ImageLocation{8});

% Show pre-processing results
exTestImage = read(validationSets(1), 5); %testset now is validationSets was(4) now (1) just to test
lvl = graythresh(exTestImage);
processedImage = im2bw(exTestImage,lvl);

figure;

subplot(1,2,1)
imshow(exTestImage)

subplot(1,2,2)
imshow(processedImage)

img = read(trainingSets, 4);
figure()
imshow(img)
% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

% Show the original image
figure;
subplot(2,3,1:3); imshow(img);

% Visualize the HOG features
subplot(2,3,4);
plot(vis2x2);
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});

subplot(2,3,5);
plot(vis4x4);
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});

subplot(2,3,6);
plot(vis8x8);
title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

%because [4 4] looks the best
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

% The trainingSet is an array of 10 imageSet objects: one for each digit.
% Loop over the trainingSet and extract HOG features from each image. A
% similar procedure will be used to extract features from the testSet.

trainingFeatures = [];
trainingLabels   = [];

for digit = 1:numel(trainingSets) %only have one training set now.... add more later

    numImages = trainingSets(digit).Count;
    sizeFeatures = [] ;
    
    for i = 1:numImages

        img = read(trainingSets(digit), i);

        % Apply pre-processing steps
        lvl = graythresh(img);
        img = im2bw(img, lvl);

        
       featuresCell{i} = extractHOGFeatures(img, 'CellSize', cellSize); %
       numHogFeat = size(featuresCell{i}) ;
       sizeFeatures = [sizeFeatures; numHogFeat(1,2)] ; 
    end
    MaxHogFeat = max(sizeFeatures) ; 
    features  = zeros(numImages, MaxHogFeat, 'single');
    
    for k=1:numImages
        CurrentVector = featuresCell{k} ; 
    for j=1:sizeFeatures(k)
        features(k,j) = CurrentVector(1,j) ;     
    end        
    end
   
    
    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(trainingSets(digit).Description, numImages, 1);

    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels;   labels  ];   %#ok<AGROW>

end

% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

% Extract HOG features from the test set. The procedure is similar to what
% was shown earlier and is encapsulated as a helper function for brevity.

%[testFeatures, testLabels] =
%helperExtractHOGFeaturesFromImageSet(validationSets, hogFeatureSize,
%cellSize); replace with earlier function buuut with validation set...
validationFeatures = [] ;
validationLabels=[];
for digit = 1:numel(validationSets) %only have one training set now.... add more later

    numImages = validationSets(digit).Count;
    sizeFeatures = [] ;
    
    for i = 1:numImages

        img = read(validationSets(digit), i);

        % Apply pre-processing steps
        lvl = graythresh(img);
        img = im2bw(img, lvl);

        
       featuresCell{i} = extractHOGFeatures(img, 'CellSize', cellSize); %
       numHogFeat = size(featuresCell{i}) ;
       sizeFeatures = [sizeFeatures; numHogFeat(1,2)] ; 
    end
    MaxHogFeat = max(sizeFeatures) ; 
    features  = zeros(numImages, MaxHogFeat, 'single');
    
    for k=1:numImages
        CurrentVector = featuresCell{k} ; 
    for j=1:sizeFeatures(k)
        features(k,j) = CurrentVector(1,j) ;     
    end        
    end
   
    
    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(validationSets(digit).Description, numImages, 1);

    validationFeatures = [validationFeatures; features];   %#ok<AGROW>
    validationLabels   = [validationLabels;   labels  ];   %#ok<AGROW>

end



% % This is the last step to matching - need to get this to work 
% % 
% % % Make class predictions using the test features.
% % predictedLabels = predict(classifier, validationFeatures);
% % 
% % % Tabulate the results using a confusion matrix.
% % confMat = confusionmat(validationLabelsLabels, predictedLabels);
% % 
% % helperDisplayConfusionMatrix(confMat)