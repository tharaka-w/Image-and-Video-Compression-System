% X , Y , f_references ,used to create real frame
%X,Y-35 35 ref_image-280,280 image got from decodeth
function fpre2=predictth(ref_image,X_motion,Y_motion)
f_ref2(1:300,1:300)=0;
fpre2(1:280,1:280)=0;
Im2=ref_image;
f_ref2(9:288,9:288)= Im2; % 280 by 280 image got from decodeth



    s=1;
   % X_motion=zeros(35);
  %  Y_motion=zeros(35);
    f_pre2(1:300,1:300)=0;
    for i=9:8:288
        t=1;
        for j=9:8:288
            
            %img_abs=zeros(8,8);
            img_16=f_ref2(i-4:i+7+4,j-4:j+7+4);
           % img_8=f_2(i:i+7,j:j+7);
%             
%             for p=1:8
%                 for q=1:8
%                     
%                     img_abs(p,q)=sum(sum(abs(img_16(p:p+7,q:q+7)- img_8)));
%                 end
%             end
%             
%             [M,I] = min(img_abs(:));
            %[row_cor, col_cor] = ind2sub(size(img_abs),I);
            
            
            row_cor=X_motion(s,t)+5; %5 comes from prediction staarting point in block mathing
            col_cor=Y_motion(s,t)+5;
            %X_motion(s,t)= row_cor -5;
            %Y_motion(s,t)= col_cor -5;
            
            f_pre2(i:i+7,j:j+7)=img_16(row_cor:row_cor+7,col_cor:col_cor+7);
            fpre2=f_pre2(9:288,9:288);
            t=t+1;
        end
        
        s=s+1;
    end
end