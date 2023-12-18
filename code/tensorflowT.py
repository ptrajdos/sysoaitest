import ssl
ssl._create_default_https_context = ssl._create_unverified_context # na problemy z ssl
from keras import layers
from keras.engine.sequential import Sequential
from tensorflow.keras.datasets.fashion_mnist import load_data
from tensorflow.keras.utils import to_categorical
(X_train, y_train), (X_test, y_test) = load_data()


X_train = X_train.reshape((X_train.shape[0], X_train.shape[1], X_train.shape[2], 1))
X_test = X_test.reshape((X_test.shape[0], X_train.shape[1], X_train.shape[2], 1))

y_train = to_categorical(y_train)
y_test = to_categorical(y_test)

X_train = X_train.astype('float32') / 255.0
X_test = X_test.astype('float32') / 255.0

img_height = 28
img_width = 28
num_classes = 10

model = Sequential([
  layers.Conv2D(16, 3, padding='same', activation='relu', 
                input_shape=(img_height, img_width, 1)),
  layers.MaxPooling2D(2),
  layers.Flatten(),
  layers.Dense(128, activation='relu'),
  layers.Dense(num_classes, activation="softmax")
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

history = model.fit(X_train, y_train, epochs=3, 
                    validation_data=(X_test, y_test), batch_size=32)