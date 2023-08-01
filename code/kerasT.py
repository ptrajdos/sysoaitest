from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Flatten
import pandas as pd
import matplotlib.pyplot as plt

if __name__ == '__main__':
    print("KERAS")
    (X_train_full, y_train_full), (X_test, y_test) = mnist.load_data()
    print("Train Shape: ", X_train_full.shape, "Dtype: ", X_train_full.dtype)

    X_valid, X_train = X_train_full[:5000] / 255.0, X_train_full[5000:] / 255.0
    y_valid, y_train = y_train_full[:5000], y_train_full[5000:]

    model = Sequential()
    model.add(Flatten(input_shape=[28,28]))
    model.add(Dense(100, activation="relu"))
    model.add(Dense(50, activation="relu"))
    model.add(Dense(10, activation="softmax"))

    model.compile(loss="sparse_categorical_crossentropy", optimizer="rmsprop", metrics=["accuracy"])

    history = model.fit(X_train, y_train, validation_data=(X_valid,y_valid),epochs=10)

    pd.DataFrame(history.history).plot()
    plt.grid(True)
    plt.gca().set_ylim(0,1)
    plt.savefig('KerasExample2.svg')