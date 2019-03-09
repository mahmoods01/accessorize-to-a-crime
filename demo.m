net_path = '../../face-rec-matconvnet/trained-model/vgg_face_matconvnet/data/vgg_face.mat'; % update me

%% digital dodging example
digital_dodging(net_path, './data/', 's478', 478);

%% physical dodging example
physical_dodging(net_path, './data/', 's478', 478);

%% digital impersonation example
target = 152; % Antonia Campbell Hughes
digital_impersonation(net_path, './data/', 's478', 478, target);

%% physical impersonation example
target = 152; % Antonia Campbell Hughes
physical_impersonation(net_path, './data/', 's478', 478, target);
