# Boosting methods for interval-censored data with regression and classification

**Yuan Bian**, Grace Y. Yi, and Wenqing He (2025), Boosting methods for interval censored data with regression and classification. In *The 13th International Conference on Learning Representations*. https://openreview.net/pdf?id=DzbUL4AJPP

This repository contains the implementation and example usage of the proposed method. The structure is as follows:

---

#### Code

* The .R file **"install_packages.R"** contains the codes to install the necessary packages.

* The .R file **"help_funcs.R"** contains help functions to simulate data.

* The .R file **"L2BOOST-CUT.R"** contains the core function for the $L_2$Boost-CUT algorithm.

* The .R file **"L2BOOST-IMP.R"** contains the core function for the $L_2$Boost-IMP algorithm.

* The .R file **"example.R"** is an example showing how to simulate the data and use our proposed algorithms.

To replicate the results in the paper, specify the parameters in **"example.R"** as described in the paper, and run it multiple times on a cluster.
