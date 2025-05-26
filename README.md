# RakuRtool
A specialized tool for rapidly generating publication-quality dimensionality reduction plots, tailored for structural biology and biostatistics research./一个专门用于结构生物学，生物统计学方面的降维的快速绘制科研等级的图片。

This project was independently developed by me as an undergraduate student during my research work. My major is pharmacy, not computer science, so there may be some bugs or imperfections in the code. I sincerely appreciate your understanding and any academic suggestions or feedback you may have./该项目是我本科期间独立开发的，属于我的研究工作。我并非计算机专业，而是药学专业的学生，因此代码中可能会有一些bug或不完善的地方。非常感谢您的包容与任何学术建议或反馈！

---
## Install RakuRtool
Both the RakuRtool installation archive and the package source files have been uploaded to this page.
>```r
>install.packages("path/to/RakuRtool_0.1.0.tar.gz", repos = NULL, type = "source")
>```
 To install the package from GitHub, run:
> 
> ```r
> devtools::install_github("YukawaRaku/RakuRtool")
> ```
## Checking and Installing Dependencies
Before using the main functions of this package, please make sure that all required dependencies are installed.
The package provides a helper function to check for missing dependencies and automatically install them if necessary.
>```r
>check_RakuDimVis_dependencies() # Check which dependencies are installed or missing
>check_RakuDimVis_dependencies(auto_install = TRUE) # To automatically install any missing packages, set auto_install = TRUE
>```
>This function will:
This function checks for installed and missing dependencies, automatically installs any that are missing if auto_install = TRUE, and loads all required packages so you can use the package immediately.

Required dependencies include:
	•	ggplot2
	•	ggrepel
	•	viridis
	•	ggnewscale
	•	uwot
	•	Rtsne
	•	gridExtra

---
## Input File Format

### Features File (`features.csv`)

- Each **row** represents a sample; each **column** represents a feature (e.g., gene expression, protein descriptor, etc.).
- The **first column** should contain unique sample names or IDs and will be used as row names.
- The **first row** contains column headers (feature names).
- All other values should be numeric.

**Example (`features.csv`):**
```csv
SampleID,Feature1,Feature2,Feature3
SampleA,0.23,5.2,1.1
SampleB,0.14,3.8,0.9
SampleC,0.37,6.0,1.3
```
### Label File (`label.csv`)

- Should be a **single-column CSV file** (The **first column** should contain unique sample names).
- The order of labels must exactly match the sample order in the features file.
- Labels can be numeric (for continuous variables) or categorical (for group analysis).

**Example (`label.csv`):**
```csv
Number
0.91
0.74
0.88
```
