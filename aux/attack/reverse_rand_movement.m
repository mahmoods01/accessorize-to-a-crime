function perturbation = reverse_rand_movement(perturbation, movement_info)
% reverse the random movement made to the accessory in rand_movement()

    perturbation_tmp = perturbation;
    height = size(perturbation, 1);
    width = size(perturbation, 2);

    % Horizontal movement
    h_mov = movement_info.h_mov;
    add = zeros(abs(h_mov), width, 3);
    if h_mov>0
        perturbation = [perturbation(h_mov+1:end,:,:); add];
    elseif h_mov<0
        perturbation = [add; perturbation(1:end+h_mov,:,:)];
    end

    % Vertical movement
    v_mov = movement_info.v_mov;
    add = zeros(height, abs(v_mov), 3);
    if v_mov>0
        perturbation = [perturbation(:,v_mov+1:end,:) add];
    elseif v_mov<0
        perturbation = [add perturbation(:,1:end+v_mov,:)];
    end
    
    % Rotation
    theta = movement_info.rotation;
    perturbation = imrotate(perturbation, -theta, 'crop');

end