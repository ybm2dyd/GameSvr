#include <iostream>
#include <string>
#include <memory>
#include <functional>
#include "boost/asio.hpp"

using namespace std;
using boost::asio::ip::tcp;

class Session : public std::enable_shared_from_this<Session>
{
public:
	Session(boost::asio::io_context& ioc, tcp::endpoint ep) :socket_(ioc)
	{
		socket_.async_connect(ep, [this](const boost::system::error_code& err) {
			if (err) {
				cout << "connect err:" << err.message() << "\n";
				return;
			}
			SendAndRecv();
		});
	}
private:
	void SendAndRecv();
private:
	tcp::socket socket_;
	char buff_[1024];
	char tempbuff_[1024];
};

int main(int argc, const char* argv[])
{
	boost::asio::io_context ioc;
	tcp::endpoint ep(boost::asio::ip::address::from_string("127.0.0.1"), 8001);
	auto p = std::make_shared<Session>(ioc, ep);
	ioc.run();
	while (true) {}
	return 0;
}

inline void Session::SendAndRecv() {
	auto p = shared_from_this();
	static int i = 0;
	if (i > 10) return;
	snprintf(tempbuff_, sizeof(tempbuff_), "hello, this is message %d", i);
	unsigned short size = (unsigned short)strlen(tempbuff_);
	unsigned short nsize = boost::asio::detail::socket_ops::host_to_network_short(size);
	memcpy(buff_, &nsize, sizeof(nsize));
	memcpy(buff_ + sizeof(nsize), tempbuff_, size);

	boost::asio::async_write(socket_, boost::asio::buffer(buff_, size + sizeof(nsize)),
		[p, this](const boost::system::error_code& err, size_t len) {
		if (err) return;
		socket_.async_read_some(boost::asio::buffer(buff_, sizeof(buff_)),
			[p, this](const boost::system::error_code& err, size_t len) {
			if (err) return;
			cout << "recved: " << std::string(buff_, len) << "\n";
			SendAndRecv();
		});
	});
	i++;
}

