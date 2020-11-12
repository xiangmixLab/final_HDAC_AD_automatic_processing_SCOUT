function sign=multiCenterNeuronDetection(A)
sign=0;
for j=0:0.01:1
    bwA=A>j*max(A(:));
    stats_bwA=regionprops(full(bwA));
    if length([stats_bwA.Area])>1
        sign=1;
        break;
    end
end