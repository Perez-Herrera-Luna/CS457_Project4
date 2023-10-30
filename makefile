all: driver
driver: driver.cpp
	g++ -std=c++17 driver.cpp -lstdc++fs -o driver