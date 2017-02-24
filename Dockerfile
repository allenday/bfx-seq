FROM google/cloud-sdk

MAINTAINER Allen Day "allenday@allenday.com"

ENV BUILD_PACKAGES="make gcc wget zlib1g-dev git g++ cmake"
ENV IMAGE_PACKAGES="bwa samtools picard-tools vcftools nginx"

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install $BUILD_PACKAGES $IMAGE_PACKAGES

## cleanup
RUN apt-get -y remove --purge $BUILD_PACKAGES
RUN apt-get -y remove --purge $(apt-mark showauto)
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --recursive git://github.com/ekg/freebayes.git
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.1-3/sratoolkit.2.8.1-3-ubuntu64.tar.gz
RUN mkdir bin
COPY bin/fastq-exclude.pl /opt/bin/fastq-exclude.pl

WORKDIR /opt
RUN tar -xvzf sratoolkit.2.8.1-3-ubuntu64.tar.gz
RUN mv sratoolkit.2.8.1-3-ubuntu64 sratoolkit
RUN rm sratoolkit.2.8.1-3-ubuntu64.tar.gz

WORKDIR /opt/freebayes
RUN make

WORKDIR /opt/freebayes/vcflib
RUN make

WORKDIR /opt
RUN ln -s /opt/freebayes/bamtools /opt/bamtools
RUN ln -s /opt/freebayes/vcflib /opt/vcflib
RUN ln -s /opt/freebayes/fastahack /opt/fastahack
RUN ln -s /opt/vcflib/tabixpp/htslib /opt/htslib

WORKDIR /

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
CMD nginx
