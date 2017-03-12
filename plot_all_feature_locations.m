map = read_parsed_output();
img1 = imread('mcam_1_scale_2.jpg');
img2 = imread('mcam_2_scale_2.jpg');
features = map('0#1');
query_features = features(:,1:2);
train_features = features(:,3:4);
plot_feature_locations(img1, query_features, img2, train_features, 10);