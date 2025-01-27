default: hh

export DIR=${PWD}
export SLEPC_DIR=${DIR}/slepc-3.22.2
export PETSC_DIR=${DIR}/petsc-3.22.2
export PETSC_ARCH=arch-linux-c-debug

OBJS = module_slepc_solver.o \
       main.o

hh: $(OBJS)
	${CLINKER} -o hh $(OBJS) ${SLEPC_SYS_LIB}

include ${SLEPC_DIR}/lib/slepc/conf/slepc_common
