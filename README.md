# CISC 813 Course Project

## Description
This is a repository for the course project development in CISC 813. This project focuses on the development of a fully observable non-deterministic (FOND) planner to be used for action selection of a greeter robot within a lab environment. Social robots capable of human-robot interaction (HRI) have increased in popularity motivating the development of this planner. FOND was selected as it can account for unknown information within the environment (i.e, visitor intention, staff availability, etc.) through its non-deterministic actions. The planner contains two action types: social actions to facilitate social interaction between the visitor-robot pair and physical actions to facilitate the robot’s interaction with the environment. This planner will facilitate the autonomous behaviour of our social robot within the lab environment.

## File System
This repository contains the domain and problem PDDL files for the initial and final models developed in this project. The initial model outlines a proof-of-concept implementation of a planner used to sequence actions for a robotic greeter. The final model improves on the initial model by adding more realistic components of the environmnet, such as the unknown location of lab members of interest for the robot. The final model uses more non-deterministic actions to account for the greater uncertainty within the robot's environment. The PRP planner was used to solve both models.

## Authors
Kieran Lachmansingh (18ksl@queensu.ca)
Eric Godden (18eg16@queensu.ca)
Department of Electrical and Computer Engineering
Queen's Univeristy 
Kingston, ON Canada

## Project status
This project has completed development for submission on December 5, 2023.
