if exp==10
objnamecell={'null','ori','ori';
                 'null','nov','novt';
                 'null','null','null'};
             
   if ikk==8
        objnamecell={'null','null','ori';
             'null','null','nov';
             'null','null','null'};
    end

    if ikk==16||ikk==17
        objnamecell={'null','nov','ori';
             'null','ori','nov';
             'null','null','null'};
    end
end

if exp==1
    objnamecell={'ori','ori','ori';
                 'mov','upd','mov';
                 'null','null','upd';
                 'null','null','nov'};
end
if exp==11
    objnamecell={'ori','ori','ori','ori';
                 'mov','mov','upd','mov';
                 'null','null','null','upd';
                 'null','null','null','nov'};
end

if exp==12

    objnamecell={'null','ori','ori';
                 'null','nov','novt';
                 'null','null','null'};

    if ikk==6||ikk==7
    objnamecell={'null','nov','nov';
                 'null','ori','ori';
                 'null','null','null'};
    end
end

if exp==4

    objnamecell={'null','ori','ori';
                 'null','nov','nov';
                 'null','null','null'};

    if ikk==2||ikk==4||ikk==8||ikk==9
    objnamecell={'null','nov','nov';
                 'null','ori','ori';
                 'null','null','null'};
    end
end

if exp==5

    objnamecell={'null','ori','ori';
                 'null','nov','nov';
                 'null','null','null'};

end

if exp==13

    objnamecell={'null','null','ori','ori';
                 'null','null','nov','novt';
                 'null','null','null','null'};
end

if exp==14

    objnamecell={'null','ori','ori';
                 'null','nov','novt';
                 'null','null','null'};
end

if exp==17

    objnamecell={'null','null','null';
                 'null','null','null';
                 'null','null','null'};
end

if exp==19
   objnamecell={};
   for i=1:num_of_conditions
       objnamecell{i}='ori';
   end
   objnamecell{1}='null';
   objnamecell{2}='null';
    
end

if exp==131
   objnamecell={'1' '1' '1' '1' '1';
       '2' '2' '2' '2' '2';
       '3' '3' '3' '3' '3';
       '4' '4' '4' '4' '4';
       '5' 'null' 'null' 'null' 'null';
       '6' 'null' 'null' 'null' 'null';
       '7' 'null' 'null' 'null' 'null';
       '8' 'null' 'null' 'null' 'null';
       '9' 'null' 'null' 'null' 'null';
       '10' 'null' 'null' 'null' 'null'
       };
   
end
