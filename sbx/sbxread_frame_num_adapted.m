function [filelength] = sbxread_frame_num_adapted(fname)

% This code should be able to read all frames if left N empty
% img = sbxread(fname,k,N,varargin)
%
% Reads from frame k to k+N-1 in file fname
% 
% fname - the file name (e.g., 'xx0_000_001')
% k     - the index of the first frame to be read.  The first index is 0.
% N     - the number of consecutive frames to read starting with k.
%
% If N>1 it returns a 4D array of size = [#pmt rows cols N] 
% If N=1 it returns a 3D array of size = [#pmt rows cols]
%
% #pmts is the number of pmt channels being sampled (1 or 2)
% rows is the number of lines in the image
% cols is the number of pixels in each line
%
% The function also creates a global 'info' variable with additional
% informationi about the file
load([fname,'.mat']);
switch info.channels
    case 1
        info.nchan = 2;      % both PMT0 & 1
        factor = 1;
    case 2
        info.nchan = 1;      % PMT 0
        factor = 2;
    case 3
        info.nchan = 1;      % PMT 1
        factor = 2;
end
info.nsamples = (info.sz(2) * info.recordsPerBuffer * 2 * info.nchan);   % bytes per record 
datfileh = fopen([fname '.sbx']);
fseek(datfileh, 0,'eof');
filelength = ftell(datfileh)/info.nsamples;
fclose(datfileh);
