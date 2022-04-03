function  [par]=QWNNM_ParSet(nSig)

par.nSig      =   nSig;                                 % Variance of the noise image
par.SearchWin =   30;                                   % Non-local patch searching window
par.delta     =   0.1;    %0.1                              % Parameter between each iter
par.c         =   1.3*sqrt(2);%%sqrt(2)                            % Constant num for the weight vector
par.Innerloop =   2;                                    % InnerLoop Num of between re-blockmatching
par.ReWeiIter =   1;%%3
if nSig<=20
    par.patsize       =   6;                            % Patch size
    par.patnum        =   80;     %70                      % Initial Non-local Patch number
    par.Iter          =   9;          %8                  % total iter numbers
    par.lamada        =   0.54;                         % Noise estimete parameter
elseif nSig <= 40
    par.patsize       =   7;
    par.patnum        =   90;
    par.Iter          =   12;
    par.lamada        =   0.56; 
elseif nSig<=60
    par.patsize       =   8;
    par.patnum        =   120;
    par.Iter          =   14;
    par.lamada        =   0.58; 
else
    par.patsize       =   9;
    par.patnum        =   140;
    par.Iter          =   14;
    par.lamada        =   0.58; 
end

par.step      =   floor((par.patsize)/2-1);                   
