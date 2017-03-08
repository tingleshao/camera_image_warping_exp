function [ upper_left, lower_right ] = opencv_detect_result_roi_by_border( img_size )
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

