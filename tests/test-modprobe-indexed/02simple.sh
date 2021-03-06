#! /bin/sh

BITNESS=32

rm -rf tests/tmp/*

MODULE_DIR=tests/tmp/lib/modules/$MODTEST_UNAME
mkdir -p $MODULE_DIR
ln tests/data/$BITNESS/normal/noexport_nodep-$BITNESS.ko \
   $MODULE_DIR

# Set up modules.dep.bin file
echo "noexport_nodep_$BITNESS noexport_nodep-$BITNESS.ko:" | modindex -o $MODULE_DIR/modules.dep.bin

SIZE=`wc -c < tests/data/$BITNESS/normal/noexport_nodep-$BITNESS.ko`

# No args
[ "`modprobe noexport_nodep-$BITNESS 2>&1`" = "INIT_MODULE: $SIZE " ]

# With quoted args
[ "`modprobe noexport_nodep-$BITNESS 'foo="bar baz"' 2>&1`" = "INIT_MODULE: $SIZE foo=\"bar baz\"" ]
# With unquoted args
[ "`modprobe noexport_nodep-$BITNESS foo=\"bar baz\" 2>&1`" = "INIT_MODULE: $SIZE foo=\"bar baz\"" ]

# Check underscore equivalence.
[ "`modprobe noexport-nodep-$BITNESS foo=\"bar baz\" 2>&1`" = "INIT_MODULE: $SIZE foo=\"bar baz\"" ]
[ "`modprobe noexport-nodep_$BITNESS foo=\"bar baz\" 2>&1`" = "INIT_MODULE: $SIZE foo=\"bar baz\"" ]
[ "`modprobe noexport_nodep_$BITNESS foo=\"bar baz\" 2>&1`" = "INIT_MODULE: $SIZE foo=\"bar baz\"" ]
