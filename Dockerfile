FROM bioconductor/bioconductor_docker:devel

RUN mkdir /home/book/

RUN for x in OSCA OSCA.intro OSCA.basic OSCA.advanced OSCA.multisample OSCA.workflows; \
do \
    git clone https://github.com/OSCA-source/${x} /home/book/${x}; \
    git -C /home/book/${x} checkout master; \
    R --quiet -e "options(warn=2); BiocManager::install(remotes::local_package_deps('/home/book/${x}'))"; \
done

LABEL name="bioconductor/bioconductor_docker_orchestratingsinglecellanalysis" \
      version="3.13" \
      date="2022-02-13" \
      url="https://github.com/Bioconductor/OrchestratingSingleCellAnalysis" \
      maintainer="infinite.monkeys.with.keyboards@gmail.com" \
      description="Build environment and source files for the OSCA books (Bioconductor 3.13)" \
      license="CC BY 4.0"

RUN mkdir /home/cache
ENV EXPERIMENT_HUB_CACHE /home/cache/ExperimentHub
ENV EXPERIMENT_HUB_ASK FALSE
ENV ANNOTATION_HUB_CACHE /home/cache/AnnotationHub
ENV XDG_CACHE_HOME /home/cache
