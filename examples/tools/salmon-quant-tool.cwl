#!/usr/bin/env cwl-runner
class: CommandLineTool
id: salmon-quant-tool
label: salmon-quant-tool
cwlVersion: v1.0

baseCommand: [salmon, quant, -l, A, --validateMappings, --gcBias, --seqBias]

hints:
  DockerRequirement:
    dockerPull: combinelab/salmon

requirements:
  - class: InlineJavascriptRequirement

inputs:
  mates1:
    type: File[]
    inputBinding:
      position: 1
      prefix: '-1'
  mates2:
    type: File[]
    inputBinding:
      position: 2
      prefix: '-2'
  index-dir:
    type: Directory
    inputBinding:
      prefix: -i
      position: 3
  output:
    type: string
    inputBinding:
      prefix: --output
      position: 4

outputs:
  quants:
    type: File
    outputBinding:
      glob: "*/quant.sf"
      outputEval: |
        ${
          var io=inputs.output
          io=io.replace(" /g","_")
          self[0].basename = io + '_quant.sf';
          return self[0]
        }





