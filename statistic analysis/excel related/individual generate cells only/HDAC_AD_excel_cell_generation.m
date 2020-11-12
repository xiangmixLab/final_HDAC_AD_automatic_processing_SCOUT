%hdac_ad_auto excel cell generation
function [compexcel,ampcompexcel,ampcompexcel_sp,infoexcel,placecellexcel,placecellindexexcel,cellclusterindexexcel,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel,individualcompexcel,individualcompexcel_all,individualcompexcel_allS,individualcompexcel_all_fc,n,compexcel_ss,compexcel_fc,individualcompexcel_sp,individualcompexcel_fc]=HDAC_AD_excel_cell_generation(nameparts1)

compexcel=cell(13,8);
compexcel{1,2}='ori';
compexcel{1,3}='mov';
compexcel{1,4}='upd';
compexcel{1,5}='nov';
compexcel{1,6}='sum activity';
compexcel{1,7}='framenum';
compexcel{1,8}='sum activity/framenum';
compexcel{1,10}='binsize';

compexcel_ss=cell(13,8);
compexcel_ss{1,2}='ori';
compexcel_ss{1,3}='mov';
compexcel_ss{1,4}='upd';
compexcel_ss{1,5}='nov';
compexcel_ss{1,6}='sum activity';
compexcel_ss{1,7}='framenum';
compexcel_ss{1,8}='sum activity/framenum';
compexcel_ss{1,10}='binsize';

compexcel_fc=cell(13,8);
compexcel_fc{1,2}='ori';
compexcel_fc{1,3}='mov';
compexcel_fc{1,4}='upd';
compexcel_fc{1,5}='nov';
compexcel_fc{1,6}='sum activity';
compexcel_fc{1,7}='framenum';
compexcel_fc{1,8}='sum activity/framenum';
compexcel_fc{1,10}='binsize';


ampcompexcel=cell(13,8);
ampcompexcel{1,2}='ori';
ampcompexcel{1,3}='mov';
ampcompexcel{1,4}='upd';
ampcompexcel{1,5}='nov';
ampcompexcel{1,6}='sum amplitude';
ampcompexcel{1,7}='framenum';
ampcompexcel{1,8}='sum amplitude/framenum';
ampcompexcel{1,10}='binsize';

ampcompexcel_sp=ampcompexcel;

infoexcel=cell(5,3);
infoexcel{1,2}='average info per second';
infoexcel{1,3}='average info per spike';
placecellexcel{1,2}='threshold';
placecellexcel{1,3}='number of placecell';
placecellexcel{1,4}='percentage of placecell to all the cells';
placecellindexexcel=cell(1000,5);
cellclusterindexexcel=cell(1000,9);

mouselookobjectfiringexcel=cell(1000,100);
for i01=1:length(nameparts1)
mouselookobjectfiringexcel{1,2+5*(i01-1)}=nameparts1(i01);
mouselookobjectfiringexcel{1,3+5*(i01-1)}='ori';
mouselookobjectfiringexcel{1,4+5*(i01-1)}='mov';
mouselookobjectfiringexcel{1,5+5*(i01-1)}='upd';
mouselookobjectfiringexcel{1,6+5*(i01-1)}='nov';
end

mouselookobjectfiringrateexcel=mouselookobjectfiringexcel;
mouselookobjectamplitudeexcel=mouselookobjectfiringexcel;
mouselookobjectamplituderateexcel=mouselookobjectfiringexcel;
mouselookobjectcounttimeexcel=mouselookobjectfiringexcel;
individualcompexcel=cell(1000,100);
individualcompexcel_all=cell(1000,100);
individualcompexcel_allS=cell(1000,100);

n=22;
for i01=1:length(nameparts1)
individualcompexcel{1,2+n*(i01-1)}=nameparts1(i01);
individualcompexcel{1,3+n*(i01-1)}='Count';
individualcompexcel{2,3+n*(i01-1)}='ori';
individualcompexcel{2,4+n*(i01-1)}='mov';
individualcompexcel{2,5+n*(i01-1)}='upd';
individualcompexcel{2,6+n*(i01-1)}='nov';
individualcompexcel{1,7+n*(i01-1)}='CountTime';
individualcompexcel{2,7+n*(i01-1)}='ori';
individualcompexcel{2,8+n*(i01-1)}='mov';
individualcompexcel{2,9+n*(i01-1)}='upd';
individualcompexcel{2,10+n*(i01-1)}='nov';
individualcompexcel{1,11+n*(i01-1)}='FiringRate';
individualcompexcel{2,11+n*(i01-1)}='ori';
individualcompexcel{2,12+n*(i01-1)}='mov';
individualcompexcel{2,13+n*(i01-1)}='upd';
individualcompexcel{2,14+n*(i01-1)}='nov';
individualcompexcel{1,15+n*(i01-1)}='Amplitude';
individualcompexcel{2,15+n*(i01-1)}='ori';
individualcompexcel{2,16+n*(i01-1)}='mov';
individualcompexcel{2,17+n*(i01-1)}='upd';
individualcompexcel{2,18+n*(i01-1)}='nov';
individualcompexcel{1,19+n*(i01-1)}='Amplitude_normalized';
individualcompexcel{2,19+n*(i01-1)}='ori';
individualcompexcel{2,20+n*(i01-1)}='mov';
individualcompexcel{2,21+n*(i01-1)}='upd';
individualcompexcel{2,22+n*(i01-1)}='nov';
individualcompexcel_all{1,2+n*(i01-1)}=nameparts1(i01);
individualcompexcel_all{1,3+n*(i01-1)}='Count';
individualcompexcel_all{1,7+n*(i01-1)}='CountTime';
individualcompexcel_all{1,11+n*(i01-1)}='FiringRate';
individualcompexcel_all{1,13+n*(i01-1)}='Amplitude';
individualcompexcel_all{1,15+n*(i01-1)}='Amplitude_normalized';
individualcompexcel_allS{1,2+n*(i01-1)}=nameparts1(i01);
individualcompexcel_allS{1,3+n*(i01-1)}='Count';
individualcompexcel_allS{1,7+n*(i01-1)}='CountTime';
individualcompexcel_allS{1,11+n*(i01-1)}='FiringRate';
individualcompexcel_allS{1,13+n*(i01-1)}='Amplitude';
individualcompexcel_allS{1,15+n*(i01-1)}='Amplitude_normalized';
end
individualcompexcel_sp=individualcompexcel;
individualcompexcel_fc=individualcompexcel;
individualcompexcel_all_fc=individualcompexcel_allS;