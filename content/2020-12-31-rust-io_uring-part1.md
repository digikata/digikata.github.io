+++
title = "Rust and io_uring Part 1"
date = 2020-12-31
+++

There are really a lot of different io_uring crates for rust. Some are quick
bindings, some are specialized to particular application or runtime
environments, some are doing deeper experiments to how they connect to the
applications using the interface,  I think I'll start looking at them to
contrast their approaches in a little more detail.

First a little background on a number of different approaches a program can
take in order to make I/O calls, be they to the network, disk, or some other
device. This post is the first in a series of notes reviewing the tradeoffs of
the various approaches at a high level, from different kinds of synchronous
i/o calls to different kinds of asynchronous calls. Some focus on an
environment where a program os running direclty in an OS, but a lot of this
also applies in other environments besides Rust.

The first part is below on a little background on Synchrnous I/O and
architectures that handle it, mostly a language independent discussion.

<!-- more -->

## Synchronous I/O

Synchronous I/O is the most common way to access data where program execution
waits on calls to read or write data. It is supported by common system I/O
apis (POSIX et al), and is simple, robust, and easy to reason about.

Calling a synchronous I/O call blocks further execution within a single
process or thread, which is why these system calls are often referred to as
blocking calls or a blocking api. If the needs of the program are only to get
one operation done at a time this is not a big concern. But the blocking makes
the use synchronous methods limited in the top throughput of progress that can
be made from multiple operations or I/Os that can be made within a program at 
once. This can limit the responsiveness of a program to singular operations, in
addition to increasing latency of response to multiple simulatanous operations 
that are waiting.

The operating system doesn't stop when these calls are made, if there are
other processes or threads, an OS scheduler can decide to make another process
active to get work done while waiting on the I/O of the blocked process to be
completed. In older computer architectures, the balance of time waiting for one
blocking I/O call was a very reasonable optimization as the time of response of the 
underlying resouse, disk or network for example, could be used to switch through 
multipe contexts to run other processes.

But an application doesn't have to be stuck with only one blocked i/o 
call. And applications that care about higher thoughput on dedicated systems
may want an application to use more system resources.


## Concurrent I/O Methods

There are ways to do more work in a computer system, and a program can arrange
its architecture a different way to open more processes or threads with
synchronous calls. For example, one can do this by spawning a thread for every
operation that is anticipated to make a blocking call. 

This does incur some overhead: eg on creation of thread/process specific stack
memory regions, as well as the introduction of a need for some level of memory
sharing locks/mutexes or messaging mechanisms so that the different threads
can coordinate; more on that later. But the basic idea here is if the
application wants to keep processing multiple operations, a thread can be
created for each operation and if it blocks on a particular call, progress for
the application overall can still be made over a number of threads. In this
architecture, the system api calls are the same synchonous i/o calls as
previously mentioned. 

The advantage here is that the fairly simple i/o access interactions are
preserved with the addition of the need for managment of shared data
structures. Typically the change isn't too different, as a separation of data
for the overall application vs data for specific operations is one that can be
cleanly layered.

A common pattern with this approach is to pre-spawn threads into a pool. From
the pool threads are available to map new operations to open threads and
otherwise queue ops to wait for a free thread. The pool gives a couple of
advantages such as trading thread creation times for lower thread mapping
times, in addition, it can create a natural point of control for the number of
outstanding threads. The ability to limit the number of threads creates is
sometimes important for controlling resource growth, robustness, and system
optimzation as the creation and context switching costs can increase with a
large number of threads.

This optimization touches on some of the drawbacks of using a set of threads
to form concurrency. Ironically within the OS, the internals of i/o access
are generally implmented using asynchronous apis, with a support layer to
receive userspace synchronous syscalls for i/o, then route and manage those
operations to a more fundamental internal asynchronous i/o.

## Asynchonous I/O APIs 

Beyond thread pools, another level of system performance for i/o involves use
of asynchronous apis to access network and disk i/o. Note this is a different topic
than the async/await Rust language support, it is what apis an OS offers up to applications
to interact with their kernels and i/o subsystems. The access apis become less
standardized:

* Windows
	* I/O Completion Ports
* BSD-Family / MacOS
	* posix aio
	* kqueue
* Linux
	* posix aio
	* linux aio
	* io_uring

The next part will focus in on the Linux asynchronous apis and in particular io_uring and
Rust crates accessing that interface.
