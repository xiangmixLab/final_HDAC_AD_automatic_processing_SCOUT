%% movie original, inside target folder
load('final_concatenate_stack.mat')
load('further_processed_neuron_extraction_final_results.mat')
figure;
aviobj = VideoWriter('original_movie_with_contour.avi','Motion JPEG AVI');
aviobj.FrameRate=30;
open(aviobj);
for i=1:35000
    imshow(Y(:,:,i));
    hold on;
    max_amp=max(neuron.C,[],2);
    max_info=[max_amp,[1:size(neuron.C,1)]'];
    max_info=sortrows(max_info,1);
    ict=max_info(end-6:end,2);
    for ic=1:length(ict)
        plot(neuron.Coor{ict(ic)}(1,2:end),neuron.Coor{ict(ic)}(2,2:end),'r-','lineWidth',0.5);
    end
    frame=getframe(gcf);
    writeVideo(aviobj,frame);
    clf
end
close(aviobj)   
    