# openvpn-status-web

![ci](https://github.com/cmur2/openvpn-status-web/workflows/ci/badge.svg)

## Description

Small (another word for naive in this case, it's simple and serves my needs) [Rack](http://rack.github.com/) application providing the information an [OpenVPN](http://openvpn.net/index.php/open-source.html) server collects in it's status file especially including a list of currently connected clients (common name, remote address, traffic, ...).

It lacks:

* caching (parses file on each request, page does auto-refresh every minute as OpenVPN updates the status file these often by default)
* management interface support
* *possibly more...*

## Usage

Install the gem:

	gem install openvpn-status-web

Create a configuration file in YAML format somewhere:

```yaml
# listen address and port
host: "0.0.0.0"
port: "8080"
# optional: drop priviliges in case you want to but you should give this user at least read access on the log files
user: "nobody"
group: "nogroup"
# logfile is optional, logs to STDOUT else
logfile: "openvpn-status-web.log"
# hash with each VPNs display name for humans as key and further config as value
vpns:
  My Small VPN:
    # the status file path and status file format version are required
    version: 1
    status_file: "/var/log/openvpn-status.log"
  My Other VPN:
    version: 3
    status_file: "/var/log/other-openvpn-status.log"
```

Your OpenVPN configuration should contain something like this:

```
# ...snip...
status /var/log/openvpn-status.log
status-version 1
# ...snip...
```

For more information about OpenVPN status file and version, see their [man page](https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage). openvpn-status-web is able to parse all versions from 1 to 3.

## Advanced topics

### Authentication

If the information exposed is important to you serve it via the VPN or use a webserver as a proxy to handle SSL and/or HTTP authentication.

### Startup

There is a [Dockerfile](docs/Dockerfile) that can be used to build a Docker image for running openvpn-status-web.

This can for example be used with `docker-compose` via:

```yaml
version: "2.4"
services:
  openvpn-status-web:
    image: your-selfbuilt-docker-image
    user: root  # needed since the default status files are chmod 600
    volumes:
    - /path/to/host/config.yml:/etc/openvpn-status-web/config.yml:ro
    - /run/openvpn-server:/run/openvpn-server
    ports:
    - "8080:8080"
```

The `/path/to/host/config.yml` could be:

```yaml
host: "0.0.0.0"
port: "8080"
vpns:
  my-cool-vpn:  # the following depends on your setup
    version: 2
    status_file: "/run/openvpn-server/status-my-cool-vpn.log"
```

## License

openvpn-status-web is licensed under the Apache License, Version 2.0. See LICENSE for more information.
