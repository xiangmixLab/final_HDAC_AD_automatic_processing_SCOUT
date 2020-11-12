%fix: Ntg or AD, or mice/cell idx
%randomm: randomm index, randomm, mice/cell index (can be multiple, in a
%cell)
%neuron: cell index

% example: lme=calculate_lme(Circle.infoScore,Circle.mtype,{Circle.midx,Circle.cell})
function [lme,anova_lme]=calculate_lme(var,fix,randomm,interact_term)

tbl_cell={};
vnames={'y'};

for i=1:length(fix)
    for j=1:length(var)
        tbl_cell{j,1}=var(j);
        tbl_cell{j,i+1}=fix{i}(j);
        vnames{i+1}=['fix',num2str(i)];
    end
end

for i=1:length(randomm)
    for j=1:length(var)
        tbl_cell{j,i+length(fix)+1}=randomm{i}(j);
        vnames{i+length(fix)+1}=['random',num2str(i)];
    end
end

tbl= cell2table(tbl_cell,'VariableNames',vnames);

formulaa='y~fix1';

% fix effect add in
for i=2:length(fix)
    formulaa=[formulaa,'+','fix',num2str(i)];
end

%interact term add in
for i=1:length(interact_term)
    formulaa=[formulaa,'+',interact_term{i}];
end

% random effect add in
for i=1:length(randomm)
    formulaa=[formulaa,'+','(1|','random',num2str(i),')'];
end

lme = fitlme(tbl,formulaa); 

anova_lme=anova(lme);