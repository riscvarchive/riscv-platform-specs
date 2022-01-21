# RISC-V Platform Specification

The files in this project are used to create the RISC-V 
Platform Specification.  This specification defines the set of firmware
and hardware required of a RISC-V platform so that it may install
and run various operating systems.

The content of the specification is created and controlled by the RISC-V
Platform Horizontal Subcommittee (RISC-V Platform HSC).  Information
about the subcommittee can be found at
https://lists.riscv.org/g/tech-unixplatformspec.
Please note that membership in RISC-V International is required to post
to the mailing list, but it is publicly readable.  Membership in RISC-V
International is free for individual community members.

All discussion of this specification occurs on the task group mailing
list.  Please use github issues for bug reports.

# Licensing

The files in this repository are licensed under the Creative Commons
Attribution 4.0 International License (CC-BY 4.0).  The full license
text is available at https://creativecommons.org/licenses/by/4.0/.

# Repository Content
* **Makefile** => 'make' in this directory will produce the HTML, markdown,
and PDF versions of the current spec
* **README.md** => this file
* ```riscv-platform-spec.adoc``` => the spec in asciidoc format; there are
several subsidiary asciidoc files that get included by this file.
* ```docs-resources``` => Git Submodule with the RISC-V documentation theme, 
fonts, etc.  for building the document

# Repository Branches
* All development occurs on ```main```; no content on main is to be
considered TSC-approved content.
* TSC-approved content will be clearly marked as such.

# Dependencies
The PDF built in this project uses AsciiDoctor (Ruby). For more information
on AsciiDoctor, specification guidelines, or building locally, see the 
[RISC-V Documentation Developer Guide](https://github.com/riscv/docs-dev-guide).

# Cloning the project
This project uses 
[GitHub Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) 
to include the RISC-V 
[docs-resources project](https://github.com/riscv/docs-resources)
to achieve a common look and feel.

When cloning this repository for the first time, you must either use 
`git clone --recurse-submodules` or execute `git submodule init` and 
`git submodule update` after the clone to populate the `docs-resources` 
directory. Failure to clone the submodule, will result in the PDF build 
fail with an error message like the following:

```
$ make
asciidoctor-pdf \
-a toc \
-a compress \
-a pdf-style=docs-resources/themes/riscv-pdf.yml \
-a pdf-fontsdir=docs-resources/fonts \
--failure-level=ERROR \
-o profiles.pdf profiles.adoc
asciidoctor: ERROR: could not locate or load the built-in pdf theme `docs-resources/themes/riscv-pdf.yml'; reverting to default theme
No such file or directory - notoserif-regular-subset.ttf not found in docs-resources/fonts
  Use --trace for backtrace
make: *** [Makefile:7: profiles.pdf] Error 1
```
