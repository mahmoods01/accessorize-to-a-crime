function experiment = prepare_experiment( starting_colors, images_dir, num_images )

    % load silhouette/accessory_im
    accessory_im = imread('aux/attack/silhouette.png');
    accessory_area = (accessory_im(:,:,1)~=0)|(accessory_im(:,:,2)~=0)|(accessory_im(:,:,3)~=0);
    accessory_area = repmat(accessory_area, [1 1 3]);
    accessory_im( accessory_area ) = starting_colors( accessory_area );

    % background images
    background_images = dir(fullfile(images_dir, 'aligned_*.png'));
    background_images = background_images(randperm(numel(background_images)));
    num_images = min(num_images, numel(background_images));
    background_images = background_images(1:num_images);
    images = uint8(zeros([224 224 3 num_images]));
    for i = 1:num_images
        im = imread(fullfile(images_dir, background_images(i).name));
        im = imresize(im, [224 224]);
        images(:,:,:,i) = im;
    end

    % prepare the experiment
    experiment = [];
    experiment.background_images_dir = images_dir;
    experiment.background_images_files = background_images;
    experiment.images = images;
    experiment.num_images = num_images;
    experiment.accessory_im = double(accessory_im);
    experiment.accessory_area = accessory_area;
    
end

