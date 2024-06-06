References to ImageJ tools used for data preprocessing and analysis:
	- CSBDeep: https://imagej.net/plugins/csbdeep
	- LocalZProjector: https://forum.image.sc/t/new-fiji-plugin-localzprojector-for-projecting-3d-volumes-on-2d-planes/47697
	- EPySeg: https://doi.org/10.1242/dev.194589

Pre-requisites:

	- MATLAB (v2021b or above): Image Processing Toolbox, Image Labeller application
	- Python (v3.8) -  Matplotlib (v2.2.2), seaborn (v 0.8.1), numpy (v1.19.5), pandas (v0.23.0), scipy (v1.5.4), scikit-learn (v0.21.3), OpenCV (v3.4.1), Tyssue (v 0.8.0)


Breakdown of codes:

1) calcium signaling model:
	- Contains a jupyter notebook (calcium_signaling_model.ipynb) that simulates calcium signaling using the two pool model (Refer to Figure 2F)


2) cell_geom_features_quantifiication_pipeline:
	- The directory contains a MATLAB code "cell_geom_analysis.m" that uses EPySeg generated segmentation masks of cells stained with E.Cadherin for quantifying cell geometric features such as area, anisotropy and circularity (Refer to Figure S9). The inputs to the code have been placed within the subdirectories.
		sub directory 1, ap_mask: Contains binary mask for apterous (for separate quantification in dorsal and ventral compartments)
		sub_directory 2, dcad_mask: Contains EPySeg generated segmentation mask of cell boundaries
		sub_directory 3, tissue_mask: Contains the Region of Interest (ROI) within the pouch where analysis has to be carried out.
	- Note: If ap mask is not available, the user can simply use the pouch mask. This will generate the quantifications twice for the same pouch but would make the code still usable. 


3) epithelia simulation model:
	- The directory contains the codes for simulating the epithelia using Python package Tyssue. The code is properly documented and is available in the form of a jupyter notebook (tyssue_epithelia_simulations.ipynb). Refer to Figure 6 and Figure S11 for more details.


4) main figure data analysis and visualization:
	- The directory contains python codes for data visualization and statistics of sub components of main manuscript figures. Each subdirectory has been labelled appropriately to describe the figure it is referenced to. For Figure 2, please refer to "calcium signaling model" directory.


5) neighborhood_quantification_pipeline:
	- The directory contains a MATLAB code "cell_neighborhood_analysis.m" that uses EPySeg generated segmentation masks of cells stained with E.Cadherin for quantifying the number of neighbors of each cell within a user specified ROI (Refer to Figure S). The inputs to the code have to be placed within the subdirectories.
		sub directory 1, ap_mask: Contains binary mask for apterous (for separate quantification in dorsal and ventral compartments)
		sub_directory 2, dcad_mask: Contains EPySeg generated segmentation mask of cell boundaries
		sub_directory 3, tissue_mask: Contains the Region of Interest (ROI) within the pouch where analysis has to be carried out.
	- Note: If ap mask is not available, the user can simply use the pouch mask. This will generate the quantifications twice for the same pouch but would make the code still usable.
