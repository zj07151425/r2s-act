from tools import wwinp_to_h5m
from nose.tools import assert_equal
import os
from itaps import iMesh, iBase
from r2s.scdmesh import ScdMesh

def test_wwinp_to_h5m():
    thisdir = os.path.dirname(__file__)
    wwinp = os.path.join(thisdir, 'files_test_wwinp_to_h5m/wwinp_test_e')
    output = os.path.join(os.getcwd(), 'wwinp_mesh.h5m')
    
    if output in os.listdir('.'):
        os.remove(output)
    
    wwinp_to_h5m.cartesian(wwinp, output)
    
    expected_sm = ScdMesh.fromFile(os.path.join(thisdir, 'files_test_wwinp_to_h5m/expected_ww_mesh.h5m'))
    written_sm = ScdMesh.fromFile(output)
    
    #verify weight window lower bounds are the same
    for x in range(0,14):
        for y in range(0,8):
            for z in range(0,6):
                expected_voxel = expected_sm.getHex(x,y,z)
                expected = expected_sm.imesh.getTagHandle('ww_n_group_001')[expected_voxel]
                written_voxel = written_sm.getHex(x,y,z)
                written = written_sm.imesh.getTagHandle('ww_n_group_001')[written_voxel]
                assert_equal(written, expected)

    #verify correct particle identifier
    assert_equal(written_sm.imesh.getTagHandle('particle')[written_sm.imesh.rootSet], 1)

    #verify correct energy upper bounds
    expected_E = [1E-9, 1E-8, 1E-7, 1E-6, 1E-5, 1E-4, 1E-3]
    written_E = written_sm.imesh.getTagHandle('E_upper_bounds')[written_sm.imesh.rootSet]
    
    for i in range(0, len(expected_E)):
        assert_equal(written_E[i], expected_E[i])

    os.remove(output)


# Run as script
#
if __name__ == "__main__":
    test_wwinp_to_h5m()
