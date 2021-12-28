
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gammatone-like filterbanks/Realistic filters for cochlear functions
% Differentiated All Pole Gammatone Filter (DAPGF)
% Author: Chen Ming, Ph.D.
% Contact: gomingchen@gmail.com
% Reference: 
% Katsiamis, Andreas G., Emmanuel M. Drakakis, and Richard F. Lyon. 
% "Practical gammatone-like filters for auditory processing." 
% EURASIP Journal on Audio, Speech, and Music Processing 2007 (2007): 1-15.
% AND
% The All-Pole Gammatone Filter and Auditory Models, Richard F. Lyon
% clc;clear;close all;
function [numd, dend] = auditoryFilterBank(N,Q,fc,fs)
% INPUTS: N - order of the filter
%         Q - quality factor
%         fc - the center frequencies of all the filters
%         fs - sampling frequency
% OUTPUTS: 
%         numd - the numerator array
%         dend - the denominator array
syms s
qr = sqrt(1-1/(2*Q^2));

numd = zeros(length(fc),2*N+1);
dend = zeros(length(fc),2*N+1);
for i = 1:length(fc)

    wc = 2*pi*fc(i);
    w0 = wc/qr;
    nu = (1/w0)*s;
    de = ((1/w0)^2*s^2 + 1/(w0*Q)*s + 1)^N;


    cn = coeffs(nu);
    cn = double(fliplr(cn)); % coeffs for numerator

    cd = coeffs(de);
    cd = double(fliplr(cd)); % coeffs for denominator

    %Hc = tf([cn, 0],cd); %%% ATTENTION!!! cn from coeffs produces a scalar
    % "alpha" for alpha*s.
    % However, in tf function, a scalar means the constant item, so have to
    % add a zero for constant!!!
    w = 2*pi*linspace(fc(i)-1E3, fc(i)+1E3, 1E3);
    h = freqs([cn 0],cd, w);

    % normalization
    CN_nor = [cn,0]./max(abs(h));
    [numd(i,:),dend(i,:)] = bilinear(CN_nor,cd,fs,fc(i)); 


end

