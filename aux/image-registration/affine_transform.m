function im_transformed = affine_transform(im, nPoints, target_nPoints)

    trans_matrix = find_transform(nPoints, target_nPoints);
    tform = maketform('affine', trans_matrix);
    [im_transformed, xdata, ydata] = imtransform(im, tform, 'XYScale', 1);
    if(xdata(1) > 0)
        temp = round(xdata(1));
        if(temp == 0)
            temp = 1;
        end
        im_transformed = [zeros(size(im_transformed,1), temp, 3) im_transformed];
    else
         temp = round(-xdata(1));
        if(temp == 0)
            temp = 1;
        end
        im_transformed = im_transformed(:,temp:end, :);
    end
    if(ydata(1) > 0)
        temp = round(ydata(1));
        if(temp == 0)
            temp = 1;
        end
        im_transformed = [zeros(temp, size(im_transformed,2), 3); im_transformed];
    else
        temp = round(-ydata(1));
        if(temp == 0)
            temp = 1;
        end
        im_transformed = im_transformed(temp:end,:,:);
    end

end