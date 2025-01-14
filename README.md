#### devcontainer-template
Development Container with NVIDIA CUDA(ompute Unifieed Device Architecture) support.
```bash
CUDA_VERSION 12.2.2
Python 3.10.12 # Change in Poetry & Dockerfile
```

## Install Dependencies.
This development container utilises poetry for dependency management.

```bash
# Poetry Shell
poetry self add poetry-plugin-shell

# Activate Poetry Environment
poetry shell

# Install Python Package
poetry add <package-name><version>
```

