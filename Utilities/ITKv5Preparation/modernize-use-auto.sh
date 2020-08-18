#!/bin/bash -e
# \author Hans J. Johnson
#
# This script assists with using clang-tidy.
#
# STEP 0;
# I recommend downloading or building the latest
# version of llvm with clang and the clang-tidy
# tools in a private repo. NOTE:  Apple does
# not currently distribute these.
#
# STEP 1:
# Build your source tree with cmake and use
# export PATH=${MYCLANG_FROM_STEP0}:$PATH
# export CXX=${MYCLANG_FROM_STEP0}
# export CC=${MYCLANG_FROM_STEP0}
# cd ${MYBLD}
# cmake -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON ${MYSRC}
# to generate the compile_commands.json
# comple options database files.
#
# STEP 2:
# Run clang-tidy with the

SRCDIR=$1
BLDDIR=$2

this_script_name=$(basename $0)
CMTMSG=$(mktemp -q /tmp/${this_script_name}.XXXXXX)
FILES_TO_CHECK=$(mktemp -q /tmp/${this_script_name}_files.XXXXXX)

cat > ${CMTMSG} << EOF
STYLE: Use auto for variable type matches the type of the initializer expression

This check is responsible for using the auto type specifier for variable
declarations to improve code readability and maintainability.

The auto type specifier will only be introduced in situations where the
variable type matches the type of the initializer expression. In other words
auto should deduce the same type that was originally spelled in the source

SRCDIR=${SRCDIR} #My local SRC
BLDDIR=${BLDDIR} #My local BLD

cd ${BLDDIR}
run-clang-tidy.py -extra-arg=-D__clang__ -checks=-*,modernize-use-auto -header-filter = .* -fix

EOF

export CC=/Users/johnsonhj/local/ccache/bin/clang_ccache
export CXX=/Users/johnsonhj/local/ccache/bin/clang++11_ccache
export PATH=~/local/llvm/llvm_trunk-build/bin:$PATH
cd ${BLDDIR}
/Users/johnsonhj/Dashboard/src/scripts/run-clang-tidy.py -extra-arg=-D__clang__ -checks=-*,modernize-use-auto -header-filter = .* -fix

cd ${SRCDIR}
git add -A && git commit --file ${CMTMSG}
