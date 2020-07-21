FROM bioconductor/bioconductor_docker:devel
COPY . /
RUN sudo apt-get update
RUN sudo apt-get install -y libglpk-dev
RUN R --quiet -e "BiocManager::install(strsplit(read.dcf('DESCRIPTION')[,'Imports'], '\n')[[1]])"
RUN R --quiet -e "BiocManager::install('bookdown')"
RUN R --quiet -e "BiocManager::install('LTLA/rebook')"
