#include <isl/set.h>
#include <isl/union_map.h>
#include <isl/union_set.h>
#include <isl/ast_build.h>
#include <isl/schedule.h>
#include <isl/schedule_node.h>

#include <tiramisu/debug.h>
#include <tiramisu/core.h>

#include <string.h>
#include <Halide.h>

using namespace tiramisu;

void generate_function_1(std::string name, int size, int val0, int val1)
{
    tiramisu::global::set_default_tiramisu_options();

    tiramisu::function function0(name);
    tiramisu::expr e_N = tiramisu::expr((int32_t) size);
    tiramisu::constant N("N", e_N, p_int32, true, NULL, 0, &function0);
    tiramisu::expr e1 = tiramisu::expr(tiramisu::o_add,
                               tiramisu::expr((uint8_t) val0),
                               tiramisu::expr((uint8_t) val1));
    tiramisu::computation S0("[N]->{S0[i,j]: 0<=i<N and 0<=j<N}", e1, true, p_uint8, &function0);

    tiramisu::buffer buf0("buf0", 2, {size,size}, tiramisu::p_uint8, NULL,
                      a_output, &function0);
    S0.set_access("{S0[i,j]->buf0[i,j]}");
    S0.tile(1,3,2,2);
    S0.tag_parallel_dimension(0);

    function0.set_arguments({&buf0});
    function0.gen_time_processor_domain();
    function0.gen_isl_ast();
    function0.gen_halide_stmt();
    function0.gen_halide_obj("build/generated_fct_test_02.o");
}


int main(int argc, char **argv)
{
    generate_function_1("assign_7_to_100x100_2D_array_with_tiling_parallelism", 100, 3, 4);

    return 0;
}
