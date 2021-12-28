
function [D, timeVector] = calSpectrogram(N, fs, aout, samplesPerFrame, samplesOverlap)
% This code is from an example in MATLAB documentation for gammatone
% filterbank
% N, number of samples
% fs, sampling frequency
% audioOut, the filtered output 

% samplesPerFrame = round(0.00025*fs);
% samplesOverlap = round(0.00020*fs);
% samplesPerFrame = 128;
% samplesOverlap = 120;

buff = dsp.AsyncBuffer(N);
if size(aout,1)<size(aout,2)
    aout = aout.';
end

write(buff,aout.^2);

sink = dsp.AsyncBuffer(N);

while buff.NumUnreadSamples > 0
    [currentFrame, ~] = read(buff,samplesPerFrame,samplesOverlap);
    write(sink,mean(currentFrame,1));
end

gammatoneSpec = read(sink);
gammatoneSpec(1: samplesOverlap/(samplesPerFrame-samplesOverlap),:) = [];
D = 20*log10(gammatoneSpec');

timeVector = ((samplesPerFrame-samplesOverlap)/fs)*(0:size(D,2)-1)*1E3;


end