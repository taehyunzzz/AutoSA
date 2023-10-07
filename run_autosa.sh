export XCL_EMULATION_MODE=sw_emu

if [[ 1 == 1 ]]; then
    # mm : https://autosa.readthedocs.io/en/latest/examples/mm.html
    # - sw_emu failed
    # - hw_emu 
    # - hw
    TEST_NAME=mm
    OUTPUT_DIR=./test_${TEST_NAME}
    rm -rf ${OUTPUT_DIR}
    cp -r autosa.tmp ${OUTPUT_DIR}
    ./autosa ./autosa_tests/mm/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[2,2,2];kernel[]->latency[1,1];kernel[]->simd[2]}" \
    --simd-info=./autosa_tests/mm/simd_info.json \
    --hls \
    --host-serialize
    # --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[64,64,64];kernel[]->latency[4,4];kernel[]->simd[8]}" \
    # --data-pack-sizes="{kernel[]->[4,32,64]}" \
    echo ""
    echo ""
fi

if [[ 0 == 1 ]]; then
    # mm_int16 : 
    #   - sw_emu passed! with array_partition[8,8,8], latency[4,4] 
    #   - hw_emu passed!
    #   - hw
    TEST_NAME=mm_int16
    OUTPUT_DIR=./test_${TEST_NAME}
    rm -rf ${OUTPUT_DIR}
    cp -r autosa.tmp test_${TEST_NAME}
    ./autosa ./autosa_tests/mm_int16/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,1024,1024];kernel[]->latency[2,2];kernel[]->simd[32]}" \
    --simd-info=./autosa_tests/mm_int16/simd_info.json \
    --host-serialize \
    --autosa-verbose \
    --hls
    echo ""
    echo ""
    # good config
    # --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,1024,1024];kernel[]->latency[2,2];kernel[]->simd[16]}" \
fi

if [[ 0 == 1 ]]; then
    # mm_hbm : 
    #   - sw_emu 
    #   - hw_emu 
    #   - hw
    TEST_NAME=mm_hbm_hls
    OUTPUT_DIR=./test_${TEST_NAME}
    rm -rf ${OUTPUT_DIR}
    cp -r autosa.tmp test_${TEST_NAME}
    ./autosa ./autosa_tests/mm_hbm/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[32,32,32];kernel[]->latency[8,8];kernel[]->simd[2];kernel[]->hbm_A[2];kernel[]->hbm_B[2];kernel[]->hbm_C_drain[2]}" \
    --simd-info=./autosa_tests/mm_hbm/simd_info.json \
    --hls \
    --hbm
    echo ""
    echo ""
fi

echo "Running ${TEST_NAME}"

cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/hls_script.tcl ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/
cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/Makefile ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/
cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/connectivity.cfg ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/

echo "Change Makefile for emu mode and set DRAM depth in kernel0 code"
echo "Remember to export emulation mode"