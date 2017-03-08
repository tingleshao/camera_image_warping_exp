function [ result_upper_left, result_lower_right ] = opencv_detect_result_roi( img_size, rinv, k)

[result_upper_left, result_lower_right] = detect_result_roi_by_border(img_size);
tl_uf = result_upper_left(1);
tl_vf = result_upper_left(2);
br_uf = result_lower_right(1);
br_vf = result_lower_right(2);

x = rinv(1,2);
y = rinv(2,2);
z = rinv(3,2);

if y > 0
   x_ = ( k(1,1) * x + k(1,2) ) * y / z + k(1,3);
   y_ = k(2,2) * y / z + k(2,3);
   if x_ > 0 && x_ < img_size(1) && y_ > 0 && y_ < img_size(2)
       tl_uf = min(tl_uf, 0) ;
       tl_vf = min(tl_vf, pi * scale);
       br_uf = max(br_uf, 0);
       br_vf = max(br_vf, pi * scale);
   end
end

x = rinv(1,2);
y = -rinv(2,2);
z = rinv(3,2);
if y > 0
    x_ = (k(1,1) * x + k(1,2)) * y / z + k(1,3);
    y_ = k(2,2) * y / z + k(2,3);
    if x_ > 0 && x_ < img_size(1) & y_ > 0 & y_ < img_size(2)
        tl_uf = min(tl_uf, 0);
        tl_vf = min(tl_vf, 0);
        br_uf = max(br_uf, 0);
        br_vf = max(br_vf, 0);
    end
end
result_upper_left = [tl_uf, tl_vf];
result_lower_right = [br_uf, br_vf];

%{
void SphericalWarper::detectResultRoi(Size src_size, Point &dst_tl, Point &dst_br)
{
    detectResultRoiByBorder(src_size, dst_tl, dst_br);

    float tl_uf = static_cast<float>(dst_tl.x);
    float tl_vf = static_cast<float>(dst_tl.y);
    float br_uf = static_cast<float>(dst_br.x);
    float br_vf = static_cast<float>(dst_br.y);

    float x = projector_.rinv[1];
    float y = projector_.rinv[4];
    float z = projector_.rinv[7];
    if (y > 0.f)
    {
        float x_ = (projector_.k[0] * x + projector_.k[1] * y) / z + projector_.k[2];
        float y_ = projector_.k[4] * y / z + projector_.k[5];
        if (x_ > 0.f && x_ < src_size.width && y_ > 0.f && y_ < src_size.height)
        {
            tl_uf = std::min(tl_uf, 0.f); tl_vf = std::min(tl_vf, static_cast<float>(CV_PI * projector_.scale));
            br_uf = std::max(br_uf, 0.f); br_vf = std::max(br_vf, static_cast<float>(CV_PI * projector_.scale));
        }
    }

    x = projector_.rinv[1];
    y = -projector_.rinv[4];
    z = projector_.rinv[7];
    if (y > 0.f)
    {
        float x_ = (projector_.k[0] * x + projector_.k[1] * y) / z + projector_.k[2];
        float y_ = projector_.k[4] * y / z + projector_.k[5];
        if (x_ > 0.f && x_ < src_size.width && y_ > 0.f && y_ < src_size.height)
        {
            tl_uf = std::min(tl_uf, 0.f); tl_vf = std::min(tl_vf, static_cast<float>(0));
            br_uf = std::max(br_uf, 0.f); br_vf = std::max(br_vf, static_cast<float>(0));
        }
    }

    dst_tl.x = static_cast<int>(tl_uf);
    dst_tl.y = static_cast<int>(tl_vf);
    dst_br.x = static_cast<int>(br_uf);
    dst_br.y = static_cast<int>(br_vf);
}
%}
end

