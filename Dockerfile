FROM python:3

RUN apt update && \
apt -y install cron

COPY sit-rezervo/requirements.txt sit-rezervo/requirements.txt

RUN python -m venv /opt/rikardo && \
/opt/rikardo/bin/pip install -U pip && \
/opt/rikardo/bin/pip install --no-cache-dir -r sit-rezervo/requirements.txt

COPY sit-rezervo sit-rezervo

# Create cron log file to be able to run tail
RUN touch /var/log/sit-rezervo.log

# Set local timezone (for cron)
RUN ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

COPY sit-rezervo-entrypoint.sh  /usr/local/bin/sit-rezervo-entrypoint.sh
RUN chmod +x /usr/local/bin/sit-rezervo-entrypoint.sh
CMD ["/bin/bash", "sit-rezervo-entrypoint.sh"]
