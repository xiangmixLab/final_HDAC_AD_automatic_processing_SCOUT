            if_mouse_head_toward_object=[headorientationcell{1,timeindex(i)+1}.if_mouse_head_toward_object(1,:)];
            for j=timeindex(i)+1:timeindex(i+1)
                if_mouse_head_toward_object=[if_mouse_head_toward_object;headorientationcell{1,j}.if_mouse_head_toward_object(2:end,:)];
            end