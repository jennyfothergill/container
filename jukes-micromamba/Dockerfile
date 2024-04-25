FROM mambaorg/micromamba:1.5.8-bookworm-slim

USER root
RUN apt update && \
    apt install -y libgl1 && \
    apt clean
USER $MAMBA_USER
RUN micromamba create -n cautorift -c conda-forge python autorift=1.1.0 \
        notebook matplotlib pandas opencv rasterio && \
    micromamba clean --all --yes
ENV AUTORIFT=opt/conda/envs/cautorift/lib/python3.9/site-packages/autoRIFT/autoRIFT.py
RUN sed -i 's/np.bool/bool/g' $AUTORIFT && \
    sed -i 's/np.int/int/g' $AUTORIFT

ENV AUTORIFT=
ENV MAMBA_DOCKERFILE_ACTIVATE=1
ENV ENV_NAME=cautorift
