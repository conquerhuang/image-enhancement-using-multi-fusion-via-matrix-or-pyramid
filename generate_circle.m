function [ mode ] = generate_circle( r )
    if r/2==floor(r/2)
        error('r must be even');
    end
    [U,V]=dftuv(r,r);
    mode=ones(r,r);
    DS=U.^2+V.^2;
    DS=fftshift(DS);
    mode(DS>((r-1)/2).^2)=0;
end

