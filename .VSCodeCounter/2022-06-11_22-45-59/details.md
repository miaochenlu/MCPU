# Details

Date : 2022-06-11 22:45:59

Directory c:\\Users\\Dell 7080\\Desktop\\Coding\\MCPU

Total : 81 files,  4096 codes, 247 comments, 685 blanks, all 5028 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [cache/sim/cache_2way_tb.v](/cache/sim/cache_2way_tb.v) | Verilog | 62 | 0 | 9 | 71 |
| [cache/sim/mem_hier_tb.v](/cache/sim/mem_hier_tb.v) | Verilog | 75 | 0 | 13 | 88 |
| [cache/sim/memory_tb.v](/cache/sim/memory_tb.v) | Verilog | 37 | 5 | 6 | 48 |
| [cache/src/cache_2way.v](/cache/src/cache_2way.v) | Verilog | 69 | 0 | 6 | 75 |
| [cache/src/cache_controller.v](/cache/src/cache_controller.v) | Verilog | 305 | 16 | 38 | 359 |
| [cache/src/cache_ram.v](/cache/src/cache_ram.v) | Verilog | 45 | 3 | 6 | 54 |
| [cache/src/cache_way.v](/cache/src/cache_way.v) | Verilog | 84 | 7 | 14 | 105 |
| [cache/src/defines.vh](/cache/src/defines.vh) | Verilog | 9 | 0 | 2 | 11 |
| [cache/src/mem_hier.v](/cache/src/mem_hier.v) | Verilog | 55 | 0 | 5 | 60 |
| [cache/src/memory.v](/cache/src/memory.v) | Verilog | 35 | 0 | 6 | 41 |
| [o3cpu/sim/rs_alu_tb.v](/o3cpu/sim/rs_alu_tb.v) | Verilog | 108 | 0 | 12 | 120 |
| [o3cpu/sim/rs_lsq_tb.v](/o3cpu/sim/rs_lsq_tb.v) | Verilog | 114 | 0 | 13 | 127 |
| [o3cpu/src/IF_IS.v](/o3cpu/src/IF_IS.v) | Verilog | 37 | 0 | 5 | 42 |
| [o3cpu/src/alu.v](/o3cpu/src/alu.v) | Verilog | 41 | 1 | 8 | 50 |
| [o3cpu/src/bra.v](/o3cpu/src/bra.v) | Verilog | 34 | 0 | 5 | 39 |
| [o3cpu/src/cdb.v](/o3cpu/src/cdb.v) | Verilog | 19 | 0 | 3 | 22 |
| [o3cpu/src/decoder.v](/o3cpu/src/decoder.v) | Verilog | 115 | 16 | 24 | 155 |
| [o3cpu/src/defines.vh](/o3cpu/src/defines.vh) | Verilog | 58 | 0 | 11 | 69 |
| [o3cpu/src/hazard.v](/o3cpu/src/hazard.v) | Verilog | 5 | 0 | 4 | 9 |
| [o3cpu/src/imm_gen.v](/o3cpu/src/imm_gen.v) | Verilog | 13 | 0 | 2 | 15 |
| [o3cpu/src/issue_queue.v](/o3cpu/src/issue_queue.v) | Verilog | 0 | 60 | 13 | 73 |
| [o3cpu/src/lsq.v](/o3cpu/src/lsq.v) | Verilog | 19 | 0 | 4 | 23 |
| [o3cpu/src/mcpu.v](/o3cpu/src/mcpu.v) | Verilog | 228 | 19 | 41 | 288 |
| [o3cpu/src/mux21_32.v](/o3cpu/src/mux21_32.v) | Verilog | 9 | 0 | 3 | 12 |
| [o3cpu/src/mux41_32.v](/o3cpu/src/mux41_32.v) | Verilog | 14 | 0 | 3 | 17 |
| [o3cpu/src/operandA_manager.v](/o3cpu/src/operandA_manager.v) | Verilog | 34 | 2 | 5 | 41 |
| [o3cpu/src/operandB_manager.v](/o3cpu/src/operandB_manager.v) | Verilog | 34 | 2 | 5 | 41 |
| [o3cpu/src/pc.v](/o3cpu/src/pc.v) | Verilog | 16 | 0 | 2 | 18 |
| [o3cpu/src/ram.v](/o3cpu/src/ram.v) | Verilog | 51 | 0 | 5 | 56 |
| [o3cpu/src/rat.v](/o3cpu/src/rat.v) | Verilog | 64 | 8 | 10 | 82 |
| [o3cpu/src/reorder_buffer.v](/o3cpu/src/reorder_buffer.v) | Verilog | 101 | 11 | 20 | 132 |
| [o3cpu/src/rom.v](/o3cpu/src/rom.v) | Verilog | 11 | 0 | 3 | 14 |
| [o3cpu/src/rs_alu.v](/o3cpu/src/rs_alu.v) | Verilog | 93 | 8 | 19 | 120 |
| [o3cpu/src/rs_bra.v](/o3cpu/src/rs_bra.v) | Verilog | 94 | 8 | 17 | 119 |
| [o3cpu/src/rs_lsq.v](/o3cpu/src/rs_lsq.v) | Verilog | 178 | 19 | 26 | 223 |
| [o3cpu/src/rs_manager.v](/o3cpu/src/rs_manager.v) | Verilog | 12 | 0 | 1 | 13 |
| [pipeline_cpu/sim/IF_ID_tb.v](/pipeline_cpu/sim/IF_ID_tb.v) | Verilog | 27 | 9 | 7 | 43 |
| [pipeline_cpu/sim/alu_tb.v](/pipeline_cpu/sim/alu_tb.v) | Verilog | 26 | 4 | 6 | 36 |
| [pipeline_cpu/sim/ctrl_unit_tb.v](/pipeline_cpu/sim/ctrl_unit_tb.v) | Verilog | 21 | 0 | 3 | 24 |
| [pipeline_cpu/sim/mcpu_tb.v](/pipeline_cpu/sim/mcpu_tb.v) | Verilog | 11 | 0 | 4 | 15 |
| [pipeline_cpu/sim/pc_tb.v](/pipeline_cpu/sim/pc_tb.v) | Verilog | 22 | 0 | 5 | 27 |
| [pipeline_cpu/sim/ram_tb.v](/pipeline_cpu/sim/ram_tb.v) | Verilog | 27 | 0 | 6 | 33 |
| [pipeline_cpu/sim/regfile_tb.v](/pipeline_cpu/sim/regfile_tb.v) | Verilog | 29 | 0 | 7 | 36 |
| [pipeline_cpu/sim/rom_tb.v](/pipeline_cpu/sim/rom_tb.v) | Verilog | 12 | 0 | 4 | 16 |
| [pipeline_cpu/src/EX_MEM.v](/pipeline_cpu/src/EX_MEM.v) | Verilog | 67 | 0 | 4 | 71 |
| [pipeline_cpu/src/ID_EX.v](/pipeline_cpu/src/ID_EX.v) | Verilog | 120 | 10 | 3 | 133 |
| [pipeline_cpu/src/IF_ID.v](/pipeline_cpu/src/IF_ID.v) | Verilog | 37 | 0 | 6 | 43 |
| [pipeline_cpu/src/MEM_WB.v](/pipeline_cpu/src/MEM_WB.v) | Verilog | 52 | 0 | 3 | 55 |
| [pipeline_cpu/src/alu.v](/pipeline_cpu/src/alu.v) | Verilog | 36 | 1 | 7 | 44 |
| [pipeline_cpu/src/branch.v](/pipeline_cpu/src/branch.v) | Verilog | 15 | 0 | 4 | 19 |
| [pipeline_cpu/src/ctrl_unit.v](/pipeline_cpu/src/ctrl_unit.v) | Verilog | 117 | 10 | 25 | 152 |
| [pipeline_cpu/src/defines.v](/pipeline_cpu/src/defines.v) | Verilog | 48 | 0 | 8 | 56 |
| [pipeline_cpu/src/forward_unit.v](/pipeline_cpu/src/forward_unit.v) | Verilog | 42 | 0 | 4 | 46 |
| [pipeline_cpu/src/hazard_unit.v](/pipeline_cpu/src/hazard_unit.v) | Verilog | 24 | 0 | 3 | 27 |
| [pipeline_cpu/src/imm_gen.v](/pipeline_cpu/src/imm_gen.v) | Verilog | 14 | 0 | 3 | 17 |
| [pipeline_cpu/src/mcpu.v](/pipeline_cpu/src/mcpu.v) | Verilog | 354 | 13 | 48 | 415 |
| [pipeline_cpu/src/mux21_32.v](/pipeline_cpu/src/mux21_32.v) | Verilog | 9 | 0 | 3 | 12 |
| [pipeline_cpu/src/mux41_32.v](/pipeline_cpu/src/mux41_32.v) | Verilog | 14 | 0 | 4 | 18 |
| [pipeline_cpu/src/pc.v](/pipeline_cpu/src/pc.v) | Verilog | 16 | 0 | 3 | 19 |
| [pipeline_cpu/src/ram.v](/pipeline_cpu/src/ram.v) | Verilog | 48 | 0 | 6 | 54 |
| [pipeline_cpu/src/regfile.v](/pipeline_cpu/src/regfile.v) | Verilog | 27 | 0 | 7 | 34 |
| [pipeline_cpu/src/rom.v](/pipeline_cpu/src/rom.v) | Verilog | 11 | 0 | 4 | 15 |
| [single_cycle_cpu/sim/alu_tb.v](/single_cycle_cpu/sim/alu_tb.v) | Verilog | 26 | 4 | 6 | 36 |
| [single_cycle_cpu/sim/ctrl_unit_tb.v](/single_cycle_cpu/sim/ctrl_unit_tb.v) | Verilog | 21 | 0 | 3 | 24 |
| [single_cycle_cpu/sim/mcpu_tb.v](/single_cycle_cpu/sim/mcpu_tb.v) | Verilog | 11 | 0 | 4 | 15 |
| [single_cycle_cpu/sim/pc_tb.v](/single_cycle_cpu/sim/pc_tb.v) | Verilog | 21 | 0 | 5 | 26 |
| [single_cycle_cpu/sim/ram_tb.v](/single_cycle_cpu/sim/ram_tb.v) | Verilog | 21 | 0 | 5 | 26 |
| [single_cycle_cpu/sim/regfile_tb.v](/single_cycle_cpu/sim/regfile_tb.v) | Verilog | 29 | 0 | 7 | 36 |
| [single_cycle_cpu/sim/rom_tb.v](/single_cycle_cpu/sim/rom_tb.v) | Verilog | 12 | 0 | 4 | 16 |
| [single_cycle_cpu/src/alu.v](/single_cycle_cpu/src/alu.v) | Verilog | 36 | 1 | 7 | 44 |
| [single_cycle_cpu/src/branch.v](/single_cycle_cpu/src/branch.v) | Verilog | 15 | 0 | 4 | 19 |
| [single_cycle_cpu/src/ctrl_unit.v](/single_cycle_cpu/src/ctrl_unit.v) | Verilog | 112 | 10 | 24 | 146 |
| [single_cycle_cpu/src/defines.v](/single_cycle_cpu/src/defines.v) | Verilog | 41 | 0 | 7 | 48 |
| [single_cycle_cpu/src/imm_gen.v](/single_cycle_cpu/src/imm_gen.v) | Verilog | 14 | 0 | 3 | 17 |
| [single_cycle_cpu/src/mcpu.v](/single_cycle_cpu/src/mcpu.v) | Verilog | 113 | 0 | 23 | 136 |
| [single_cycle_cpu/src/mux21_32.v](/single_cycle_cpu/src/mux21_32.v) | Verilog | 9 | 0 | 3 | 12 |
| [single_cycle_cpu/src/mux41_32.v](/single_cycle_cpu/src/mux41_32.v) | Verilog | 14 | 0 | 4 | 18 |
| [single_cycle_cpu/src/pc.v](/single_cycle_cpu/src/pc.v) | Verilog | 12 | 0 | 3 | 15 |
| [single_cycle_cpu/src/ram.v](/single_cycle_cpu/src/ram.v) | Verilog | 47 | 0 | 6 | 53 |
| [single_cycle_cpu/src/regfile.v](/single_cycle_cpu/src/regfile.v) | Verilog | 27 | 0 | 7 | 34 |
| [single_cycle_cpu/src/rom.v](/single_cycle_cpu/src/rom.v) | Verilog | 11 | 0 | 4 | 15 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)