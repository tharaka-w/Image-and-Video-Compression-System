function [err,strp,rate]=bitrates(quality,residul,space,space2)
time=5; %duratio of the fly
%space has all the mv huffman coded part
%space2 has all the huffman coded intra predicted code part
%keep p=0 to stick with basinc image compression
for i=1:1:9
     
     res1=residul(1:300,1+i*300:(i+1)*300);
     [r1,r2]=huffmanenc(round(res1./20).*20,300); % to get better reduction rounding up,otherwise all get intra predictio fromthis decoden
     res2(1:300,1+i*300:(i+1)*300)=huffmand(r1,r2,300);
     
     space(i+1)=space(i+1)+length(r1); %add residual part as well
     
end
rate=0;
space(5)=space2(5);%since 5 is an i frame
err=space-space2;% to finnd what is better inter or intra
for i=1:1:10
    if err(i)>=0
        rate=rate+space(i);
        strp(i)=1;
    else
        rate=rate+space2(i);
        strp(i)=0;
    end
        
end
rate=rate/time;
end