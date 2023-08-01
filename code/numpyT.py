import numpy as np

if __name__ =='__main__':
    print("Testing numpy")
    X = np.random.random((10,10))
    X = X + X
    xm = np.mean(X, axis=1)
    print(xm)