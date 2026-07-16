import pyopencl as cl
import numpy as np

def main():
    print("PyOpenCL version:", cl.VERSION_TEXT)

    # List platforms and devices
    platforms = cl.get_platforms()

    if not platforms:
        raise RuntimeError("No OpenCL platforms found.")

    print("\nPlatforms:")
    for p in platforms:
        print(f"  {p.name}")
        for d in p.get_devices():
            print(f"    - {d.name} ({cl.device_type.to_string(d.type)})")

    # Create a context (first available device)
    ctx = cl.create_some_context(interactive=False)
    queue = cl.CommandQueue(ctx)

    # OpenCL kernel
    program = cl.Program(ctx, """
    __kernel void square(__global const float *x,
                         __global float *y)
    {
        int i = get_global_id(0);
        y[i] = x[i] * x[i];
    }
    """).build()

    # Input data
    x = np.array([1, 2, 3, 4], dtype=np.float32)
    y = np.empty_like(x)

    mf = cl.mem_flags

    x_buf = cl.Buffer(ctx, mf.READ_ONLY | mf.COPY_HOST_PTR, hostbuf=x)
    y_buf = cl.Buffer(ctx, mf.WRITE_ONLY, y.nbytes)

    # Launch kernel
    program.square(queue, x.shape, None, x_buf, y_buf)

    # Copy result back
    cl.enqueue_copy(queue, y, y_buf)
    queue.finish()

    print("\nResult:")
    for a, b in zip(x, y):
        print(f"{a:.0f} -> {b:.0f}")

    print("\nPyOpenCL installation appears to be working!")

if __name__ == "__main__":
    main()
