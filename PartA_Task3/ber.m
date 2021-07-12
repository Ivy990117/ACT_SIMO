function BER=ber(received_image,ori_signal)
    M=length(received_image);
    BER=0;
    for i=1:M
        if received_image(i) ~= ori_signal(i)
            BER=BER+1;
        end
    end
    BER=BER/M;
end