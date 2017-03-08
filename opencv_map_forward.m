function [ u, v ] = opencv_map_forward( x, y, rkinv )
%{
C++ code....
============
void SphericalProjector::mapForward(float x, float y, float &u, float &v)
{
    float x_ = r_kinv[0] * x + r_kinv[1] * y + r_kinv[2];
    float y_ = r_kinv[3] * x + r_kinv[4] * y + r_kinv[5];
    float z_ = r_kinv[6] * x + r_kinv[7] * y + r_kinv[8];

    u = scale * atan2f(x_, z_);
    float w = y_ / sqrtf(x_ * x_ + y_ * y_ + z_ * z_);
    v = scale * (static_cast<float>(CV_PI) - acosf(w == w ? w : 0));
}
%}
x_ = rkinv(1,1) * x + rkinv(1,2) * y + rkinv(1,3);
y_ = rkinv(2,1) * x + rkinv(2,2) * y + rkinv(2,3); 
z_ = rkinv(3,1) * x + rkinv(3,2) * y + rkinv(3,3);

scale = 1;
u = scale * atan2(x_, z_);
w = y_ / sqrt(x_ * x_ + y_ * y_ + z_ * z_);
if w == w 
    ww = w; 
else 
    ww = 0;
end
v = scale * (pi - acos(ww));

end

