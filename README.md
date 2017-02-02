# Installation

1. Clone the repo into your project `$ git clone https://github.com/cnanders/matlab-point.git`
2. Add the repo to the MATLAB path `addpath('matlab-npoint');`
3. Access methods through namespace, i.e., lc400 = nPoint.LC400.LC400();

This repo is collection of namespaced packages.  

# Recommended project structure

* project
  * libs
    * lib-a
    * lib-b
  * pkgs
    * +nPoint
	* +pkg-a
	* +pkg-b
  * classes
    * ClassA.m
    * ClassB.m
  * tests
  	* TestClassA.m
  	* TestClassB.m
  * README.md (list lib dependencies)
  * .git
  * .gitignore (should ignore /lib)