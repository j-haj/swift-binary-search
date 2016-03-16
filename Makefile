CXX := clang++
CFLAGS := -std=c++14 -Wall -pedantic

TARGET := binarysearch

all: binarysearch.cpp
	$(CXX) $(CFLAGS) $< -o $(TARGET)
	@./$(TARGET)
