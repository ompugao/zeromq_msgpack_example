project(zmqtest)
cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_STANDARD 11)

list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
find_package(ZeroMQ REQUIRED)
find_package(MsgPack REQUIRED)

include_directories(${ZeroMQ_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
add_executable(sub zmq-subscriber.cpp)
add_executable(pub zmq-publisher.cpp)
target_link_libraries(sub PUBLIC ${ZeroMQ_LIBRARY} zmqpp)
target_link_libraries(pub PUBLIC ${ZeroMQ_LIBRARY} zmqpp)
