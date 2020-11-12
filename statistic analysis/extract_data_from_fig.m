function dataObjs=extract_data_from_fig(fname)

openfig(fname);

fig=gcf;

axObjs = fig.Children
dataObjs = axObjs.Children