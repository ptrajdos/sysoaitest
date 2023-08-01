import threading
import os
import time

def threadInfo(threadName):
    print("%s; PID: %s; Thread name: %s" %(threadName, os.getpid(), threading.current_thread().name ))
    time.sleep(5)

if __name__ == '__main__':
    print("Main thread PID: {mPID}, thread name {mTh}".format(mPID=os.getpid(),mTh=threading.current_thread().name ))
    tList=[]
    for i in range(3):
        t = threading.Thread(target=threadInfo, args=("Thread: {tName}".format(tName=i),) )
        t.start()
        tList.append(t)
    print("Active threads number: {}".format(threading.active_count()))
    #Optional
    for t in tList:
        t.join()