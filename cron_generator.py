import os
import sys
import datetime

SIT_REZERVO_ACTIVITY_WEEKDAY = os.environ['SIT_REZERVO_ACTIVITY_WEEKDAY']
SIT_REZERVO_ACTIVITY_HOUR = int(os.environ['SIT_REZERVO_ACTIVITY_HOUR'])
SIT_REZERVO_ACTIVITY_MINUTE = int(os.environ['SIT_REZERVO_ACTIVITY_MINUTE'])

SIT_REZERVO_STARTUP_DAYS_BEFORE_ACTIVITY = 2
SIT_REZERVO_STARTUP_MINUTES_BEFORE_BOOKING = int(os.environ['SIT_REZERVO_STARTUP_MINUTES_BEFORE_BOOKING'])


def main():
    # Using current datetime simply as a starting point
    # We really only care about the "wall clock" part, which is replaced by input values
    activity_time = datetime.datetime.now().replace(
        hour=SIT_REZERVO_ACTIVITY_HOUR,
        minute=SIT_REZERVO_ACTIVITY_MINUTE,
        second=0, microsecond=0  # Cosmetic only
    )
    print(f"Activity starts {SIT_REZERVO_ACTIVITY_WEEKDAY} {activity_time.time()}")

    # Back up time to give booking script some prep time
    cron_time = activity_time - datetime.timedelta(minutes=SIT_REZERVO_STARTUP_MINUTES_BEFORE_BOOKING)

    weekdays = ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"]
    cron_weekday = \
        (weekdays.index(SIT_REZERVO_ACTIVITY_WEEKDAY) + 1 - SIT_REZERVO_STARTUP_DAYS_BEFORE_ACTIVITY) % len(weekdays)

    print(f"Creating booking cron job at '{cron_time.minute} {cron_time.hour} * * {cron_weekday}'")

    if len(sys.argv) < 1:
        print("[ERROR] No output file path provided")
        return

    with open(sys.argv[1], "w+") as cron_file:
        cron_file.write(
            f"{cron_time.minute} {cron_time.hour} * * {cron_weekday} "
            ". /sit-rezervo/sit-rezervo-env.sh && "
            "(cd /sit-rezervo/ || exit 1; PATH=$PATH:/usr/local/bin "
            "/opt/rikardo/bin/python -u rezervo.py >> /var/log/cron.log 2>&1)"
            "\n"  # Empty line to please the cron gods ...
        )


if __name__ == '__main__':
    main()
