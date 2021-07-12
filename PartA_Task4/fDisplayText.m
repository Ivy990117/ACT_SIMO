function fDisplayText(text_bits,n_chars)
    text_bits=uint8(reshape(text_bits,length(text_bits)/n_chars,n_chars));
    text_bits=bi2de(text_bits.','left-msb')';
    disp(char(text_bits));
end