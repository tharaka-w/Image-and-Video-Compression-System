
function [full_code_img,dict_codes]=huffmanenc(quant8_I,N)
% find probabilities
[g,~,Intensity_val] = grp2idx(quant8_I(:));
Frequency  = accumarray(g,1);


[Intensity_val Frequency];
probability=Frequency./(N*N); % probabilities
prob2 =Frequency./(N*N);
T = table(Intensity_val,Frequency,probability); %table (element | count | probability )
T(1:length(Frequency),:);

%huffman
Array_probability=table2array(T(:,3))
Array_intensity=table2array(T(:,1))
dict_codes= huffmandict(Array_intensity,Array_probability);
full_code_img = huffmanenco(quant8_I(:),dict_codes);
end