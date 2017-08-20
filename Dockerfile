FROM rocker/tidyverse
COPY . /usr/local/src/scripts
COPY ./scripts/* /usr/local/src/scripts
WORKDIR /usr/local/src/scripts
RUN apt-get update; \
    apt-get -y upgrade

RUN apt-get -y install cmake
RUN apt-get install -y x11vnc xvfb firefox
RUN mkdir ~/.vnc
#
RUN Rscript myantsr.R
RUN wget https://github.com/stnava/ITKR/releases/download/latest/ITKR_0.4.12_R_x86_64-pc-linux-gnu.tar.gz
RUN R CMD INSTALL ITKR_0.4.12_R_x86_64-pc-linux-gnu.tar.gz
RUN wget https://github.com/stnava/ANTsRCore/releases/download/v0.4.2.1/ANTsRCore_0.4.2.1_R_x86_64-pc-linux-gnu.tar.gz
RUN R CMD INSTALL ANTsRCore_0.4.2.1_R_x86_64-pc-linux-gnu.tar.gz
RUN wget https://github.com/stnava/ANTsR/releases/download/latest/ANTsR_0.6_R_x86_64-pc-linux-gnu.tar.gz
RUN R CMD INSTALL ANTsR_0.6_R_x86_64-pc-linux-gnu.tar.gz
# RUN Rscript -e 'rmarkdown::render("antsRegistrationInto.Rmd")'
VOLUME /data /tmp /usr/local/src/scripts
# Setup a password
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
# Autostart R (might not be the best way, but it does the trick)
RUN bash -c 'echo "R" >> /.bashrc'

EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
