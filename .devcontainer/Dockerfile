# The platform is needed for those of use with toy computers with apple silicon
FROM --platform=linux/amd64 mcr.microsoft.com/vscode/devcontainers/base:dev-bullseye

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Args
ARG USERNAME=developer
ARG USER_UID=1001
ARG USER_GID=1001

#VERSION ARGS
ARG TFLINT_VERSION=0.20.1

USER root
# Get our scripts tghat we'll use to configure the container
COPY --chown=root:root ./root-install-scripts /tmp/root-scripts
# Create a non-root user to use if preferred
RUN sudo /tmp/root-scripts/non-root-user.sh ${USERNAME} ${USER_UID} ${USER_GID}

# Install Terraform
RUN sudo /tmp/root-scripts/install-terraform.sh

# Install Kubectl
RUN sudo /tmp/root-scripts/install-kubectl.sh

# Install python
RUN sudo /tmp/root-scripts/install-python.sh

# Become that user
USER $USERNAME

# Copy the scripts used to set up the dev container
COPY --chown=$USERNAME:$USER_GID  ./install-scripts /tmp/scripts

# Instal some common tools
RUN sudo bash /tmp/scripts/common-tools.sh ${USERNAME}

# Install Az CLI. We do this first as it also installs the Microsoft gpg signing key
RUN sudo bash /tmp/scripts/install-azcli.sh ${USERNAME}

# Install azbrowse
RUN sudo bash /tmp/scripts/install-azbrowse.sh ${USERNAME}

# Install GOLANG
RUN sudo bash /tmp/scripts/install-go.sh

# Install .NET
RUN /tmp/scripts/install-dotnet.sh

# Configure zsh
ENV TERM xterm
ENV SHELL /bin/zsh
RUN bash /tmp/scripts/install-oh-my-zsh.sh

# Copy our dot files
COPY --chown=$USERNAME:$USER_GID ./dotfiles /home/$USERNAME

# SET PATH
ENV PATH="$PATH:/home/$USERNAME/bin:/usr/local/go/bin:/home/$USERNAME/.dotnet"