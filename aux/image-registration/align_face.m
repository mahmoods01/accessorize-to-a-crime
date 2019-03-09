function im = align_face( im, nPoints, target_nPoints, crop )
% Align faces with an affine transform
% im = align_face( im, nPoints, target_nPoints, crop )
%   im: image
%   nPoints: source landmarks
%   target_nPoints: target landmarks
%   crop: crop the resulting image (e.g., [1 1 224 224])


    im = affine_transform(im, nPoints, target_nPoints);
   
    % crop
    if nargin>3
       im = imcrop(im, crop);
       if( size(im,1)<crop(3) )
           im = [im; zeros(crop(3)-size(im,1)+1, size(im,2), size(im,3))];
       end
       if( size(im,2)<crop(4) )
           im = [im zeros(size(im,1), crop(4)-size(im,2)+1, size(im,3))];
       end
       im = im(1:crop(3), 1:crop(4), :);
    end

end
