default: main

export DIR=${PWD}
export SLEPC_DIR=${DIR}/slepc-3.22.2
export PETSC_DIR=${DIR}/petsc-3.22.2
export PETSC_ARCH=arch-linux-c-debug

CFLAGS     =
FFLAGS     = -cpp -dM -I${SLEPC_DIR}/include -I${PETSC_DIR}/include
CPPFLAGS   =

OBJ = one.o \
      main.o

main: $(OBJ)
			-${CLINKER} -o wtb *.o ${SLEPC_SYS_LIB}
			${RM} main.o
           
include ${SLEPC_DIR}/lib/slepc/conf/slepc_common
