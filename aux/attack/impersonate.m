function experiment = impersonate(experiment, net, target, step_size, lambda_tv, lambda_printability, momentum_coeff, max_iter, verbose, filtering, fixed_rgb_channels, move_ranges, preprocess, stop_prob)

    % adjust the step size and lambda_tv
    step_size = step_size/experiment.num_images;
    lambda_tv = lambda_tv/experiment.num_images;
    
    % rounds' perturbations
    perturbations = repmat(struct(), [experiment.num_images 1]);
    
    % a matrix of printable RGB values
    printable_vals = get_printable_vals();
    
    % start perturbing...
    scores = 0;
    iter = 1;
    while iter<=max_iter && mean(scores)<stop_prob
        
        %% Get gradients from net
        ims = [];
        movements = [];
        areas_to_perturb = [];
        for im_i = 1:experiment.num_images
            
            [round_accessory_area, round_accessory_im, movement_info] = ...
                    rand_movement(experiment.accessory_im, experiment.accessory_area, ...
                            move_ranges.hor_range, move_ranges.vert_range, move_ranges.rot_range);
            perturbations(im_i).movement_info = movement_info;
            
            % use segmentation to define the area to perturb
            area_to_perturb = round_accessory_area;
            area_to_perturb(:,:,fixed_rgb_channels) = 0;
                
            % add accessory
            im = double(experiment.images(:,:,:,im_i));
            im( round_accessory_area==1 ) = round_accessory_im( round_accessory_area==1 );
            
            % store image
            im = single(im);
            ims = cat(4, ims, im);
            movements = cat(1, movements, movement_info);
            areas_to_perturb = cat(4, areas_to_perturb, area_to_perturb);
        end        
        % Update the perturbation: increase the confidence in the target class
        [scores, gradients] = find_gradient( net, preprocess(ims), target );
        gradients = -gather(gradients);
        
        
        %% preprocess gradients compute TV gradients, and update perturbations
        for im_i = 1:experiment.num_images
            
            % get image, gradient, area to perturb, and movement info
            im = ims(:,:,:,im_i);
            gradient = gradients(:,:,:,im_i);
            area_to_perturb = areas_to_perturb(:,:,:,im_i);
            movement_info = movements(im_i);
            
            % normalize gradient
            gradient( area_to_perturb~=1 ) = 0;
            gradient = gradient(:)/max(abs(gradient(:)));

            % Update the perturbation: total variation
            [~, dr_tv] = total_variation(im, 1);
            dr_tv( area_to_perturb~=1 ) = 0;
            dr_tv = dr_tv(:)/max(abs(dr_tv(:)));

            % compute the perturbation, and reverse the movement
            r = step_size*gradient - dr_tv*lambda_tv;
            r = reshape(r,size(im));
            r = reverse_rand_movement(r, movement_info);
            r( experiment.accessory_area~=1 ) = 0;

            % apply Gaussian filtering
            if ~isempty(filtering) && filtering~=0
                for c = 1:3
                    r(:,:,c) = imgaussfilt(r(:,:,c), filtering);
                end
            end

            % store the perturbation from the given view
            if iter>1
                perturbations(im_i).r = momentum_coeff*perturbations(im_i).r + r;
            else
                perturbations(im_i).r = r;
            end
        end
        
        %% Non-printability score
        [ps, dr_printability] = non_printability_score( experiment.accessory_im, experiment.accessory_area(:,:,1), printable_vals );
        if lambda_printability~=0
            dr_printability = -dr_printability;
            dr_printability( (experiment.accessory_im + dr_printability) > 255) = 0;
            dr_printability( (experiment.accessory_im + dr_printability) < 0) = 0;
            area_to_perturb = experiment.accessory_area;
            dr_printability(:,:,fixed_rgb_channels) = 0;
            gradient( area_to_perturb~=1 ) = 0;
            experiment.accessory_im = experiment.accessory_im + lambda_printability*dr_printability;
        end
        
        %% apply the perturbations
        for r_i = 1:size(perturbations,1)
            % get the perturbation
            r = perturbations(r_i).r;

            % perturb the model
            r( (experiment.accessory_im + r) > 255) = 0;
            r( (experiment.accessory_im + r) < 0) = 0;
            experiment.accessory_im = experiment.accessory_im + r;
        end
        
        % quantization (values should be integets in {0,1,...,255}
        experiment.accessory_im = experiment.accessory_im - mod(experiment.accessory_im, 1);
        
        %% Display
        if verbose
            scores = scores(:,:,target,:);
            scores = scores(:);
            fprintf('Avg. target probability: %0.2e\n', mean(scores));
            fprintf('Non-printability score = %0.2e\n', ps);
            disp(['Done with iter #' num2str(iter)]);
            imshow(uint8(ims(:,:,:,1))); drawnow;
        end
        
        %% Update counter
        iter = iter + 1;
        
    end

end
