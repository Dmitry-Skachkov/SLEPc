# SLEPc installation and examples

## Installation on DARWIN cluster of University of Delaware

Load the compilers:

> vpkg_require openmpi/5.0.2:intel-oneapi-2024

> vpkg_require intel-oneapi-mkl/2024

Download PETSc library archive:

> wget https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.22.2.tar.gz

untar the archive

> tar -xvf petsc-3.22.2.tar.gz

Configure the package with complex scalars

> ./configure --with-scalar-type=complex

Make installation:

> make PETSC_DIR=/home/3811/petsc-3.22.2 PETSC_ARCH=arch-linux-c-debug all

Download SLEPc library archive:

> wget https://slepc.upv.es/download/distrib/slepc-3.22.2.tar.gz

and untar

> tar -xvf slepc-3.22.2.tar.gz

> cd slepc-3.22.2/

> export SLEPC_DIR=$PWD

> export PETSC_DIR=/home/3811/petsc-3.22.2

> export PETSC_ARCH=arch-linux-c-debug

> ./configure

> make SLEPC_DIR=/home/3811/slepc-3.22.2 PETSC_DIR=/home/3811/petsc-3.22.2 PETSC_ARCH=arch-linux-c-debug



