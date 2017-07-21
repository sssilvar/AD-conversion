function imgOut = thFilter(img, thA, thI)
    
    d = size(img);
    index = max(size(d));
    imgOut = zeros(d);
    
    for i = 1:d(1)
        for j = 1:d(2)
            for k = 1: d(3)
                if(img(i,j,k) <= thI)
                    img(i,j,k) = 0;
                end
            end
        end
    end
    
    for i = 1:d(index)
        buff = conv2(img(:,:,i),ones(thA)) > thA;
        imgOut(:,:,i) = buff(1:d(1), 1:d(2));
    end
end