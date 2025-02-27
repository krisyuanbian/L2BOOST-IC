# Boosting methods for interval-censored data with regression and classification

Boosting has garnered significant interest across both machine learning and statistical communities. Traditional boosting algorithms, designed for fully observed random samples, often struggle with real-world problems, particularly with interval-censored data. This type of data is common in survival analysis and time-to-event studies where exact event times are unobserved but fall within known intervals. Effective handling of such data is crucial in fields like medical research, reliability engineering, and social sciences. In this work, we introduce novel nonparametric boosting methods for regression and classification tasks with interval-censored data. Our approaches leverage censoring unbiased transformations to adjust loss functions and impute transformed responses while maintaining model accuracy. Implemented via functional gradient descent, these methods ensure scalability and adaptability. We rigorously establish their theoretical properties, including optimality and mean squared error trade-offs, offering solid guarantees. Our proposed methods not only offer a robust framework for enhancing predictive accuracy in domains where interval-censored data are common but also complement existing work, expanding the applicability of existing boosting techniques. Empirical studies demonstrate robust performance across various finite-sample scenarios, highlighting the practical utility of our approaches.

#### Reference

**Yuan Bian**, Grace Y. Yi, and Wenqing He (2025), Boosting methods for interval censored data with regression and classification. In *Thirteenth International Conference on Learning Representations*.

#### Code

* The .R file **"install_packages.R"** contains the codes to install the necessary packages.

* The .R file **"help_funcs.R"** contains help functions to simulate data.

* The .R file **"L2BOOST-CUT.R"** contains the core function for the $L_2$Boost-CUT algorithm.

* The .R file **"L2BOOST-IMP.R"** contains the core function for the $L_2$Boost-IMP algorithm.

* The .R file **"example.R"** is an example showing how to simulate the data and use our proposed algorithms.

To replicate the results in the paper, specify the parameters in **"example.R"** as described in the paper, and run it multiple times on a cluster.
