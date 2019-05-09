Rationale
=========

.. meta::
    :description lang=en: Our philosophy on promoting standardized workflows.

Why use workflows?
------------------

Software container technologies, such as Docker, allow researchers to create lightweight virtual machines into which they can install software, configuration, and small data files. The resulting images can be shared across a variety of cloud or local computing platforms. Such “Dockerized” algorithms can be “moved” to the data (i.e., uploaded in the same computer system containing the data) in contrast to the traditional format of “moving data” to modelers (i.e., modelers download data to their computational space, which could be onerous when datasets are massive). One advantage to this framework are that it facilitates the use of protected, proprietary, and very large datasets — with vastly reduced data-transfer, improved data security, and reduction of administrative and IRB overhead. Another advantage is the creation of a library of well-annotated algorithms with consistent input and output parameters for community use.

While container technologies provide a reliable and interoperable way to move models across computational environments, orchestration of large numbers of containers and distributed data assets requires significant engineering overhead. Workflow execution systems orchestrate one or more asynchronous tasks, linked by dependency relationships. Managing container execution through hardened workflow systems (e.g., Toil, FireCloud/Cromwell, Galaxy) offers several benefits: (i) Scalability: built-in support for resource provisioning, distributed task execution, autoscaling, and utilization of different backends for scheduling and load balancing; (ii) Portability: coordination of dependencies and data among containerized steps for reproducible computing across environments; (iii) Reentrancy: the ability of a program to continue where it left off if interrupted through sophisticated caching mechanisms and failure/recovery logic.