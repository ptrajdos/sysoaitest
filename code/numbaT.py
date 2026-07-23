# verify_numba.py

import sys
import numpy as np

print("=" * 50)

try:
    import numba
    from numba import njit

    print(f"✅ Numba version: {numba.__version__}")
except Exception as e:
    print("❌ Failed to import Numba")
    print(e)
    sys.exit(1)

@njit
def fib(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

try:
    result = fib(30)
    print(f"✅ JIT compiled successfully.")
    print(f"fib(30) = {result}")
except Exception as e:
    print("❌ JIT compilation failed")
    print(e)
    sys.exit(1)

try:
    arr = np.arange(1_000_000, dtype=np.float64)

    @njit
    def sum_array(a):
        s = 0.0
        for x in a:
            s += x
        return s

    numba_result = sum_array(arr)
    numpy_result = arr.sum()

    assert np.isclose(numba_result, numpy_result)

    print("✅ Numerical correctness verified.")
except Exception as e:
    print("❌ Numerical verification failed")
    print(e)
    sys.exit(1)

print(f"Numba threads: {numba.get_num_threads()}")

print("=" * 50)
print("🎉 All Numba tests passed.")
