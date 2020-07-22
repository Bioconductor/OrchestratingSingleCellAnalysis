FROM bioconductor/bioconductor_docker:devel

COPY . /

RUN apt-get update \
  && apt-get install --no-install-recommends -y libglpk-dev \
  && rm -rf /var/lib/apt/lists/*

RUN R --quiet -e "BiocManager::install(strsplit(read.dcf('DESCRIPTION')[,'Imports'], ',\n')[[1]])" \
  && R --quiet -e "BiocManager::install('bookdown')" \
  && R --quiet -e "BiocManager::install('LTLA/rebook')"

ENV EXPERIMENT_HUB_CACHE /ExperimentHub
ENV ANNOTATION_HUB_CACHE /AnnotationHub
ENV XDG_CACHE_HOME /
