#!/bin/sh

echo "Loading booking environment variables..."
printenv | grep -e ^SIT_REZERVO_ | sed 's/^\(.*\)=\(.*\)$/export \1="\2"/g' > sit-rezervo-env.sh
cat sit-rezervo-env.sh | grep -o -E ^[^=]* 2>&1

echo "Generating crontab..."
python -u cron_generator.py sit-rezervo-cron

echo "Installing crontab..."
cp sit-rezervo-cron /etc/cron.d/sit-rezervo-cron
chmod 0644 /etc/cron.d/sit-rezervo-cron
crontab /etc/cron.d/sit-rezervo-cron
cat /etc/cron.d/sit-rezervo-cron

echo "Starting cron..."
cron && tail -f /var/log/cron.log
