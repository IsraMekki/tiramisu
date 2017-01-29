#ifndef HALIDE__build___wrapper_blurxy_o_h
#define HALIDE__build___wrapper_blurxy_o_h

#include <tiramisu/utils.h>

#ifdef __cplusplus
extern "C" {
#endif

int blurxy_tiramisu(buffer_t *_b_input_buffer, buffer_t *_b_blury_buffer) HALIDE_FUNCTION_ATTRS;
int blurxy_tiramisu_argv(void **args) HALIDE_FUNCTION_ATTRS;
int blurxy_ref(buffer_t *_b_input_buffer, buffer_t *_b_blury_buffer) HALIDE_FUNCTION_ATTRS;
int blurxy_ref_argv(void **args) HALIDE_FUNCTION_ATTRS;
// Result is never null and points to constant static data
const struct halide_filter_metadata_t *blurxy_tiramisu_metadata() HALIDE_FUNCTION_ATTRS;
const struct halide_filter_metadata_t *blurxy_ref_metadata() HALIDE_FUNCTION_ATTRS;

#ifdef __cplusplus
}  // extern "C"
#endif
#endif
