# ===========================================
# infotechsoft/immportgalaxy 
# ===========================================
# ==================================
# infotechsoft/immport-galaxy
# ----------------------------------
# 2018-01-05
# thomas@infotechsoft.com
# ==================================

FROM ubuntu:latest AS immportgalaxy
# TODO - Add/Configure Postgres
# TODO - Update Galaxy Configuration
# TODO - Configure HTTPS
# TODO - Add/Configure Ansible
# TODO - Add/Configure HTCondor
LABEL name="infotechsoft/immport-galaxy" \
	release-date="2018-01-05" \
	description="ImmPortGalaxy on Ubuntu" \
	immportgalaxy.url="https://github.com/ImmPortDB/immport-galaxy" \
	maintainer="Thomas J. Taylor <thomas@infotechsoft.com>"

ARG GALAXY_RELEASE
ARG GALAXY_REPO

ENV GALAXY_RELEASE=${GALAXY_RELEASE:-master} \
	GALAXY_REPO=${GALAXY_REPO:-https://github.com/ImmPortDB/immport-galaxy.git} \
	GALAXY_HOME=/home/galaxy \
	GALAXY_CONFIG_FILE=/home/galaxy/config/galaxy.ini \
	GALAXY_USER=galaxy \
	GALAXY_GID=1001 \
	GALAXY_UID=1001 \
	GALAXY_VIRTUAL_ENV=/home/galaxy/.venv \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US:en \ 
	LC_ALL=en_US.UTF-8 \
	PATH=$PATH:/opt/conda/bin

# Configure Locale to en_US.UTF-8
# Add RStudio repo to get the latest R for Ubuntu 16.04
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \ 
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
	apt-get -qq update && \
	apt-get -qq -y install \
		curl \
		gfortran g++ \ 
		git \
		libbz2-dev \
		libcurl4-openssl-dev \
		libglu1-mesa-dev \
		libhdf5-dev \
		libhdf5-serial-dev \
		liblzma-dev \
		libpcre3-dev \ 
		libreadline-dev \
		libx11-dev \
		libxml2-dev \
		locales \
		mesa-common-dev \
		python2.7 \
		python-dev \
		python-pip \
		python-virtualenv \
		r-base \
		r-base-dev \
		xorg-dev && \
	apt-get -qq clean && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i -e 's/# ${LANG} UTF-8/${LANG} UTF-8/' /etc/locale.gen && \
	locale-gen ${LANG} && \
	dpkg-reconfigure --frontend $DEBIAN_FRONTEND locales

# Add initialization and configuration files
COPY ./src/ /tmp/
	
# Create GALAXY_USER
# Retrieve the Galaxy source files (ImmPort-Galaxy 16.07)
RUN groupadd -r $GALAXY_USER -g $GALAXY_GID && \
    useradd -u $GALAXY_UID -r -g $GALAXY_USER -d $GALAXY_HOME -c "Galaxy user" $GALAXY_USER && \
	git clone $GALAXY_REPO $GALAXY_HOME && \
	chown -R $GALAXY_USER:$GALAXY_USER $GALAXY_HOME && \
	cp /tmp/galaxy.ini $GALAXY_CONFIG_FILE

	
WORKDIR $GALAXY_HOME
	
# Install required python packages in the galaxy virtual environment (.venv):
RUN	pip install --upgrade pip && \
	pip install --upgrade virtualenv && \
	virtualenv $GALAXY_VIRTUAL_ENV --distribute && \
	chown -R $GALAXY_USER:$GALAXY_USER $GALAXY_VIRTUAL_ENV && \
	. $GALAXY_VIRTUAL_ENV/bin/activate && \
	pip install -r /tmp/pip-requirements.txt && \
	./scripts/common_startup.sh --no-create-venv --no-replace-pip

# Install required Bioconductor packages
RUN Rscript /tmp/r-requirements.R
	
# ImmPort Galaxy supports auto-detection of FCS files, with the following dependency
RUN curl -o /tmp/anaconda.sh https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh && \
    /bin/bash /tmp/anaconda.sh -b -p /opt/conda && \
	mv /tmp/.condarc /opt/conda/.condarc && \
	conda update -y --all && \
	conda install -y ig-checkFCS && \
    rm /tmp/*

# Compile FLOCK. The binaries are included in $GALAXY_HOME/tools/flowtools/src.
RUN cd ./tools/flowtools/bin && \
	cc -o flock1 ../src/flock1.c ../src/find_connected.c -lm && \
	cc -o flock2 ../src/flock2.c -lm && \
	cc -o cent_adjust ../src/cent_adjust.c -lm
	
EXPOSE 8080
USER $GALAXY_USER

# Initializes and starts up Galaxy
CMD ["sh", "run.sh"]