function A = extend_feature_main2( out )
[m, n] = size(out);
A_temp = zeros(m+2,n+2);

A_temp(2:m+1, 2:n+1) = double(out);

A = A_temp;
end

