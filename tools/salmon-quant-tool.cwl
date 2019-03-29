#!/usr/bin/env cwl-runner
class: CommandLineTool
id: salmon-quant-tool
label: salmon-quant-tool
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: combinelab/salmon
  - class: InlineJavascriptRequirement
#  - class: InitialWorkDirRequirement
#    listing: $(inputs.output)

baseCommand: [salmon, quant, -l, A, --validateMappings,--gcBias, --seqBias]]

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
          self[0].basename = inputs.output + '_quant.sf';
          return self[0]
        }
