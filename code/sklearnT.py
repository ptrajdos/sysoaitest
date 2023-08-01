
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier

if __name__ == '__main__':

    print("Sklearn")

    X, y = load_iris(return_X_y=True)

    clf = RandomForestClassifier()
    clf.fit(X,y)

    clf.predict(X,)