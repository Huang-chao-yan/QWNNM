clear 
close all

q2double = @(X) double2q(X, 'inverse');
Sig = 25; beta = 7.5; theta = 8.5;  lambda = 110;
H = fspecial('motion',20,60);  
psnr_max=0;
imgO = double(imread('26.png'));
     
% add blur and noise to the clean img
[imgB, H_full] = addblur(H, imgO);

imgN = imgB + Sig * randn(size(imgB)); 
imshow(uint8(imgN));                               % save or show the degraded image
fprintf( 'Degraded Image PSNR = %2.2f \n\n', psnr(imgN./255, imgO./255));
fprintf( 'Degraded Image SSIM = %2.4f \n\n', ssim(imgN./255, imgO./255));
% set parameters
nSig = Sig*theta;                        
Par   = QWNNM_ParSet(nSig);              
par.c         =   1.3*sqrt(2); 
par.delta     =   0.1;  
Par.Innerloop           =       1;
Par.patsize             =       6;
Par.patnum              =       155;      
Par.lamada              =       0.334;      
Par.Iter                =       5;

% initial setup for Subproblem1 (do some Fourier Transform preparations)
f       =       double2q(imgN);                          
g       =       f;
eta     =       double2q(zeros(size(imgN)));            
f_      =       fft2(f); 
A       =       double2q(H_full);
A_      =       fft2(H_full);
AtA_    =       conj(A_).*A_;
D_      =       lambda .* AtA_ + beta;                    

% initial setup for Subproblem2 (QWNNM)
[Height, Width, Depth]  = size(imgO);
TotalPatNum = (Height-Par.patsize+1)*(Width-Par.patsize+1);
[Neighbor_arr, Num_arr, Self_arr] =	QWNNM_NeighborIndex(imgO, Par);
NL_mat = zeros(Par.patnum,length(Num_arr));

tic
% iteration begin
for iter = 1:8
    g_ = fft2(g);
    etat_ = conj(fft2(eta));
    
    u = ifft2((lambda .* real(A_) .* f_ + beta .* g_ - 2 .* etat_)./ D_);
    psnr_p2 = psnr(q2double(u) ./ 255, imgO./255);                    % PSNR of SubP1
    if psnr_max < psnr_p2
        psnr_max = psnr_p2;
        imgBest = q2double(u);
    end
    N_Img = q2double(u + eta./beta);
    E_Img = N_Img;
    E_Img = E_Img + Par.delta*(N_Img - E_Img);
    [CurPat, Sigma_arr] = QWNNM_Im2Patch(E_Img, N_Img, Par);
    NL_mat = QWNNM_Block_matching(CurPat, Par, Neighbor_arr, Num_arr, Self_arr);
    [EPat, W] = QWNNM_PatEstimation(NL_mat, Self_arr, Sigma_arr, CurPat, Par);
    E_Img = QWNNM_Patch2Im(EPat, W, Par.patsize, Height, Width, Depth);
    g = double2q(E_Img);   
    psnr_wnnm = psnr(q2double(g) ./ 255, imgO./255);              % PSNR of each step of WNNM
        if psnr_max < psnr_wnnm
            psnr_max = psnr_wnnm;
            imgBest = q2double(g);
        end

    eta = eta + 0.001*(u - g);
    psnr_p2 = psnr(q2double(u) ./ 255, imgO./255);                    % PSNR of SubP1
    if psnr_max < psnr_p2
        psnr_max = psnr_p2;
        imgBest = q2double(g);
    end
    
end
toc
SSIM=ssim(imgO./255,imgBest./255);
figure;imshow(cat(2,uint8(imgO),uint8(imgN),uint8(imgBest)));
drawnow;
title(['Original','               ','degraded             ',num2str(psnr_max,'%2.2f'),'dB'],'FontSize',16)
    
