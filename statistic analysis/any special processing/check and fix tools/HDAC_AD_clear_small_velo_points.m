%hdac_ad auto clear small velocity points

function [behavcell,neuronIndividuals,headorientationcell]=HDAC_AD_clear_small_velo_points(neuronIndividuals,behavcell,headorientationcell,smallvelo)

for i=1:length(smallvelo)
    if ~isempty(neuronIndividuals{i})
        neuronIndividuals{i}.C=neuronIndividuals{i}.C(smallvelo{i}==0,:);
        neuronIndividuals{i}.S=neuronIndividuals{i}.C(smallvelo{i}==0,:);
        neuronIndividuals{i}.time=neuronIndividuals{i}.time(smallvelo{i}==0,:);
    end
    if ~isempty(behavcell{i})
        behavcell{i}.position=behavcell{i}.position(smallvelo{i}==0,:);
        behavcell{i}.time=behavcell{i}.time(smallvelo{i}==0);
    end
    if ~isempty(headorientationcell{i})
        headorientationcell{i}.if_mouse_head_toward_object=headorientationcell{i}.if_mouse_head_toward_object(smallvelo{i}==0,:);
    end
end