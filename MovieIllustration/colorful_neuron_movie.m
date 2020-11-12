% colorful neuron movies
load('further_processed_neuron_extraction_final_result.mat');


colorful_movie=zeros(neuron.imageSize(1),neuron.imageSize(2),3,size(neuron.C,2));
colorn = distinguishable_colors(size(neuron.C,1));
for i=1:size(neuron.C,2)
    for j=1:size(neuron.C,1)
        t=neuron.A(:,j);
        t_reshape=reshape(t,neuron.imageSize(1),neuron.imageSize(2));
        %     t=t*255/max(t);
        t_reshape=t_reshape*neuron.C(j,i);
        colorful_movie(:,:,1,i)=colorful_movie(:,:,1,i)+t_reshape*colorn(j,1);
        colorful_movie(:,:,2,i)=colorful_movie(:,:,1,i)+t_reshape*colorn(j,2);
        colorful_movie(:,:,3,i)=colorful_movie(:,:,1,i)+t_reshape*colorn(j,3);
    end
end

colorful_movie=colorful_movie*300/max(colorful_movie(:));
colorful_movie=uint8(colorful_movie);

sav=['colorful_neuron_firing.avi'];
aviobj = VideoWriter(sav,'Motion JPEG AVI');
aviobj.FrameRate=30;
open(aviobj);
for it=1:size(colorful_movie,4)
    frame=colorful_movie(:,:,:,it);
    writeVideo(aviobj,frame);
end
close(aviobj);
