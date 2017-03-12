function [ matches_map ] = read_parsed_output()
% read output file, generate map: img1#img2 -> x, y, x, y
text = fileread('parse_output.txt');

matches_map = containers.Map;
lines = strsplit(text, '\n');
curr_value = [];
curr_key = '';
for i = 1:size(lines,2)
    
    line = lines{i};
    length(line)
    if length(line) > 0 
        if line(1:1) == '#' 
          matches_map(curr_key) = curr_value;
          tokens = strsplit(line);
          src_img_idx = tokens{2};
          dst_img_idx = tokens{3};
          curr_key = [src_img_idx, '#', dst_img_idx];
          matches_map([src_img_idx, '#', dst_img_idx]) = [];
        else 
    % append curr_value 
        tokens = strsplit(line);
        query_x = str2num(tokens{1});
        query_y = str2num(tokens{2});
        train_x = str2num(tokens{3});
        train_y = str2num(tokens{4});
     %   curr_value
        curr_value = [curr_value; [query_x, query_y, train_x, train_y]];
        end
    end
end
end

