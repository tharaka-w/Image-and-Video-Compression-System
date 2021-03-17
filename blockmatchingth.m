
%edit the source when running in a different computer
%reference is given 300*300
function [X,Y,residu1,space2]=blockmatchingth(imageref,decoded_ref,l,quality)

space2(1:10)=zeros;
f_ref(1:300,1:300)=0;
Im=imageref;
f_ref(9:288,9:288)= Im(9:288,9:288);
srcFiles = dir('E:\shrek\*.jpg'); %source file change this if source is in different place

i22=decoded_ref;
f_ref(9:288,9:288)= i22; %now reference is created as in decoded end 280*280 and dct idct quant dequant but f_ref 300*300

f_p=zeros(300,3000);
X=zeros(35,350);
Y=zeros(35,350);

for frameNo=1:9
    filename = strcat('E:\shrek\',srcFiles(frameNo+1).name);
    f_2(1:300,1:300)=0;
    Im2= imread(filename);
    f_2(9:288,9:288)= Im2(9:288,9:288);
    if frameNo==1
        f_2_n=f_2;
    end
    s=1;
    X_motion=zeros(35);
    Y_motion=zeros(35);
    f_pre(1:300,1:300)=0;
    for i=9:8:288
        t=1;
        for j=9:8:288
            
            img_abs=zeros(8,8);
            img_16=f_ref(i-4:i+7+4,j-4:j+7+4);%Search area
            img_8=f_2(i:i+7,j:j+7);%target block
            
            for p=1:8
                for q=1:8
                    
                    img_abs(p,q)=(sum(sum(abs(img_16(p:p+7,q:q+7)- img_8))))./64;%sad
                end
            end
            
            [M,I] = min(img_abs(:));%min point n value
            [row_cor, col_cor] = ind2sub(size(img_abs),I);
            
            
            f_pre(i:i+7,j:j+7)=img_16(row_cor:row_cor+7,col_cor:col_cor+7);%prediction
            
            X_motion(s,t)= row_cor -5;%5 taken as the initial point to get started 5,5
            Y_motion(s,t)= col_cor -5;
            t=t+1;
        end
        
        s=s+1;
    end
        if frameNo==9
        f_new_p=f_pre;
    end
     f_p(1:300, 1+(300*frameNo):300*(frameNo+1))=f_pre;
    X(1:35, 1+(35*(frameNo-1)):35*frameNo)=X_motion;
     Y(1:35, 1+(35*(frameNo-1)):35*frameNo)=Y_motion;
     %residual is encoded and decoded to get the same frame as in decoder
     ress(1:300,1:300)=zeros;
     ress=(f_2-f_pre);
     [ress1,ress2]=encodingth(ress,quality);
     ress3=decodeth(ress1,ress2,quality);
     ress(9:288,9:288)=ress3;
    
     %residu1(9:288, 9+(300*frameNo):300*(frameNo)-12)=ress3;
     residu1(1:300, 1+(300*frameNo):300*(frameNo+1))=ress;
     
     
     
     %If need images uncomment below 5 lines
      
      %figure,imshow(uint8(ress(9:288,9:288)));
      %title('Residual after Full Search Operation');
     %t=f_p(1:300, 1+(300*frameNo):300*(frameNo+1));
      %figure,imshow(uint8(t(9:288,9:288)));
      %title('Predicted frame');
     
     
     
     
     %To last part
%  if p==1
%      [a,b,c]=encodingth2(f_2,quality);
%  else
%      [a,b]=encodingth(f_2,quality);
%  end
%     
%    space2(frameNo)=length(a)+length(b)*2;
%     
%     if frameNo==4
%         if p==1
%             i2n=decodeth2(a,b,c,quality);
%         elseif p==0
%             i2n=decodeth(a,b,quality);
%         end
%         f_ref(9:288,9:288)=i2n;
%     else 
%         f_ref=ress+f_pre;
%     end
   
if l==1
    [a,b,c]=encodingth2(f_2,quality);
elseif l==0
    [a,b]=encodingth(f_2,quality);
end


space2(frameNo+1)=length(a);


    if frameNo==4 
        if l==1
            i2n=decodeth2(a,b,c,quality);
        elseif l==0
            i2n=decodeth(a,b,quality);
        end
        f_ref(9:288,9:288)=i2n;
        
    else 
        f_ref=ress+f_pre;
        %f_ref=f_2;
    end
    
end

end


