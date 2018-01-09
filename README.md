# docker-immportgalaxy
**Version:** 16.07-alpha (based on ImmPort-Galaxy's customization of Galaxy 16.07)

**Note:** *This is an Alpha release intended to test configuration and deployment of cusom immunogenomics tools to the ImmPort-Galaxy platform. It will be updated to a more stable release to include a Postgres database and additional file management services, potentially with a connection to remote execution in AWS.*


##  ImmPort-Galaxy Deployment on Ubuntu

Built against the master branch of the [ImmPortDB/ImmPort-Galaxy](https://github.com/ImmPortDB/immport-galaxy) project on GitHub on an updated Ubuntu 16.04 LTS release.


## Usage
The docker container runs the Galaxy server under a `galaxy` user account in `\home\docker\`.

```shell
# get the latest ImmPort-Galaxy build
> docker pull infotechsoft/immportgalaxy:latest

# start Galaxy server on port 8080
> docker run -d -p 8080:8080 --name immport-galaxy infotechsoft/immportgalaxy:latest

 # follow the Galaxy server startup/logs
 > docker logs -f immport-galaxy

# interactive (shell)
docker run -it -p 8080:8080 --name immport-galaxy infotechsoft/immportgalaxy:latest /bin/bash
 # start the Galaxy server
 > sh ./run.sh
 
# cleanup (remove the immport-galaxy container)
docker rm immport-galaxy
```

## Building
**Note:** Building from the `Dockerfile` may take approximately an hour and involve significant Internet usage as the ImmPort-Galaxy prerequites are downloaded, built, installed, and updated. It is recommended to run using the Docker image on Docker Hub.

```shell
# build an image, tagging it "immport-galaxy"
> docker build . -t immport-galaxy
```

## Related Projects
[<img src="https://immportgalaxy.org/static/images/flowtools/home/immportgalaxy_green_sharp.png" height=80px/>](https://immportgalaxy.org/)

[<img src="http://www.immport.org/immport-open/resources/images/home/immport-main-icon.png" height=48px/>](http://www.immport.org/)
 
[<img src="https://galaxyproject.org/images/galaxy-logos/galaxy_logo_25percent.png" height="48px"/>](https://galaxyproject.org/)

[<img src="https://assets.ubuntu.com/v1/4e9b777c-ubuntu-orange-on-white.gif" height="48px"/>](https://www.ubuntu.com/)


## Build Details
 * **Ubuntu Version:** 16.04 LTS
 * **ImmPort-Galaxy Version:** master [https://github.com/ImmPortDB/immport-galaxy](https://github.com/ImmPortDB/immport-galaxy)
 * **Galaxy Version:** 16.07 (ImmPort-Galaxy customization)
 * **Python Version:** 2.7.14
 * **R Version:** 3.4.3 (from [cran.rstudio.com](http://cran.rstudio.com))
 * **Bioconductor Version:** 3.6 (from [bioconductor.org](https://bioconductor.org))
 * **Anaconda Version:** 5.0.1 (from [repo.continuum.io](https://repo.continuum.io))

# Maintainer 
![INFOTECH Soft](http://infotechsoft.com/wp-content/uploads/2017/04/InfotechSoft_logo-small.png "INFOTECH Soft, Inc.")