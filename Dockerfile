FROM pytorch/pytorch:latest

# Install dependencies
RUN apt-get update && apt-get install -y git sudo

# Install requirements
COPY requirements.txt /requirements.txt
RUN --mount=type=cache,target=/root/.cache \
    pip install -r /requirements.txt

# Override the default jupyter notebook configs
RUN mkdir -p /opt/conda/share/jupyter/lab/settings
COPY overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json

# Add non-root user
RUN adduser --disabled-password --gecos "" devcontainer
RUN echo "devcontainer:devcontainer" | chpasswd

# Add user to sudoers
RUN echo "devcontainer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to user
USER devcontainer

# Run jupyter lab
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser"]
