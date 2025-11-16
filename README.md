# Graylog Log Management and SIEM Tool

This repository contains Docker deployment files for Graylog, a powerful open-source log management and SIEM (Security Information and Event Management) tool.

## Overview

Graylog is a centralized log management solution that allows you to collect, index, and analyze log data from various sources. It provides:

- **Log Collection**: Collect logs from multiple sources using various input methods (Syslog, GELF, Beats, etc.)
- **Search and Analysis**: Powerful search capabilities powered by Elasticsearch
- **Alerting**: Set up alerts based on log patterns and thresholds
- **Dashboards**: Create custom dashboards for visualization
- **SIEM Capabilities**: Security event monitoring and correlation

## Architecture

This deployment consists of three main components:

1. **MongoDB**: Stores Graylog's metadata and configuration
2. **Elasticsearch**: Stores and indexes log messages for fast searching
3. **Graylog Server**: Main application providing web interface and log processing

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose 2.0 or later
- At least 4GB of RAM available for containers
- Ports 9000, 1514, and 12201 available on the host

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Victortimbwa/Graylog.git
cd Graylog
```

### 2. Configure Environment Variables

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Edit `.env` file and change the following:

- `MONGO_ROOT_PASSWORD`: MongoDB root password
- `GRAYLOG_PASSWORD_SECRET`: A random string (at least 16 characters)
- `GRAYLOG_ROOT_PASSWORD_SHA2`: SHA2 hash of your desired admin password
- `GRAYLOG_HTTP_EXTERNAL_URI`: Your server's external URL

**Generate a password secret:**
```bash
pwgen -N 1 -s 96
```

**Generate a password hash (for "yourpassword"):**
```bash
echo -n "yourpassword" | sha256sum
```

### 3. Start Graylog

```bash
docker-compose up -d
```

This will start all three containers in the background.

### 4. Access Graylog

Once all containers are running (this may take 1-2 minutes), access Graylog at:

```
http://localhost:9000
```

**Default credentials:**
- Username: `admin`
- Password: `admin` (or the password you hashed in step 2)

**⚠️ IMPORTANT:** Change the default password immediately after first login!

## Container Management

### View Logs

```bash
# All containers
docker-compose logs -f

# Specific container
docker-compose logs -f graylog
docker-compose logs -f elasticsearch
docker-compose logs -f mongodb
```

### Stop Graylog

```bash
docker-compose down
```

### Stop and Remove Data

**⚠️ WARNING:** This will delete all logs and configurations!

```bash
docker-compose down -v
```

### Restart Services

```bash
docker-compose restart
```

## Using the Dockerfile

If you want to build a custom Graylog image:

```bash
docker build -t my-graylog:latest .
```

## Port Reference

| Port  | Protocol | Purpose                          |
|-------|----------|----------------------------------|
| 9000  | TCP      | Graylog web interface & REST API |
| 1514  | TCP/UDP  | Syslog input                     |
| 12201 | TCP/UDP  | GELF (Graylog Extended Log Format) input |

## Sending Logs to Graylog

### Using GELF (Recommended)

**Docker containers:**
```bash
docker run --log-driver=gelf --log-opt gelf-address=udp://localhost:12201 your-image
```

**Application example (Python):**
```python
import logging
from pygelf import GelfUdpHandler

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.addHandler(GelfUdpHandler(host='localhost', port=12201))

logger.info('Hello Graylog!')
```

### Using Syslog

```bash
logger -n localhost -P 1514 "Test message to Graylog"
```

## Data Persistence

All data is stored in Docker volumes:

- `mongodb_data`: MongoDB data
- `elasticsearch_data`: Elasticsearch indices
- `graylog_data`: Graylog data and configuration

These volumes persist even when containers are stopped or removed.

## Troubleshooting

### Elasticsearch won't start

If Elasticsearch fails with memory errors, increase the Docker memory limit or adjust the ES heap size in `docker-compose.yml`:

```yaml
environment:
  - "ES_JAVA_OPTS=-Xms512m -Xmx512m"  # Adjust these values
```

### Graylog can't connect to Elasticsearch

Wait 1-2 minutes for Elasticsearch to fully start before Graylog attempts connection. The containers should eventually connect automatically.

### Permission errors

Ensure the Docker daemon has proper permissions to create and manage volumes.

### Web interface not accessible

1. Check if all containers are running: `docker-compose ps`
2. Check Graylog logs: `docker-compose logs graylog`
3. Verify port 9000 is not being used by another application

## Production Deployment

For production deployments, consider:

1. **Use strong passwords**: Generate secure passwords for all services
2. **Enable TLS**: Configure HTTPS for the web interface
3. **Backup strategy**: Regularly backup MongoDB and Elasticsearch data
4. **Resource limits**: Set appropriate CPU and memory limits in docker-compose.yml
5. **External databases**: Use managed MongoDB and Elasticsearch services
6. **Monitoring**: Set up monitoring for container health and resource usage
7. **Network security**: Use firewalls and limit exposed ports
8. **Update regularly**: Keep Graylog and dependencies updated

## Resources

- [Graylog Documentation](https://docs.graylog.org/)
- [Graylog Docker Image](https://hub.docker.com/r/graylog/graylog/)
- [Graylog Community](https://community.graylog.org/)

## License

This deployment configuration is provided as-is for deploying Graylog. Graylog itself is licensed under the Server Side Public License (SSPL).

## Support

For issues related to:
- **This deployment**: Open an issue in this repository
- **Graylog itself**: Visit the [Graylog Community](https://community.graylog.org/)