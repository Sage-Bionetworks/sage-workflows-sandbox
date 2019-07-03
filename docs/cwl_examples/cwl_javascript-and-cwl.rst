JavaScript & CWL
================

.. meta::
    :description lang=en: Using inline JavaScript and 'ExpressionTool's.

Part 1: InlineJavascriptRequirement
-----------------------------------

If you need to do a computation while running a cwltool, you can do so using a snippet of javascript.

.. code-block:: YAML

	#!/usr/bin/env cwl-runner

	$namespaces:
	  s: https://schema.org/

	s:author:
	  - class: s:Person
	    s:identifier: https://orcid.org/0000-0002-0326-7494
	    s:email: andrew.lamb@sagebase.org

	s:name: Andrew Lamb

	cwlVersion: v1.0

	class: CommandLineTool

	requirements:
	- class: InlineJavascriptRequirement
	- class: InitialWorkDirRequirement
	  listing:
	  - entry: $(inputs.file)
	    writable: true

	baseCommand: 
	- gzip

	inputs:

	- id: file
	  type: File
	  inputBinding:
	    position: 1

	outputs:

	- id: gziped_file
	  type: File
	  outputBinding:
	    glob: $(inputs.file.path + ".gz")

The above tool gzips the given input file. The gzip util will tack on the the .gz suffix, so we don't know what the exact file name will be. 
But we can figure it out using a little bit of javascript:

.. code-block:: YAML

	- id: gziped_file
	  type: File
	  outputBinding:
	    glob: $(inputs.file.path + ".gz")

1. Inputs.file.path returns the path of the input file
2. '+ ".gz"' concatenates the gz suffix
3. $() returns the result of the javscript expression contained between the parens

Part 2: Expression tools
------------------------

Expression tools are cwltools that only perform javascript, and don't call any other script or command.


.. code-block:: YAML

	#!/usr/bin/env cwl-runner

	$namespaces:
	  s: https://schema.org/

	s:author:
	  - class: s:Person
	    s:identifier: https://orcid.org/0000-0002-0326-7494
	    s:email: andrew.lamb@sagebase.org

	s:name: Andrew Lamb

	cwlVersion: v1.0
	class: ExpressionTool

	requirements:
	- class: InlineJavascriptRequirement

	inputs:

	- id: input_file
	  type: File
	- id: new_file_name
	  type: string

	outputs:

	- id: output_file
	  type: File

	expression: |
	  ${
	    inputs.input_file.basename = inputs.new_file_name;
	    return {output_file: inputs.input_file};
	  }

Expression tools are like command line tools in terms of input and outputs. The difference is that instead of execution a commnad, expression tools execute a javascript expression:

.. code-block:: YAML

	expression: |
	  ${
	    inputs.input_file.basename = inputs.new_file_name;
	    return {output_file: inputs.input_file};
	  }

This expression simply renames the file, and returns it.



