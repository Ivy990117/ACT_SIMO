% Main function: 
% PartA_Task1.m
% 
% Sub functions:
% fImageSource: convert image to bit stream
% gold: generate fixed number gold sequences according to given rules
% fMSeqGen: generate one m-sequence
% fGoldSeq: generate one gold seqence
% fDSQPSKModulator: modulate and spread signals
% fChannel: channel modulation
% fChannelEstimation:estimate channel parameters: delay, DOA and fading coefficients
% fDSQPSKDemodulator: despread and demodulate symbols
% ber: compute bit error rate between transfered image and recovered image
% fImageSink:convert bit stream to image