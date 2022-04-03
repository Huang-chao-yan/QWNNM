function [res_matrix] = double2q(varargin)
if nargin == 1
    M = varargin{1};
    type = 'forward';
elseif nargin == 2
    M = varargin{1};
    type = varargin{2};
end

if strcmp(type, 'forward') == 1
    classname = class(M);
    if length(size(M)) == 3
        [h, w, channel] = size(M);
        if channel == 3
            res_matrix = quaternion(zeros(h,w,classname),M(:,:,1),M(:,:,2),M(:,:,3));
        end
    elseif length(size(M)) == 2
        [h, w] = size(M);
        res_matrix = quaternion(zeros(h,w,classname),M, M, M);
    end
elseif strcmp(type, 'inverse') == 1
    [h, w] = size(M);
    res_matrix = zeros(h, w, 3);
    res_matrix(:,:,1) = x(M);
    res_matrix(:,:,2) = y(M);
    res_matrix(:,:,3) = z(M);
end
end