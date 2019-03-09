function [scores, gradients] = find_gradient( net, ims, target )

    % change the last layer to a softmaxloss layer
    net.layers{end} = struct('type', 'softmaxloss');
    if numel(target)==1
        target = repmat(target, [1 1 1 size(ims,4)]) ;
    end
    net.layers{end}.class = target;

    % compute gradient
    res = [];
    res = vl_simplenn(net, ims, 1, res, 'disableDropout', 1);
    gradients = gather(res(1).dzdx);
    
    % scores
    scores = gather(vl_nnsoftmax(res(end-1).x));

end

