import numpy as np
import time
from sklearn.linear_model import OrthogonalMatchingPursuit #bad performance
from sklearn import linear_model
def SparseCoefRecovery(Xp, Opt='Lasso', lmbda=0.001):
    begin = time.time()
    D, N = Xp.shape
    CMat = np.zeros([N, N])
    print('opt',Opt)
    for i in range(N):
        if i%1==0:
            print(i,time.time()-begin)
        y = Xp[:, i]
        if i == 0:
            Y = Xp[:, i + 1:]
        elif i > 0 and i < N - 1:
            Y = np.concatenate((Xp[:, 0:i], Xp[:, i + 1:N]), axis=1)
          
        else:
            Y = Xp[:, 0:N - 1]
           
        if Opt == 'omp':
            K = 10;
            omp = OrthogonalMatchingPursuit(n_nonzero_coefs=K)
            omp.fit(Y, y)
            c = omp.coef_
            
        if Opt == 'Lasso':
            clf = linear_model.Lasso(alpha=lmbda)  #this is the fastest way to solve sparse regression(I think)
            clf.fit(Y,y)
            c = clf.coef_
            
        if i == 0:
            CMat[0, 0] = 0
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
