Using Containers
================

.. meta::
    :description lang=en: Using containers to manage environment and dependencies.

What is Docker: 
=================
Docker is an open-source project developed with the goal of saving applications from failing to run due to 
* Missing other applications that the final application depends on (dependencies)
* Presence of conflicting dependencies
* Presence of different platforms for running the application

Docker helps isolate the application from the host it is running on and run it efficiently due to the following:
1. Linux Containers and LXC : constitute the core of Docker, uses kernel-level namespaces to isolate the container from the host. (_Namespaces are used to organize code into logical groups and to prevent name collisions that can occur especially when your code base includes multiple libraries._)
2. ControlGroups or cgroups : implement resource accounting and limiting
3. Advanced Multi-Layered Unification Filesystem or AuFS : enables using images as the basis for containers (eg. using CentOS image for many different containers), also enables version control (each new version is diff of changes from the previous version, thus conserving memory)

Docker images store all the information about the necessary packages that an application depends on. These images can be registered in a Docker Registry (eg. DockerHub) and can be easily shared and reused. Many instances can use the same Docker image, each such instance is called a Container.

Synapse hosts a private docker registry, freely available to the members and users of Sage Bionetworks. This allow users to create software on a per project basis which can be easily shared across Synapse. You can make your custom Docker image and push it to Synapse Docker registry using the following command
``docker login -u <synapse username> -p <synapse password> docker.synapse.org`` 

Why use Docker Images  with CWL:
===================================
With CWL we aim to produce computational analysis pipelines or workflows that can run without fail in various disparate platforms, are compatible with various different computing environments, scripting languages and their associated dependencies. We can do this by calling well documented docker images from within our workflow. This will generate docker containers at appropriate steps in the workflow to ensure that all the different dependencies for any particular specialized analysis tool/step in the workflow are met and the multistep analytical process completes without error in any production environment. Thus is crucial for scalability as well as reproducibility of analyses given a specific workflow. 

Run CWL tools with  Docker:
============================
One of the most important attributes of docker containers is to isolate the processes running inside it from the host system. Thus running CWL based workflows with docker containers require additional steps to ensure that input files are available inside the container and output files can be recovered from the container.

A **CWL Runner** script can perform these steps automatically by adjusting the paths of input files to reflect the location where they appear inside the container.

Write a CWL Runner:
-------------------
You can follow the example below to write your own CWL runner. Make sure to specify your favorite Docker image for your favorite tool with **DockerRequirement** in the *hints* section of the CWL file. 

**EXAMPLE: hello-world.cwl**

``#!/usr/bin/env cwl-runner

class: CommandLineTool
id: "hello-world"
label: "Simple hello world tool"

cwlVersion: v1.0

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0001-XXXX-XXXX"
  foaf:name: JohnSmith
  foaf:mbox: "mailto:johnsmith@gmail.com"

requirements:
- class: DockerRequirement
  dockerPull: quay.io/ga4gh-dream/dockstore-tool-helloworld:1.0.2

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1

outputs:
  output:
    type: File
    outputBinding:
      glob: "helloworld.txt"

baseCommand: ["bash", "/usr/local/bin/input.txt"]``

**USAGE**

``$ cwl-runner hello-world.cwl input.txt``

In the example above:
* Docker Container == quay.io/ga4gh-dream/dockstore-tool-helloworld:1.0.2 
* Input == Job to be ran using the dockerfile ==  ``input.txt``
* Output == the file in ``glob``  will be copied out of the container to a location you specify in your parameter JSON file 
* Actual command that will be executed == ``baseCommand:``


