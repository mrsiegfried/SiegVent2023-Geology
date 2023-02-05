# SiegVent2023-Geology 
Code repository for processing data and generating figures from Siegfried\*, Venturelli\*, et al., 2023, _Geology_ (doi: [10.1130/G50995.1](https://doi.org/10.1130/G50995.1)). Code for generating figures in the manuscript, including the `.afdeisgn` file (made with [Affinity Designer](https://affinity.serif.com/en-us/designer/), an Adobe Illustrator alternative) for making adjustments to Figure 4 in future use. See [referencing section](#referencing) for appropriate citations.

Data associated with this repository is [available on Zenodo](https://www.doi.org/10.5281/zenodo.7597019). See [running the notebooks](#running-the-notebooks) for instructions to programmatically download the dataset that will allow the code to run.

## Running the notebooks: 

1. Set up the environment: `conda env create -f environment.yml --name siegvent2023`
2. Activate the kernel: `conda activate siegvent2023`
3. Add the environment to Jupyter as a kernel: `python -m ipykernel install --user --name siegvent2023`
4. Make interactive ipywidgets work by enabling the extension: `jupyter labextension install @jupyter-widgets/jupyterlab-manager`
5. Fire up JupyterLab: `jupyter lab`
6. Install `zenodo_get` to download the data repository by running the following in a command line: `pip install zenodo_get`
7. Download the data repository in a command line: `zenodo_get 10.5281/zenodo.7597019` 
8. Unarchive the data into the current directory in a command line: `unzip data.zip`
9. Open the notebook from the file browser on the left side and hit play on the cells to your heart's content.

## Some notes:

1. The calculation for the scaling ratio between GPS sites on SLM as well as that for scaled height change between low stand and high stand at the drill site is in `figures/plot_siegvent2023_fig1.ipynb` just before the figure is plotted
2. The CT dicom files of the two sediment cores used in this manuscript are included in the data archive as the cores are still in moratorium on on the Oregon State University Marine and Geology Repository. When that is released, we will update this file with a DOI.
3. The calculations for lake sediment thickness are in `plot_siegvent2023_fig2.ipynb`.
4. The calcuations for the likely sedimentation rates and uncertainty around each rate through a multi-Gaussian fit as well as the actual estimation for the age of Mercer Subglacial Lake are in `plot_siegvent2023_fig3_figS2.ipynb`. This file also prints out the information in Table S1.
5. We're happy for you to leave issues on GitHub or email us if you have any questions

## Referencing

If you use code from this repository, please cite both the publication in _Geology_ and the code:

>Siegfried, M. R., Arnuk, W., Venturelli, R. A., and Patterson, M. O. (2023). mrsiegfried/SiegVent2023-Geology code repository (v1.1). Zenodo. https://doi.org/10.5281/ZENODO.7605994

>Siegfried, M. R., Venturelli, R. A., Patterson, M. O., Arnuk, W., Campbell, T. D., Gustafson, C. D., Michaud, A. B., Galton-Fenzi, B. K., Hausner, M. B., Holzschuh, S. N., Huber, B., Mankoff, K. D., Schroeder, D. M., Summers, P., Tyler, S., Carter, S. P., Fricker, H. A., Harwood, D. M., Leventer, A., Rosenheim, B. E., Skidmore, M. L., Priscu, J. C., and the SALSA Science Team. (2023). The life and death of a subglacial lake in West Antarctica. Geology. https://doi.org/10.1130/G50995.1

If you use data associated with this repository, please alose cite both the publication in _Geology_ and the data:

>Siegfried, M. R., Venturelli, R. A., Patterson, M. O., Arnuk, W., Campbell, Gustafson, Chloe D., C. D., Michaud, A. B., Galton-Fenzi, B. K., Hausner, M. B., Holzschuh, S. N., Huber, B., Mankoff, K. D., Schroeder, D. M., Summers, P. T., Tyler, S., Carter, S. P., Fricker, H. A., Harwood, D. M., Leventer, A., Rosenheim, B. E., Skidmore, M. L., Priscu, J. P., and the SALSA Science Team. (2023). Data for Siegfried*, Venturelli*, et al., 2023, Geology (1.0) [Data set]. Zenodo. https://doi.org/10.5281/ZENODO.7597019

>Siegfried, M. R., Venturelli, R. A., Patterson, M. O., Arnuk, W., Campbell, T. D., Gustafson, C. D., Michaud, A. B., Galton-Fenzi, B. K., Hausner, M. B., Holzschuh, S. N., Huber, B., Mankoff, K. D., Schroeder, D. M., Summers, P., Tyler, S., Carter, S. P., Fricker, H. A., Harwood, D. M., Leventer, A., Rosenheim, B. E., Skidmore, M. L., Priscu, J. C., and the SALSA Science Team. (2023). The life and death of a subglacial lake in West Antarctica. Geology. https://doi.org/10.1130/G50995.1
