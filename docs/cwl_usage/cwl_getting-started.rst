Getting Started with CWL
========================

.. meta::
    :description lang=en: Get started with building and running workflows using CWL.
While the details of CWL can be overwhelming the basics of CWL are quite simple 

Tools vs. Workflows
-------------------
A *workflow* is a set of steps required to fulfill a particular tasks. For example a simple workflow for an analysis pipeline could be comprised of:
1- Get File
2- Zip File
3- Upload new zipped file
These are all three individual steps that, by being chained together, are more easily done with a workflow. 

A *tool* is a single atomic step of a workflow. In the above example, each of the steps can be a single tool. For example, you want have a single tool to get the file, a second to zip it, and a third to upload it. 

A step of a workflow can also be another workflow. For example, imagine if Step 1 required authentication before retrieving a file. In this case you could invoke a second *workflow* to execute that step, which would have 2 steps: authenticate and then get file.

Building a CWL tool
-------------------
There are many existing examples of CWL tools out there. 

Required elements
*****************
The following elements are required of a CWL tool:
- A `cwlVersion`: the version of CWL to use
- A `class`: CommandLineTool or ExpressionTool
- A `baseCommand`: the command to be executed
- `inputs`: the inputs being passed into the command
- `outputs`: the outputs being passed out.

Borrowing an example from the [CWL Docs](https://github.com/common-workflow-language/common-workflow-language/blob/master/v1.0/examples/1st-tool.cwl)::
cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo
inputs:
  message:
    type: string
    inputBinding:
      position: 1
outputs: []

Of course this only scratches the surface of a CWL tool. There are other option elements below.


Optional Elements
******************
In addition to the five required elements, there are many optional elements.
[Not even sure i know what they all are]


Building a CWL workflow
=======================
Once you have a series of tools created it is handy to *glue* them together into a single workflow. A workflow has a slightly different set of required features:
- A `cwlVersion`: the version of CWL implemented
- A `class`: will always be `Workflow`
- `inputs`: 
- `outputs`:
- `steps`:

While most of these are similar to those of the command line tools they are formatted slightly different with different options within.

Working with Synapse
=====================


Other resources
================
