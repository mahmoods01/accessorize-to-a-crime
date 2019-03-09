function [scores, dydx] = classify_convnet(ims, net, dydx)

    if nargin==2
        res = vl_simplenn(net, ims);
    else
        res = vl_simplenn(net, ims, dydx);
    end

    scores = res(end).x;
    
    if nargin==3
        dydx = res(1).dzdx;
    end

end
