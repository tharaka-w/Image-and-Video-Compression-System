# Image-and-Video-Compression-System


step1- add all the .m fies to a one folder

Step2- Paste the folder named 'shrek' folder to Local Disk E right away 

Step3-open mainth.m

step4-run the mainth.m and change folder to the created folder in step1

Encoder and Decoder will run automatically and the decoded images will be saved to automatically created E/saved folder location.

step5-If needed, change the said features in mainth.m file to switch to full search, logarithmic search algorithms, bit rate quality changes,and Jpeg pipeline or huffman.

step6-wait for 1 minute till the code run completely
  
Decoded images,Optimum Bit rate, for a quality when used inter or intra prediction for each frames, the best prediction method are displayed.
 
Enjoy.....

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Exceptions-
1. If want to change the paths of input images-
	
	paste the images to anywhere else and
	add your path to
	1.main.m

	line4
		image=imread('E:\shrek\f001.jpg'); %read initial i frame
	line5
		image2=imread('E:\shrek\f005.jpg') %read 5th image because this is an i frame


	2.blockmatchingth.m and blockmatchinglog.m

	line10
		srcFiles = dir('E:\shrek\*.jpg'); 
	line20
	    	filename = strcat('E:\shrek\',srcFiles(frameNo+1).name);

2.If want to change the saving location change
	mainth.m
	line8
		destinationFolder = 'E:\saved';

3. If need to see the intermediate (predicted and residuals)
	uncomment the said lines in blockmatchingth.m and blockmatchinglog.m

4.If want to add another set of frames 
	add 10 frames
	add only 300*300 images
	else change the coding accordingly 
						
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mainth.m-all the encoding and decoding handling

blockmatchingth.m-Full search

blockmatchinglog.m-Logarithmic Search

encodingth.m-dct,quantization,huffman

encodingth2.m-dct,quantization,jpeg pipeline, dpcm ,huffman

decodeth.m-huffmandecoding,IDCT,Dequantization

huffmanenc.m-huffman encoding

huffmand.m-huffmandecoding

predictth.m-Prediction from MV

bitrate.m-finds best bit rate, and optimum method intra or inter for each frame are found by rounding the residual value,use p=0 to get best results for bit rate

Coded in Matlab 2019a
Use the same or higher version to correctly run the code.....................................................................................................................
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



