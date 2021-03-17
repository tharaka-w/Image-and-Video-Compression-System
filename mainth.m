close all
clear all 
clc
image=imread('E:\shrek\f001.jpg'); %read initial i frame
image2=imread('E:\shrek\f005.jpg') %read 5th image because this is an i frame

%Saving locationof final decoded images, change this if you want
destinationFolder = 'E:\saved';


quality=2; % add quality 0-low,1-medium,2-best quantization depending on bit rate

p=0; % if p=0 no jpeg pipeline, if p=1 jpeg pipeline

full_search=1; %1-Full search, 0-Logarithmic Search




if p==0
    [a,b]=encodingth(image,quality);
    [c,d]=encodingth(image2,quality)
    i22=decodeth(a,b,quality);
    i23=decodeth(c,d,quality);
    space3=length(a);
    space4=length(c);
elseif p==1
    [a,b,c]=encodingth2(image,quality);
    [d,e,f]=encodingth2(image2,quality)
    i22=decodeth2(a,b,c,quality);
    i23=decodeth2(d,e,f,quality);
    space3=length(b);
    space4=length(e);
   

end


if full_search==1
        [x,y,residul,space2]=blockmatchingth(image,i22,p,quality); %Block matching full search
elseif full_search==0
        [x,y,residul,space2]=blockmatchinglog(image,i22,p,quality) %Block matching
%Logarithmic search
end
space2(1)=space3;%huffman encoded bit size
space2(5)=space4;
%Motion vectors and DCT Quantized residual from block matching
X=x(1:35,1:35);
Y=y(1:35,1:35);
residual=residul(1:300,301:600);

%Huffman encoding and decoding all the motion vectors and residual parts
%both encoder and decoder is run here
res2(1:300,1:3000)=0;
%close all
space(1:10)=zeros;
for i=1:1:9
    
     X_1=x(1:35,1+(i-1)*35:35*i);
     Y_1=y(1:35,1+(i-1)*35:35*i);
     [X11,X12]=huffmanenc(X_1,35);
     [Y11,Y12]=huffmanenc(Y_1,35);
     
     X1(1:35,1+(i-1)*35:35*i)=huffmand(X11,X12,35);
     Y1(1:35,1+(i-1)*35:35*i)=huffmand(Y11,Y12,35);
     res1=residul(1:300,1+i*300:(i+1)*300);
     [r1,r2]=huffmanenc(round(res1),300);
     res2(1:300,1+i*300:(i+1)*300)=huffmand(r1,r2,300);
     
     space(i+1)=length(X11)+length(Y11);%only MV are considered and residual added in another function to increase further compression to residual part by rounding
end
space(1)=space3;%here also uses i frame therefore same bit amount
space(5)=space4;
%predicting and adding residuals and showing final images
 for i =1:1:9
    
     %X=x(1:35,1+(i-1)*35:35*i);
     %Y=y(1:35,1+(i-1)*35:35*i);
     
     X=X1(1:35,1+(i-1)*35:35*i);
     Y=Y1(1:35,1+(i-1)*35:35*i);
     %residual=residul(1:300,1+i*300:(i+1)*300);
     residual1=res2(1:300,1+i*300:(i+1)*300);
     residual=residual1(9:288,9:288);
     if i==1
         frame_pred=predictth(i22,X,Y);
         imagef=frame_pred+residual;
         %figure;imshow(uint8(image(9:288,9:288)));
         figure;imshow(uint8(i22));
         %figure;imshow(uint8(imagef(9:288,9:288)));
         figure;imshow(uint8(imagef));
         %figure;imshow(uint8(frame_pred));
         %title('pred')
     elseif i==4
         figure;imshow(uint8(i23));
     elseif i==5
         
        frame_pred=predictth(i23,X,Y);
        imagef=frame_pred+residual;
         %figure;imshow(uint8(image(9:288,9:288)));
         %figure;imshow(uint8(i23));
         %figure;imshow(uint8(imagef(9:288,9:288)));
         figure;imshow(uint8(imagef));
         
     else
         frame_pred2=predictth(imagef,X,Y);
         imagef2=frame_pred2+residual;
         %figure; imshow(uint8(imagef2(9:288,9:288)));
         figure;imshow(uint8(imagef2));
         imagef=imagef2;
         %figure;imshow(uint8(frame_pred2));
         %title('pred')
     end
        
     
    if ~exist(destinationFolder, 'dir')
        mkdir(destinationFolder);
    end
    
    %Saving Images
    baseFileName = sprintf('%d.jpg', i); % e.g. "1.png"
    baseFileName2 = sprintf('%d.jpg', i+20); % e.g. "1.png"
    baseFileName3 = sprintf('%d.jpg', i+30); % e.g. "1.png"
    fullFileName = fullfile(destinationFolder, baseFileName); 
    fullFileName2 = fullfile(destinationFolder, baseFileName2); 
    fullFileName3 = fullfile(destinationFolder, baseFileName3); 
    if i==1
        imwrite(uint8(i22), fullFileName);
        imwrite(uint8(imagef), fullFileName2);
        % img respresents input image
    elseif i==4
        imwrite(uint8(i23), fullFileName); % img respresents input image
    elseif i==5
        imwrite(uint8(imagef), fullFileName); % img respresents input image
    else
        imwrite(uint8(imagef2), fullFileName);
        %imwrite(uint8(imagef), fullFileName3);
    end
   
 end
    [err,order,bit_rate]=bitrate(quality,residul,space,space2);%predicts bits needed without anny buffering
clc
bit_rate
for i=1:1:10
    if order(i)==1
        disp('intra');
    else
        disp('inter');
    end
    %display whether inter or intra is required to get optimum prediction
    %with for lowest bit rate
end

     






