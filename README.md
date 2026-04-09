# Testing and Validation of Automated Driving Systems

## Overview
This project focuses on evaluating and optimizing automated driving systems (ADS) under diverse and uncertain traffic conditions. Using simulation tools, the system performance is analyzed through key safety metrics such as Time-to-Collision (TTC) and crash probability.

## Objective
- Evaluate the performance of automated driving systems under varying conditions  
- Analyze the impact of parameters such as vehicle mass, time gap, and communication delay  
- Ensure system safety and robustness using simulation-based validation  

## Tools & Technologies
- MATLAB / Simulink  
- SUMO (Simulation of Urban Mobility)  
- TraCI (Traffic Control Interface)  

## Methodology

### Simulation Environment
- Integrated **SUMO with MATLAB/Simulink using TraCI** for realistic traffic scenarios :contentReference[oaicite:1]{index=1}  
- Simulated dynamic environments with varying traffic density and vehicle behavior  

### Parameter Exploration
- Investigated key system parameters:
  - Vehicle mass  
  - Time gap (Adaptive Cruise Control)  
  - Standstill distance  
  - Communication delay  

### Sampling Technique
- Applied **Latin Hypercube Sampling (LHS)** for efficient exploration of parameter space :contentReference[oaicite:2]{index=2}  
- Generated diverse simulation scenarios:
  - Model A: 200 simulations  
  - Model B: 300 simulations  

### System Testing
- Tested system under:
  - Uncertainty conditions  
  - Dynamic traffic scenarios  
  - Communication delays  

### Key Performance Indicators (KPIs)

- Minimum Distance  
- Time-to-Collision (TTC)  
- Crash Rate  
- Danger Rate :contentReference[oaicite:3]{index=3}  

## Results

- Identified critical conditions leading to unsafe behavior  
- Observed correlation between:
  - Distance error and minimum distance  
  - Speed error and TTC  
- Highlighted system vulnerabilities under high uncertainty  

## Key Features
- Large-scale simulation-based testing (500+ scenarios)  
- Advanced sampling using LHS for robust evaluation  
- KPI-driven performance analysis  
- Integration of traffic simulation with control systems  

## Applications
- Autonomous vehicle validation  
- Advanced Driver Assistance Systems (ADAS)  
- Safety analysis in automotive systems  

## Future Work
- Integration with real-time vehicle data  
- Implementation of improved control strategies  
- Testing with more complex urban environments  

## Author
Sudip Kishan Sarker  
MSc Autonomous Vehicle Engineering  
University of Naples Federico II
