# Daphnia_Displacement_Analysis

This repository contains a MATLAB script for analyzing the **displacement scaling behavior** of Daphnia trajectories.  

The script calculates displacement for each individual relative to its starting point, averages across all tracked Daphnia, and performs **log-log scaling analysis** to test for power-law trends in motion.

This script can be viewed as **Step 2A of the Daphnia motion pipeline**, focusing on displacement before angular/cumulative rotation analysis.

---

## Research Background
This code was developed as part of an undergraduate research project at **CUNY Queens College**, under the supervision of **Dr. Oleg Kogan (Physics Department)** and **Dr. Sebastian Alvarado (Biology Department)**.  

The displacement behavior of Daphnia is a key measure in collective motion studies, providing insight into **diffusion-like spreading, motility, and behavioral scaling**.

---

## Features
- Loads trajectory data for **all Daphnia** in dataset  
- Computes displacement relative to starting position  
- Calculates **average displacement** across all individuals  
- Visualizes:
  - All displacement trajectories  
  - Average displacement over time  
  - Log-log scaling of displacement  
  - Piecewise fits for early vs. late time regimes  

---

## Input
CSV files (from TREX) for each Daphnia, containing:
- `X`, `Y` positions  
- `Time` stamps  
- `fps` values  

---

## Output
- **Plots**:
  - Individual displacement vs. time
  - Average displacement vs. time
  - Log-log scaling plots with piecewise fits  
- **Fitted equations** (slope and intercept) displayed on plot annotation  

---

## Use Case
This script is useful for analyzing **motility scaling** in Daphnia populations, testing whether displacement follows **diffusion-like or anomalous scaling laws**.

---

## Dependencies
- MATLAB (tested on R2022b)  
- Optimization Toolbox (`lsqcurvefit` function)  

---

## Usage
1. Place `.csv` files in the appropriate folder  
2. Set in the script:
   - `base` = dataset name  
   - `inputDir` = folder containing `<base>_csv` files  
   - `N` = number of Daphnia in dataset  
3. Run the script in MATLAB  
4. View the generated plots and fits  

---
