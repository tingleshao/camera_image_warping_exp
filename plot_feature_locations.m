function [ ] = plot_feature_locations( img1, fe_locs1, img2, fe_locs2 )
% plot feature locations.
% resize images
% fe: a list of x, ys 

img1 = imresize(img1, [670, 895]);
img2 = imresize(img2, [670, 895]);

figure, imshow(img1);
hold on 

r= 5;
th = 0:pi/50:2*pi;

for i = 1:size(fe_locs1, 1) 
    [x,y] = fe_locs1(i,:);
    
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    
    plot(xunit, yunit);
end
hold off
figure;
imshow(img2);
hold on 

for i = 1:size(fe_locs2, 1) 
    [x,y] = fe_locs2(i,:);
    
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    
    plot(xunit, yunit);
end

hold off

end

