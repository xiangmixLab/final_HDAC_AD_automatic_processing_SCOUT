%% movie original, inside target folder
load('further_processed_neuron_extraction_final_results.mat')

colorProfile=distinguishable_colors(size(neuron.C,1));
sum=zeros(240,376,3,15000);
for i=10000:25000    
    max_amp=max(neuron.C,[],2);
    max_info=[max_amp,[1:size(neuron.C,1)]'];
    max_info=sortrows(max_info,1);
%     ict=max_info(end-6:end,2);
    ict=max_info(:,2)
    for ic=1:length(ict)
        sum(:,:,1,i)=sum(:,:,1,i)+reshape(neuron.A(:,ict(ic))*1/max(neuron.A(:,ict(ic))),240,376)*neuron.C(ict(ic),i)*colorProfile(ic,1);
        sum(:,:,2,i)=sum(:,:,2,i)+reshape(neuron.A(:,ict(ic))*1/max(neuron.A(:,ict(ic))),240,376)*neuron.C(ict(ic),i)*colorProfile(ic,2);
        sum(:,:,3,i)=sum(:,:,3,i)+reshape(neuron.A(:,ict(ic))*1/max(neuron.A(:,ict(ic))),240,376)*neuron.C(ict(ic),i)*colorProfile(ic,3);
    end

end

sum=sum*255/max(sum(:));
figure;
aviobj = VideoWriter('extracted_neuron_with_color.avi','uncompressed AVI');
aviobj.FrameRate=30;
open(aviobj);
for i=10025:13000
    imshow(uint8(sum(:,:,:,i)));drawnow;
    frame=getframe(gcf);
    writeVideo(aviobj,frame);
    clf
end
close(aviobj)   
    