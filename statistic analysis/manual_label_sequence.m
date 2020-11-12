function seqs=manual_label_sequence(seqimg)

imagesc(seqimg);
caxis([0 max(max(seqimg))*0.6])

ctt=1;
while true
    [x,y]=ginput(2);
    l1=line(x,y,'Color','red','LineWidth',2);
    strr=input('ok for this?','s');
    if isequal(strr,'y')
        seqs{ctt}=[x,y];
        ctt=ctt+1;
    end
    if isequal(strr,'n')
        delete(l1);
    end
    if isequal(strr,'o')
        seqs{ctt}=[x,y];
        ctt=ctt+1;
        break;
    end    
end 