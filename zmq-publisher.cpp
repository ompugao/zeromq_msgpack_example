/**
* Example of ZeroMQ pub/sub usage for C++11.
*/

#include <zmqpp/zmqpp.hpp>
#include <iostream>
#include <chrono>
#include <thread>

#include "data.h"

using namespace std;

//static const string PUBLISH_ENDPOINT = "tcp://*:4242";
static const string PUBLISH_ENDPOINT = "ipc://@denso/hoge";

int main(int argc, char *argv[]) {

  // Create a publisher socket
  zmqpp::context context;
  zmqpp::socket_type type = zmqpp::socket_type::publish;
  zmqpp::socket socket (context, type);

  // Open the connection
  cout << "Binding to " << PUBLISH_ENDPOINT << "..." << endl;
  socket.bind(PUBLISH_ENDPOINT);

  // Pause to connect
  this_thread::sleep_for(chrono::milliseconds(1000));

  while(true) {

    // Current time in ms
    unsigned long ms = chrono::system_clock::now().time_since_epoch() /
        chrono::milliseconds(1);

    string text = "Hello at " + to_string(ms);
    Data d;
    d.message = text;
    d.value = {1,2,3,4,5,6};

    // Create a message and feed data into it
    zmqpp::message message;
    //message << d;
    msgpack::sbuffer buffer;
    msgpack::pack(buffer, d);
    message.add_raw(buffer.data(), buffer.size());

    // Send it off to any subscribers
    socket.send(message);
    cout << "[SENT] at " << ms << ": " << text << endl;

    this_thread::sleep_for(chrono::microseconds(8000));
  }

  // Unreachable, but for good measure
  socket.disconnect(PUBLISH_ENDPOINT);
  return 0;
}
