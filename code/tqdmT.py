from tqdm import tqdm


if __name__ == '__main__':

    for i in tqdm(range(10), total=10):
        print(i)