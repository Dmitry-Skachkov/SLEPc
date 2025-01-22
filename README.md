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


## Installation on BRIDGES-2 cluster of Pittsburg SuperComputer Center

Load modules

> module load intel-compiler/2023.2.1

> module load intel-mpi/2021.10.0

The remaining installation will be the same


## Examples on Fortran

Example 1 solve large system for 3000 x 3000 and calculate 1000 first lowest eigenvalues.

Example 2 calculate eigenvalues and eigenvectors, store them into arrays, and check the solutions. 


