function [X,Y,residu1,space2]=blockmatchinglog(imageref,decoded_ref,p,quality)
space2(1:10)=zeros;
f_ref(1:300,1:300)=0;
Im=imageref;
f_ref(9:288,9:288)= Im(9:288,9:288);

i22=decoded_ref;
f_ref(9:288,9:288)= i22; %now reference is created as in decoded end 280*280 and dct idct quant dequant but f_ref 300*300

srcFiles = dir('E:\shrek\*.jpg');
    
f_p=zeros(300,3000);

X=zeros(35,350);
Y=zeros(35,350);

for frameNo=1:9
    filename = strcat('E:\shrek\',srcFiles(frameNo+1).name);
     f_2(1:300,1:300)=0;
    Im2= imread(filename);
    f_2(9:288,9:288)= Im2(9:288,9:288); 
    f_pre(1:300,1:300)=0;

s=1;
X_motion= zeros(22,22);
Y_motion=zeros(22,22);
for i=9:8:288
    t=1;
    for j=9:8:288
 img_abs=[0 0 0 0 0];
img_16=f_ref(i-4:i+7+4,j-4:j+7+4);
img_8=f_2(i:i+7,j:j+7);
flag = 1;
I=1;
Rc=5;
Cc=5;
step_size=4;

while flag
    r=[Rc,Rc-step_size,Rc,Rc,Rc+step_size];%Initializing neighbours with respect to a point
    c=[Cc,Cc,Cc-step_size,Cc+step_size,Cc];%Initializing the neighbour
   %SAD with boundary limitations
    for g=1:5
    if r(g)<=0 || r(g)>=10
        img_abs(g)=255*64*255;
    elseif c(g)<=0 || c(g)>=10
        img_abs(g)=255*64*255;
    elseif g==I && g-1>0
        img_abs(g)=255*64*255;
    else 
        img_abs(g)=sum(sum((img_16(r(g):r(g)+7,c(g):c(g)+7)- img_8).^2));
    end
    end
  
%minimum is opttmized by stepping down to a proper sub neighbours
[M,I] = min(img_abs);
switch (I)
    case 1
        step_size=step_size/2;
    case 2
        Rc=Rc-step_size;
    case 3
        Cc=Cc-step_size;
    case 4
        Cc=Cc+step_size;
    case 5
        Rc=Rc+step_size;    
end
%stopping point defining to find sub neighbours
if step_size<1
    flag=0;  
    break;
else
    continue;
end
end
    f_pre(i:i+7,j:j+7)=img_16(Rc:Rc+7,Cc:Cc+7);
    X_motion(s,t)= Rc-5;
    Y_motion(s,t)= Cc-5;

t=t+1;
    end
    s=s+1;

end
f_p(1:300, 1+(300*frameNo):300*(frameNo+1))=f_pre;
X(1:35, 1+(35*(frameNo-1)):35*frameNo)=X_motion;
Y(1:35, 1+(35*(frameNo-1)):35*frameNo)=Y_motion;


     ress(1:300,1:300)=zeros;
     ress=(f_2-f_pre);
     [ress1,ress2]=encodingth(ress,quality);
     ress3=decodeth(ress1,ress2,quality);
     ress(9:288,9:288)=ress3;
    
     %residu1(9:288, 9+(300*frameNo):300*(frameNo)-12)=ress3;
     residu1(1:300, 1+(300*frameNo):300*(frameNo+1))=ress;

% 

     %If need images uncomment below 5 lines
% 
 %      figure,imshow(uint8(ress(9:288,9:288)));
 %      title('Residual after logarithmic Search Operation');
%      t=f_p(1:300, 1+(300*frameNo):300*(frameNo+1));
%      figure,imshow(uint8(t(9:288,9:288)));
%      title('Predicted frame logarithmic');





if p==1
    [a,b,c]=encodingth2(f_2,quality);
elseif p==0
    [a,b]=encodingth(f_2,quality);
end


space2(frameNo+1)=length(a);


    if frameNo==4 
        if p==1
            i2n=decodeth2(a,b,c,quality);
        elseif p==0
            i2n=decodeth(a,b,quality);
        end
        f_ref(9:288,9:288)=i2n;
        
    else 
        f_ref=ress+f_pre;
        %f_ref=f_2;
    end
    %figure,imshow(f_pre)
%f_ref=f_2;
end

end
