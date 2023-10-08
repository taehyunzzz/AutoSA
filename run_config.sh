./autosa ./autosa_tests/large/mm/kernel.c \
--config=./autosa_config/autosa_config.json \
--target=autosa_hls_c \
--output-dir=./autosa.tmp/output \
--sa-sizes="{kernel[]->space_time[5];kernel[]->array_part[260,256,512];kernel[]->latency[20,16];kernel[]->simd[8]}" \
--simd-info=./autosa_tests/large/mm/simd_info.json \
--host-serialize \
--hls