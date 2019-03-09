function align_vgg_pose(path, wildcard, target_landmarks_file)
% Align images to vgg pose
% Input:
%   path: folder where images are
%   wildcard: wildcard to find images to align (e.g., *.png)
%   target_landmarks_file: optional path to target's landmarks

    % load target landmarks
    if nargin<3
        target_landmarks_file = 'Fast_Marks_vgg_ref_face.png.csv';
    end
    target_landmarks = csvread(target_landmarks_file);

    % fixed variables
    prefix = 'Fast_Marks_';
    suffix = '.csv';
    out_prefix = 'aligned_vgg_';
    crop_size = [1 1 224 224];

    % align images
    imfiles = dir(fullfile(path, wildcard));
    for i_m = 1:numel(imfiles)
        im_fname = imfiles(i_m).name;
        landmarks_fname = strcat(prefix,im_fname,suffix);
        im = imread(fullfile(path,im_fname));
        landmarks = csvread(fullfile(path,landmarks_fname));
        im = align_face(im, landmarks, target_landmarks, crop_size);
        out_fname = strcat(out_prefix,im_fname);
        imwrite(im, fullfile(path,out_fname));
    end


end
