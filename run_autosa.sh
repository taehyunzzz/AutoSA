# mm : fail https://autosa.readthedocs.io/en/latest/examples/mm.html
# mm_int16 : passed with array_partition[8,8,8], latency[4,4]

./autosa ./autosa_tests/mm_int16/kernel.c \
--config=./autosa_config/autosa_config.json \
--target=autosa_hls_c \
--output-dir=./autosa.tmp/output \
--sa-sizes="{kernel[]->space_time[3];kernel[]->array_part[8,8,8];kernel[]->latency[4,4];kernel[]->simd[2]}" \
--simd-info=./autosa_tests/mm_int16/simd_info.json \
--host-serialize

cp ${AUTOSA_ROOT}/autosa_tests/mm/Makefile ${AUTOSA_ROOT}/autosa.tmp/output/
cp ${AUTOSA_ROOT}/autosa_tests/mm/connectivity.cfg ${AUTOSA_ROOT}/autosa.tmp/output/

echo "Change Makefile for emu mode and set DRAM depth in kernel0 code"
echo "Remember to export emulation mode"