FROM ghcr.io/3kmfi6hp/argo-airport-paas:main
# Create a new user and group 
RUN groupadd -g 10014 choreo  && \ 
    useradd -u 10014 -g choreo -s /bin/bash -G choreo choreouser

# Set a non-root user 
USER 10014

RUN rm -rf package.json
COPY ./package.json .
