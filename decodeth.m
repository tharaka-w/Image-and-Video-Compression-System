function Decoded_dequontized_idct_img_mat=decodeth(full_code_img,dict_codes,quality)

Decoded_quontized_img_array = huffmandeco(full_code_img,dict_codes);

Decoded_quontized_img_mat=reshape(Decoded_quontized_img_array,[280,280]);

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
               

Decoded_dequontized_img_mat = blockproc(Decoded_quontized_img_mat,[8 8],@(block_struct) q_mtx .* block_struct.data);

%uncomment this if need the image
%figure; imshow(Decoded_dequontized_img_mat); title('Decoded dequantized image');

IDCT=@(block_struct) idct2(block_struct.data);
Decoded_dequontized_idct_img_mat = blockproc(Decoded_dequontized_img_mat,[8 8],IDCT);

%uncomment this if need the image
 % figure,imshow(uint8(Decoded_dequontized_idct_img_mat)); 
%  title('IDCT Dequantized image');
end