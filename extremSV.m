function [left, right, pleft, pright, midle, dir] = extremSV(MPs, r, o, bl1, bl2)

[nMPs,~] = size(MPs);
il = 0;
ic = 0;
ia = 0;

midle = [];
for i = 1:nMPs  

    if MPs(i,1) == 1
        n = 50;
        il = il + 1;
        p1 = MPs(i,2:3);
        p2 = MPs(i,4:5);
        p_x = linspace(p1(1), p2(1), n);
        p_y = linspace(p1(2), p2(2), n);
        
        position = sign((bl1(i,1) - o(1))*(bl2(i,2) - o(2)) - (bl1(i,2) - o(2))*(bl2(i,1) - o(1)));
        if position > 0
            right = bl1(i,:);
            left = bl2(i,:);
            pleft = p2;
            pright = p1;
        elseif position <= 0
            right = bl2(i,:);
            left = bl1(i,:);
            pleft = p1;
            pright = p2;
        end     
        prevD = dotproduct(o, left, o, right);
        prevelbow = bl1;
        for j = 2:n - 1
            [p1, p2] = IK2DOF(o, [p_x(j), p_y(j)], r(1), r(2));
            aux1 = crossproduct(o, p1, o, [p_x(j), p_y(j)]);
            aux2 = crossproduct(o, prevelbow, o, [p_x(j-1), p_y(j-1)]);
            if aux1*aux2 > 0
                elbow = p1;
            else
                elbow = p2;
            end
            prevelbow = elbow;
            pos_wr_left = sign((left(1) - o(1))*(elbow(2) - o(2)) - (left(2) - o(2))*(elbow(1) - o(1)));
            if pos_wr_left ~= 0
                dir = pos_wr_left;
            end
            if pos_wr_left > 0
                left = elbow;
                pleft = [p_x(j), p_y(j)];
                prevD = dotproduct(o, left, o, right);
            else
                pos_wr_right = sign((right(1) - o(1))*(elbow(2) - o(2)) - (right(2) - o(2))*(elbow(1) - o(1)));
                if pos_wr_right < 0
                    right = elbow;
                    pright = [p_x(j), p_y(j)];
                    prevD = dotproduct(o, left, o, right);
                else
                    dotle = dotproduct(o, left, o, elbow);
                    dotre = dotproduct(o, right, o, elbow);
                    if (abs(dotle - dotre)) < prevD
                        prevD = (abs(dotle - dotre));
                        midle = elbow;
                    end            
                end  
            end
            
        end
        
    elseif MPs(i,1) == 0 
        n = 50;
        ic = ic + 1;
        
        ci = MPs(i,2:3);
        radius = MPs(i,4);
        p = MPs(i,5:6);
        cangp = (p(1) - ci(1))/radius;
        sangp = (p(2) - ci(2))/radius;
        angp = wrapTo2Pi(atan2(sangp, cangp));
        ang = linspace(angp, angp + 2*pi, n);
        p_x = ci(1) + radius*cos(ang);
        p_y = ci(2) + radius*sin(ang);
        pleft = p;
        pright = p;
        
        position = sign((bl1(i,1) - o(1))*(bl2(i,2) - o(2)) - (bl1(i,2) - o(2))*(bl2(i,1) - o(1)));
        if position > 0
            right = bl1(i,:);
            left = bl2(i,:);
            prevD = dotproduct(o, left, o, right);
        elseif position <= 0
            right = bl2(i,:);
            left = bl1(i,:);
            prevD = dotproduct(o, left, o, right);
        end     
        prevelbow = bl1;
        for j = 2:n - 1
            [p1, p2] = IK2DOF(o, [p_x(j), p_y(j)], r(1), r(2));
            aux1 = crossproduct(o, p1, o, [p_x(j), p_y(j)]);
            aux2 = crossproduct(o, prevelbow, o, [p_x(j-1), p_y(j-1)]);
            if aux1*aux2 > 0
                elbow = p1;
            else
                elbow = p2;
            end
            prevelbow = elbow;
            pos_wr_left = sign((left(1) - o(1))*(elbow(2) - o(2)) - (left(2) - o(2))*(elbow(1) - o(1)));
            if pos_wr_left ~= 0
                dir = pos_wr_left;
            end
            if pos_wr_left > 0
                left = elbow;
                pleft = [p_x(j), p_y(j)];
                prevD = dotproduct(o, left, o, right);
            else
                pos_wr_right = sign((right(1) - o(1))*(elbow(2) - o(2)) - (right(2) - o(2))*(elbow(1) - o(1)));
                if pos_wr_right < 0
                    right = elbow;
                    pright = [p_x(j), p_y(j)];
                    prevD = dotproduct(o, left, o, right);
                else
                    dotle = dotproduct(o, left, o, elbow);
                    dotre = dotproduct(o, right, o, elbow);
                    if (abs(dotle - dotre)) < prevD
                        prevD = (abs(dotle - dotre));
                        midle = elbow;
                    end       
                end  
            end
            
        end
        
        
    else
        n = 50;
        ia = ia + 1;
        
        direction = MPs(i,1);
        ca = MPs(i,2:3);
        p1 = MPs(i,4:5);
        p2 = MPs(i,6:7);
        ra = sqrt((p1(1) - ca(1))^2 + (p1(2) - ca(2))^2);
        angp1p2 = MPs(i,8);
        nt = abs(round(2*pi*n/angp1p2));
        cangp1 = (p1(1) - ca(1))/ra;
        sangp1 = (p1(2) - ca(2))/ra;
        angp1 = wrapTo2Pi(atan2(sangp1, cangp1));
        ang = linspace(angp1, angp1 + 2*pi, nt);
        p_x_aux = ca(1) + ra*cos(ang');
        p_y_aux = ca(2) + ra*sin(ang');
        v1 = [p1(1) - ca(1), p1(2) - ca(2)];
        v2 = [p_x_aux(2) - ca(1), p_y_aux(2) - ca(2)];
        v1xv2 = v1(1)*v2(2) - v1(2)*v2(1);
        if direction*v1xv2 > 0
            dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
            [~,indx] = min(dists);
            p_x = [p_x_aux(1:indx(1));p2(1)];
            p_y = [p_y_aux(1:indx(1));p2(2)];
        else
            p_x_aux = [p1(1); flipud(p_x_aux(2:end))];
            p_y_aux = [p1(2); flipud(p_y_aux(2:end))];
            dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
            [~,indx] = min(dists);
            p_x = [p_x_aux(1:indx(1));p2(1)];
            p_y = [p_y_aux(1:indx(1));p2(2)];
        end 
        n = length(p_x);
        position = sign((bl1(i,1) - o(1))*(bl2(i,2) - o(2)) - (bl1(i,2) - o(2))*(bl2(i,1) - o(1)));
        if position > 0
            right = bl1(i,:);
            left = bl2(i,:);
            pleft = p2;
            pright = p1;
        elseif position < 0
            right = bl2(i,:);
            left = bl1(i,:);
            pleft = p1;
            pright = p2;
        end     
        prevD = dotproduct(o, left, o, right);
        prevelbow = bl1;
        for j = 2:n - 1
            [p1, p2] = IK2DOF(o, [p_x(j), p_y(j)], r(1), r(2));
            aux1 = crossproduct(o, p1, o, [p_x(j), p_y(j)]);
            aux2 = crossproduct(o, prevelbow, o, [p_x(j-1), p_y(j-1)]);
            if aux1*aux2 > 0
                elbow = p1;
            else
                elbow = p2;
            end
            prevelbow = elbow;
            pos_wr_left = sign((left(1) - o(1))*(elbow(2) - o(2)) - (left(2) - o(2))*(elbow(1) - o(1)));
            if pos_wr_left ~= 0
                dir = pos_wr_left;
            end
            if pos_wr_left > 0
                left = elbow;
                pleft = [p_x(j), p_y(j)];
            else
                pos_wr_right = sign((right(1) - o(1))*(elbow(2) - o(2)) - (right(2) - o(2))*(elbow(1) - o(1)));
                if pos_wr_right < 0
                    right = elbow;
                    pright = [p_x(j), p_y(j)];
                else
                    dotle = dotproduct(o, left, o, elbow);
                    dotre = dotproduct(o, right, o, elbow);
                    if (abs(dotle - dotre)) < prevD
                        prevD = (abs(dotle - dotre));
                        midle = elbow;
                    end          
                end  
            end
            
        end
        
    end

end


end