function esm_ratemap=clust_ensemble_ratemap(gp,ratemap)

esm_ratemap={};
for j=1:length(unique(gp))
    ratemap_gp_t=ratemap(gp==j);
    ratemap_size=[0 0];
    for k=1:length(ratemap_gp_t)
        if ~isempty(ratemap_gp_t{k})
            ratemap_size=size(ratemap_gp_t{k});
            break;
        end
    end
    for k=2:length(ratemap_gp_t)
        if isempty(ratemap_gp_t{1})
            ratemap_gp_t{1}=zeros(ratemap_size(1),ratemap_size(2));
        end
        if ~isempty(ratemap_gp_t{k})
            ratemap_gp_t{1}=ratemap_gp_t{1}+ratemap_gp_t{k};
        end
    end
    ratemap_gp_t{1}=ratemap_gp_t{1}/length(ratemap_gp_t);
    esm_ratemap{j}=ratemap_gp_t{1};
    esm_ratemap{j}(esm_ratemap{j}>mean(esm_ratemap{j}(:))+3*std(esm_ratemap{j}(:)))=0;
    esm_ratemap{j}=filter2DMatrices(esm_ratemap{j},1);
end
