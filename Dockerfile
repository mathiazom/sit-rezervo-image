FROM python:3

RUN apt update && \
apt -y install firefox-esr && \
apt -y install cron

# Download and install geckodriver (must be in /usr/bin to be accessed by cron)
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.29.1/geckodriver-v0.29.1-linux64.tar.gz && \
tar -xvzf geckodriver-v0.29.1-linux64.tar.gz && \
mv geckodriver /usr/local/bin/

COPY sit-rezervo sit-rezervo

RUN python -m venv /opt/rikardo && /opt/rikardo/bin/pip install --no-cache-dir -r sit-rezervo/requirements.txt

COPY cron_generator.py cron_generator.py

# Create cron log file to be able to run tail
RUN touch /var/log/cron.log

# Set local timezone (for cron)
RUN ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

COPY sit-rezervo-entrypoint.sh  /usr/local/bin/sit-rezervo-entrypoint.sh
RUN chmod +x /usr/local/bin/sit-rezervo-entrypoint.sh
CMD ["/bin/bash", "sit-rezervo-entrypoint.sh"]
