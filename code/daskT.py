from dask.distributed import Client
from joblib import Parallel, delayed, parallel_backend


def square(x):
    return x * x


if __name__ == "__main__":
    client = Client()

    with parallel_backend("dask"):
        result = Parallel(n_jobs=-1)(
            delayed(square)(i) for i in range(100)
        )

    print(result)
