# Madvise Notes

By Ray Andrew

[Github](github.com/rayandrews) - [Email](mailto:raydreww@gmail.com)

## What is KSM

KSM is a memory de-duplication feature
Allows KSVM hypervisor to share identical memory pages among different process virtual machines.

## How to use KSM

**Use :** [MADVISE](http://man7.org/linux/man-pages/man2/madvise.2.html)

**Definition :** give advice about use of memory

> Taken from http://man7.org/linux/man-pages/man2/madvise.2.html

> The madvise() system call is used to give advice or directions to the kernel about the address range beginning at address addr and with size length bytes In most cases, the goal of such advice is to
> improve system or application performance.

> Initially, the system call supported a set of "conventional" advice
> values, which are also available on several other implementations.
> (Note, though, that madvise() is not specified in POSIX.)
> Subsequently, a number of Linux-specific advice values have been
> added.

## Keywords

**MADV_MERGEABLE and MMAP**

### Definition

> Since Linux 2.6.32

> Enable Kernel Samepage Merging (KSM) for the pages in the
> range specified by _addr_ and _length_. The kernel regularly
> scans those areas of user memory that have been marked as
> mergeable, looking for pages with identical content. These
> are replaced by a single write-protected page (which is automatically copied if a process later wants to update the content of the page).

> KSM merges only private anonymous pages (see [mmap(2)](http://man7.org/linux/man-pages/man2/mmap.2.html)).

> The KSM feature is intended for applications that generate many instances of the same data (e.g., virtualization systems such as KVM). It can consume a lot of processing power; use with care. See the Linux kernel source file _Documentation/vm/ksm.txt_ for more details.

> The **MADV_MERGEABLE** and **MADV_UNMERGEABLE** operations are available only if the kernel was configured with **CONFIG_KSM**.

### Why use MMAP?

Because **KSM** merges only private anonymous pages.

And this process can be done by using **MMAP**.

### Definition

> POSIX-compliant Unix system call that maps files or devices into memory. It is a method of memory-mapped file I/O. It implements demand paging, because file contents are not read from disk initially and do not use physical RAM at all.
>
> Taken from Wikipedia

### Question

1. Why process keep creating many memory pages even if the content is the same?

> The kernel regularly scans those areas of user memory that have been marked as mergeable, looking for pages with identical content. These are replaced by a single write-protected page (which is automatically copied if a process later wants to update the content of the page). KSM merges only private anonymous pages (see [mmap(2)](http://man7.org/linux/man-pages/man2/mmap.2.html)).
>
> "Sleep" time before each scan can be configured.
>
> For more info read https://www.kernel.org/doc/html/latest/admin-guide/mm/ksm.html

## Further Reading

- [Kernel SamePage Merging](https://www.kernel.org/doc/html/latest/admin-guide/mm/ksm.html)
- [Madvise](http://man7.org/linux/man-pages/man2/madvise.2.html)
