
% A demo for auditoryFilterBank function
% Author: Chen Ming, Ph.D.
% Contact: gomingchen@gmail.com

clc;clear;close all;
N = 4;
Q = 10;

load('exampleSig.mat');
audioIn = ts.data;

fs = ts.fs;
fc = 20E3:1E3:100E3;
audioOut = zeros(numel(audioIn),length(fc));
[numd, dend] = auditoryFilterBank(N,Q,fc,fs);
cmap = jet(length(fc));
figure
for i = 1:length(fc)
    freqz(numd(i,:),dend(i,:),1:0.5E3:ts.fs/2, fs);
    ax = findall(gcf, 'Type', 'axes');
    hold([ax(1) ax(2)],'on')
    lines = findall(gcf,'type','line');
    lines(1).Color = cmap(i,:);
    lines(1).LineWidth = 1.5;
    lines(i+1).Color = cmap(i,:);
    lines(i+1).LineWidth = 1.5;
    audioOut(:,i) = filtfilt(numd(i,:),dend(i,:),audioIn);
end

ax = findall(gcf, 'Type', 'axes');
set(ax,'XTick',20E3:20E3:180E3,'XTickLabel',20:20:180);
xlabel(ax,'Frequency (kHz)');
title('Frequency Response');
ylim([-250,0])
set(ax, 'Fontsize',14);

% calculate and plot the spectrogram
smplPerWin = 128;
smplOverlap = 120;
[DL,timeVec] = calSpectrogram(numel(audioIn), fs, audioOut, smplPerWin, smplOverlap);
figure,
surf(timeVec,fc/1E3,DL,'EdgeColor','none');
view(0,90);
title('Spectrogram');
xlabel('Time (ms)'); ylabel('Frequency (kHz)');
set(gca,'FontSize',14);