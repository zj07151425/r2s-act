# e.g. export SCRIPT_DIR=/filespace/people/r/relson/r2s-act-work/r2s-act/scripts/
export SCRIPT_DIR=../../scripts/
# e.g. export TEST_DIR=/filespace/people/r/relson/r2s-act-work/r2s-act/testcases/simplebox-3/
export TEST_DIR=../../testcases/simplebox-3/

export MCNP5_PATH=/filespace/people/r/relson/DAG-MCNP/5.1.51/trunk/Source/src/mcnp5

cd $TEST_DIR
rm test_gammas1 test_gammas2 test_gammas3 test_gammas4 test_sdef1 test_sdef2 matFracsTest.h5m test_mcnp.* -f

echo ------------------------------------
echo Now TESTING creation of the simplest sdef file.
echo A warning is expected regarding \# mesh cells != mesh intervals\' product.
echo - - - - - - - - - - - - - - - - - -
# Note: not using default output - avoids accidental overwrite of phtn_sdef
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -s -o test_sdef1

echo
echo ------------------------------------
echo Now TESTING creation of the simplest gammas file.
echo A warning is expected regarding \# mesh cells != mesh intervals\' product.
echo - - - - - - - - - - - - - - - - - -
# Note: not using default output - avoids accidental overwrite of gammas
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -s -o test_gammas1

echo
echo ------------------------------------
echo Now TESTING creation of a more advanced sdef file.
echo  No warnings or errors should be given.
echo - - - - - - - - - - - - - - - - - -
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -s -m 0,10,3,0,10,3,0,10,3 -o test_sdef2

echo
echo --------------------------------------
echo Now TESTING creation of a more advanced gammas file.
echo  No warnings or errors should be given.
echo - - - - - - - - - - - - - - - - - -
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -g -m 0,10,3,0,10,3,0,10,3 -o test_gammas2

echo
read -p "Press [Enter] key to run next set of tests..." 
echo
echo --------------------------------------
echo Now TESTING addition of photon source information tags to an h5m mesh.
echo  No warnings or errors should be given.
echo - - - - - - - - - - - - - - - - - -

cp matFracs.h5m matFracsTest.h5m
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -H matFracsTest.h5m

echo
echo --------------------------------------
echo Now trying to add the information to the same mesh again.
echo  This should fail when trying to create new tags.
echo - - - - - - - - - - - - - - - - - -
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -H matFracsTest.h5m

echo
echo --------------------------------------
echo Now trying to read the photon source information back from a mesh missing this information.
echo  This should fail, with an error noting the missing information.
echo - - - - - - - - - - - - - - - - - -
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -p matFracs.h5m -o test_gammas3 -m 0,10,3,0,10,3,0,10,3 

echo
echo --------------------------------------
echo Now trying to read the photon source information back from a mesh containing this information.
echo  This should successfully create a gammas file.
echo - - - - - - - - - - - - - - - - - -
$SCRIPT_DIR/obj_phtn_src.py -i phtn_src -p matFracsTest.h5m -o test_gammas4 -m 0,10,3,0,10,3,0,10,3 

echo
read -p "Press [Enter] key to run next set of tests..." 
echo
echo --------------------------------------
echo "MCNP5 will now be run to test the phtn_src->h5m->gammas->source.f90 workflow for the 3x3x3 case."
echo  This should succeed and look like a normal MCNP5 run.
echo - - - - - - - - - - - - - - - - - -
cp test_gammas4 gammas

$MCNP5_PATH i=simplebox-3_src n=test_mcnp.

# Cleanup
echo
echo All tests are done. Now removing created files.
rm test_gammas1 test_gammas2 test_gammas3 test_gammas4 test_sdef1 test_sdef2 xmatFracsTest.h5m test_mcnp.* -f

