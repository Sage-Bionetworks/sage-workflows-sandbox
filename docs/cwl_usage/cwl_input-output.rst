CWL Inputs & Outputs
====================
Input and output parameters control how data and software arguments are passed through tools in a workflow.  As described in the `CWL User Guide <https://www.commonwl.org/user_guide/03-input/index.html>`_ , each input and output parameter requires an id and a type.  These types include ``File``, ``string``, and ``int``.  If multiple inputs are required for a given id, arrays such as ``File[]``, ``string[]``, or ``int[]`` can be used.  These same types can be used for output parameters.  For example, a single input file with the id *genome* can be required as an input parameter as follows:

.. code-block:: YAML

        inputs:
            - id: genome
              type: File

and an array of output files with the id *indices* can be produced:

.. code-block:: YAML

        outputs:
        - id: indices
          type: File[]

**Input Binding: Command Line Tool Arguments**


**Passing input and output parameters through workflows**

**File Formats**


.. meta::
    :description lang=en: Common types of I/O for CWL tools and workflows.
    
   
