FROM bioconductor/bioconductor_docker:devel

RUN mkdir /home/book
COPY . /home/book

RUN apt-get update \
  && apt-get install --no-install-recommends -y libglpk-dev \
  && rm -rf /var/lib/apt/lists/*

RUN R --quiet -e "BiocManager::install(setdiff(strsplit(read.dcf('DESCRIPTION')[,'Imports'], ',\n')[[1]], 'rebook'))" \
  && R --quiet -e "BiocManager::install('bookdown')" \
  && R --quiet -e "BiocManager::install('LTLA/rebook')"

RUN mkdir /home/cache
ENV EXPERIMENT_HUB_CACHE /home/cache/ExperimentHub
ENV ANNOTATION_HUB_CACHE /home/cache/AnnotationHub
ENV XDG_CACHE_HOME /home/cache
