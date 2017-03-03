function [ output_image, corner ] = opencv_warp_image( input_image, R, K )
% an reference implementation of the image warping in opencv stitching
% example. 

% spherical mapping

  UMat xmap, ymap;
    Rect dst_roi = buildMaps(src.size(), K, R, xmap, ymap);

    dst.create(dst_roi.height + 1, dst_roi.width + 1, src.type());
    remap(src, dst, xmap, ymap, interp_mode, border_mode);

    return dst_roi.tl();
    
    
    

end




