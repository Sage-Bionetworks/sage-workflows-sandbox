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

