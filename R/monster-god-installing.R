## God script to install several libraries. 


install.packages("RODBC") ## Load Data
install.packages("RMySQL") ## Load Data
install.packages("RPostgresSQL") ## Load Data
install.packages("RSQLite") ## Load Data
install.packages("XLConnect") ## Load Data - Read Microsoft Excel
install.packages("xlsx") ## Load Data - Read Microsoft Excel
install.packages("foreign") ##  Load Data - Want to read a SAS data set into R? Or an SPSS data set? Foreign provides functions that help you load data files from other programs into R.
                 
install.packages("plyr") ##To manipulate data - Essential shortcuts for subsetting, summarizing, rearranging, and joining together data sets. plyr is the go to package for doing "groupwise" operations with your data.
install.packages("reshape2") ##To manipulate data - Tools for changing the layout of your data sets. Use the melt function to convert your data to long format, the layout R likes best.
install.packages("stringr") ##To manipulate data - Easy to learn tools for regular expressions and character strings.
install.packages("lubridate") ##To manipulate data - Tools that make working with dates and times easier.
                 
install.packages("ggplot2") ##To visualize data - R's famous package for making beautiful graphics. ggplot2 lets you use the grammar of graphics to build layered, customizable plots.
install.packages("rgl") ##To visualize data - Interactive 3D visualizations with R
install.packages("googleVis") ##To visualize data - Let's you use Google Chart tools to visualize data in R. Google Chart tools used to be called Gapminder, the graphing software Hans Rosling made famous in hie TED talk.
                 
install.packages("car") ##To model data - car's Anova function is popular for making type II and type III Anova tables.
install.packages("mgcv") ##To model data - Generalized Additive Models
install.packages("lme4/nlme") ##To model data - Linear and Non-linear mixed effects models
install.packages("randomForest") ##To model data - Random forest methods from machine learning
install.packages("multcomp") ##To model data - Tools for multiple comparison testing
install.packages("vcd") ##To model data - Visualization tools and tests for categorical data
install.packages("glmnet") ##To model data - Lasso and elastic-net regression methods with cross validation
install.packages("survival") ##To model data - Tools for survival analysis
install.packages("caret") ##To model data - Tools for training regression and classification models
                 
install.packages("shiny") ##To report results - Easily make interactive, web apps with R. A perfect way to explore data and share findings with non-programmers.
install.packages("knitr") ##To report results - Write R code in your Latex markdown (e.g. HTML) documents. When you run knit, knitr will replace the code with its results and then build your document. The result? Automated reporting. Knitr is integrated straight into RStudio.
install.packages("xtable") ##To report results - The xtable function takes an R object (like a data frame) and returns the latex or HTML code you need to paste a pretty version of the object into your documents. Copy and paste, or pair up with knitr.
install.packages("slidify") ##To report results - Slidify lets you build HTML 5 slide shows straight from R. You write your slides in a combination of R and markdown.
                 
install.packages("sp") ## For Spatial data - Tools for loading and using spatial data including shapefiles.
install.packages("maptools") ## For Spatial data - Tools for loading and using spatial data including shapefiles.
install.packages("maps") ## For Spatial data - Tools for loading and using spatial data including shapefiles. Easy to use map polygons for plots.
install.packages("ggmap") ##For Spatial data - Download street maps straight from Google maps and use them as a background in your ggplots.
                 
install.packages("zoo") ##For Time Series and Financial data - Provides the most popular format for saving time series objects in R.
install.packages("xts") ##For Time Series and Financial data - Very flexible tools for manipulating time series data sets.
install.packages("quantmod") ##For Time Series and Financial data - Tools for downloading financial data, plotting common charts, and doing technical analysis.
                 
install.packages("Rcpp") ##To write high performance R code - Write R functions that call C++ code for lightning fast speed.
install.packages("data.table") ##To write high performance R code - An alternative way to organize data sets for very, very fast operations. Useful for big data.
install.packages("parallel") ##To write high performance R code - Use parallel processing in R to speed up your code or to crunch large data sets.
                 
install.packages("XML") ##To work with the web - Read and create XML documents with R
install.packages("jsonlite") ##To work with the web - Read and create JSON data tables with R
install.packages("httr") ##To work with the web - A set of useful tools for working with http connections
                 
install.packages("devtools") ##To write your own R packages - An essential suite of tools for turning your code into an R package.
install.packages("testthat") ##To write your own R packages - testthat provides an easy way to write unit tests for your code projects.
install.packages("roxygen2") ##To write your own R packages - A quick way to document your R packages. roxygen2 turns inline code comments into documentation pages and builds a package namespace.
                 


install.packages("sqldf") ##Perform SQL Queries
install.packages("forecast") ##Time Series Analysis
install.packages("stringr") ##Manipulate Strings
install.packages("RPostgreSQL") ##SQL Connector
install.packages("RMySQL") ##SQL Connector
install.packages("RMongo") ##SQL Connector
install.packages("RODBC") ##SQL Connector
install.packages("RSQLite") ##SQL Connector
install.packages("lubridate") ##Dates


install.packages("qcc") ##Controle Estatistico de Qualidade
install.packages("reshape2") ##Convert data wide to long
install.packages("wordcloud") ##WordCloud
install.packages('neuralnet') ##NeuralNetworks


install.packages("plyr")  ##Tools for splitting, applying and combining data
install.packages("digest")  ##Create cryptographic hash digests of R objects
install.packages("ggplot2")  ##An implementation of the Grammar of Graphics
install.packages("colorspace")  ##Color Space Manipulation
install.packages("stringr")  ##Make it easier to work with strings
install.packages("RColorBrewer")  ##ColorBrewer palettes
install.packages("reshape2")  ##Flexibly reshape data: a reboot of the reshape package
install.packages("zoo")  ##S3 Infrastructure for Regular and Irregular Time Series (Z's
install.packages("0")  ##ordered observations)
install.packages("proto")  ##Prototype object-based programming
install.packages("scales")  ##Scale functions for graphics
install.packages("car")  ##Companion to Applied Regression
install.packages("dichromat")  ##Color Schemes for Dichromats
install.packages("gtable")  ##Arrange grobs in tables
install.packages("munsell")  ##Munsell colour system
install.packages("labeling")  ##Axis Labeling
install.packages("Hmisc")  ##Harrell Miscellaneous
install.packages("rJava")  ##Low-level R to Java interface
install.packages("mvtnorm")  ##Multivariate Normal and t Distributions
install.packages("bitops")  ##Bitwise Operations
install.packages("rgl")  ##3D visualization device system (OpenGL)
install.packages("foreign")  ##Read Data Stored by Minitab, S, SAS, SPSS, Stata, Systat, dBase,
install.packages("0")  ##..
install.packages("XML")  ##Tools for parsing and generating XML within R and S-Plus
install.packages("lattice")  ##Lattice Graphics
install.packages("e1071")  ##Misc Functions of the Department of Statistics (e1071), TU Wien
install.packages("gtools")  ##Various R programming tools
install.packages("sp")  ##classes and methods for spatial data
install.packages("gdata")  ##Various R programming tools for data manipulation
install.packages("Rcpp")  ##Seamless R and C++ Integration
install.packages("MASS")  ##Support Functions and Datasets for Venables and Ripley's MASS
install.packages("Matrix")  ##Sparse and Dense Matrix Classes and Methods
install.packages("lmtest")  ##Testing Linear Regression Models
install.packages("survival")  ##Survival Analysis
install.packages("caTools")  ##Tools: moving window statistics, GIF, Base64, ROC AUC, etc
install.packages("multcomp")  ##Simultaneous Inference in General Parametric Models
install.packages("RCurl")  ##General network (HTTP/FTP/.) client interface for R
install.packages("knitr")  ##A general-purpose package for dynamic report generation in R
install.packages("xtable")  ##Export tables to LaTeX or HTML
install.packages("xts")  ##eXtensible Time Series
install.packages("rpart")  ##Recursive Partitioning
install.packages("evaluate")  ##Parsing and evaluation tools that provide more details than the
install.packages("0")  ##default
install.packages("RODBC")  ##ODBC Database Access
install.packages("quadprog")  ##Functions to solve Quadratic Programming Problems
install.packages("tseries")  ##Time series analysis and computational finance
install.packages("DBI")  ##R Database Interface
install.packages("nlme")  ##Linear and Nonlinear Mixed Effects Models
install.packages("lme4")  ##Linear mixed-effects models using S4 classes
install.packages("reshape")  ##Flexibly reshape data
install.packages("sandwich")  ##Robust Covariance Matrix Estimators
install.packages("leaps")  ##regression subset selection
install.packages("gplots")  ##Various R programming tools for plotting data
install.packages("abind")  ##Combine multi-dimensional arrays
install.packages("randomForest")  ##Breiman and Cutler's random forests for classification and
install.packages("0")  ##regression
install.packages("Rcmdr")  ##R Commander
install.packages("coda")  ##Output analysis and diagnostics for MCMC
install.packages("maps")  ##Draw Geographical Maps
install.packages("igraph")  ##Network analysis and visualization
install.packages("formatR")  ##Format R Code Automatically
install.packages("maptools")  ##Tools for reading and handling spatial objects
install.packages("RSQLite")  ##SQLite interface for R
install.packages("psych")  ##Procedures for Psychological, Psychometric, and Personality
install.packages("0")  ##Research
install.packages("KernSmooth")  ##Functions for kernel smoothing for Wand &amp Jones (1995)
install.packages("rgdal")  ##Bindings for the Geospatial Data Abstraction Library
install.packages("RcppArmadillo")  ##Rcpp integration for Armadillo templated linear algebra library
install.packages("effects")  ##Effect Displays for Linear, Generalized Linear,
install.packages("0")  ##Multinomial-Logit, Proportional-Odds Logit Models and
install.packages("0")  ##Mixed-Effects Models
install.packages("sem")  ##Structural Equation Models
install.packages("vcd")  ##Visualizing Categorical Data
install.packages("XLConnect")  ##Excel Connector for R
install.packages("markdown")  ##Markdown rendering for R
install.packages("timeSeries")  ##Rmetrics - Financial Time Series Objects
install.packages("timeDate")  ##Rmetrics - Chronological and Calendar Objects
install.packages("RJSONIO")  ##Serialize R objects to JSON, JavaScript Object Notation
install.packages("cluster")  ##Cluster Analysis Extended Rousseeuw et al
install.packages("scatterplot3d")  ##3D Scatter Plot
install.packages("nnet")  ##Feed-forward Neural Networks and Multinomial Log-Linear Models
install.packages("fBasics")  ##Rmetrics - Markets and Basic Statistics
install.packages("forecast")  ##Forecasting functions for time series and linear models
install.packages("quantreg")  ##Quantile Regression
install.packages("foreach")  ##Foreach looping construct for R
install.packages("chron")  ##Chronological objects which can handle dates and times
install.packages("plotrix")  ##Various plotting functions
install.packages("matrixcalc")  ##Collection of functions for matrix calculations
install.packages("aplpack")  ##Another Plot PACKage: stem.leaf, bagplot, faces, spin3R, and
install.packages("0")  ##some slider functions
install.packages("strucchange")  ##Testing, Monitoring, and Dating Structural Changes
install.packages("iterators")  ##Iterator construct for R
install.packages("mgcv")  ##Mixed GAM Computation Vehicle with GCV/AIC/REML smoothness
install.packages("0")  ##estimation
install.packages("kernlab")  ##Kernel-based Machine Learning Lab
install.packages("SparseM")  ##Sparse Linear Algebra
install.packages("tree")  ##Classification and regression trees
install.packages("robustbase")  ##Basic Robust Statistics
install.packages("vegan")  ##Community Ecology Package
install.packages("devtools")  ##Tools to make developing R code easier
install.packages("latticeExtra")  ##Extra Graphical Utilities Based on Lattice
install.packages("modeltools")  ##Tools and Classes for Statistical Models
install.packages("xlsx")  ##Read, write, format Excel 2007 and Excel 97/2000/XP/2003 files
install.packages("slam")  ##Sparse Lightweight Arrays and Matrices
install.packages("TTR")  ##Technical Trading Rules
install.packages("quantmod")  ##Quantitative Financial Modelling Framework
install.packages("relimp")  ##Relative Contribution of Effects in a Regression Model
install.packages("akima")  ##Interpolation of irregularly spaced data
install.packages("memoise")  ##Memoise functions

