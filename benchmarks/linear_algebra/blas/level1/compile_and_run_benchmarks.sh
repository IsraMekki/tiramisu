#set -x

TIRAMISU_ROOT=/Users/b/Documents/src/MIT/tiramisu/

if [ $# -eq 0 ]; then
      echo "Usage: TIRAMISU_SMALL=1 script.sh <KERNEL_FOLDER>"
      echo "Example: script.sh axpy"
      exit
fi

if [ "${TIRAMISU_XLARGE}" = "1" ]; then
    DEFINED_SIZE="-DTIRAMISU_XLARGE"
elif [ "${TIRAMISU_LARGE}" = "1" ]; then
    DEFINED_SIZE="-DTIRAMISU_LARGE"
elif [ "${TIRAMISU_MEDIUM}" = "1" ]; then
    DEFINED_SIZE="-DTIRAMISU_MEDIUM"
elif [ "${TIRAMISU_SMALL}" = "1" ]; then
    DEFINED_SIZE="-DTIRAMISU_SMALL"
else
    DEFINED_SIZE="-DTIRAMISU_LARGE"
fi

KERNEL=$1
source ${TIRAMISU_ROOT}/configure_paths.sh

CXXFLAGS="-std=c++11 -O3"

INCLUDES="-I${MKL_PREFIX}/include/ -I${TIRAMISU_ROOT}/include/ -I${TIRAMISU_ROOT}/${HALIDE_SOURCE_DIRECTORY}/include/ -I${TIRAMISU_ROOT}/${ISL_INCLUDE_DIRECTORY}"
LIBRARIES="-lcblas -lhalide -lisl -lz -lpthread"
LIBRARIES_DIR="-L${MKL_PREFIX}/lib/ -L${TIRAMISU_ROOT}/$HALIDE_LIB_DIRECTORY -L${TIRAMISU_ROOT}/${ISL_LIB_DIRECTORY}"
TIRAMISU_OBJ="${TIRAMISU_ROOT}/build/tiramisu_core.o ${TIRAMISU_ROOT}/build/tiramisu_codegen_halide.o ${TIRAMISU_ROOT}/build/tiramisu_codegen_c.o ${TIRAMISU_ROOT}/build/tiramisu_debug.o ${TIRAMISU_ROOT}/build/tiramisu_utils.o ${TIRAMISU_ROOT}/build/tiramisu_codegen_halide_lowering.o ${TIRAMISU_ROOT}/build/tiramisu_codegen_from_halide.o"

echo "Compiling ${KERNEL}"

cd ${KERNEL}

rm -rf ${KERNEL}_generator ${KERNEL}_wrapper
g++ $CXXFLAGS ${INCLUDES} ${DEFINED_SIZE} ${KERNEL}_generator.cpp ${TIRAMISU_OBJ} ${LIBRARIES_DIR} ${LIBRARIES}                       -o ${KERNEL}_generator
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HALIDE_LIB_DIRECTORY}:${ISL_LIB_DIRECTORY}:${PWD}/build/ DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${HALIDE_LIB_DIRECTORY}:${PWD}/build/ ./${KERNEL}_generator
g++ $CXXFLAGS ${INCLUDES} ${DEFINED_SIZE} ${KERNEL}_wrapper.cpp   ${TIRAMISU_OBJ} ${LIBRARIES_DIR} ${LIBRARIES} generated_${KERNEL}.o -o ${KERNEL}_wrapper
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HALIDE_LIB_DIRECTORY}:${ISL_LIB_DIRECTORY}:${PWD}/build/ DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${HALIDE_LIB_DIRECTORY}:${PWD}/build/ ./${KERNEL}_wrapper

cd -