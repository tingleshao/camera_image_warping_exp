function [ output_image ] = opencv_remap( new_w, new_h, input_image, xmap, ymap )
% remap basically takes the input image, and map it using xmap and ymap

% xmap: on the spherical plane x, which x on the original plane it is
% ymap: on the spherical plane y, which y on the original plane it is
output_image= zeros(new_h,new_w,3);
for i = 1:new_h
    for j = 1:new_w  
        output_image( i, j)= input_image(ymap(i,j), xmap(i,j));    
    end
end
end

