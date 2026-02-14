# Boosting Methods for Interval-Censored Data with Regression and Classification

**Yuan Bian**, Grace Y. Yi, and Wenqing He (2025).  
*Boosting methods for interval-censored data with regression and classification.*  
In **The 13th International Conference on Learning Representations (ICLR 2025)**.  
https://openreview.net/pdf?id=DzbUL4AJPP

---

## Overview

This repository provides the implementation of the proposed $L_2$ boosting methods for interval-censored data, supporting both regression and classification settings. It also includes scripts for data simulation and example usage.

---

## Repository Structure

### Setup

- **`install_packages.R`**  
  Installs all required R packages for running the code.

### Core Algorithms

- **`L2BOOST-CUT.R`**  
  Implements the core function for the $L_2$Boost-CUT algorithm.

- **`L2BOOST-IMP.R`**  
  Implements the core function for the $L_2$Boost-IMP algorithm.

### Utilities

- **`help_funcs.R`**  
  Contains helper functions for data simulation and supporting computations.

### Example

- **`example.R`**  
  Demonstrates how to simulate interval-censored data and apply the proposed algorithms.

---

## Reproducing Results

To replicate the numerical results reported in the paper:

1. Install required packages by running `install_packages.R`.
2. Set the simulation parameters in `example.R` according to the configurations described in the paper.
3. Run `example.R` repeatedly (e.g., across multiple seeds).
4. For large-scale simulations, parallel execution on a computing cluster is recommended.

---

## Citation

If you use this code in your research, please cite:

Bian, Y., Yi, G. Y., & He, W. (2025). Boosting methods for interval-censored data with regression and classification. In *the 13th International Conference on Learning Representations*.
