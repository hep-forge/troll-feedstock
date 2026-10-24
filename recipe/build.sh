#! /usr/bin/bash
set -euo pipefail

# TROLL builds with a plain Makefile: a static libTROLL.a and example programs.
# CFLAGS replaces the Makefile's own (-Wall -O2 + include paths), so the include
# path is passed here; LIBS_PATH still gets -L$PREFIX/lib from LHAPDF_PATH.
# The Higgs examples need ggHiggs next to the source tree: not built.
# HELL (small-x resummation) is optional and not found: built without it.
make -j"${CPU_COUNT:-2}" libTROLL.a examples/example_DrellYan examples/example_DIS \
     CC="${CXX}" FF="${FC}" \
     CFLAGS="${CXXFLAGS} -Wall -O2 -I${PREFIX}/include" \
     LHAPDF_PATH="${PREFIX}" GSL_PATH="${PREFIX}" CUBA_PATH="${PREFIX}/include"

mkdir -p "${PREFIX}/lib" "${PREFIX}/bin" "${PREFIX}/include/TROLL"
cp libTROLL.a "${PREFIX}/lib/"
# keep the src/... layout the examples include (#include "src/resummation.hh")
( find src -name "*.hh" -print0 | xargs -0 -I{} cp --parents {} "${PREFIX}/include/TROLL/" )
cp examples/example_DrellYan "${PREFIX}/bin/troll-drellyan"
cp examples/example_DIS      "${PREFIX}/bin/troll-dis"
