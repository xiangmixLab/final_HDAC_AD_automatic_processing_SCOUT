function all_bin=surrounding_bin_generation(central_bin,bin_radius)

all_bin=[];

for u=-bin_radius:bin_radius
    for v=-bin_radius:bin_radius
        all_bin=[all_bin;central_bin(1)+u,central_bin(2)+v]; % left is 2, right is 1
    end
end