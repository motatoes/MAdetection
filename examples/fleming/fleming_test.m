
dataset = 'messidor'; % {messidor, diaretdb}

if (strcmp(dataset, 'messidor'))
    DATASET_SETTINGS = microaneurysm.settings.DatasetMessidor(SettingsGlobal.datasetPath);
elseif (strcmp(dataset, 'diaretdb'))
    DATASET_SETTINGS = microaneurysm.settings.DatasetDiaretdb2(SettingsGlobal.datasetPath);
end
% The following variables are loaded as a result of the call to 'settings':
trainingimagenames = DATASET_SETTINGS.training_files;
testimagenames = DATASET_SETTINGS.test_files;
output_dir = '';
% ============

IMAGE_FOLDER = DATASET_SETTINGS.pathImage;
GROUNDTRUTH_FOLDER = DATASET_SETTINGS.pathGround;
GROUNDTRUTH_SUFFIX = DATASET_SETTINGS.groundtruthSuffix;

% Loading features
trainingFeatures = [];
for i=1:length(trainingimagenames)
    x = load(strcat('experiments/fleming/', dataset, '/', testimagenames{i}, '_training.mat'), 'trainingFeatures');
    trainingFeatures = [trainingFeatures; x.trainingFeatures];
    
end

% Undersampling
trainingFeatures = microaneurysm.classification.undersample(trainingFeatures);

for p_idx = 1:length(testimagenames)
    x = load(strcat('experiments/fleming/', dataset, '/', testimagenames{p_idx}, '_training.mat'));
end
