CWL & Linked Data
=================

.. meta::
    :description lang=en: CWL's connection to linked data, JSON-LD, and the semantic web.

    
Below is a somewhat verbose story/explanation of the connection between CWL and linked data.

- `SALAD <https://www.commonwl.org/v1.0/SchemaSalad.html>`_ is a schema language for linked data, co-developed by developers of JSON-LD and Apache Avro
- the **Common Workflow Language (CWL)** is more of a standard/specification than a programming language or DSL, according to Michael Crusoe, Peter Amstutz, et al.
- when you poke around the CWL GitHub repo long enough, you come across files like `CommandLineTool.yml <https://github.com/common-workflow-language/common-workflow-language/blob/master/v1.0/CommandLineTool.yml>`_ and `Workflow.yml <Workflow.yml>`_
    - when building tools and workflows, these are the primary “classes” of descriptor files (documents) that one would write, typically with a ``.cwl`` extension
    - as far as I can tell the ``.yml`` files represent the corresponding schema for each class, based on SALAD


The link between CWL and JSON-LD isn’t obvious at first, because a .cwl descriptor is typically more YAML-like in structure; however, a few things happen when a CWL file is preprocessed before execution (you can test this with the ``cwltool --print-pre my_tool-or-workflow.cwl`` command):

- the output is clearly JSON, not YAML
- namespaces and references get expanded:

.. code-block:: yaml

    $namespaces:
    dct: http://purl.org/dc/terms/
    foaf: http://xmlns.com/foaf/0.1/

    dct:creator:
    "@id": "http://orcid.org/0000-0001-9758-0176"
    foaf:name: James Eddy
    foaf:mbox: "mailto:james.a.eddy@gmail.com"

becomes…

.. code-block:: json

    {
        "$namespaces": {
            "dct": "http://purl.org/dc/terms/",
            "foaf": "http://xmlns.com/foaf/0.1/"
        },
        "http://purl.org/dc/terms/creator": {
            "@id": "http://orcid.org/0000-0001-9758-0176",
            "http://xmlns.com/foaf/0.1/mbox": "mailto:james.a.eddy@gmail.com",
            "http://xmlns.com/foaf/0.1/name": "James Eddy"
        },

        ...

paths get resolved (ish):

.. code-block:: yaml

    inputs:
    template_file:
        type: File
        inputBinding:
        position: 1

    input_file:
        type: File
        inputBinding:
        position: 2

becomes…

.. code-block:: json

    "inputs": [
        {
            "id": "file:///Users/jaeddy/code/github/containers/dockstore-workflow-helloworld/dockstore-tool-helloworld.cwl#input_file",
            "inputBinding": {
                "position": 2
            },
            "type": "File"
        },
        {
            "id": "file:///Users/jaeddy/code/github/containers/dockstore-workflow-helloworld/dockstore-tool-helloworld.cwl#template_file",
            "inputBinding": {
                "position": 1
            },
            "type": "File"
        }
    ],

at runtime, the “job” JSON (or YAML) file gets used and processed somehow to define the actual paths:

.. code-block:: json

    {
        "template_file": {
            "class": "File",
            "path": "template.txt"
        },
        "input_file": {
            "class": "File",
            "path": "input.txt"
        }
    }
    
(result not shown — because I’m not entirely sure how to produce it)

So… there are clearly some JSON-LD “things” going on here. Further evidence as you scan through the schemas are sections like this:

.. code-block:: json

    - name: "class"
      jsonldPredicate:
        "_id": "@type"
        "_type": "@vocab"
      type: string

In terms of developing workflows for Translator using CWL, we could stick to a file-centric approach: dumping the results from one query/task into a JSON, then passing that as input to the next query/task — leaving it up to the underlying software to handle logic related to parsing and validation. However, I think we could take advantage of CWL’s JSON-LD elements to operate directly on the data objects, and utilize schemas/namespaces/ontologies to specify and validate the more “conceptual” inputs and outputs (i.e., not just file formats). I’ve played around with this idea a bit using CWL’s ``SchemaDefRequirement`` to schematize special input ``record`` types…

.. code-block:: yaml

    requirements:
    - class: InlineJavascriptRequirement
    - class: SchemaDefRequirement
        types:
        - $import: biolink-types.yaml
    biolink-types.yaml

    type: record
    name: disease
    fields:
    - name: thing_id
    type: string
    - name: thing_name
    type: string
    - name: thing_category
    type: string

Such that I can now parameterize the CWL tool with my ``"disease"`` record:

.. code-block:: json

    {
        "disease": {
            "thing_id": "8712",
            "thing_name": "neurofibromatosis",
            "thing_category": ""
        }
    }

... and use some funny in-line JavaScript to parse and pass that record to the Python module as a JSON string:

.. code-block:: yaml

    inputs:
    - id: disease
        label: Disease
        type: biolink-types.yaml#disease
        inputBinding:
        position: 1
        valueFrom: $(JSON.stringify(inputs.disease))

This would hopefully allow me to take advantage of a CWL executor’s built-in features for validating parameters, such that I’d get an error or warning if my ``"disease"`` didn’t conform to specs. It’d also be nice if we could verify that identifiers and other values map to allowable vocabularies, based on the BioLink model.

This is where I get a bit lost/stuck, and haven’t quite been able to wrap my head around the details or mechanics...