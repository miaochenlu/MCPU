# Details

Date : 2022-05-31 22:10:27

Directory c:\Users\Dell 7080\Desktop\Coding\MCPU

Total : 52 files,  2365 codes, 341 comments, 420 blanks, all 3126 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [cache/sim/cache_2way_tb.v](/cache/sim/cache_2way_tb.v) | Verilog | 47 | 0 | 10 | 57 |
| [cache/sim/cache_way_tb.v](/cache/sim/cache_way_tb.v) | Verilog | 41 | 0 | 8 | 49 |
| [cache/src/cache_2way.v](/cache/src/cache_2way.v) | Verilog | 63 | 0 | 6 | 69 |
| [cache/src/cache_controller.v](/cache/src/cache_controller.v) | Verilog | 0 | 257 | 24 | 281 |
| [cache/src/cache_controller_tmp.v](/cache/src/cache_controller_tmp.v) | Verilog | 293 | 12 | 38 | 343 |
| [cache/src/cache_ram.v](/cache/src/cache_ram.v) | Verilog | 35 | 3 | 7 | 45 |
| [cache/src/cache_way.v](/cache/src/cache_way.v) | Verilog | 68 | 7 | 11 | 86 |
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