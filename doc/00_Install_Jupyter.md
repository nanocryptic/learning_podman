# Install Jupyter Tools


```bash
pip3 install -r jupyter_tools/requirements.txt
```

    DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
    Requirement already satisfied: jupyter in /opt/homebrew/lib/python3.9/site-packages (from -r jupyter_tools/requirements.txt (line 1)) (1.0.0)
    Requirement already satisfied: nbconvert in /opt/homebrew/lib/python3.9/site-packages (from -r jupyter_tools/requirements.txt (line 2)) (6.5.0)
    Requirement already satisfied: bash_kernel in /opt/homebrew/lib/python3.9/site-packages (from -r jupyter_tools/requirements.txt (line 3)) (0.7.2)
    Requirement already satisfied: ipywidgets in /opt/homebrew/lib/python3.9/site-packages (from jupyter->-r jupyter_tools/requirements.txt (line 1)) (7.7.1)
    Requirement already satisfied: qtconsole in /opt/homebrew/lib/python3.9/site-packages (from jupyter->-r jupyter_tools/requirements.txt (line 1)) (5.3.1)
    Requirement already satisfied: ipykernel in /opt/homebrew/lib/python3.9/site-packages (from jupyter->-r jupyter_tools/requirements.txt (line 1)) (6.15.0)
    Requirement already satisfied: notebook in /opt/homebrew/lib/python3.9/site-packages (from jupyter->-r jupyter_tools/requirements.txt (line 1)) (6.4.12)
    Requirement already satisfied: jupyter-console in /opt/homebrew/lib/python3.9/site-packages (from jupyter->-r jupyter_tools/requirements.txt (line 1)) (6.4.4)
    Requirement already satisfied: jupyter-core>=4.7 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (4.10.0)
    Requirement already satisfied: pandocfilters>=1.4.1 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (1.5.0)
    Requirement already satisfied: bleach in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (5.0.1)
    Requirement already satisfied: tinycss2 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (1.1.1)
    Requirement already satisfied: nbclient>=0.5.0 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.6.5)
    Requirement already satisfied: defusedxml in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.7.1)
    Requirement already satisfied: MarkupSafe>=2.0 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (2.1.1)
    Requirement already satisfied: packaging in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (21.3)
    Requirement already satisfied: entrypoints>=0.2.2 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.4)
    Requirement already satisfied: pygments>=2.4.1 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (2.12.0)
    Requirement already satisfied: traitlets>=5.0 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (5.3.0)
    Requirement already satisfied: beautifulsoup4 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (4.11.1)
    Requirement already satisfied: jinja2>=3.0 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (3.1.2)
    Requirement already satisfied: nbformat>=5.1 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (5.4.0)
    Requirement already satisfied: mistune<2,>=0.8.1 in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.8.4)
    Requirement already satisfied: jupyterlab-pygments in /opt/homebrew/lib/python3.9/site-packages (from nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.2.2)
    Requirement already satisfied: pexpect>=4.0 in /opt/homebrew/lib/python3.9/site-packages (from bash_kernel->-r jupyter_tools/requirements.txt (line 3)) (4.8.0)
    Requirement already satisfied: nest-asyncio in /opt/homebrew/lib/python3.9/site-packages (from nbclient>=0.5.0->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (1.5.5)
    Requirement already satisfied: jupyter-client>=6.1.5 in /opt/homebrew/lib/python3.9/site-packages (from nbclient>=0.5.0->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (7.3.4)
    Requirement already satisfied: fastjsonschema in /opt/homebrew/lib/python3.9/site-packages (from nbformat>=5.1->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (2.15.3)
    Requirement already satisfied: jsonschema>=2.6 in /opt/homebrew/lib/python3.9/site-packages (from nbformat>=5.1->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (4.6.1)
    Requirement already satisfied: ptyprocess>=0.5 in /opt/homebrew/lib/python3.9/site-packages (from pexpect>=4.0->bash_kernel->-r jupyter_tools/requirements.txt (line 3)) (0.7.0)
    Requirement already satisfied: soupsieve>1.2 in /opt/homebrew/lib/python3.9/site-packages (from beautifulsoup4->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (2.3.2.post1)
    Requirement already satisfied: six>=1.9.0 in /opt/homebrew/lib/python3.9/site-packages (from bleach->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (1.16.0)
    Requirement already satisfied: webencodings in /opt/homebrew/lib/python3.9/site-packages (from bleach->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.5.1)
    Requirement already satisfied: ipython>=7.23.1 in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (8.4.0)
    Requirement already satisfied: pyzmq>=17 in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (23.2.0)
    Requirement already satisfied: debugpy>=1.0 in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (1.6.0)
    Requirement already satisfied: appnope in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.1.3)
    Requirement already satisfied: matplotlib-inline>=0.1 in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.1.3)
    Requirement already satisfied: psutil in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (5.9.1)
    Requirement already satisfied: tornado>=6.1 in /opt/homebrew/lib/python3.9/site-packages (from ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (6.1)
    Requirement already satisfied: widgetsnbextension~=3.6.0 in /opt/homebrew/lib/python3.9/site-packages (from ipywidgets->jupyter->-r jupyter_tools/requirements.txt (line 1)) (3.6.1)
    Requirement already satisfied: jupyterlab-widgets>=1.0.0 in /opt/homebrew/lib/python3.9/site-packages (from ipywidgets->jupyter->-r jupyter_tools/requirements.txt (line 1)) (1.1.1)
    Requirement already satisfied: ipython-genutils~=0.2.0 in /opt/homebrew/lib/python3.9/site-packages (from ipywidgets->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.2.0)
    Requirement already satisfied: prompt-toolkit!=3.0.0,!=3.0.1,<3.1.0,>=2.0.0 in /opt/homebrew/lib/python3.9/site-packages (from jupyter-console->jupyter->-r jupyter_tools/requirements.txt (line 1)) (3.0.30)
    Requirement already satisfied: terminado>=0.8.3 in /opt/homebrew/lib/python3.9/site-packages (from notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.15.0)
    Requirement already satisfied: argon2-cffi in /opt/homebrew/lib/python3.9/site-packages (from notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (21.3.0)
    Requirement already satisfied: prometheus-client in /opt/homebrew/lib/python3.9/site-packages (from notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.14.1)
    Requirement already satisfied: Send2Trash>=1.8.0 in /opt/homebrew/lib/python3.9/site-packages (from notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (1.8.0)
    Requirement already satisfied: pyparsing!=3.0.5,>=2.0.2 in /opt/homebrew/lib/python3.9/site-packages (from packaging->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (3.0.9)
    Requirement already satisfied: qtpy>=2.0.1 in /opt/homebrew/lib/python3.9/site-packages (from qtconsole->jupyter->-r jupyter_tools/requirements.txt (line 1)) (2.1.0)
    Requirement already satisfied: pickleshare in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.7.5)
    Requirement already satisfied: stack-data in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.3.0)
    Requirement already satisfied: setuptools>=18.5 in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (62.3.2)
    Requirement already satisfied: decorator in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (5.1.1)
    Requirement already satisfied: backcall in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.2.0)
    Requirement already satisfied: jedi>=0.16 in /opt/homebrew/lib/python3.9/site-packages (from ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.18.1)
    Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /opt/homebrew/lib/python3.9/site-packages (from jsonschema>=2.6->nbformat>=5.1->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (0.18.1)
    Requirement already satisfied: attrs>=17.4.0 in /opt/homebrew/lib/python3.9/site-packages (from jsonschema>=2.6->nbformat>=5.1->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (21.4.0)
    Requirement already satisfied: python-dateutil>=2.8.2 in /opt/homebrew/lib/python3.9/site-packages (from jupyter-client>=6.1.5->nbclient>=0.5.0->nbconvert->-r jupyter_tools/requirements.txt (line 2)) (2.8.2)
    Requirement already satisfied: wcwidth in /opt/homebrew/lib/python3.9/site-packages (from prompt-toolkit!=3.0.0,!=3.0.1,<3.1.0,>=2.0.0->jupyter-console->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.2.5)
    Requirement already satisfied: argon2-cffi-bindings in /opt/homebrew/lib/python3.9/site-packages (from argon2-cffi->notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (21.2.0)
    Requirement already satisfied: parso<0.9.0,>=0.8.0 in /opt/homebrew/lib/python3.9/site-packages (from jedi>=0.16->ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.8.3)
    Requirement already satisfied: cffi>=1.0.1 in /opt/homebrew/lib/python3.9/site-packages (from argon2-cffi-bindings->argon2-cffi->notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (1.15.1)
    Requirement already satisfied: pure-eval in /opt/homebrew/lib/python3.9/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.2.2)
    Requirement already satisfied: executing in /opt/homebrew/lib/python3.9/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (0.8.3)
    Requirement already satisfied: asttokens in /opt/homebrew/lib/python3.9/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter->-r jupyter_tools/requirements.txt (line 1)) (2.0.5)
    Requirement already satisfied: pycparser in /opt/homebrew/lib/python3.9/site-packages (from cffi>=1.0.1->argon2-cffi-bindings->argon2-cffi->notebook->jupyter->-r jupyter_tools/requirements.txt (line 1)) (2.21)
    DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
    WARNING: There was an error checking the latest version of pip.
    



## Install the Bash Kernel


```bash
python3 -m bash_kernel install

```

    Installed kernelspec python3 in /usr/local/share/jupyter/kernels/python3
    


