#!/bin/bash

# A terminal window is opened and the commands are run with update messages

gnome-terminal --tab -- bash -c '\
	echo "Script is starting...";\
	echo ;\
	sleep 3;\
	echo "Checking docker login status...";\
	echo ;\
	sleep 3;\
	docker login;\
	echo ;\
	echo "Uninstalling the docker image...";\
	echo ;\
	sleep 3;\
	docker rmi dlbuesen/cv_sim_ec-prime-film:version-1.0.0-layer08;\
	sleep 3;\
	echo ;\
	echo "Confirming uninstallation of the docker image...";\
	echo ;\
	sleep 5;\
	echo "Docker image from repository "dlbuesen/cv_sim_ec-prime-film" with tag "version-1.0.0-layer08" should not appear in the list of images below";\
	echo ;\
	docker images;\
	echo ;\
	echo "Done";\
	echo ;\
sleep 60'
