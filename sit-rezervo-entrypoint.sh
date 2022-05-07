#!/bin/sh

echo "Generating crontab..."
/opt/rikardo/bin/python -u sit-rezervo/cron_generator.py sit-rezervo-cron

echo "Installing crontab..."
cp sit-rezervo-cron /etc/cron.d/sit-rezervo-cron
chmod 0644 /etc/cron.d/sit-rezervo-cron
crontab /etc/cron.d/sit-rezervo-cron
cat /etc/cron.d/sit-rezervo-cron

echo "Starting cron..."
cron && tail -f /var/log/sit-rezervo.log
