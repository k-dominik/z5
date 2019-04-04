mkdir -p build
cd build

CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include"
LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib"

if [ $(uname) == Darwin ]; then
    CXXFLAGS="$CXXFLAGS -stdlib=libc++"
fi

if [[ ${PY3K} == 1 ]];
then
    PYTHON_LIBRARIES="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}"
    PYTHON_INCLUDE_DIR=${PREFIX}/lib/python${PY_VER}m
else
    PYTHON_LIBRARIES="${PREFIX}/lib/libpython${PY_VER}${SHLIB_EXT}"
    PYTHON_INCLUDE_DIR=${PREFIX}/lib/python${PY_VER}
fi

##
## Configure
##
cmake .. \
        -DCMAKE_C_COMPILER=${CC} \
        -DCMAKE_CXX_COMPILER=${CXX} \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9\
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_PREFIX_PATH=${PREFIX} \
\
        -DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} -O3 -DNDEBUG -std=c++17" \
\
        -DBOOST_ROOT=${PREFIX} \
        -DWITH_BLOSC=ON \
        -DWITH_ZLIB=ON \
        -DWITH_BZIP2=ON \
        -DWITH_XZ=ON \
\
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY=${PYTHON_LIBRARIES} \
        -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR} \
##

##
## Compile
##
make -j${CPU_COUNT}

##
## Install to prefix
make install
#cp -r ${SRC_DIR}/build/python/z5py ${PREFIX}/lib/python${PY_VER}/site-packages/
