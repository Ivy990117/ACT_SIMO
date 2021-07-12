Array Mainflod Method
Main function: PartA_Task3.m
% Sub functions:
% fImageSource: convert image to bit stream
% gold: generate fixed number gold sequences according to given rules
% fMSeqGen: generate one m-sequence
% fGoldSeq: generate one gold seqence
% fDSQPSKModulator: modulate and spread signals
% fChannel3: channel modulation
% fChannelEstimation3:estimate channel parameters: delay, DOA and fading coefficients
% fDSQPSKDemodulator3: despread and demodulate symbols
% ber: compute bit error rate between transfered image and recovered image
% fImageSink:convert bit stream to image
% supres:supressolution beamformer
% MDL/AIC:estimate the number of transmitters



Spatiotemporal Array Manifold Method 
Main function: PartA_Task3_STAR.m
% Sub functions:
% fImageSource: convert image to bit stream
% gold: generate fixed number gold sequences according to given rules
% fMSeqGen: generate one m-sequence
% fGoldSeq: generate one gold seqence
% fDSQPSKModulator: modulate and spread signals
% fChannel3: channel modulation
% fChannelEstimation3:estimate3 channel parameters: delay, DOA and fading coefficients
% fDSQPSKDemodulator3: despread and demodulate symbols
% ber: compute bit error rate between transfered image and recovered image
% fImageSink:convert bit stream to image
% fShifting: obtain J and Jc
% fStarRake: STAR reveiver
% fVect: generate symbol matrix (vectorization)