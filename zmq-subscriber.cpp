/**
* Example of ZeroMQ pub/sub usage for C++11.
*/

#include <zmqpp/zmqpp.hpp>
#include <iostream>
#include <chrono>
#include <vector>

#include "data.h"

using namespace std;

//static const string PUBLISHER_ENDPOINT = "tcp://localhost:4242";
static const string PUBLISHER_ENDPOINT = "ipc://@denso/hoge";

int main(int argc, char *argv[]) {

  // Create a subscriber socket
  zmqpp::context context;
  zmqpp::socket_type type = zmqpp::socket_type::subscribe;
  zmqpp::socket socket(context, type);

  // Subscribe to the default channel
  socket.subscribe("");

  // Connect to the publisher
  cout << "Connecting to " << PUBLISHER_ENDPOINT << "..." << endl;
  socket.connect(PUBLISHER_ENDPOINT);

  Data d;

  while(true) {

    // Receive (blocking call)
    zmqpp::message message;
    socket.receive(message);

    // Read as a string
    // string text;
    // message >> text;

    msgpack::unpacked unpackedData;
    msgpack::unpack(unpackedData,
            static_cast<const char*>(message.raw_data(0)),
            message.size(0));
    unpackedData.get().convert(d);

    unsigned long ms = std::chrono::system_clock::now().time_since_epoch() /
            std::chrono::milliseconds(1);

    cout << "[RECV] at " << ms << ": \"" << d.message << "\"" << endl;
    for (auto&& e : d.value) {
        cout << e << ",";
    }
    cout << endl;
  }

  // Unreachable, but for good measure
  socket.disconnect(PUBLISHER_ENDPOINT);
  return 0;
}
