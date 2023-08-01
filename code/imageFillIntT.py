import numpy as np
import pyopencl as cl
import matplotlib.pyplot as plt

def create_environment():
    context =  cl.create_some_context(interactive=False)#no prompt for platform choice
    queue = cl.CommandQueue(context)
    prog = cl.Program(context, open('./imageFillIntKernel.cl').read()).build()
    return (context,queue,prog)

if __name__ == '__main__':

    print("Running image filler")
    context, queue, prog = create_environment()

    img_width, img_height = (4,4)
    im_src = np.full(shape=(img_width, img_height), fill_value=np.iinfo(np.uint16).max, dtype=np.uint16)
    im_dst = np.empty_like(im_src, dtype=np.uint16)

    src_buff = cl.image_from_array(context, im_src, mode='r')
    dst_buff = cl.image_from_array(context, im_dst, mode='w')

    # Note: Global indices is reversed due to OpenCL using column-major order when reading images
    global_size = im_src.shape[::-1]
    local_size = None

    prog.simple_image(queue, global_size, local_size, src_buff, dst_buff)

    # Note: Region indices is reversed due to OpenCL using column-major order when reading images
    cl.enqueue_copy(queue, dest=im_dst, src=dst_buff, is_blocking=True, origin=(0, 0), region=im_src.shape[::-1])

    fig, (ax1, ax2) = plt.subplots(1, 2)
    ax1.imshow(im_src, cmap='gray', vmin=0, vmax=np.iinfo(np.uint16).max)
    ax2.imshow(im_dst, cmap='gray', vmin=0, vmax=np.iinfo(np.uint16).max, interpolation='nearest')
    plt.savefig("./imageFillInt.pdf",bbox_inches='tight')
