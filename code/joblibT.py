from math import sqrt
from joblib import Parallel, delayed

if __name__ == '__main__':
    parallel = Parallel(n_jobs=-1)(delayed(sqrt)(i ** 2) for i in range(10))

    for p in parallel:
        print(p)
    