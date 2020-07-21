FROM bioconductor/bioconductor_docker:devel
COPY . /
RUN R --quiet -e "BiocManager::install(strsplit(read.dcf('DESCRIPTION')[,'Imports'], '\n')[[1]])"
RUN R --quiet -e "BiocManager::install('bookdown')"
RUN R --quiet -e "BiocManager::install('LTLA/rebook')"
