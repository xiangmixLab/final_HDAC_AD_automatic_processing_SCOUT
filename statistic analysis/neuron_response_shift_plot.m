function neuron_response_shift_plot(nC)

figure;
hold on;
interval=25;
for i=1:size(nC,1)
    plot(nC(i,:)-(i-1)*interval);
end