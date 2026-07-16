import tensorflow as tf

def main():
    print("TensorFlow version:", tf.__version__)

    # Check devices
    gpus = tf.config.list_physical_devices("GPU")
    print("GPUs available:", len(gpus))

    if gpus:
        for gpu in gpus:
            print("GPU:", gpu)

    # Basic tensor test
    print("\nTensor test:")

    x = tf.random.normal((3, 3))
    y = tf.random.normal((3, 3))

    z = tf.matmul(x, y)

    print("Matrix multiplication result:")
    print(z)

    # Choose device
    device = "/GPU:0" if gpus else "/CPU:0"
    print("\nUsing device:", device)

    # Neural network test
    print("\nNeural network test:")

    with tf.device(device):
        model = tf.keras.Sequential([
            tf.keras.layers.Dense(8, activation="relu", input_shape=(3,)),
            tf.keras.layers.Dense(1)
        ])

        optimizer = tf.keras.optimizers.Adam()

        inputs = tf.random.normal((4, 3))
        targets = tf.random.normal((4, 1))

        with tf.GradientTape() as tape:
            predictions = model(inputs)
            loss = tf.reduce_mean((predictions - targets) ** 2)

        gradients = tape.gradient(loss, model.trainable_variables)
        optimizer.apply_gradients(zip(gradients, model.trainable_variables))

    print("Output shape:", predictions.shape)
    print("Loss:", float(loss))
    print("Gradient update: OK")

    print("\nTensorFlow installation appears to be working!")

if __name__ == "__main__":
    main()
