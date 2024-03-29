# Cube 123d
Various discretizations of 01_steady_flow test. 
Useful for scaling parallel tests.

Benchmarks on the cube mesh:
```
flow_bddc_fieldformula.yaml     - steady MH flow (BDDC) (Fieldformula field in assembly)
flow_bddc.yaml                  - steady MH flow (BDDC) 
flow_fv.yaml                    - steady MH flow (Petsc) + FV solute transport
flow_unsteady_dg.yaml           - unsteady MH flow + DG solute transport  
                                
flow_LMH_dg_heat.yaml           - unsteady LMH flow + DG heat
flow_LMH_richards.yaml          - unsteady LMH Richards
                                
flow_dg_sorption.yaml           - steady MH flow + DG solute transport + sorption
flow_fv_sorption.yaml           - steady MH flow + FV transport + sorption
```                        

Mesh for this benchmark is:

<p align="center">
  <img src='cube.png' alt='Cube mesh' width=400 />
</p>


