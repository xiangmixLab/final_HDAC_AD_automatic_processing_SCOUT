function Cn=correlation_image_for_alignment(Y)
    tic;
    Y=Y(:,:,1:10:end);
    HY=Y;
    d1=size(Y,1);
    d2=size(Y,2);
    HY = reshape(HY, d1*d2, []);
    HY = bsxfun(@minus, HY, median(HY, 2));
    Ysig = GetSn(HY);
    HY_thr = HY;
    sig=3;
    HY_thr(bsxfun(@lt, HY_thr, Ysig*sig)) = 0;
    Cn = correlation_image(HY_thr, [1,2], d1,d2);
    toc;


