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

Borrowing an example from the [CWL Docs](https://github.com/common-workflow-language/common-workflow-language/blob/master/v1.0/examples/1st-tool.cwl)

.. code-block:: YAML

    cwlVersion: v1.0
    class: CommandLineTool
    baseCommand: echo
    inputs:
      message:
        type: string
        inputBinding:
          position: 1
    outputs: []

::

Of course this only scratches the surface of a CWL tool. There are other optional elements below.


Optional Elements
******************
In addition to the five required elements, there are many optional elements.
**TODO: fill in optional elements**


Building a CWL workflow
=======================
Once you have a series of tools created it is handy to *glue* them together into a single workflow. A workflow has a slightly different set of required features:
- A `cwlVersion`: the version of CWL implemented
- A `class`: will always be `Workflow`
- `inputs`: 
- `outputs`:
- `steps`:

Again, borrowing from the CWL Guide, we have a handy example [here]():

.. code-block::YAML
    cwlVersion: v1.0
    class: Workflow
    inputs:
      inp: File
      ex: string

    outputs:
      classout:
        type: File
        outputSource: compile/classfile

    steps:
      untar:
        run: tar-param.cwl
        in:
          tarfile: inp
          extractfile: ex
        out: [example_out]

      compile:
        run: arguments.cwl
        in:
          src: untar/example_out
        out: [classfile]


While most of these are similar to those of the command line tools they are formatted slightly different with different options within.
**TODO: fill out differences***

Working with Synapse
=====================
At Sage we have developed a suite of CWL-based tools for interacting with the Synapse command line client. These can be found [here]() and describe the basic functionalities of the Synapse Command line client.


Once you have this file in your directory, you can pass it in to any of the available synapse commands 

Synapse Config
**************
For any workflow that includes Synapse command tools you will need to include a `.synapseConfig` file. This is a file that provides authentication guidance to whatever commands you run. If you are planning to run the client inside a container you should be 

Here is a basic `.synapseConfig` file:
::code-block::YAML
    [authentication]
    username: fakeUser
    password: myfakePassword
    
Examples of using Synapse
**************************

Some of the most common activities involving the synapse client are `get` and `store`. We have built CWL tools for both of these command available on the [Synapse CWL repo](https://github.com/Sage-Bionetworks/synapse-client-cwl-tools).

For example, say you wanted to execute a set of commands that gets a synapse file, renames it, then stores it.

This could be done using the command line as follows:

::code-block::BASH
   synapse get syn123456
   mv file1.txt file2.txt
   synapse store file2.txt --parent syn234567

CWL tools can also be run at the command line, though are obviously a bit more cumbersome because that is not their primary use case:
::code-block::BASH
   cwl-runner https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl --synapsid syn123456 --synapse_config /path/to/my/.synapseConfig
   cwl-runner mv-tool.cwl --from file1.txt --to file2.txt
   cwl-runner https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-store-tool.cwl --file_to_store file2.txt --synapse_config /path/to/my/.synapseConfig --parentid syn234567
   
Of course ideally you'd build this into a workflow step as follows:

Other resources
================
