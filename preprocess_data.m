% Detect landmarks and align faces to a normalized pose (via an affine
% transformation)

py_cmd = '/usr/local/bin/python'; % update me
py_script = './aux/image-registration/face_landmark_detection.py'; % update me
dlib_model = '../../../libraries/dlib-master/trained-models/shape_predictor_68_face_landmarks.dat'; % update me
ref_landmarks = './aux/image-registration/ref_marks.csv';

subjects = {'s478'};
for i = 1:numel(subjects)
    ims_path = fullfile('./data/', subjects{i});
    face_landmark_detection(py_cmd, py_script, dlib_model, ...
                    ims_path, '*.png');
    align_vgg_pose(ims_path, '*.png', ref_landmarks);
end
