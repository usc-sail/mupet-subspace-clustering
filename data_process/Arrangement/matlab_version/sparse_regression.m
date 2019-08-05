function Y = sparse_regression(X,lambda)
%data per column
%solve with lasso
%why use lasso? because lasso is (maybe 100 times)faster than general
%convex optimization methods
%typically, time cost of lasso ranges from 1h~20h
%time cost depends on the size of dataset(N) and lambda
%usually, bigger lambda uses fewer time with less non_zero coefficients
%time cost is at least O(N^2) (I am not quite sure about that now)

N = size(X,2);
Y = zeros(N,N);
tic
for i=1:N
    disp(i)
    y = X(:,i);
    dict = [X(:,1:i-1),X(:,i+1:end)];
    [alpha,FitInfo] = lasso(dict,y,'Lambda',lambda);
    Y(1:i-1,i) = alpha(1:i-1);
    Y(i+1:end,i) = alpha(i:end);
    toc
end
end