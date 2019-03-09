function face_landmark_detection(py_cmd, py_script, dlib_model, im_dir, wildcard)

    command_str = sprintf('%s %s %s %s "%s"', py_cmd, py_script, dlib_model, im_dir, wildcard);
    system(command_str);

end