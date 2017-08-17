from apscheduler.schedulers.blocking import BlockingScheduler
import os
client = Client('https://ae99f0a9931a4625b73d332bb13e2c57:d35713bacc3445008c5953ba4f3f9783@sentry.io/108400')
sched = BlockingScheduler()


@sched.scheduled_job('cron', day_of_week='mon-sun', hour=5)
def scheduled_job():
    os.system("python3 high_value_client_projection2.py --loadbasemodel XGBClassifier --loadmodel LogisticRegression --loadthreshold --predict")


