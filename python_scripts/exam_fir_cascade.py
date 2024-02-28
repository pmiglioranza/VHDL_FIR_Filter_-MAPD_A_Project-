import serial
import numpy as np
import matplotlib.pyplot as plt
import time

np.random.seed(1234)
ser = serial.Serial('/dev/ttyUSB1', baudrate=115200)

# signal

# main signal frequency
sampling_rate = 192000
frequency = sampling_rate/100
t = np.arange(0, 3*(1/frequency), (1/sampling_rate))
# taps
n = 4 
# main signal component
amplitude = 10
x0 = amplitude*np.sin(2*np.pi*frequency*t)
# components to be filtered
f_cutoff = (1/n)*sampling_rate
x1 = 0.3*amplitude*np.sin(2*np.pi*f_cutoff*t)
x2 = 0.2*amplitude*np.sin(2*np.pi*((1/n)+0.1)*sampling_rate*t)
x3 = 0.1*amplitude*np.sin(2*np.pi*((1/n)+0.2)*sampling_rate*t)
# gaussian noise
noise = np.random.normal(0, 1, len(t))
# complete signal
x = x0 + x1 + x2 + x3 + noise
x_input=x.copy()
# pre-processing
N=4
taps = 4
s = 1/np.max(abs(x))
c = (127)
x = x*(s*c)
x = np.array([int(i) for i in x])
y=np.zeros(len(x))


# time measure
times = np.zeros(len(x))

# fpga
for i in range(len(x)):
	tic = time.time_ns()
	ser.write(int(x[i]).to_bytes(1, "little", signed=True))
	d=ser.read()
	toc = time.time_ns()
	times[i] = toc - tic
	y[i]=int.from_bytes(d, "little", signed=True)	

# post-processing	
y = y/(s*c)
y_ticks=np.arange(-20,21,5)


fig0, (ax1, ax0) = plt.subplots(nrows=2, ncols=1, figsize=(12,10))

ax0.plot(t*1000, x0, label="low main frequency component", color='black', marker='', linestyle='--')
#ax0.plot(t[(n-1)*N:-6]*1000, y[(n-1)*N+6:], label="filtered output", color='black', marker='', linestyle='-')
ax0.plot(t[(n-1)*N:]*1000, y[(n-1)*N:], label="filtered output", color='black', marker='', linestyle='-')
ax0.legend()
ax0.set_yticks(y_ticks)
ax0.set_xlabel("Time [ms]")
ax0.set_ylabel("Amplitude")
ax0.set_title("Low-pass filter result evaluation")
ax0.grid()

ax1.plot(t*1000, x_input, label="input", color='black', marker='', linestyle='-')
ax1.legend()
ax1.set_yticks(y_ticks)
ax1.set_xlabel("Time [ms]")
ax1.set_ylabel("Amplitude")
ax1.set_title("Input signal")
ax1.grid()


plt.savefig("exam_cascade_test.pdf")


