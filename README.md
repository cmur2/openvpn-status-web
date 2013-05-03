# openvpn-status-web

Small (another word for naive in this case, it's simple and serves my needs) [Rack](http://rack.github.com/) application providing the information the [OpenVPN](http://openvpn.net/index.php/open-source.html) server collects in it's status file especially including a list of currently connected clients (common name, remote address, traffic, ...).

It lacks:

* caching (parses file on each request, page does auto-refresh every minute as OpenVPN updates the status file these often)
* newer status file versions than v1
* management interface support
* tracking multiple status at the same time
* *possibly more...*

## Usage

Install the gem:

	gem install openvpn-status-web

Create a configuration file in YAML format somewhere:

```yaml
# listen address and port
host: "0.0.0.0"
port: "8080"
# logfile is optional, logs to STDOUT else
logfile: "openvpn-status-web.log"
# display name for humans and the status file path
name: "My Small VPN"
status_file: "/var/log/openvpn-status.log"
```

## Advanced topics

## Authentication

### Init scripts

The [Debian 6 init.d script](init.d/debian-6-openvpn-status-web) assumes that openvpn-status-web is installed into the system ruby (no RVM support) and the config.yaml is at /opt/openvpn-status-web/config.yaml. Modify to your needs.

## License

openvpn-statsu-web is licensed under the Apache License, Version 2.0. See LICENSE for more information.
