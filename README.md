# SiegVent2023-Geology 
Repo for processing data and generating figures from Siegfried\*, Venturelli\*, et al. (2023). The life and death of a subglacial lake in West Antarctica, *Geology*, doi: 10.1130/G50995.1. Code for generating every figure in the manuscript except Figure 4 is included. Figure 4 was made in Adobe Illustrator; just let us know if you are interested in the `.ai` file.

Data associated with this repository is [available on Zenodo](https://www.doi.org/10.5281/zenodo.7597019).

If you use code from this repository, please cite your use as:

Matthew R. Siegfried, Will Arnuk, Ryan A. Venturelli, & Molly Patterson. (2023). mrsiegfried/SiegVent2023-Geology (v1.1). Zenodo. https://doi.org/10.5281/zenodo.7605994.

If you use data associated with this repository, please cite your use as:

Siegfried, Matthew R., Venturelli, Ryan A., Patterson, Molly O., Arnuk, William, Campbell, Timothy D., Gustafson, Chloe D., Michaud, Alexander B., Galton-Fenzi, Benjamin K., Hausner, Mark B., Holzschuh, Stephanie N., Huber, Bruce, Mankoff, Kenneth D., Schroeder, Dustin M., Summers, Paul, Tyler, Scott, Carter, Sasha P., Fricker, Helen A., Harwood, David M., Leventer, Amy, … SALSA Science Team. (2023). Data for Siegfried*, Venturelli*, et al., 2023, Geology [Data set]. In Geology (1.0). Zenodo. https://doi.org/10.5281/zenodo.7597019.


Running the notebook: 

1. Set up the environment: `conda env create -f environment.yml --name siegvent2023`
2. Activate the kernel: `conda activate siegvent2023`
3. Add the environment to Jupyter as a kernel: `python -m ipykernel install --user --name siegvent2023`
4. Make interactive ipywidgets work by enabling the extension: `jupyter labextension install @jupyter-widgets/jupyterlab-manager`
5. Fire up JupyterLab: `jupyter lab`
6. Install `zenodo_get` to download the data repository by running the following in a command line: `pip install zenodo_get`
7. Download the data repository in a command line: `zenodo_get 10.5281/zenodo.7597019` 
8. Unarchive the data into the current directory in a command line: `unzip data.zip`
9. Open the notebook from the file browser on the left side and hit play on the cells to your heart's content.

Some notes:

1. The calculation for the scaling ratio between GPS sites on SLM as well as that for scaled height change between low stand and high stand at the drill site is in `figures/plot_siegvent2023_fig1.ipynb` just before the figure is plotted
2. The CT dicom files of the two sediment cores used in this manuscript are included in the data archive as the cores are still in moratorium on on the Oregon State University Marine and Geology Repository. When that is released, we will update this file with a DOI.
3. The calculations for lake sediment thickness are in `plot_siegvent2023_fig2.ipynb`.
4. The calcuations for the optimal sedimentation rates and uncertainty around each rate through a multi-Gaussian fit as well as the actual estimation for the age of Mercer Subglacial Lake are in `plot_siegvent2023_fig3.ipynb`. This file also prints out the information in Table S1.
5. We're happy for you to leave issues on GitHub or email us if you have any questions
