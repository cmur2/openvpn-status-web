# openvpn-status-web

Small (another word for naive in this case, it's simple and serves my needs) [rack](http://rack.github.com/) app
providing the information the [OpenVPN](http://openvpn.net/index.php/open-source.html) server collects in it's status file
especially including a list of currently connected clients (common name, remote address, traffic, ...).
It comes with a Debian 6 compatible init.d file.

It lacks:

* authentication
* caching (parses file on each request, page does auto-refresh every minute as OpenVPN updates the status file these often)
* management interface support
* a gem
* *possibly more...*
