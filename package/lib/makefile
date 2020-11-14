LIB_NAME := mCuWave

ifndef OPTLEVEL
OPTLEVEL := 0
endif

ifndef CUDA_ENABLE
CUDA_ENABLE := 0
endif

ifndef DEBUG_LEVEL
DEBUG_LEVEL := 0
endif

ifndef MEMCHECK
MEMCHECK := 0
endif

ifndef DIM
DIM := 2
endif

ifndef DOCLEAN
DOCLEAN :=
endif

ifndef ZLIB_ENABLE
ZLIB_ENABLE := 1
endif

ifndef DOLATEXOUTPUT
DOLATEXOUTPUT := 0
endif
export DOLATEXOUTPUT


CURRENT_BASEIDIR   = $(shell pwd)
CURRENT_SRC_DIR   := ${CURRENT_BASEIDIR}/src
CURRENT_LIB_DIR   := ${CURRENT_BASEIDIR}/lib
CURRENT_OBJ_DIR   := ${CURRENT_BASEIDIR}/obj
CURRENT_HDR_DIR   := ${CURRENT_BASEIDIR}/include
CURRENT_HDRHX_DIR := ${CURRENT_BASEIDIR}/includex

SRC_FILES_HOST          := $(shell find ${CURRENT_SRC_DIR} -name *.cpp)
SRC_FILES_CUDA          := $(shell find ${CURRENT_SRC_DIR} -name *.cu)

HEADER_FILES    := $(shell find ${CURRENT_SRC_DIR} -name *.h)
HEADER_FILES_HX := $(shell find ${CURRENT_SRC_DIR} -name *.hx)

ifndef TESTS
TESTS := $(wildcard ${CURRENT_TST_DIR}/*)
else
TESTS := $(addprefix ${CURRENT_TST_DIR}/, ${TESTS})
endif


TARGET_S := ${CURRENT_LIB_DIR}/lib${LIB_NAME}S.a
TARGET_D := ${CURRENT_LIB_DIR}/lib${LIB_NAME}D.so

PY_EXE := $(shell which python3)
CC_HOST := $(shell which mpicxx)
CC_DEVICE :=  $(shell which nvcc) -ccbin=${CC_HOST}
ifneq (${PARALLEL}, MPI)
CC_HOST := g++
CC_DEVICE := none
endif
CUDA_ENABLE := 1
CU_O_TARGET_NAME := ${CURRENT_OBJ_DIR}/CU_dlink.o
ifeq (${CUDA_ENABLE}, 1)
LINK_STEP := link_step
CU_O_TARGET := ${CU_O_TARGET_NAME}
ICUDA := -I/usr/local/cuda/include
LCUDA := -L/usr/local/cuda/lib64 -lcudadevrt -lcudart
else
LINK_STEP :=
OBJ_FILES_HYBRID_DEVICE :=
CUDA_ENABLE := 0
OBJ_FILES_CUDA :=
CU_O_TARGET :=
ICUDA :=
LCUDA :=
endif


COMPILE_TIME_OPT := 



DEVICE_FLAGS := -O${OPTLEVEL} -x cu -rdc=true -Xcompiler -fPIC ${COMPILE_TIME_OPT} -dc
DEVICE_DLINK_FLAGS := -Xcompiler -fPIC -rdc=true -dlink
HOST_FLAGS := -O${OPTLEVEL} -x c++ -Wno-unknown-pragmas -fPIC -shared -fpermissive -std=c++11 -Werror -c ${LCUDA}

export CUDA_ENABLE


TARGETNAME_HYBRID_H := $(addprefix ${CURRENT_OBJ_DIR}/,$(addsuffix .o,$(notdir ${SRC_FILES_HYBRID_H})))
TARGETNAME_HYBRID_D := $(addprefix ${CURRENT_OBJ_DIR}/,$(addsuffix .o,$(notdir ${SRC_FILES_HYBRID_D})))
TARGETNAME_HOST     := $(addprefix ${CURRENT_OBJ_DIR}/,$(addsuffix .o,$(notdir ${SRC_FILES_HOST})))
TARGETNAME_CUDA     := $(addprefix ${CURRENT_OBJ_DIR}/,$(addsuffix .o,$(notdir ${SRC_FILES_CUDA})))

SRC_FILES_HOST_DIR := $(dir ${SRC_FILES_HOST})
MP:=%

ifeq (,${TARGETNAME_HYBRID_D})
ifeq (,${TARGETNAME_CUDA})
LINK_STEP :=
endif
endif

export CURRENT_ICONFIG=-I${CURRENT_HDR_DIR} ${ICUDA} ${IFLAGS_DEPENDENCIES}
export CURRENT_LCONFIG= ${LCUDA} -L${CURRENT_LIB_DIR} -l${LIB_NAME} ${LFLAGS_DEPENDENCIES}

.PHONY: final docs

final: ${DO_CLEAN} setup ${TARGETNAME_CUDA} ${TARGETNAME_HYBRID_D} ${LINK_STEP} ${TARGETNAME_HYBRID_H} ${TARGETNAME_HOST}
	${CC_HOST} -fPIC -shared ${CURRENT_OBJ_DIR}/*.o ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} ${COMPILE_TIME_OPT} ${LZLIB} ${LCUDA} ${LFLAGS_DEPENDENCIES} -o ${TARGET_D}
	${CC_HOST} -fPIC -shared ${CURRENT_OBJ_DIR}/*.o ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} ${COMPILE_TIME_OPT} ${LZLIB} ${LCUDA} ${LFLAGS_DEPENDENCIES} -o ${TARGET_S}

.SECONDEXPANSION:
${TARGETNAME_HYBRID_D}: ${CURRENT_OBJ_DIR}/%.o : $$(filter $$(MP)/$$*,$$(SRC_FILES_HYBRID_D))
	${CC_DEVICE} ${DEVICE_FLAGS} ${COMPILE_TIME_OPT} ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} $< -o $@

.SECONDEXPANSION:
${TARGETNAME_HYBRID_H}: ${CURRENT_OBJ_DIR}/%.o : $$(filter $$(MP)/$$*,$$(SRC_FILES_HYBRID_H))
	${CC_HOST} ${HOST_FLAGS} ${COMPILE_TIME_OPT} ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} $< -o $@

.SECONDEXPANSION:
${TARGETNAME_HOST}: ${CURRENT_OBJ_DIR}/%.o : $$(filter $$(MP)/$$*,$$(SRC_FILES_HOST))
	${CC_HOST} ${HOST_FLAGS} ${COMPILE_TIME_OPT} ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} $< -o $@

.SECONDEXPANSION:
${TARGETNAME_CUDA}: ${CURRENT_OBJ_DIR}/%.o : $$(filter $$(MP)/$$*,$$(SRC_FILES_CUDA))
	${CC_DEVICE} ${DEVICE_FLAGS} ${COMPILE_TIME_OPT} ${CURRENT_IFLAGS} ${IFLAGS_DEPENDENCIES} $< -o $@

${LINK_STEP}:
	${CC_DEVICE} ${DEVICE_DLINK_FLAGS} ${COMPILE_TIME_OPT} ${OBJ_FILES_HYBRID_DEVICE} ${OBJ_FILES_CUDA} -o ${CU_O_TARGET} -lcudadevrt

setup:
	echo ${AA}
	-rm -r ${CURRENT_HDR_DIR}
	-rm -r ${CURRENT_HDRHX_DIR}
	mkdir -p ${CURRENT_LIB_DIR}
	mkdir -p ${CURRENT_OBJ_DIR}
	mkdir -p ${CURRENT_HDR_DIR}
	mkdir -p ${CURRENT_HDRHX_DIR}
	@for hdr in ${HEADER_FILES} ; do\
		echo "Linking $${hdr}:";\
		ln -s $${hdr} -t ${CURRENT_HDR_DIR};\
	done
	@for hdr in ${HEADER_FILES_HX} ; do\
		echo "Linking $${hdr}:";\
		ln -s $${hdr} -t ${CURRENT_HDRHX_DIR};\
	done

clean:
	-rm -r ${CURRENT_LIB_DIR}
	-rm -r ${CURRENT_OBJ_DIR}
	-rm -r ${CURRENT_HDR_DIR}
	-rm -r ${CURRENT_HDRHX_DIR}

docs:
	${MAKE} -C ${CURRENT_DOC_DIR} -f makefile.docs
