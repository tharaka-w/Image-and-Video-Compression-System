
function [DC,full_code_img,dict_codes]=encodingth2(image,quality)
% image=imread('E:\foreman\f001.jpg');
grayimage=image(9:288,9:288);
%imshow(grayimage);


fun=@(block_struct) dct2(block_struct.data);
I2=blockproc(grayimage,[8,8], fun)
% 
% %quntization
% thresh = multithresh(I2,7);
% valuesMax = [thresh max(I2(:))];
% [quant8_I, index] = imquantize(I2, thresh, valuesMax);

%figure; imshow(I2,[]); title('DCT Image')   % To get the DCT image uncomment this
% A Standard Quantization Matrix

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

   QM=round(quant8_I);
 %figure
 %imshow(quant8_I,[]);title('quantized after DCT'); %to get the quantized
 %dct image uncomment this
   
    
% function getCoefficients returns encoded AC and DC coefficients
% of quantized matrix QM

% index to order elements in a block following zig-zag way
order = [1 9 2 3 10 17 25 18 11 4 5 12 19 26 33 ...
41 34 27 20 13 6 7 14 21 28 35 42 49 57 50 ...
43 36 29 22 15 8 16 23 30 37 44 51 58 59 52 ...
45 38 31 24 32 39 46 53 60 61 54 47 40 48 55 ...
62 63 56 64];
BLK = im2col(QM, [8 8], 'distinct');
BLK = BLK(order,:); % each ordered block in a column of 64 elements

DC = BLK(1,:); % get DC coefficients
AC = BLK(2:64,:); % get AC coefficients

% DPCM on DC coefficients
for k = length(DC):-1:2
DC(k) = DC(k) - DC(k-1);
end

% RLC on AC coefficients

%AC1 = zeros;
% AC1(1:(size(AC,2)*63))=zeros
%     for icol = 1:size(AC,2)
%     count0 = 0; % count number of zeros in the run
%         for irow = 1:63
%             if AC(irow,icol) == 0
%                 count0 = count0 + 1;
%             else
%                 AC1(length(AC1)+1) = count0;
%                 AC1(length(AC1)+1) = AC(irow,icol);
%                 count0 = 0;
%             end
% 
%             if irow == 63
% % add tuple (0,0) to mark end of a block
%                 AC1(length(AC1)+1) = 0;
%                 AC1(length(AC1)+1) = 0;
%             end
%         end
%     end
% 


n1=size(AC,1)
n2=size(AC,2)
% find probabilities
[g,~,Intensity_val] = grp2idx(AC(:));
Frequency  = accumarray(g,1);


[Intensity_val Frequency];
probability=Frequency./(n1*n2); % probabilities
prob2 =Frequency./(n1*n2);
T = table(Intensity_val,Frequency,probability); %table (element | count | probability )
T(1:length(Frequency),:);

%huffman
Array_probability=table2array(T(:,3))
Array_intensity=table2array(T(:,1))
dict_codes= huffmandict(Array_intensity,Array_probability);
 full_code_img = huffmanenco(AC(:),dict_codes);

end
