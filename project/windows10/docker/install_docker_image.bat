@echo off

echo.

echo Starting script...
echo.

timeout 3

echo Installing the docker container image...
echo.

timeout 3

docker pull dlbuesen/cv_sim_ec-prime-film:version-1.0.0-layer08

timeout 3
echo Listing the installed docker images on the system...

timeout 3

docker images

timeout 3

echo Docker image from repository
echo "dlbuesen/cv_sim_ec-prime-film"
echo with tag "version-1.0.0-layer08"
echo should appear in the list of images above
echo.

echo Done
echo.

pause
