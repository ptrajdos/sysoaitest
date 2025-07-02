from pyspark.sql import SparkSession
import findspark

def init_session():
	findspark.init()
	session = SparkSession.builder.appName("Simple App").getOrCreate()
	context = session.sparkContext
	context.setLogLevel("ERROR")
	return session

if __name__ == '__main__':
	session = init_session()
	print("Session:",session)
	data_frame = session.range(2000).toDF("column1")
	print("Data Frame:\n",data_frame)
	data_frame.show(n=3)
