function res_matrix = q2cplx(varargin)
if nargin == 1
    M = varargin{1};
    type = 'forward';
elseif nargin == 2
    M = varargin{1};
    type = varargin{2};
end

if strcmp(type, 'forward') == 1
    [h,w] = size(M);
    cM = adjoint(M);
    res_matrix = [cM(1:2*h,1:w);cM(1:2*h,w+1:end)];
elseif strcmp(type, 'inverse') == 1
    [h, w] = size(M);
    cM = [M(1:h/2,1:w),M(1+h/2:end,1:w)];
    res_matrix = unadjoint(cM);
end
end