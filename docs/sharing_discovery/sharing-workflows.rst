Sharing Workflows
=================

.. meta::
    :description lang=en: Sharing tools and workflows with Dockstore and the Tool Registry Service (TRS) API.

Dockstore
---------

**Dockstore** is a platform and `website <https://dockstore.org/>`_ ...

    ... that brings together Docker images with standardized, machine-readable ways of describing and running the tools contained within.

(`their own words) <https://f1000research.com/articles/6-52/>`_)

With the growing use of standard workflow languages like CWL and WDL, Dockstore has become the de facto repository for finding and sharing new tools and workflows. As the name suggests, Dockstore provides a way to describe the tools inside *Docker* images to ease automation and integration among other images and execution systems. This description is made possible by tool definition syntaxes such as CWL or WDL tool definition syntaxes. These definitions clarify and expose the commands available inside a Docker image and how to parameterize them.

Dockstore integrates with source code (GitHub, GitLab, BitBucket) and Docker image (DockerHub, QUAY) repositories to create a combined record of all the ingredients needed to run a particular tool. Using the Dockstore CLI or API, a scientist can retrieve these ingredients — which individually are geared towards reproducibility and portability — to run tools within different local and remote environments.

Dockstore also provides an implementation of the GA4GH `Tool Registry Service (TRS) <https://github.com/ga4gh/tool-registry-schemas/>`_ API. The TRS API is being developed as part of a larger effort by the GA4GH Cloud Work Stream to address the complexity of sharing Dockerized workflows, which often include multiple, interdependent files of different formats, stored in different repositories. By standardizing the representation and transfer of workflows, the developers of TRS aim to increase interoperability, enable automated retrieval and deployment with through other services, and allow for federated searches across registries.

Using Dockstore
---------------

The Dockstore `docs page <https://docs.dockstore.org//>`_ is incredibly thorough and helpful — not just for using Dockstore, but for those getting started with Docker and CWL-based tool development.
