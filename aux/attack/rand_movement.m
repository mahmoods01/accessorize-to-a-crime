function [accessory_area, accessory_im, movement_info] = rand_movement(accessory_im, accessory_area, hor_range, vert_range, rot_range)
% Randomly move the accessory horizontaly, vertically, or rotate it
% within the ranges: [-hor_range,hor_range], [-vert_range,vert_range],
% and [-rot_range,rot_range]

    movement_info = struct();
    
    height = size(accessory_im, 1);
    width = size(accessory_im, 2);

    % Horizontal movement
    h_mov = round((2*(rand()-0.5))*hor_range);
    movement_info.h_mov = h_mov;
    add = 255 + zeros(abs(h_mov), width, 3);
    if h_mov>0
        accessory_im = [add; accessory_im(1:end-h_mov,:,:)];
        accessory_area = [add~=255; accessory_area(1:end-h_mov,:,:)];
    elseif h_mov<0
        accessory_im = [accessory_im(-h_mov+1:end,:,:); add];
        accessory_area = [accessory_area(-h_mov+1:end,:,:); add~=255];
    end

    % Vertical movement
    v_mov = round((2*(rand()-0.5))*vert_range);
    movement_info.v_mov = v_mov;
    add = 255 + zeros(height, abs(v_mov), 3);
    if v_mov>0
        accessory_im = [add accessory_im(:,1:end-v_mov,:)];
        accessory_area = [add~=255 accessory_area(:,1:end-v_mov,:)];
    elseif v_mov<0
        accessory_im = [accessory_im(:,-v_mov+1:end,:) add];
        accessory_area = [accessory_area(:,-v_mov+1:end,:) add~=255];
    end
    
    % Rotation
    theta = (2*(rand()-0.5))*rot_range;
    movement_info.rotation = theta;
    accessory_im = imrotate(accessory_im, theta, 'crop');
    accessory_area = imrotate(accessory_area, theta, 'crop');
    
end