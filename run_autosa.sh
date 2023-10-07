export XCL_EMULATION_MODE=sw_emu

if 0; then
    mm : https://autosa.readthedocs.io/en/latest/examples/mm.html
    - sw_emu (256,256) x (256,256)
    - hw_emu 
    - hw
    TEST_NAME=mm
    OUTPUT_DIR=./test_${TEST_NAME}
    rm -rf ${OUTPUT_DIR}
    cp -r autosa.tmp test_${TEST_NAME}
    ./autosa ./autosa_tests/mm/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[16,16,16];kernel[]->latency[4,4];kernel[]->simd[2]}" \
    --simd-info=./autosa_tests/mm/simd_info.json \
    --host-serialize
fi

if 0; then
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
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,8,8];kernel[]->latency[4,4];kernel[]->simd[2]}" \
    --simd-info=./autosa_tests/mm_int16/simd_info.json \
    --host-serialize
fi


cp ${AUTOSA_ROOT}/autosa_tests/mm/Makefile ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/
cp ${AUTOSA_ROOT}/autosa_tests/mm/connectivity.cfg ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/

echo "Change Makefile for emu mode and set DRAM depth in kernel0 code"
echo "Remember to export emulation mode"