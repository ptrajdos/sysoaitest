import jax
import jax.numpy as jnp

def main():
    print("JAX version:", jax.__version__)

    # Check devices
    print("\nAvailable devices:")
    for device in jax.devices():
        print(device)

    device = jax.devices()[0]
    print("\nUsing device:", device)

    # Basic tensor operations
    print("\nTensor test:")

    x = jax.random.normal(jax.random.PRNGKey(0), (3, 3))
    y = jax.random.normal(jax.random.PRNGKey(1), (3, 3))

    z = x @ y

    print("Matrix multiplication result:")
    print(z)

    # JIT compilation test
    print("\nJIT test:")

    @jax.jit
    def matmul(a, b):
        return a @ b

    z_jit = matmul(x, y)

    print("JIT result:")
    print(z_jit)

    # Automatic differentiation test
    print("\nAutodiff test:")

    def loss_fn(w):
        return jnp.sum(w ** 2)

    w = jnp.array([1.0, 2.0, 3.0])

    grad = jax.grad(loss_fn)(w)

    print("Gradient:")
    print(grad)

    # Tiny neural network forward/backward test
    print("\nNeural network-style test:")

    key = jax.random.PRNGKey(42)

    W = jax.random.normal(key, (3, 4))
    b = jnp.zeros((4,))

    def model(x):
        return jnp.maximum(0, x @ W + b)  # ReLU

    inputs = jax.random.normal(key, (5, 3))

    outputs = model(inputs)

    def model_loss(W):
        preds = jnp.maximum(0, inputs @ W + b)
        return jnp.mean(preds ** 2)

    gradients = jax.grad(model_loss)(W)

    print("Output shape:", outputs.shape)
    print("Gradient shape:", gradients.shape)

    print("\nJAX installation appears to be working!")

if __name__ == "__main__":
    main()
