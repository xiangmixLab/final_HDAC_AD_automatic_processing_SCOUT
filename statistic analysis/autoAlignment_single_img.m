%arbitary_move: [x,y]
function [deformed]=autoAlignment_single_img(fix,moved,mode)

switch mode
    case 'auto'
    fixed=double(fix);
    moving=double(moved);

    registration=registration2d(fixed,moving);
    deformed = deformation(moving,registration.displacementField,registration.interpolation);
    
    case 'manual'
    fixed=double(fix);
    moving=double(moved);

    p=imfuse(fixed,moving);
    imagesc(p);
    for i=1:3
        disp(['get corresponding point pairs (fixed first) ',num2str(i)]);
        l=ginput(2);
        shiftt(i,:)=l(1,:)-l(2,:);
    end
    arbitary_move=mean(shiftt,1);
    deformed=moved;
    deformed = imtranslate(deformed,arbitary_move);
    
    otherwise
end
