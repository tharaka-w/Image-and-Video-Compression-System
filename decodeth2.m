function Decoded_dequontized_idct_img_mat=decodeth2(DC,full_code_img,dict_codes,quality)
A(1:280,1:280)=zeros;
IMS=size(A);
cols = length(DC);
DECOEF = zeros(64, cols); % decoded coefficients

% decode DPCM of DC coefficients
for i=2:cols
DC(i) = DC(i-1) + DC(i);
end
DECOEF(1,:) = DC;


Decoded_quontized_img_array = huffmandeco(full_code_img,dict_codes);
AC=Decoded_quontized_img_array;


AC1=reshape(Decoded_quontized_img_array,[63,1225]);
clc
size(AC1)
DECOEF(2:64,:)=AC1;


% index to reverse zig-zag way to normal
rev = [1 3 4 10 11 21 22 36 2 5 9 12 20 23 35 ...
37 6 8 13 19 24 34 38 49 7 14 18 25 33 39 ...
48 50 15 17 26 32 40 47 51 58 16 27 31 41 46 ...
52 57 59 28 30 42 45 53 56 60 63 29 43 44 54 ...
55 61 62 64];
DECOEF = DECOEF(rev, :);
QM = col2im(DECOEF, [8 8], IMS, 'distinct'); % rearrange to quantized matrix
Decoded_quontized_img_mat=QM;

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