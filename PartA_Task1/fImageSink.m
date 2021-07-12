% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display the received image by converting bits back into R, B and G
% matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P demodulated bits of 1's and 0's
% Q (Integer) = Number of bits in the image Q=8
% x (Integer) = Number of pixels in image in x dimension
% y (Integer) = Number of pixels in image in y dimension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fImageSink(bitsIn,Q,x,y)
img = reshape(bitsIn, Q,floor(length(bitsIn)/Q));
image = [];
n=size(img,2);
for i = 1 : n
    image(:,i) = bin2dec(sprintf('%d',(img(:,i)')));
end
image = reshape(uint8(image),x,y,3);
imshow(image);
end