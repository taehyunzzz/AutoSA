export XCL_EMULATION_MODE=sw_emu

if [[ 0 == 1 ]]; then
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
    --sa-sizes="{kernel[]->space_time[4];kernel[]->array_part[64,64,64];kernel[]->latency[2,2];kernel[]->simd[8]}" \
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
    #   - hls Csim: pass
    #   - sw_emu 
    #   - hw_emu 
    #   - hw
    TEST_NAME=mm_hbm
    OUTPUT_DIR=./test_${TEST_NAME}_vitis
    rm -rf ${OUTPUT_DIR}
    cp -r autosa.tmp ${OUTPUT_DIR}
    ./autosa ./autosa_tests/mm_hbm/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,512,32];\
                kernel[]->latency[4,4];kernel[]->simd[16];\
                kernel[]->hbm_A[4];kernel[]->hbm_B[16];kernel[]->hbm_C_drain[4]}" \
    --simd-info=./autosa_tests/mm_hbm/simd_info.json \
    --hbm-port-num=31 \
    --hbm
    # --hls \
    # A small toy SA sample with high latency hiding
    # 2x128 output stationary SA
    # --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,512,32];\
    #             kernel[]->latency[4,4];kernel[]->simd[16];\
    #             kernel[]->hbm_A[4];kernel[]->hbm_B[16];kernel[]->hbm_C_drain[4]}" \
    echo ""
    echo ""
fi

if [[ 1 == 1 ]]; then

    TEST_NAME=large/mm
    OUTPUT_DIR=./test_${TEST_NAME}
    rm -rf ${OUTPUT_DIR}
    mkdir -p ${OUTPUT_DIR}
    cp -r autosa.tmp/* ${OUTPUT_DIR}/
    ./autosa ./autosa_tests/large/mm/kernel.c \
    --config=./autosa_config/autosa_config.json \
    --target=autosa_hls_c \
    --output-dir=${OUTPUT_DIR}/output \
    --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[4,128,128]; \
                kernel[]->latency[2,2];kernel[]->simd[4]}" \
    --simd-info=./autosa_tests/large/mm/simd_info.json \
    --host-serialize
    # --hls \
    # 2x64 prototype SA model
    # --sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[4,128,128]; \
    #             kernel[]->latency[2,2];kernel[]->simd[4]}" \
    echo ""
    echo ""

fi
echo "Running ${TEST_NAME}"

cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/hls_script.tcl ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/
cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/Makefile ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/
cp ${AUTOSA_ROOT}/autosa_tests/${TEST_NAME}/connectivity.cfg ${AUTOSA_ROOT}/${OUTPUT_DIR}/output/

echo "Change Makefile for emu mode and set DRAM depth in kernel0 code"
echo "Remember to export emulation mode"