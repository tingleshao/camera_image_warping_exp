function [ output_args ] = opencv_build_maps( input_args )
% a reference implementation of the opencv corresponding function
    projector_.setCameraParams(K, R);

    Point dst_tl, dst_br;
    detectResultRoi(src_size, dst_tl, dst_br);

    _xmap.create(dst_br.y - dst_tl.y + 1, dst_br.x - dst_tl.x + 1, CV_32F);
    _ymap.create(dst_br.y - dst_tl.y + 1, dst_br.x - dst_tl.x + 1, CV_32F);

    Mat xmap = _xmap.getMat(), ymap = _ymap.getMat();

    float x, y;
    for (int v = dst_tl.y; v <= dst_br.y; ++v)
    {
        for (int u = dst_tl.x; u <= dst_br.x; ++u)
        {
            projector_.mapBackward(static_cast<float>(u), static_cast<float>(v), x, y);
            xmap.at<float>(v - dst_tl.y, u - dst_tl.x) = x;
            ymap.at<float>(v - dst_tl.y, u - dst_tl.x) = y;
        }
    }

    return Rect(dst_tl, dst_br);


end

