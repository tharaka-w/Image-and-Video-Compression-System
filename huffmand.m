function Decode_img_mat=huffmand(full_code_img,dict_codes,N)

Decoded_img_array = huffmandeco(full_code_img,dict_codes);

Decode_img_mat=reshape(Decoded_img_array,[N,N]);


end