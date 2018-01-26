# RISC-V Unix-class Platform Specification

# Copyright and license information

This RISC-V Unix-class platform specification is

 &copy; 2017 Krste Asanovic <krste@sifive.com>

 &copy; 2017 Palmer Dabbelt <palmer@sifive.com>

 &copy; 2017 Andrew Waterman <andrew@sifive.com>

It is licensed under the Creative Commons Attribution 4.0 International
License (CC-BY 4.0).  The full license text is available at
https://creativecommons.org/licenses/by/4.0/.

# Unix-class Platform Specification

This Unix-class platform specification is incomplete.  Currently, it only
lists the constraints on a RISC-V implementation beyond those in the
architecture manual.  It only describes the RV64 Unix platform; a future
version of this specification will describe the RV32 Unix platform.

RISC-V Unix-class systems implement the RV64GC ISA with supervisor mode and
the Sv39 page-based virtual-memory scheme.  Systems may support additional ISA
extensions, but if these extensions add user-visible architectural state, they
must be initially disabled.  Systems that support Sv48 must support Sv39,
systems that support Sv57 must support Sv48, and so forth.

Within main-memory regions, aligned instruction fetch must be atomic, up to
the smaller of ILEN and XLEN bits.  In particular, if an aligned 4-byte word
is stored with the `sw` instruction, then any processor attempts to execute
that word, the processor either fetches the newly stored word, or some
previous value stored to that location.  (That is, the fetched instruction is
not an unpredictable value, nor is it a hybrid of the bytes of the old and new
values.)

Unless otherwise specified by a given I/O device,
I/O regions are at least point-to-point strongly ordered.
All devices attached to a given PCIe root complex are on the same ordered
channel (numbered 2 or above), though different root complexes might not
be on the same ordering channel.

On RV64I-based Unix-class systems the negative virtual addresses are
reserved for the kernel.

## Misaligned Physical-Memory Access Atomicity

Consider a data memory access of size *w* to physical address *p<sub>0</sub>*,
where *w* does not evenly divide *p<sub>0</sub>*.  Let *p<sub>1</sub>* denote
the physical address of the last byte of the access, and let *P* denote the
address pair *(p<sub>0</sub>, p<sub>1</sub>)*.  There are two cases:

1. *P* lies within a single physical-memory region.  One of the following
   holds:

   1. Loads and stores to *P* execute atomically with respect to other
      accesses to *P*.  AMOs to *P* either execute atomically
      with respect to other accesses to *P* or raise access
      exceptions.  LRs and SCs to *P* either execute atomically
      with respect to other accesses to *P* or raise access exceptions.
   
   2. Loads and stores to *P* execute without guarantee of atomicity.  AMOs,
      LRs, and SCs to *P* raise access exceptions.

2. *P* spans two physical-memory regions. AMOs, LRs, and SCs all raise access
   exceptions.  Additionally, one of the following holds:

   1. Loads and stores to *P* raise access exceptions.

   2. Loads and stores to *P* succeed without guarantee of atomicity.

   3. Loads and stores to *P* proceed partially, then raise access exceptions.
      No register writebacks occur.

## Misaligned Virtual-Memory Access Atomicity

Consider a data memory access of size *w* to virtual address *v<sub>0</sub>*,
where *w* does not evenly divide *v<sub>0</sub>*.  Let *v<sub>1</sub>* denote
the virtual address of the last byte of the access.  Let *p<sub>0</sub>* and
*p<sub>1</sub>* be the physical addresses corresponding to *v<sub>0</sub>* and
*v<sub>1</sub>*, if translations exist.  One of the following must hold:

1. *v<sub>0</sub>* is an impermissible virtual address; the access raises
   a page-fault exception with trap value *v<sub>0</sub>*.

3. *v<sub>0</sub>* is a permissible virtual address; *v<sub>1</sub>* lies
   in a different, impermissible page.
   The access raises a page-fault exception with a trap value equal
   to the base virtual address of the page containing *v<sub>1</sub>*.
   Alternatively, if the same access to physical-address pair
   *(p<sub>0</sub>, p<sub>0</sub>+w-1)* would have caused an access exception,
   the implementation may raise that exception instead.  (This design
   simplifies the emulation of misaligned accesses in more-privileged software.)

3. *v<sub>0</sub>* and *v<sub>1</sub>* are both permissible virtual
   addresses.
   The access proceeds according to the misaligned physical-memory access
   rules above, noting that *v<sub>0</sub>* and *v<sub>1</sub>* may lie
   in different physical-memory regions, despite their virtual contiguity.
