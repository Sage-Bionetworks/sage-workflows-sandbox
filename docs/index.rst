.. Sage Workflows User Guide documentation master file, created by
   sphinx-quickstart on Wed May  8 12:29:22 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Sage Workflows User Guide!
=====================================================

Numerous groups are developing technologies and best practices for describing and running genomic analyses in a portable and reproducible fashion. Key among these technologies are specifications to describe workflows and tools/tasks such as the Common Workflow Language (CWL) and the Workflow Description Language (WDL) as well as software containers such as Docker. These enable scientists to express and run complex workflows by explicitly defining the inputs and outputs of tools/tasks, how the outputs of tools are passed to the inputs of others, and runtime requirements.

Workflow execution should support multiple tasks and domains at Sage, including challenge infrastructure, data processing pipelines, computationally intensive analyses, and benchmarking for scientific communities. The WG will support teams by developing scalable, documented workflows, as well as the systems and guidance to author, test, execute, and share these workflows for diverse applications. Our goal is to prototype and demonstrate solutions, and define requirements and specifications for the Synapse platform team. Members of this team will participate in and monitor external groups and communities — to stay aware of and informed on best practices and emerging standards. Any systems we devise and implement should conform to and enable FAIR principles; in particular, tight integration with data provenance in Synapse should be a long term goal of any workflow-related developments.

.. toctree::
   :maxdepth: 2
   :caption: Overview:

  overview/rationale.rst
  overview/workflows-101.rst
  overview/workflow-standards.rst
  overview/workflow-engines.rst

.. toctree::
   :maxdepth: 2
   :caption: CWL Usage:

  cwl_usage/cwl_getting-started.rst
  cwl_usage/cwl_input-output.rst
  cwl_usage/cwl_using-containers.rst

.. toctree::
   :maxdepth: 2
   :caption: CWL Examples:

  cwl_examples/cwl_javascript-and-cwl.rst
  cwl_examples/cwl_scattering-inputs.rst
  cwl_examples/cwl_staging-folders.rst

.. toctree::
   :maxdepth: 2
   :caption: Workflow Infrastructure:

  infrastructure/cloud-providers.rst

.. toctree::
   :maxdepth: 2
   :caption: Sharing & Discovery:

  sharing_discovery/sharing-workflows.rst
  sharing_discovery/workflow-metadata.rst
  sharing_discoverycwl-and-linked-data.rst

.. toctree::
   :maxdepth: 2
   :caption: Synapse & Workflows:

  synapse_workflows/synapse-cwl-tools.rst
  synapse_workflows/synapse-workflow-hook.rst


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
