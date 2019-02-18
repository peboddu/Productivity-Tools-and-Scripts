from random import randrange
from time import sleep

delays = [randrange(1, 10) for i in range(30)]


def wait_delay(d):
    print('sleeping for (%d)sec' % d)
    sleep(d)


pool = ThreadPool(20)
for i, d in enumerate(delays):
    pool.add_task(wait_delay, d)
pool.wait_completion()
