# SiegVent2023-Geology
Repo for processing data and generating figures from Siegfried\*, Venturelli\*, et al. (2023). The life and death of a subglacial lake in West Antarctica, *Geology*. 

\[put a short description here\]


Running the notebook: 

1. Set up the environment: `conda env create -f environment.yml --name siegvent2023`
2. Activate the kernel: `conda activate siegvent2023`
3. Add the environment to Jupyter as a kernel: `python -m ipykernel install --user --name siegvent2023`
4. Make interactive ipywidgets work by enabling the extension: `jupyter labextension install @jupyter-widgets/jupyterlab-manager`
5. Fire up JupyterLab: `jupyter lab`
6. Open the notebook from the file browser on the left side and hit play on the cells to your heart's content.

Some notes:

1. The calculation for the scaling ratio between GPS sites on SLM as well as that for scaled height change between low stand and high stand at the drill site is in `figures/plot_siegvent2023_fig1.ipynb` just before the figure is plotted
2. The CT dicom files of the two sediment cores used in this manuscript are included in the data archive as the cores are still in moratorium on on the Oregon State University Marine and Geology Repository. When that is released, we will update this file with a DOI.
3. The calculations for lake sediment thickness are in `plot_siegvent2023_fig2.ipynb`.
4. The calcuations for the optimal sedimentation rates and uncertainty around each rate through a multi-Gaussian fit as well as the actual estimation for the age of Mercer Subglacial Lake are in `plot_siegvent2023_fig3.ipynb`. This file also prints out the information in Table S1.
