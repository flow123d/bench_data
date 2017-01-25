# bench_data
Sources for  generating large data for Flow123d benchmarks.

## Benchmarks on Cube123d

flow_bddc_fieldformula.yaml     - steady MH flow (BDDC) (Fieldformula field in assembly)
flow_bddc.yaml                  - steady MH flow (BDDC) 
flow_fv.yaml                    - steady MH flow (Petsc) + FV solute transport
flow_unsteady_dg.yaml           - unsteady MH flow + DG solute transport  
                                
flow_LMH_dg_heat.yaml           - unsteady LMH flow + DG heat
flow_LMH_richards.yaml          - unsteady LMH Richards
                                
flow_dg_sorption.yaml           - steady MH flow + DG solute transport + sorption
flow_fv_sorption.yaml           - steady MH flow + FV transport + sorption

