function [ upper_left, lower_right ] = opencv_detect_result_roi_by_border( img_size, rinv )
tl_uf = 100000000;
tl_vf = 100000000;
br_uf = 100000000;
br_vf = 100000000;

for x = 1:img_size(1)
    [u, v] = opencv_map_forward(x, 0, rinv);
    tl_uf = min(tl_uf, u); 
    tl_vf = min(tl_vf, v);
    br_uf = max(br_uf, u);
    br_vf = max(br_vf, v);
    
    [u,v] = opencv_map_forward(x, img_size(2), rinv);
    tl_uf = min(tl_uf, u);
    tl_vf = min(tl_vf, v);
    br_uf = max(br_uf, u);
    br_vf = max(br_vf, v);
end
for y = 1:img_size(2)
    [u, v] = opencv_map_forward(y, 0, rinv);
    tl_uf = min(tl_uf, u); 
    tl_vf = min(tl_vf, v);
    br_uf = max(br_uf, u);
    br_vf = max(br_vf, v);
    
    [u,v] = opencv_map_forward(img_size(2), y, rinv);
    tl_uf = min(tl_uf, u);
    tl_vf = min(tl_vf, v);
    br_uf = max(br_uf, u);
    br_vf = max(br_vf, v);
end

upper_left = [tl_uf, tl_vf];
lower_right = [br_uf, br_vf];

%{
C++ code...
===========
template <class P>
void RotationWarperBase<P>::detectResultRoiByBorder(Size src_size, Point &dst_tl, Point &dst_br)
{
    float tl_uf = (std::numeric_limits<float>::max)();
    float tl_vf = (std::numeric_limits<float>::max)();
    float br_uf = -(std::numeric_limits<float>::max)();
    float br_vf = -(std::numeric_limits<float>::max)();

    float u, v;
    for (float x = 0; x < src_size.width; ++x)
    {
        projector_.mapForward(static_cast<float>(x), 0, u, v);
        tl_uf = (std::min)(tl_uf, u); tl_vf = (std::min)(tl_vf, v);
        br_uf = (std::max)(br_uf, u); br_vf = (std::max)(br_vf, v);

        projector_.mapForward(static_cast<float>(x), static_cast<float>(src_size.height - 1), u, v);
        tl_uf = (std::min)(tl_uf, u); tl_vf = (std::min)(tl_vf, v);
        br_uf = (std::max)(br_uf, u); br_vf = (std::max)(br_vf, v);
    }
    for (int y = 0; y < src_size.height; ++y)
    {
        projector_.mapForward(0, static_cast<float>(y), u, v);
        tl_uf = (std::min)(tl_uf, u); tl_vf = (std::min)(tl_vf, v);
        br_uf = (std::max)(br_uf, u); br_vf = (std::max)(br_vf, v);

        projector_.mapForward(static_cast<float>(src_size.width - 1), static_cast<float>(y), u, v);
        tl_uf = (std::min)(tl_uf, u); tl_vf = (std::min)(tl_vf, v);
        br_uf = (std::max)(br_uf, u); br_vf = (std::max)(br_vf, v);
    }

    dst_tl.x = static_cast<int>(tl_uf);
    dst_tl.y = static_cast<int>(tl_vf);
    dst_br.x = static_cast<int>(br_uf);
    dst_br.y = static_cast<int>(br_vf);
}
%}
end

