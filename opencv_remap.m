function [ output_image ] = opencv_remap( new_w, new_h, input_image, xmap, ymap )
% remap basically takes the input image, and map it using xmap and ymap

% xmap: on the spherical plane x, which x on the original plane it is
% ymap: on the spherical plane y, which y on the original plane it is
output_image= zeros(int8(new_h),int8(new_w),3);
ymap
xmap
for i = 1:uint8(new_h)
    for j = 1:uint8(new_w)
        
        output_image(i, j)= input_image(uint8(ymap(i,j)), uint8(xmap(i,j)));    
    end
end
end

