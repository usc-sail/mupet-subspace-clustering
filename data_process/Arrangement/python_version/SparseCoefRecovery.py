# This function takes the D x N matrix of N data points and write every
# point as a sparse linear combination of other points.
# Xp: D x N matrix of N data points
# cst: 1 if using the affine constraint sum(c)=1, else 0
# Opt: type of optimization, {'L1Perfect','L1Noisy','Lasso','L1ED'}
# lambda: regularizartion parameter of LASSO, typically between 0.001 and
# 0.1 or the noise level for 'L1Noise'
# CMat: N x N matrix of coefficients, column i correspond to the sparse
# coefficients of data point in column i of Xp

# For this to work install cvxpy from:
# https://cvxgrp.github.io/cvxpy/install/index.html

import numpy as np
import cvxpy as cvx
import time
#from sklearn.linear_model import OrthogonalMatchingPursuit #bad performance
from sklearn import linear_model
def SparseCoefRecovery(Xp, cst=1, Opt='Lasso', lmbda=0.001):
    begin = time.time()
    D, N = Xp.shape
    CMat = np.zeros([N, N])
    print('cst',cst)
    for i in range(0, N):

        if i%1==0:
            print(i,time.time()-begin)
        y = Xp[:, i]
        if i == 0:
            Y = Xp[:, i + 1:]
        elif i > 0 and i < N - 1:
            Y = np.concatenate((Xp[:, 0:i], Xp[:, i + 1:N]), axis=1)
          
        else:
            Y = Xp[:, 0:N - 1]
        '''if cst == 2:
            omp = OrthogonalMatchingPursuit(n_nonzero_coefs=K)
            omp.fit(Y, y)
            c = omp.coef_'''
        if cst == 1:       
            if Opt == 'Lasso':
                c = cvx.Variable(N - 1,'1', 1)
                obj = cvx.Minimize(lmbda*cvx.norm(c, 1) + cvx.norm(Y * c - y)/2)
                constraint = [cvx.sum(c) == 1]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            elif Opt == 'L1Perfect':
                c = cvx.Variable(N - 1,'1', 1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [Y * c == y, cvx.sum(c) == 1]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            elif Opt == 'L1Noise':
                c = cvx.Variable(N - 1,'1', 1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [(Y * c - y) <= lmbda, cvx.sum(c) == 1]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            elif Opt == 'L1ED':
                c = cvx.Variable(N - 1 + D, '1',1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [np.concatenate((Y, np.identity(D)), axis=1)
                              * c == y, cvx.sum(c[0:N - 1]) == 1]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            
        if cst == 0:
            if Opt == 'Lasso':
                clf = linear_model.Lasso(alpha=lmbda)  #this is the fastest way to solve sparse regression(I think)
                clf.fit(Y,y)
                c = clf.coef_
                #c = cvx.Variable(N - 1,'1', 1)
                #obj = cvx.Minimize(lmbda *cvx.norm(c, 1) + cvx.norm(Y * c - y)/2) 
                #prob = cvx.Problem(obj)
                #prob.solve()
                #c = c.value
            elif Opt == 'L1Perfect':
                c = cvx.Variable(N - 1, '1',1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [Y * c == y]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            elif Opt == 'L1Noise':
                c = cvx.Variable(N - 1,'1', 1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [(Y * c - y) <= lmbda]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value
            elif Opt == 'L1ED':
                c = cvx.Variable(N - 1 + D,'1', 1)
                obj = cvx.Minimize(cvx.norm(c, 1))
                constraint = [np.concatenate((Y, np.identity(D)), axis=1) * c == y]
                prob = cvx.Problem(obj, constraint)
                prob.solve()
                c = c.value

        if i == 0:
            CMat[0, 0] = 0
            #CMat[1:N, 0] = c.value[0: N - 1]
            CMat[1:N, 0] = c[0: N - 1]
        elif i > 0 and i < N - 1:
            CMat[0:i, i] = c[0:i]
            CMat[i, i] = 0
            CMat[i + 1:N, i] = c[i:N - 1]
        else:
            CMat[0:N - 1, N - 1] = c[0:N - 1]
            CMat[N - 1, N - 1] = 0

    return CMat



if __name__ == "__main__":
    pass
