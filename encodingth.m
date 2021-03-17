
function [full_code_img,dict_codes]=encodingth(image,quality)

grayimage=image(9:288,9:288);



fun=@(block_struct) dct2(block_struct.data);
I2=blockproc(grayimage,[8,8], fun)

%figure; imshow(I2,[]); title('DCT Image')   % To get the DCT image uncomment this


% Standard Quantization Matrix
q_mtx =     [16 11 10 16 24 40 51 61; 
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
        
if quality==2
       q_mtx=q_mtx;
elseif quality==1
       q_mtx=q_mtx.*5;
elseif quality==0
       q_mtx=q_mtx.*10;
end   
       
           
   %PErforming Quantization by Dividing with q_mtx on blocks of 8 by 8
   Function_Quantization = @(block_struct) round((block_struct.data) ./ q_mtx);        
   quant8_I = blockproc(I2,[8 8],Function_Quantization);

   %QM=round(quant8_I);

   
  %figure
 %imshow(quant8_I,[]);title('quantized after DCT'); %to get the quantized
 %dct image uncomment this
   



% find probabilities
[g,~,Intensity_val] = grp2idx(quant8_I(:));
Frequency  = accumarray(g,1);


[Intensity_val Frequency];
probability=Frequency./(280*280); % probabilities
prob2 =Frequency./(280*280);
T = table(Intensity_val,Frequency,probability); %table (element | count | probability )
T(1:length(Frequency),:);

%huffman
Array_probability=table2array(T(:,3))
Array_intensity=table2array(T(:,1))
dict_codes= huffmandict(Array_intensity,Array_probability);
full_code_img = huffmanenco(quant8_I(:),dict_codes);

end
