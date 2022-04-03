function [ x ] = Init_my( y, HTy, fftHtH, H,nSig, mOrgImg )
% Set initial value for x

% Extract Data From struct
sAlgParam.H=H;
sAlgParam.noiseStd=nSig;
sAlgParam.algorithmPurpose='deblurring';
algorithmPurpose    = 'deblurring';
noiseStd            = nSig;
initType            = 3;
% --------------------------------------------------

% Choose initialization type
switch(initType)
    case(1)
        % Simple Initialization
        x = y;
    case(2)
        % Initialization Using Wiener Filter
        x = RunWienerFilter(y, HTy, fftHtH, sAlgParam);
    case(3)
        % Initialization Using IRCNN
        fprintf('\nInitializing using IRCNN:\n');
        vl_compilenn();
        sAlgParam = RunIRCNN(y, noiseStd, H, algorithmPurpose, sAlgParam, mOrgImg);
        fprintf('Initialization Completed.\n');
        x = sAlgParam.sResults.mRestoredImage;
    otherwise
        % Simple Initialization
        x = y;
end

if nargin > 4, fprintf('PSNR after initialization: %f [db].\n', CalcPsnr(x, mOrgImg)); end

end


function [ x ] = RunWienerFilter( y, HTy, fftHtH, sAlgParam )
% Deblur image using the Wiener filter:
%
%       conj(H)*Y
% X = -------------
%     |H|^2 + Su/Sx
%
% If Image Processing Toolbox is available then x = deconvwnr(y, H, Su)
% -----------------------------------------------------------------------

% Extract Data From struct
noiseStd            = sAlgParam.noiseStd;
imgHeight           = sAlgParam.imgHeight;
imgWidth            = sAlgParam.imgWidth;
imgDim              = sAlgParam.imgDim;
% -----------------------------------------

x = NaN(imgHeight, imgWidth, imgDim);
%for ii = 1:imgDim
    yy=double2q(y);
    Su  = noiseStd^2 / var(reshape(yy,[],1));
    Sx  = 1;
    HTY=double2q(HTy);
    fftHTH=double2q(fftHtH);
    X   = fft2(HTY) ./ (fftHTH + Su/Sx);
    xx=q2double(X);
    x=real(xx);
    %x(:,:,ii) = real(ifft2(X)); % The 'real' is for avoiding numerical issues
    
%end

end
