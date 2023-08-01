from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt

if __name__ == '__main__':
    print("Matplotlib")

    xs = [x for x in range(10)]
    ys = [x*x for x in xs]

    with PdfPages("./matplotlib.pdf") as pdf:
        plt.plot(xs,ys)
        pdf.savefig()
        plt.close()