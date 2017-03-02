% the goal of this script is to find the correct pitch and yaw angles so
% that the images are translated to the given corner positions


function [euls] = rotation_iterator(crner, img, starting_euls, K)
upperleft_x = crner(1);
upperleft_y = crner(2);
w = crner(3);
h = crner(4);
size(img)
euls = starting_euls;
R = eul2rotm(euls);
H = K * R * K^(-1);
T = projective2d(H');
[I, RB] = imwarp(img, T);
disp('before loop')
xnotdone = 1
ynotdone = 1
while (xnotdone | ynotdone)
    % compute the starting transformed x and y    
    disp('start loop')

    R = eul2rotm(euls);
    H = K * R * K^(-1);
    T = projective2d(H');
    [I, RB] = imwarp(img, T);
    
    curr_x = RB.XWorldLimits(1);
    curr_y = RB.YWorldLimits(1);
    % extract the computed x and y
    
    curr_x 
    upperleft_x
%     if (curr_x < upperleft_x) & (abs(curr_x - upperleft_x) > 100)
%         xnotdone = 1;
%         euls(3) = euls(3) + 0.01;
%     elseif (curr_x > upperleft_x) & (abs(curr_x - upperleft_x) > 100)
%         xnotdone = 1;
%         euls(3) = euls(3) - 0.01;
%     else
%         xnotdone = 0;
%     end

    if (abs(curr_x - upperleft_x) > 100)
        old_diff = abs(curr_x - upperleft_x);
        xnotdone = 1;
        euls_temp = euls;
        euls_temp(2) = euls_temp(2) + 0.01;
        
        R = eul2rotm(euls_temp);
        H = K * R * K^(-1);
        T = projective2d(H');
        [I, RB] = imwarp(img, T);
        new_curr_x = RB.XWorldLimits(1);
        if abs(new_curr_x - upperleft_x) < old_diff
            euls = euls_temp;
        else
            euls(2) = euls(2) - 0.01;
        end
    else
        xnotdone = 0;
    end 
    
    curr_y 
    upperleft_y
    if (abs(curr_y - upperleft_y) > 100)
        old_diff = abs(curr_y - upperleft_y);
        ynotdone = 1;
        euls_temp = euls;
        euls_temp(3) = euls_temp(3) + 0.01;
        
        R = eul2rotm(euls_temp);
        H = K * R * K^(-1);
        T = projective2d(H');
        [I, RB] = imwarp(img, T);
        new_curr_y = RB.YWorldLimits(1);
        if abs(new_curr_y - upperleft_y) < old_diff
            euls = euls_temp;
        else
            euls(3) = euls(3) - 0.01;
        end
    else
        ynotdone = 0;
    end 
    
end

end
