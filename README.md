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


## Example on Fortran

Copy files from [Example](Example) into some directory and compile Fortran program

> make

Run exemple:

> ./wtb

```
1-D Laplacian Eigenproblem, n = 100 (Fortran)
 Number of requested eigenvalues:  10
 ierr:   0
 Solution method: krylovschur                                                                     
 Number of requested eigenvalues:  10
 Linear eigensolve converged (10 eigenpairs) due to CONVERGED_TOL; iterations 40
 ---------------------- --------------------
            k             ||Ax-kx||/||kx||
 ---------------------- --------------------
        3.999756            4.19575e-09
        3.999023            9.31525e-09
        3.997802            3.46131e-09
        3.996093            7.97019e-09
        3.993896            1.60115e-09
        3.991212             5.5682e-09
        3.988042            6.69835e-09
        3.984386            7.69882e-09
        3.980245            2.13191e-09
        3.975621            3.77331e-09
 ---------------------- --------------------
 calc time =  0.20098399999999997       s

``` 





