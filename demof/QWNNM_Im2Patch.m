function  [Y, SigmaArr]  =  QWNNM_Im2Patch( E_Img,N_Img, par )
TotalPatNum = (size(E_Img,1)-par.patsize+1)*(size(E_Img,2)-par.patsize+1);                  %Total Patch Number in the image
Y           =   zeros(par.patsize*par.patsize, TotalPatNum, size(E_Img,3), 'single');  %% add the third channle                   %Current Patches
N_Y         =   zeros(par.patsize*par.patsize, TotalPatNum, size(E_Img,3), 'single');    %%                  %Patches in the original noisy image
k           =   0;

for i  = 1:par.patsize
    for j  = 1:par.patsize
              k     =  k+1;
        E_patch     =  E_Img(i:end-par.patsize+i,j:end-par.patsize+j, :);
        N_patch     =  N_Img(i:end-par.patsize+i,j:end-par.patsize+j, :);        
        Y(k,:,:)      =  reshape(E_patch, [1 size(E_patch,1)*size(E_patch,2) 3]);
        N_Y(k,:,:)    =  reshape(N_patch, [1 size(E_patch,1)*size(E_patch,2) 3]);
    end
end
 SigmaArr = par.lamada*sqrt(abs(repmat(par.nSig^2,1,size(Y,2))-mean((N_Y-Y).^2)));          %Estimated Local Noise Level