# Install Podman


```bash
# On macOS
brew install podman

```

    Running `brew update --auto-update`...
    ==> Auto-updated Homebrew!
    Updated 3 taps (guillem-riera/qemu, homebrew/core and homebrew/cask).
    
    You have 1 outdated formula installed.
    You can upgrade it with brew upgrade
    or list it with brew outdated.
    
    Warning: podman 4.1.1 is already installed and up-to-date.
    To reinstall 4.1.1, run:
      brew reinstall podman
    



## Optional: Podman Compose

Podman compose is the equivalent to docker compose.


```bash
brew install podman-compose
```

    Running `brew update --auto-update`...
    ==> Auto-updated Homebrew!
    Updated 7 taps (guillem-riera/qemu, homebrew/cask-versions, homebrew/core, homebrew/cask, homebrew/cask-drivers, minio/stable and aws/tap).
    ==> New Casks
    ccprofiler
    
    You have 3 outdated formulae installed.
    You can upgrade them with brew upgrade
    or list them with brew outdated.
    
    Warning: podman-compose 1.0.3 is already installed and up-to-date.
    To reinstall 1.0.3, run:
      brew reinstall podman-compose
    



## Optional: Docker Socket

It is possible that podman creates a socket for Docker so that there is no need for the DOCKER_HOST environment variable.
This is performed by the bundled `podman-mac-helper` tool.

**Note** Don't run the command from this notebook unless you have setup passwordless sudo.


```bash
sudo podman-mac-helper install
```
