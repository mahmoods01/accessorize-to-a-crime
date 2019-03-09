function digital_impersonation(net_path, main_data_directory, images_directory, impersonator, target)

%% Setting Parameters
num_images = 1;
step_size = 20;
lambda_tv = 0;
printability_coeff = 0;
momentum_coeff = 0.4;
gauss_filtering = 0;
max_iter = 300;
stop_prob = 0.95;
channels_to_fix = [];
move_ranges.hor_range = 0;
move_ranges.vert_range = 0;
move_ranges.rot_range = 0;
verbose = 1;

%% Constants
potential_starting_colors = [
          128, 128, 128; % Grey
          220, 130, 0;   % Orangish
          160, 105, 55;  % Brownish
          200, 175, 30;  % Goldish
          220, 210, 50;  % Yellowish
          ];

%% Loading, and experiment setup
net = load(net_path);
net = net.net;
[net, ~] = change_dropout_rates(net, 0);

%% Use GPU?
preprocess = @(x)(x);
if gpuDeviceCount>0
    net = vl_simplenn_move(net, 'gpu');
    preprocess = @(x)(gpuArray(x));
end

%% Prepare the experiment, starting from the best solid color
best_experiment = []; max_avg_target_prob = 0;
for c_i = 1:size(potential_starting_colors, 1)
    starting_vals = repmat(reshape(potential_starting_colors(c_i,:), [1 1 3]), [224 224]);
    experiment = prepare_experiment( starting_vals, fullfile(main_data_directory, images_directory), num_images );
    ims = single(experiment.images);
    for im_i = 1:size(experiment.images,4)
        im = double(ims(:,:,:,im_i));
        im( experiment.accessory_area~=0 ) = starting_vals( experiment.accessory_area~=0 );
        ims(:,:,:,im_i) = single(im);
    end
    scores = gather(classify_convnet(preprocess(single(ims)), net));
    scores = scores(:,:,target,:);
    avg_target_prob = mean(scores(:));
    if avg_target_prob>max_avg_target_prob
        max_avg_target_prob = avg_target_prob;
        best_experiment = experiment;
    end
end
experiment = best_experiment;

%% Find the perturbation
experiment = impersonate( experiment, net, target, step_size, lambda_tv, ...
                          printability_coeff, momentum_coeff, max_iter, ...
                          verbose, gauss_filtering, channels_to_fix, ...
                          move_ranges, preprocess, stop_prob );

                      
%% Store result
results_file = sprintf('vgg-nn-%d-digital-impersonate-%d.mat', impersonator, target);
save(['./results/' results_file], 'experiment');

end