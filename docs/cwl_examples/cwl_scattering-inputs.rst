Scattering Inputs
=================

.. meta::
    :description lang=en: Running a tool or workflow multiple times over a list of inputs.

Part 1: Getting started
-----------------------

If you need to run a tool or workflow on an array, or multiple arrays of inputs, scatter is the way to accomplish this. We will be using the following tool as example of what we are looping over:

.. code-block:: YAML
	#!/usr/bin/env cwl-runner
	#
	# Authors: Andrew Lamb
	class: CommandLineTool
	cwlVersion: v1.0

	stdout: output.txt

	baseCommand: 
	  - wc

	inputs:

	  - id: lines
	    type: boolean?
	    inputBinding:
	      position: 1
	      prefix: -l

	  - id: file
	    type: File
	    inputBinding:
	      position: 2

	outputs:

	  - id: output
	    type: stdout

This runs the linux command wc(word count) on an input file, with the option to use the -l(lines) flag. Let's assume we want to run this tool on an array of files. (You can use the wc command on a list of files, but let's ignore this for the example.)

The way to run a tool on an array of inputs is to do it at the workflow level:

.. code-block:: YAML
	#!/usr/bin/env cwl-runner
	#
	# Authors: Andrew Lamb

	cwlVersion: v1.0
	class: Workflow

	requirements:
	- class: ScatterFeatureRequirement

	inputs:

	  lines: boolean?
	  file_array: File[]
	      
	      
	outputs:

	  output_array: 
	    type: File[]
	    outputSource: 
	    - wc/output

	steps:

	  wc:
	    run: wc.cwl
	    in:
	      lines: lines
	      file: file_array
	    scatter: file
	    out: 
	      - output

Let's go through the relevant parts.

This is necessary for using the scatter functionality:

.. code-block:: YAML

	requirements:
	- class: ScatterFeatureRequirement


We want to run the tool on a list of input files. This is indicated by placing square brackets after the type:

.. code-block:: YAML

	inputs:

	  lines: boolean?tep
	  file_array: File[]

We will get back an array of files. Note that the scatter step will always result in an array output of whatever type the you are scattering produces. For example if the tool produces a File, the scattered version will produce and array of files. If the tool produces an array, the scattered version produces an array of arrays. This is true if the output of the step is the final workflow output, as in the above example, or it's being fed into another step. 

.. code-block:: YAML

	outputs:

	  output_array: 
	    type: File[]
	    outputSource: 
	    - wc/output

Finally we need to specify where an what we are scattering

In this example we want to run the wc.cwl tool over multiple files. The tool only takes in one file, so we have to make the workflow run the tool multiple times. The tool has the file input named 'file', whereas the workflow has
the array input named 'file_array'. If we gave the tool the array input here, normally this would cause an error since a file array is not the same as a file:

.. code-block:: YAML

	    in:
	      lines: lines
	      file: file_array


However by adding the scatter definition, we are telling the workflow to iterate over the array of files, running the tool once per each item in the array:


.. code-block:: YAML

 	   scatter: file


Note that the item we scatter is the name of the tool input name, NOT the workflow input name.


Part 2: dotproduct
------------------

This is a continuation from part 1.  We will also be using the wc.cwl tool from that example.

In part 1 we covered how to do a sample scatter on an array of files. We'll now extend that any number of arrays. When you want to scatter over multiple arrays, you will need to tell CWL how to handle that. For this example we will use the scatter method called "dotproduct".

You can use the dotproduct as long as the arrays are the same length. The length of the arrays will determine how time your tool is run, and thus the length of the output array. For example if you have two arrays of three items each, and both are scattered, the tool would be run three times, the first instance would take the first item from each array as parameters, the second instance would use the second item from each array, and so on. Lets see an example:


.. code-block:: YAML

	#!/usr/bin/env cwl-runner
	#
	# Authors: Andrew Lamb

	cwlVersion: v1.0
	class: Workflow

	requirements:
	- class: ScatterFeatureRequirement

	inputs:

	  line_array: boolean[]
	  file_array: File[]
	      
	      
	outputs:

	  output_array: 
	    type: File[]
	    outputSource: 
	    - wc/output

	steps:

	  wc:
	    run: wc.cwl
	    in:
	      lines: line_array
	      file: file_array
	    scatter: 
	      - lines
	      - file
	    scatterMethod: dotproduct
	    out: 
	      - output


This is very similar to the first example, let's look at what's changed.

We are still iterating over an array of input files, but here we want to also control whether or not we use the lines flag or not, so we are now providing an array of booleans:

.. code-block:: YAML

	inputs:

	  line_array: boolean[]
	  file_array: File[]

We now need to scatter two array inputs:

.. code-block:: YAML

	    scatter: 
	      - lines
	      - file


Finally since we are scattering more than one array we need to provide the method:


.. code-block:: YAML

 	   scatterMethod: dotproduct


Part 3: flat_crossproduct
-------------------------


This is a continuation from part 1 and 2.  We will also be using the wc.cwl tool from part1

In part 1 we covered how to do a sample scatter on an array of files. In part 2 we extended that any number of arrays using the dotproduct. We will now look at scattering over multiple arrays using the flat crossproduct. Where the dotproduct required that your arrays be the same length, the flat crossproduct can scatter over arrays of different length. In addition, where the dotproduct result output is equal to that length of the arrays, the flat crossproduct result output is equal to: len(array1) * len(array2) * ...len(array_n). 

Another way of describing this is that the cwltool is run on every combination of inputs from each array. For example if you have an array of 3 files, and array of 2 flags, you will have 6 outputs. Each file will be run, once per each flag. The example workflow is exactly the same as the one in part2 except:
 
.. code-block:: YAML

   	 scatterMethod: flat_crossproduct


And  the input yaml:


.. code-block:: YAML

	line_array:
	- true
	- false

	file_array:
	- class: File
	  path: test_file1
	- class: File
	  path: test_file2
	- class: File
	  path: test_file3


And finally the output of "cwltool wc_workflow3.cwl wc_workflow.yaml" :

.. code-block:: JSON

	{
	    "output_array": [
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 70,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$a912a8cf6107efe1bff86c42b7899e0a090d383c"
		},
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 70,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$ad06722d0c3641f8baf46242fcea51b77ee558e9"
		},
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 70,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$35470ddb936f3d1d3a5b907ff73c61d8df35d968"
		},
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 74,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$16fb2f95337e0b7c2b0e5076dc09b6509a762482"
		},
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 77,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$c5c3a3c1ff8ef9d4573f8238cb67c355225775d7"
		},
		{
		    "path": "/home/aelamb/cwl_stuff/output.txt",
		    "basename": "output.txt",
		    "size": 77,
		    "location": "file:///home/aelamb/cwl_stuff/output.txt",
		    "class": "File",
		    "checksum": "sha1$b0fb51fac542b2b9f64d1408acabcfb61b8a4055"
		}
	    ]
	}


Part 4: nested_crossproduct
---------------------------

This is very similar to flat_crossproduct. The difference is that instead of one long flat array, you will receive a nested array as output:


.. code-block:: YAML

	#!/usr/bin/env cwl-runner
	#
	# Authors: Andrew Lamb

	cwlVersion: v1.0
	class: Workflow

	requirements:
	- class: ScatterFeatureRequirement

	inputs:

	  line_array: boolean[]
	  file_array: File[]
	      
	      
	outputs:

	  output_array: 
	    type: 
	      type: array
	      items:
		type: array
		items: File
	    outputSource: 
	    - wc/output

	steps:

	  wc:
	    run: wc.cwl
	    in:
	      lines: line_array
	      file: file_array
	    scatter: 
	      - lines
	      - file
	    scatterMethod: nested_crossproduct
	    out: 
	      - output



The output will look like:


.. code-block:: JSON

	{
	    "output_array": [
		[
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 70,
		        "checksum": "sha1$e211886d70dfff0eb61fc917d75f184ce8b609b7",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    },
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 70,
		        "checksum": "sha1$5a30593e67cc7d8e446b0ea1559da74fb35be45a",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    },
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 70,
		        "checksum": "sha1$0220442cc49f0a4b3f82821725b40449c4e150f6",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    }
		],
		[
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 74,
		        "checksum": "sha1$ff65542777206d16635fa2c1a3e0e6376ea02a29",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    },
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 77,
		        "checksum": "sha1$c5f042720e1f9e6cf75de5659ef01f547cd1d38f",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    },
		    {
		        "location": "file:///home/aelamb/cwl_stuff/output.txt",
		        "basename": "output.txt",
		        "size": 77,
		        "checksum": "sha1$e125e09c3b8a7d398014e791698dda762afb0bea",
		        "class": "File",
		        "path": "/home/aelamb/cwl_stuff/output.txt"
		    }
		]
	    ]
	}






