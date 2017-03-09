function [ xmap, ymap, dst, dst_width, dst_height ] = opencv_build_maps( image_size, K, R )
% a reference implementation of the opencv corresponding function
% buid the map: (u,v) -> (x,y) from the K and R matrices. 
% u and v are corrdinates on the spherical surface. 
% x and y are corrdinates on the planar surface.

% set camera params 
Rinv = R';
Kinv = K^(-1);
%RKinv = R*Kinv;
KRinv = K*Rinv;

% detect result roi
[ upper_left, lower_right ] = opencv_detect_result_roi( image_size, Rinv, K);
upper_left
lower_right
v_length = lower_right(2) - upper_left(2);
u_length = lower_right(1) - upper_left(1);

% map backward: find the x and y for the u and v 
xmap = uint8(zeros(uint8(v_length), uint8(u_length)));
ymap = uint8(zeros(uint8(v_length), uint8(u_length)));

for v = 1:v_length
    for u = 1:u_length     
        sinv = sin(pi - v);
        x_ = sinv * sin(u);
        y_ = cos(pi - v);
        z_ = sinv * cos(u); 
        
        x = KRinv(1,1) * x_ + KRinv(1,2) * y_ + KRinv(1,3) * z_; 
        y = KRinv(2,1) * x_ + KRinv(2,2) * y_ + KRinv(2,3) * z_; 
        z = KRinv(3,1) * x_ + KRinv(3,2) * y_ + KRinv(3,3) * z_; 
        
        if (z > 0)
            x = x / z;
            y = y / z;
        else 
            x = -1;
            y = -1;
        end
        xmap(v,u) = x;
        ymap(v,u) = y;
    end 
end

dst_width = u_length;
dst_height = v_length;
dst = [upper_left, lower_right];


%{
C++ code...
============================================
void SphericalWarper::detectResultRoi(Size src_size, Point &dst_tl, Point &dst_br)
{...
}
===================================
void SphericalProjector::mapBackward(float u, float v, float &x, float &y)
{
    u /= scale;
    v /= scale;

    float sinv = sinf(static_cast<float>(CV_PI) - v);
    float x_ = sinv * sinf(u);
    float y_ = cosf(static_cast<float>(CV_PI) - v);
    float z_ = sinv * cosf(u);

    float z;
    x = k_rinv[0] * x_ + k_rinv[1] * y_ + k_rinv[2] * z_;
    y = k_rinv[3] * x_ + k_rinv[4] * y_ + k_rinv[5] * z_;
    z = k_rinv[6] * x_ + k_rinv[7] * y_ + k_rinv[8] * z_;

    if (z > 0) { x /= z; y /= z; }
    else x = y = -1;
}

==================

void ProjectorBase::setCameraParams(InputArray _K, InputArray _R, InputArray _T)
{
    Mat K = _K.getMat(), R = _R.getMat(), T = _T.getMat();

    CV_Assert(K.size() == Size(3, 3) && K.type() == CV_32F);
    CV_Assert(R.size() == Size(3, 3) && R.type() == CV_32F);
    CV_Assert((T.size() == Size(1, 3) || T.size() == Size(3, 1)) && T.type() == CV_32F);

    Mat_<float> K_(K);
    k[0] = K_(0,0); k[1] = K_(0,1); k[2] = K_(0,2);
    k[3] = K_(1,0); k[4] = K_(1,1); k[5] = K_(1,2);
    k[6] = K_(2,0); k[7] = K_(2,1); k[8] = K_(2,2);

    Mat_<float> Rinv = R.t();
    rinv[0] = Rinv(0,0); rinv[1] = Rinv(0,1); rinv[2] = Rinv(0,2);
    rinv[3] = Rinv(1,0); rinv[4] = Rinv(1,1); rinv[5] = Rinv(1,2);
    rinv[6] = Rinv(2,0); rinv[7] = Rinv(2,1); rinv[8] = Rinv(2,2);

    Mat_<float> R_Kinv = R * K.inv();
    r_kinv[0] = R_Kinv(0,0); r_kinv[1] = R_Kinv(0,1); r_kinv[2] = R_Kinv(0,2);
    r_kinv[3] = R_Kinv(1,0); r_kinv[4] = R_Kinv(1,1); r_kinv[5] = R_Kinv(1,2);
    r_kinv[6] = R_Kinv(2,0); r_kinv[7] = R_Kinv(2,1); r_kinv[8] = R_Kinv(2,2);

    Mat_<float> K_Rinv = K * Rinv;
    k_rinv[0] = K_Rinv(0,0); k_rinv[1] = K_Rinv(0,1); k_rinv[2] = K_Rinv(0,2);
    k_rinv[3] = K_Rinv(1,0); k_rinv[4] = K_Rinv(1,1); k_rinv[5] = K_Rinv(1,2);
    k_rinv[6] = K_Rinv(2,0); k_rinv[7] = K_Rinv(2,1); k_rinv[8] = K_Rinv(2,2);

    Mat_<float> T_(T.reshape(0, 3));
    t[0] = T_(0,0); t[1] = T_(1,0); t[2] = T_(2,0);
}
======================
projector_.setCameraParams(K, R);
Point dst_tl, dst_br;
detectResultRoi(src_size, dst_tl, dst_br);
_xmap.create(dst_br.y - dst_tl.y + 1, dst_br.x - dst_tl.x + 1, CV_32F);
_ymap.create(dst_br.y - dst_tl.y + 1, dst_br.x - dst_tl.x + 1, CV_32F);

Mat xmap = _xmap.getMat(), ymap = _ymap.getMat();

float x, y;
for (int v = dst_tl.y; v <= dst_br.y; ++v) {
    for (int u = dst_tl.x; u <= dst_br.x; ++u) {
        projector_.mapBackward(static_cast<float>(u), static_cast<float>(v), x, y);
        xmap.at<float>(v - dst_tl.y, u - dst_tl.x) = x;
        ymap.at<float>(v - dst_tl.y, u - dst_tl.x) = y;
    }
}
return Rect(dst_tl, dst_br);
======================
%}
end

