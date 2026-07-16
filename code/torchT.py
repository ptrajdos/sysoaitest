import torch

def main():
    print("PyTorch version:", torch.__version__)

    # Check CUDA
    cuda_available = torch.cuda.is_available()
    print("CUDA available:", cuda_available)

    if cuda_available:
        print("CUDA version:", torch.version.cuda)
        print("GPU:", torch.cuda.get_device_name(0))

    # Create tensors
    x = torch.randn(3, 3)
    y = torch.randn(3, 3)

    print("\nCPU tensor test:")
    print("x + y =")
    print(x + y)

    # Move to GPU if possible
    device = torch.device("cuda" if cuda_available else "cpu")
    print("\nUsing device:", device)

    x = x.to(device)
    y = y.to(device)

    z = x @ y  # matrix multiplication

    print("Matrix multiplication result:")
    print(z)

    # Tiny neural network test
    print("\nNeural network test:")

    model = torch.nn.Sequential(
        torch.nn.Linear(3, 8),
        torch.nn.ReLU(),
        torch.nn.Linear(8, 1)
    ).to(device)

    inp = torch.randn(4, 3, device=device)
    out = model(inp)

    loss = out.mean()
    loss.backward()

    print("Output shape:", out.shape)
    print("Backward pass: OK")

    print("\nPyTorch installation appears to be working!")

if __name__ == "__main__":
    main()
