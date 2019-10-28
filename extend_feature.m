function A = extract_feature( out )

[m, n] = size(out);
A_temp = zeros(m+4,n+4);

A_temp(3:m+2, 3:n+2) = double(out);

A = A_temp;
% A=out;
end

