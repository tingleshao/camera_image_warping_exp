% the goal of this script is to find the correct pitch and yaw angles so
% that the images are translated to the given corner positions


function [euls] = rotation_iterator(crner, img, starting_euls, K)
upperleft_x = crner(1);
upperleft_y = crner(2);
w = crner(3);
h = crner(4);

euls = starting_euls;
R = eul2rotm(euls);
H = K * R * K^(-1);
T = projective2d(H);
[I, RB] = imwarp(img, T);
curr_x = RB.XWorldLimits(1);
curr_y = RB.YWorldLimits(1);
     
while 1
    % compute the starting transformed x and y    
    R = eul2rotm(euls);
    H = K * R * K^(-1);
    T = projective2d(H);
    [I, RB] = imwarp(img, T);
    % extract the computed x and y

    if (curr_x < upperleft_x) & (abs(curr_x - upperleft_x) > 5)
        euls(3) = euls(3) + 0.1 * abs(curr_x - upperleft_x);
    elseif (curr_x > upperleft_x) & (abs(curr_x - upperleft_x) > 5)
        euls(3) = euls(3) - 0.1 * abs(curr_x - upperleft_x);
    else
        break;
    end
    
    if (curr_y < upperleft_y) & (abs(curr_y - upperleft_y) > 5)
        euls(2) = euls(2) + 0.1 * abs(curr_y - upperleft_y);
    elseif (curr_y > upperleft_y) & (abs(curr_y - upperleft_y) > 5)
        euls(2) = euls(2) - 0.1 * abs(curr_y - upperleft_y);
    else
        break;
    end 
    
    curr_x = RB.XWorldLimits(1);
    curr_y = RB.YWorldLimits(1);
end

end
