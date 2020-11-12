function bw = rgbThreshold(frame,rgbLevels)
%HSVTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    h = frame(:,:,1);
    s = frame(:,:,2);
    v = frame(:,:,3);
    hMask = h >= rgbLevels(1) & h <= rgbLevels(2);
    if (rgbLevels(1)<0)
        hMask = hMask | h >= (1+rgbLevels(1));
    end
    if (rgbLevels(2)>1)
        hMask = hMask | h <= (rgbLevels(2)-1);
    end
    sMask = s >= rgbLevels(3) & s <= rgbLevels(4);
    vMask = v >= rgbLevels(5) & v <= rgbLevels(6);
    
    bw = hMask & sMask & vMask;
end

