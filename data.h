#pragma once
#include <msgpack.hpp>
#include <array>
//#include <boost/array.hpp>

class Data {
public:
    Data() {
    }
    virtual ~Data() {
    }
    std::array<double, 6> value;
    std::string message;
public:
    MSGPACK_DEFINE(value, message);
};
