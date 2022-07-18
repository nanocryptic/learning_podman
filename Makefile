.phony : start install_jupyter_tools trust

INSTALL_PODMAN_NB = 00_Install_Podman.ipynb
INSTALL_JUPYTER_NB = 00_Install_Jupyter.ipynb
PODMAN_SETUP_NB = 01_Podman_Setup.ipynb

start: trust
	jupyter notebook

trust:
	jupyter trust *.ipynb


install_jupyter_tools:
	pip3 install -r jupyter_tools/requirements.txt

