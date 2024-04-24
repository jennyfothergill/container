FROM mambaorg/micromamba:1.5.8-bookworm-slim

ENV MAMBA_DOCKERFILE_ACTIVATE=1
ENV ENV_NAME=cautorift

RUN apt update && apt install -y libgl1 && \
    apt clean
RUN micromamba create -n cautorift -c conda-forge python autorift=1.1.0 \
    notebook matplotlib pandas opencv rasterio && \
    micromamba clean --all --yes
ENV SITEPACKAGES=`micromamba run -n cautorift python -m site \
    | grep -m 1 site-packages | sed "s/[,']//g"`
ENV AUTORIFT=${SITEPACKAGES}/autoRIFT/autoRIFT.py
RUN sed -i 's/np.bool/bool/g' $AUTORIFT && \
    sed -i 's/np.int/int/g' $AUTORIFT
ENV SITEPACKAGES=
ENV AUTORIFT=
