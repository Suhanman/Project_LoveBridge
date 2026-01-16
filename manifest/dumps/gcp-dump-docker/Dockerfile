# Dockerfile
FROM google/cloud-sdk:slim

COPY import.sh /import.sh
RUN chmod +x /import.sh

ENTRYPOINT ["/import.sh"]
