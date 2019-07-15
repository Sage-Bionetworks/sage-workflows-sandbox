Workflows 101
=============

.. meta::
    :description lang=en: Introduction to workflows.

What is a workflow?
-------------------

According to `Merriam-Webster <https://www.merriam-webster.com/dictionary/workflow/>`_, a workflow is

    the sequence of steps involved in moving from the beginning to the end of a working process

For our purposes, we'll attempt to more specifically define "scientific workflows" (or `#sciworkflows <https://twitter.com/search?q=%23sciworkflows&src=typd/>`_ for Twitter users). Let's start by clarifying what we *don't* mean by scientific workflows (henceforth "workflows" for short):

- A general way of approaching a problem or task — for example, create a new repo -> clone the repo -> open RStudio -> create a README, etc.
- A pre-defined operating procedure for a business process or "agile" project — for example, the stages ("OPEN", "IN PROGRESS", "CLOSED") a ticket might go through in an issue tracking system like Jira.
- A computational pipeline encoded by a Bash, Python, or R script or series of shell commands — though this is getting closer!

In the most abstract terms, a workflow is a directed acyclic graph connecting multiple pieces of data (nodes). Each connection in the graph (edge) represents a path from the output of one process or tool to the input of the next. While this definition is less useful to most workflow developers, it's an important point. We'll go with something simpler:

    A scientific workflow is a **series of steps**, each representing the **execution of a computational process or tool** that **transforms a set of input data elements to a set of output data elements**.

For our purposes, we'll extend the definition to include:

    Workflows are encoded in descriptive, standardized, and machine-readable languages as to enable portability and reproducibility, as well as the scalability provided by workflow management systems.

Why workflows?
--------------

A major advantage of workflows is the opportunity to take advantage of *workflow management systems*. These systems might also be referred to as engines or platforms. Samuel Lampa excellently summarizes the benefits provided by workflow management systems in his `SciPipe paper <https://academic.oup.com/gigascience/article/8/5/giz044/5480570/>`_:

    As a result of the increasingly large sizes of biological data sets ... pipelines often require integration with high-performance computing (HPC) infrastructures or cloud computing resources to complete in an acceptable time. This has created a need for tools to coordinate the execution of such pipelines in an efficient, robust. and reproducible manner. This coordination can in principle be done with simple scripts in languages such as Bash, Python, or Perl, but plain scripts can quickly become fragile. When the number of tasks becomes sufficiently large and the execution times long, the risk for failures during the execution of such scripts increases almost linearly with time, and simple scripts are not a good strategy for when large jobs need to be restarted from a failure. ... [They] lack the ability to distinguish between finished and half-finished files. They also do not provide means to detect whether intermediate output files are already created and can be reused to avoid wasting time on redoing already finished calculations. These limitations with simple scripts call for a strategy with a higher level of automation and more careful management of data and state.

(see above note for why we're not considering such scripts as workflows here)

    This need is addressed by a class of software commonly referred to as “scientific workflow management systems” or simply “workflow tools.” Through a more automated way of handling the execution, workflow tools can improve the robustness, reproducibility, and understandability of computational analyses. In concrete terms, workflow tools provide means for handling atomic writes (making sure finished and half-finished files can be separated after a crashed or stopped workflow), caching of intermediate results, distribution of tasks to the available computing resources, and automatically keeping or generating records of exactly what was run, to make analyses reproducible.

Besides the merits of workflows related to scalable computing and reproducibility, they also imply (and often require) a greater level of intentionial and principled design. Workflows aren't great for simple, one-off tasks; they're best suited for production applications where an algorithm needs to be matured to a more robust and reusable state.