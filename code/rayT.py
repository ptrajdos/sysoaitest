import ray
from ray.util.joblib import register_ray
from joblib import Parallel, delayed

ray.init()  # starts local Ray instance

register_ray()

def f(x):
    return x * x

results = Parallel(n_jobs=-1, backend="ray")(
    delayed(f)(i) for i in range(100)
)

print(results)
