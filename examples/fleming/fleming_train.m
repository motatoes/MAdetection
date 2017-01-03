dataset = 'messidor';

if (strcmp(dataset, 'messidor'))
    DATASET_SETTINGS = microaneurysm.settings.DatasetMessidor(SettingsGlobal.datasetPath);
elseif (strcmp(dataset, 'diaretdb'))
    DATASET_SETTINGS = microaneurysm.settings.DatasetDiaretdb2(SettingsGlobal.datasetPath);
end

% The following variables are loaded as a result of the call to 'settings':
trainimagenames = { DATASET_SETTINGS.training_files{:} DATASET_SETTINGS.test_files{:} };
output_dir = '';
% ============

IMAGE_FOLDER = DATASET_SETTINGS.pathImage;
GROUNDTRUTH_FOLDER = DATASET_SETTINGS.pathGround;
GROUNDTRUTH_SUFFIX = DATASET_SETTINGS.groundtruthSuffix;

for p_idx = 1:length(trainimagenames)
    disp(strcat('************ ', 'Performing training on image: ', num2str(p_idx) ,' ***************'));

    %% == loading initial images == %%
    %     groundtruth_matfile = strcat(GROUNDTRUTH_FOLDER, '\', imagenames{p_idx}, GROUNDTRUTH_SUFFIX );
    %     OD_matfile = strcat(OD_FOLDER , '\', imagenames{p_idx}, '_markers_new.mat' );
    %     fullsizeImage = imread( strcat(IMAGE_FOLDER, '\', imagenames{p_idx}) ); % The full sized image (in case it was rescaled) 
    fullsizeImage = DATASET_SETTINGS.getImage(trainimagenames{p_idx});
    green_channel = microaneurysm.util.color2green( fullsizeImage );
    
    ODmask = DATASET_SETTINGS.getODImage(trainimagenames{p_idx});
    
    fovMask = microaneurysm.util.generate_FOV_mask(green_channel);
    % eroding in case the fovmask included part of the background
    fovMask = imerode(fovMask, strel('disk', 3));

    % Generating vessel mask
%     vesselMask = colour_segmentation( fullsizeImage,  fovMask, 'W', 19);
%     % postprocessing the vessel mask by removing small objects in it
%     vesselMask = bwareaopen(vesselMask, 100);++-
    GTmask = DATASET_SETTINGS.getGTImage(trainimagenames{p_idx});
    
    fleming = microaneurysm.algorithm.Fleming();
%     a.candidatesDetector.setExclusionMask( ODmask | ~fovMask );
    fleming.candidateDetectionOptions = {'exclusionMask', ODmask | ~fovMask };
    [trainingFeatures, intermediateResults] = fleming.train( fullsizeImage, GTmask );
    
    save( strcat(trainimagenames{p_idx}, '_training', '.mat' ), 'trainingFeatures', 'intermediateResults' );
    
end
