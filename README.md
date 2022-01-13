# sem-fem
Scanning electron microscopy (SEM) image based finite-element models (FEM)

This code was developed to generate scanning electron microscopy (SEM) image-based finite-element models (FEM) to explore the influence of collagen fiber-level organization on tissue-level mechanics. In this framework, fiber directions are first measured from the SEM images and then used to assign fiber directions in the FEM. A baseline FEM is required, with model geometry matching the size of the SEM images and the boundary conditions and material properties of interest. FEMs are run in FeBio 2.9 and must be in an FeBio compatible format (.xml). 

The ‘SEMFEMCode’ folder contains all of the required functions for this analysis. ‘Test_blank’ contains example inputs and ‘Test_complete’ contains the results after running this code. Note that the folder structure is set up such that multiple images can be processed at once, see ‘Test_blank’ for example setup. 

See below for outline of components of this code:

Inputs
•	SEM Images (.tif)
•	Baseline FeBio Model (.xml)
Main Code
•	CodeOverview_final.m
Functions called in main code
•	ImageMeasurments_final.m
•	FeBioGen_final.m
•	Reformat_final.m
•	Calcmeans_final.m
Outputs
Images folder:
•	Fiber directions per image window (.xlsx)
Models folder: 
•	FeBio model file (.xml)
•	FeBio Postview file (.xplt)
Outputs folder:
•	Image analysis measurements (.xlsx)
•	Calculated stiffness measurements (.xlsx)


