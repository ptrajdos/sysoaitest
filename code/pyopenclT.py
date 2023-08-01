import pyopencl as cl

if __name__ == '__main__':

	print("PyOpenCL version: ", cl.VERSION_TEXT)
	print("OpenCL header version: ",cl.get_cl_header_version() )

	platforms = cl.get_platforms()
	for platform in platforms:
		print("Platform: ", platform.name)
		devices = platform.get_devices(device_type = cl.device_type.ALL)
		for device in devices:
			print("\tDevice name: {}; vendor: {}; version{}".format(device.name, device.vendor,device.version))