function [net, prev_dropout_rates] = change_dropout_rates(net, new_dropout_rates)

    prev_dropout_rates = [];
    for i = 1:numel(net.layers)
        layer = net.layers(i);
        layer = layer{1};
        if strcmp( layer.type, 'dropout' )
            prev_dropout_rates = [prev_dropout_rates, layer.rate];
            layer.rate = new_dropout_rates(1);
            net.layers(i) = {layer};
            if numel(new_dropout_rates)>1
                new_dropout_rates = new_dropout_rates(2:end);
            end
        end
    end

end