FROM google/cloud-sdk

#FROM ubuntu:12.04

MAINTAINER Allen Day "allenday@allenday.com"

ENV BUILD_PACKAGES="make gcc wget zlib1g-dev git g++ cmake"
ENV IMAGE_PACKAGES="bwa samtools picard-tools vcftools"

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install $BUILD_PACKAGES $IMAGE_PACKAGES

## cleanup
#RUN apt-get -y remove --purge $BUILD_PACKAGES
#RUN apt-get -y remove --purge $(apt-mark showauto)
#RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --recursive git://github.com/ekg/freebayes.git
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.1-3/sratoolkit.2.8.1-3-ubuntu64.tar.gz

WORKDIR /opt
RUN tar -xvzf sratoolkit.2.8.1-3-ubuntu64.tar.gz
RUN mv sratoolkit.2.8.1-3-ubuntu64 sratoolkit
RUN rm sratoolkit.2.8.1-3-ubuntu64.tar.gz

WORKDIR /opt/freebayes
RUN make


