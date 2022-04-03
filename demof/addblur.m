function [degradedIm, H_full] = addblur(h, img)
    [Ny,Nx,Nz]=size(img);
    H_full = zeros(Ny,Nx);
    H_full(1:size(h,1), 1:size(h,2)) = h;
    center=[(size(h,1)+1)/2,(size(h,2)+1)/2];
    blur_A=padPSF(H_full,[Ny,Nx]);
    blur_matrix_trans=fft2(circshift(blur_A,1-center));
    degradedIm = real(ifft2(fft2(img).*blur_matrix_trans));
    H_full = circshift(blur_A,1-center);
end