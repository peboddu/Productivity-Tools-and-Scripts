#!python
'''
    This script intented to clone repositories from GitLab
    Pre-requisites:
        * Access-Token
    USAGE:
        python ListBuildRepos.py
'''

from queue import Queue
import time
import os
import shutil
from threading import Thread
import requests
from git import Repo
from clint.textui import colored


THREADS_COUNT = 8


def clone_repo(queue):
    '''
        Clone repositories
        Accepts queue object
    '''
    while not queue.empty():
        row = queue.get()
        queue.task_done()
        repo = row

        # Clone repositoryies
        result = repo.split(':', 1)[1]
        repo_dir = result.split('.', 1)[0]
        if os.path.exists(repo_dir):
            print(colored.red("Removing {} .. ".format(repo_dir)))
            shutil.rmtree(repo_dir)

        if not os.path.exists(repo_dir):
            os.makedirs(repo_dir)
        print(colored.yellow("Cloning {} ".format(repo)))
        Repo.clone_from(repo, repo_dir)


def main():
    '''
        This script clones all repositories / specific repositories that match the repository path
        * Query all repository names
        * Clone each repository
    '''
    page = 0
    page_size = 52
    exist_more = 1
    repo_urls = []
    queue = Queue(maxsize=0)
    no_of_repos = 0
    while exist_more:
        url = 'http://git-eman.cisco.com/api/v4/projects?sort=asc&private_token=RCzPaQsf-ZFtvzcz9GyX&per_page={}&page={}'.format(
            page_size, page)
        response = requests.get(url, auth=('', ''), headers={"Accept": "application/json"})
        repos = response.json()
        page += 1
        for project in repos:
            # if project['ssh_url_to_repo'] in repo_urls or 'unified_monitoring' not in project['ssh_url_to_repo']:
            if project['ssh_url_to_repo'] in repo_urls:
                continue
            no_of_repos += 1
            repo_urls.append(project['ssh_url_to_repo'])
            print(colored.green(project['ssh_url_to_repo']))
            queue.put(project['ssh_url_to_repo'])
        if len(repos) != page_size:
            exist_more = 0

    workers = []
    for cnt in range(THREADS_COUNT):
        worker = Thread(target=clone_repo, args=(queue,),
                        name='Thread-{}'.format(cnt + 1))
        worker.setDaemon(True)
        worker.start()
        workers.append(worker)

    while True:
        threads_alive = 0
        print(colored.green("Queue Size: {}".format(queue.qsize())))
        if queue.qsize() == 0:
            time.sleep(60)
            for i, worker in enumerate(workers):
                if worker is not None and worker.isAlive():
                    worker.join(1)
                    workers[i] = None
                    threads_alive += 1

            if threads_alive == 0:
                break
        else:
            time.sleep(10)
    print(colored.green("Unified Monitoring Repositories Count: {}".format(no_of_repos)))


if __name__ == '__main__':
    main()
