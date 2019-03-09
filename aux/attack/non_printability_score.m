function [score, gradient] = non_printability_score( im, segmentation, printable_vals )
% Evaluate the "non-printability" of an image: the products of the distances
% of the pixels of interest in an image from the set of printable values
    
    im = double(im);
    printable_vals = double(reshape(printable_vals, [size(printable_vals,1) 1 3]));
    
    my_norm = @(x,y)( sum( (x-y).^2 ) );
    max_norm = my_norm([0 0 0], [80 80 80]); % to keep values in a reasonable range
    
    % compute non-printability scores (per pixel)
    scores = ones( size(im,1), size(im,2) );
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            if segmentation(i,j,1) == 1
                for k = 1:size(printable_vals,1)
                    scores(i,j) = scores(i,j)*my_norm( im(i,j,:), printable_vals(k,1,:) )/max_norm;
                end
            else
                scores(i,j) = 0;
            end
        end
    end
    score = sum(scores(:));
    
    % compute gradients
    gradient = zeros( size(im) );
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            if segmentation(i,j,1) == 1 && scores(i,j)~=0
                for k = 1:size(printable_vals,1)
                    f_k = my_norm( im(i,j,:), printable_vals(k,1,:) );
                    gradient(i,j,1) = gradient(i,j,1) + 2*(im(i,j,1) - printable_vals(k,1,1))*(scores(i,j)/f_k); % R
                    gradient(i,j,2) = gradient(i,j,2) + 2*(im(i,j,2) - printable_vals(k,1,2))*(scores(i,j)/f_k); % G
                    gradient(i,j,3) = gradient(i,j,3) + 2*(im(i,j,3) - printable_vals(k,1,3))*(scores(i,j)/f_k); % B
                end
            end
        end
    end
    gradient = gradient/max(abs(gradient(:)));
    
end