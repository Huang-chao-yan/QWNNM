% function  [X] =  QWNNM( Y, C, NSig, m, Iter )
% qY = zeros(size(Y,1),size(Y,2),4);
% qY(:,:,2:4) = Y;
% [U,SigmaY,V] = qsvd(qY);    
% PatNum       = size(Y,2);
% mNSig = sqrt(sum(NSig(:).^2)/length(NSig(:)));
% TempC  = C*sqrt(PatNum)*2*mNSig^2;
% [SigmaX,svp] = ClosedQWNNM(SigmaY,TempC,eps);                        
% X =  qsvd_inv(SigmaX,U,V,svp);
% X = X(:,:,2:4) + m;
% end
% 
% function [U,S,V] = qsvd(qY)
% % computer svd of the equivalent complex matrix of Qq
% Ac = qY(:,:,1)+i*qY(:,:,2);
% Bc = qY(:,:,3)+i*qY(:,:,4);
% Cc = [Ac Bc;-conj(Bc) conj(Ac)];
% [U,S,V] = svd(Cc, 'econ');
% end
% 
% function X = qsvd_inv(SigmaX,cU,cV,svp)
% cX = cU(:,1:svp)*diag(SigmaX)*cV(:,1:svp)';
% X(:,:,1) = real(cX(1:end/2,1:2:end));
% X(:,:,2) = imag(cX(1:end/2,1:2:end));
% X(:,:,3) = real(-conj(cX(end/2+1:end,1:2:end)));
% X(:,:,4) = imag(-conj(cX(end/2+1:end,1:2:end)));
% end


function  [X] =  QWNNM( Y, C, NSig, m, Iter )
    cY = q2cplx(double2q(Y));
    [U,SigmaY,V] =   svd(full(cY),'econ');    
    PatNum       = size(Y,2);
    mNSig = sqrt(sum(NSig(:).^2)/length(NSig(:)));%%%%
    TempC  = C*sqrt(PatNum)*2*mNSig^2;
    [SigmaX,svp] = ClosedQWNNM(SigmaY,TempC,eps);                        
    cX =  U(:,1:svp)*diag(SigmaX)*V(:,1:svp)';     
    X = double2q(q2cplx(cX,'inverse'), 'inverse');
    X = real(X)+m;
return;
