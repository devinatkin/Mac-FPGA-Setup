# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode for APT to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt update -y && apt install -y \
    git wget xz-utils curl \
    cmake make ninja-build clang bison flex \
    libboost-all-dev libgmp-dev libmpfr-dev libmpc-dev \
    libffi-dev libeigen3-dev autoconf pkg-config \
    libftdi1-dev libusb-1.0-0-dev \
    python3 python3-pip python3-setuptools python3-venv && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Clone the F4PGA examples repository
RUN git clone https://github.com/chipsalliance/f4pga-examples /opt/f4pga-examples

# Set the installation directory for F4PGA tools
ENV F4PGA_INSTALL_DIR=/opt/f4pga

# Select the FPGA family (e.g., Xilinx 7-Series "xc7" or QuickLogic EOS S3 "eos-s3")
ENV FPGA_FAM=xc7

# Set working directory
WORKDIR /opt/f4pga-examples

# Determine system architecture and download the appropriate Miniconda installer
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget "$MINICONDA_URL" -O conda_installer.sh && \
    bash conda_installer.sh -u -b -p $F4PGA_INSTALL_DIR/$FPGA_FAM/conda && \
    rm conda_installer.sh


# Use bash explicitly to source conda
RUN ls -l /opt/f4pga-examples/$FPGA_FAM && \
    . "$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh" && \
    conda env create -f "/opt/f4pga-examples/$FPGA_FAM/environment.yml"



# Set environment variables for FPGA packages
ENV F4PGA_PACKAGES='install-xc7 xc7a50t_test xc7a100t_test xc7a200t_test xc7z010_test'

# Create the installation directory
RUN mkdir -p $F4PGA_INSTALL_DIR/$FPGA_FAM

# Define the timestamp and hash for the toolchain package version
ENV F4PGA_TIMESTAMP=20220920-124259
ENV F4PGA_HASH=007d1c1

# Download and extract the F4PGA toolchain
RUN for PKG in $F4PGA_PACKAGES; do \
      wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/${F4PGA_TIMESTAMP}/symbiflow-arch-defs-${PKG}-${F4PGA_HASH}.tar.xz | \
      tar -xJC $F4PGA_INSTALL_DIR/${FPGA_FAM}; \
    done

# Add F4PGA environment setup to .bashrc for persistence in interactive shells
RUN echo 'export F4PGA_INSTALL_DIR=/opt/f4pga' >> ~/.bashrc && \
    echo 'export FPGA_FAM="xc7"' >> ~/.bashrc && \
    echo 'source "$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh"' >> ~/.bashrc && \
    echo 'conda activate $FPGA_FAM' >> ~/.bashrc

# Set working directory
WORKDIR /opt/f4pga-examples

# Default command to start an interactive shell
CMD ["/bin/bash"]
