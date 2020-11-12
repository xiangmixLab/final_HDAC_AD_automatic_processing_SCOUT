function [f_best,model_best,rsquare_best]=fit_selection(d)

possible_models={
    'poly1';
    'poly2';
    'poly3';
    'poly4';
    'poly5';
    'poly6';
    'poly7';
    'poly8';
    'poly9';
    'weibull';
    'exp1';
    'exp2';
    'fourier1';
    'fourier2';
    'fourier3';
    'fourier4';
    'fourier5';
    'fourier6';
    'fourier7';
    'fourier8';
    'gauss2';
    'gauss3';
    'gauss4';
    'gauss5';
    'gauss6';
    'gauss7';
    'gauss8';
    'power1';
    'power2';
    }

for i=1:length(possible_models)
    [f{i},gof{i}]=fit(d(:,1),d(:,2),possible_models{i});
end

for i=1:length(gof)
    rsquare_dat(i)=gof{i}.rsquare;
end

best_mod_idx=find(rsquare_dat==max(rsquare_dat));
f_best=f{best_mod_idx};
model_best=possible_models{best_mod_idx};
rsquare_best=rsquare_dat(best_mod_idx);