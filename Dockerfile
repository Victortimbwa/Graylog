# Graylog Docker Image
# This Dockerfile can be used to build a custom Graylog image
# For production deployment, use the docker-compose.yml file instead

FROM graylog/graylog:5.2

LABEL maintainer="Graylog Deployment"
LABEL description="Graylog log management and SIEM tool"

# Environment variables (override these with -e flags or docker-compose)
ENV GRAYLOG_HTTP_BIND_ADDRESS=0.0.0.0:9000
ENV GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/

# Expose ports
# 9000: Graylog web interface and REST API
# 1514: Syslog TCP/UDP
# 12201: GELF TCP/UDP
EXPOSE 9000 1514 1514/udp 12201 12201/udp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:9000/api/ || exit 1

# Use the default entrypoint from the base image
