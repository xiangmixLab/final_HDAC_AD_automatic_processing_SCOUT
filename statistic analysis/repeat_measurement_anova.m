% repeat measurement anova calculation
% group variable should be a character array or cell (as all examples do
% like this, may be able to use different types of data)

% see
% https://www.mathworks.com/help/stats/repeatedmeasuresmodel.ranova.html %
% details
function [ranovatbl,rm]=repeat_measurement_anova(dat,group)

tbl_cell={};
vnames={'group'};


for i=1:size(dat,2)    
    for j=1:size(dat,1)
        tbl_cell{j,1}=group{j}; % do this to make each cell only contains one number/string, make cell2tab
        tbl_cell{j,i+1}=dat(j,i);
        vnames{i+1}=['meas',num2str(i)];
    end
end

tbl= cell2table(tbl_cell,'VariableNames',vnames);

formulaa=['meas1-meas',num2str(size(dat,2)),'~group'];

WithinDesignn=table([1:size(dat,2)]','VariableNames',{'Measurements'});

rm = fitrm(tbl,formulaa,'WithinDesign',WithinDesignn);

ranovatbl = ranova(rm);

