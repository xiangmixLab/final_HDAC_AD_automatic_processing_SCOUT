function out_cell=python_zip(cell1,cell2)
%cell1 and str2 are strings of the same length, or cell2 is of length
%n*length(cell1)
out_str='';
for i=1:length(cell2)
    cell1_index=mod(i,length(cell1));
    if cell1_index==0
        cell1_index=length(cell1);
    end
    out_cell{i}=horzcat(cell1{cell1_index},cell2{i});
end
