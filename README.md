# sem-fem
Scanning electron microscopy (SEM) image based finite-element models (FEM)

This code was developed to generate scanning electron microscopy (SEM) image-based finite-element models (FEM) to explore the influence of collagen fiber-level organization on tissue-level mechanics. In this framework, fiber directions are first measured from the SEM images and then used to assign fiber directions in the FEM. A baseline FEM is required, with model geometry matching the size of the SEM images and the boundary conditions and material properties of interest. FEMs are run in FeBio 2.9 and must be in an FeBio compatible format (.xml). 

The files here contain all of the required functions and example inputs for this analysis. ‘Test_images’ contains example SEM images and ‘Test_complete’ contains the results after running this code. Note that the folder structure is set up such that multiple images can be processed at once with input image in \Images, model saved in \Models, and outputs saved in \Outputs. See ‘Test_complete’ for example setup and outputs. 

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

Code developed by Ridhi Sahani and published in the Journal of Applied Physiology.
Citation will be updated upon publication, see pre-print: https://www.biorxiv.org/content/10.1101/2021.04.07.438870v1
Contact rs8te@virginia.edu with and questions or comments.
