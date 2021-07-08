CWL Inputs & Outputs
====================
Input and output parameters control how data and software arguments are passed through tools in a workflow. As described in the `CWL User Guide <https://www.commonwl.org/user_guide/03-input/index.html>`_ , each input and output parameter requires an id and a type.  These types include ``File``, ``string``, and ``int``. If multiple inputs are required for a given id, arrays such as ``File[]``, ``string[]``, or ``int[]`` can be used.  These same types can be used for output parameters. For example, a single input file with the id *genome* can be required as an input parameter as follows:

.. code-block:: YAML

        inputs:
        - id: genome
          type: File

and an array of output files with the id *indices* can be produced:

.. code-block:: YAML

        outputs:
        - id: indices
          type: File[]
          
To run your workflow, you will need to provide all necessary inputs in a separate YAML or JSON input file:

.. code-block:: YAML

        genome:
          class: File
          path: human_genome.txt

or

.. code-block:: JSON

     {
         "genome": {
             "class": "File",
             "path": "human_genome.txt"}
     {

**Gathering output files**

Output files must be explicitly defined in CWL, defining the output parameter type, such as ``File`` is not sufficient. You can use the ``outputBinding`` field to control which files are gathered as outputs from your workflow. Glob can be used to match a specific filename pattern, or to gather all files. For example, if you want to gather all of the files from the working directory as outputs:

.. code-block:: YAML

        outputs:
        - id: indices
        type: File[]
        outputBinding:
          glob: "*"
          
If you want to gather a single output file with the extension ".genome.txt":

.. code-block:: YAML

        outputs:
        - id: index
        type: File
        outputBinding:
          glob: "*.genome.txt"


**Input Binding: Command Line Tool Arguments**

The syntax for providing input arguments for command line software tools often varies. CWL allows this flexibility through the ``inputBinding`` field.  For example, let's pretend you have a software tool with a function called *GenomeAnalyzer*, and you want to run the following command:

.. code-block:: bash

        GenomeAnalyzer --inputgenome=test.fa --annotation=test.gtf  --method=robust
        
You can use the base command *GenomeAnalyzer*, and specify the ``inputBinding`` field in your CWL code:

.. code-block:: YAML

        baseCommand: GenomeAnalyzer
        inputs:
            genomefile:
              type: File
              inputBinding:
                position: 1
                prefix: --inputgenome=
                separate: false
            annotationfile:
              type: File
              inputBinding: 
                position: 2
                prefix: --annotation=
                separate: false
            analysismethod:
              type: string
                inputBinding:
                  position: 3
                  prefix: --method=
                  separate: false
                
                
In the above example, position numbers are provided to specify the order of the arguments provided to the software tool. If the order does not matter, you can remove the position field.

                
                
                
**Setting Default Inputs**

**Passing input and output parameters through workflows**

**File Formats**


.. meta::
    :description lang=en: Common types of I/O for CWL tools and workflows.
    
   
