# bayesian_data_analysis
This repo contains my exercises from kruschke's book

Instead of using the RBrugs to communicate with OpenBUGS (only works in Windows), I use R2OpenBUGS (in a Debian based docker container). Therefore, the codes look a little different from the book.

# Prepare
Have docker / docker-compose installed
Share drives if you are on Docker-desktop
Install Xming
Set host for Xming
Restart Xming

# Get container running
(1) Build the image for R/OpenBUGS: docker-compose build
(2 for Windows) Running container: docker run -it --rm -v "C:\Users\tsu\Desktop\bayesian_data_analysis":/home/bayesian_data_analysis --privileged -e DISPLAY=163.188.38.85:0.0 -v /tmp/.X11-unix:/tmp/.X11-unix tianxiang84/rbugs /bin/bash

(2 for Linux) Running container: docker run -it --rm -v /home/TSu/Projects/bayesian_data_analysis:/home/bayesian_data_analysis --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tianxiang84/rbugs /bin/bash

Rstudio:

docker run --rm -p 8787:8787 -e PASSWORD=devpass -v /home/TSu/Projects/bayesian_data_analysis:/home/rstudio/kitematic/bayesian_data_analysis --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix rocker/rstudio

docker exec -it xxx /bin/bash

# Run R
Running R: "R" in terminal

Windows for host display
http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
https://blogs.msdn.microsoft.com/jamiedalton/2018/05/17/windows-10-docker-gui/

# Status
RScript exists
Installed feh to view plots (C1)
Tested R2OpenBUGS with example
Read R2OpenBUGS again
Totally reproduce C7 example
Do C9 examples

Next
(1) Move to C10
