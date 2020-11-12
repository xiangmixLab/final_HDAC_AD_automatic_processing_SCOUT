function aligned_neurons=align_neurons(neurons,height,width,method,threshold,corr_thresh,overlap)
aligned_neurons=zeros(size(neurons{1}.centroid,1),length(neurons));
for i=1:length(neurons)
    available_neurons{i}=1:size(neurons{i}.centroid,1);
end


if strcmp(method,'manual')==true
    
    for i=1:size(aligned_neurons,1)
        disp(strcat('neuron',num2str(i)))
        current_aligned=zeros(1,length(neurons));
        current_aligned(1,1)=i;
        for j=2:length(neurons)
            neurons_under_thresh=[];
            for k=1:size(neurons{j}.centroid,1)
                if sqrt(sum((neurons{j}.centroid(k,:)-neurons{j-1}.centroid(current_aligned(j-1),:)).^2))<threshold;
                    if ismember(k,available_neurons{j})
                        neurons_under_thresh(end+1,:)=[k,sqrt(sum((neurons{j}.centroid(k,:)-neurons{j-1}.centroid(current_aligned(j-1),:)).^2))];
                        
                        
                    end
                end
            end
            neurons_under_thresh=sortrows(neurons_under_thresh,2);
            distances=neurons_under_thresh(:,2);
            neurons_under_thresh=neurons_under_thresh(:,1);
            counter=1;
            
            while counter<=length(neurons_under_thresh)
                disp(strcat('possible neurons remaining: ',num2str(length(neurons_under_thresh)-counter+1)))
                
                fig=neurons{j-1}.A(:,current_aligned(j-1))/max(neurons{j-1}.A(:,current_aligned(j-1)))+neurons{j}.A(:,neurons_under_thresh(counter))/max(neurons{j}.A(:,neurons_under_thresh(counter)));
                fig=reshape(fig,[height,width]);
                figure()
                imagesc(fig)
               
                figure()
                hold on
                plot(1:overlap,neurons{j-1}.C(current_aligned(j-1),end-(overlap-1):end));
               
               
                plot(1:overlap,neurons{j}.C(neurons_under_thresh(counter),1:overlap));
                hold off
                corr=corrcoef(neurons{j-1}.trace(current_aligned(j-1),end-(overlap-1):end),neurons{j}.trace(neurons_under_thresh(counter),1:overlap));
                disp(horzcat('correlation: ',num2str(corr(1,2)),'centroid distance: ', num2str(distances(counter))))
                if counter==1&&counter~=length(neurons_under_thresh)
                    keep=input('Accept this identification? y(yes),n(no) ','s');
                elseif counter~=length(neurons_under_thresh)&&counter~=1
                    keep=input('Accept this identification? y(yes),n(no),b(back) ','s');
                else
                    keep=input('Accept this identification? If not, the full neuron will be deleted? y(yes),n(no),b(back) ','s');
                end
                close all
                if keep=='y'
                    current_aligned(1,j)=neurons_under_thresh(counter);
                    break
                elseif keep=='b'
                     counter=counter-1;
                else
                     counter=counter+1;
                end
            end
            if current_aligned(1,j)==0 || isempty(neurons_under_thresh)
                disp('no acceptable neurons within threshold, neuron deleted') 
                current_aligned=zeros(1,length(neurons));
                break
            else
                aligned_neurons(i,:)=current_aligned;
                for m=1:size(current_aligned,2)
                    available_neurons{m}=available_neurons{m}(available_neurons{m}~=current_aligned(1,m));
                end
            end
        end
       empty=false;
       for m=1:length(available_neurons)
           if isempty(available_neurons{m})
               empty=true;
           end
       end
       if empty==true
           break
       end
    end
else
    for i=1:size(aligned_neurons,1)
        current_aligned=zeros(1,length(neurons));
        current_aligned(1,1)=i;
        for j=2:length(neurons)
            current_best=0;
            current_min=threshold;
            neurons_under_thresh=[];
            for k=1:size(neurons{j}.centroid,1)
                
                if sqrt(sum((neurons{j}.centroid(k,:)-neurons{j-1}.centroid(current_aligned(j-1),:)).^2))<current_min
                    if ismember(k,available_neurons{j})
                        corr_coeff=corrcoef(neurons{j}.C(k,1:overlap),neurons{j-1}.C(current_aligned(j-1),end-overlap+1:end));
                        neurons_under_thresh(end+1,:)=[k,sqrt(sum((neurons{j}.centroid(k,:)-neurons{j-1}.centroid(current_aligned(j-1),:)).^2)),corr_coeff(1,2)];
                        
                
                    end
                end
            end
            if size(neurons_under_thresh,1)~=0
                neurons_under_thresh=sortrows(neurons_under_thresh,3);
                
                if neurons_under_thresh(end,3)>corr_thresh
                    current_best=neurons_under_thresh(end,1);
                end
            end
            
          
            
            if current_best==0 
                disp('no acceptable neurons within threshold, neuron deleted') 
                current_aligned=zeros(1,length(neurons));
                break
            else
                current_aligned(j)=current_best;
            end
            
       end
       aligned_neurons(i,:)=current_aligned;
       for m=1:size(current_aligned,2)
           available_neurons{m}=available_neurons{m}(available_neurons{m}~=current_aligned(1,m));
                
      end
     
       empty=false;
       for m=1:length(available_neurons)
           if isempty(available_neurons{m})
               empty=true;
           end
       end
       if empty==true
           break
       end
    end
    
 
end
               
                
                
                    
                
                
            
            