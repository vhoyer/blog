---
isDraft: false
lang: en
title: Speed up docker command tear down
description: Save up to 10 seconds every time you have to close your docker
  container TL;DR just forward the `TERM` signal to your running process.
author: Vinícius Hoyer
date: 2022-10-18T21:17:23.285Z
tags:
  - Tech
---
When you have a container running with a web server and you want to stop it,
what do you do? I think it's fair to say that one just CTRL-C out of the
process, right?

But now there are either two possible outcomes, either you have configured your
docker setup correctly and the process quits in about 1-2 seconds which is the
time needed for your main web server to shutdown, write all logs and what not
and then the time for docker to clean up after the container stopped.

The other option is you sit there waiting for about 10 seconds for docker to get
fed up of waiting for your process to shutdown and it sends a `KILL` signal to
everything running in the container and then cleans up itself.

This post is here to help your docker instance not to die out of boredom in
those 10 seconds, do you know how many calculations your computer can do in
those 10 seconds?

The introduction is long but the fix is on the simpler side, to fix it you just
need to make sure that the `TERM` signal docker sends to the container arrives
at your main web server process.

Docker only sends the `TERM` signal to the process with id `1` (or pid 1,
process id 1) on the container, which is the first command ran by the `CMD`
(`CMD ["this_command_here.sh"]`, generally at the end of Dockerfiles, or
`command`, on a `docker-compose.yml` file).

Ok, but how do I forward a `TERM` signal to my web server process? Well, as any
senior developer will tell you whenever you ask them about anything, it depends.

Let's assume you are programming an node/javascript application and your server
starts by running `npm start`. Then you only need to call it using the following
syntax:

```dockerfile
CMD ["npm", "start"]
```

It's important to use the JSON syntax because otherwise, if you use the `CMD npm
start` syntax, the pid 1 will not be `npm start`, it will be `sh`, because
docker invokes the `sh` to interpret the string you passed to it, whilst when
using the array-like syntax, docker runs the command directly, thus ensuring
that the command you asked for is the pid number 1.

## What if I need to run something before?

Now, imagine you want, not only to run the `npm start` command, but also to run
`npm install` before the `npm start` to provide a clean, easy-to-start way to
run your app while developing.

There are presumably lot's of ways to do it, the way Quero Education, the
company I work for, decided to do was to use a `Makefile` to run the multiple
commands, only requiring the container to run `make quero-boot-startup`
(quero-boot being the name of the project containing the docker-compose setup).

```
quero-boot-startup:
    npm install
    npm start
```

The problem of using `make` to do this, we later discovered, is that make don't
forward the signals it receives, so when docker tells make to terminate itself,
it does, but it leaves it's subprocesses still running preventing the container
from stopping. The solution?

## Forwarding TERM signal to all sub-processes

A custom script with the ability to forward the `TERM` signals received for all
it's subprocesses.

```sh
#!/bin/sh
set -e

PIDS_FILE="/tmp/pids"
run() {
    echo "$*"                # feedback of execution
    "$@" &                   # async execution
    pid=$!                   # save pid
    echo "$pid" >>$PIDS_FILE # store pid
    wait "$pid"              # await pid
}

terminate() {
    # forward TERM signal to all subprocesses whose pid reside on $PIDS_FILE
    xargs -f $PIDS_FILE -I{} "kill -TERM '{}' 2> /dev/null"
}
trap terminate TERM

run npm install
run npm start
```

The magic relies on the `run` function that saves all the process ids from the
commands invoked in the script in a file stored in the `/tmp/` folder inside the
container.

If a `TERM` signal is received by this script, the appropriately named `trap`
command, traps the signal and calls the `terminate` functions which sends `TERM`
to all PIDs in the temporary file and when it ends, it closes itself.

As it is a temporary file, it only exists in the current execution of the
container, so no clean up is needed. Also, if a process whose id was saved in
this file, has already started and died, the signal is ignored by the system.

You are only required to prepend all your commands with `run` (name of the
function), and if the script receives a `TERM` it will forward it leading every
subprocess to shutdown, so the container can die peacefully.

## References:

- <https://www.ctl.io/developers/blog/post/gracefully-stopping-docker-containers/>
- <https://dirask.com/posts/Bash-forward-SIGTERM-to-child-processes-DkBqq1>
- <https://gist.github.com/vhoyer/7130f95b830e6d302c537701ad7f83d2>
