label: breakdown-by-row-tool
id: breakdown-by-row-tool
cwlVersion: v1.0


class: CommandLineTool
baseCommand:
- python
- breakdownfiles.py


requirements:
 - class: InlineJavascriptRequirement
 - class: DockerRequirement
   dockerPull: amancevice/pandas
 - class: InitialWorkDirRequirement
   listing:
     - entryname: breakdownfiles.py
       entry: |
         #!/usr/bin/env python
         import json
         import sys
         import pandas as pd
         query_tsv=sys.argv[1]
         res = [a for a in pd.read_csv(query_tsv,delimiter='\t')['id']]
         with open('cwl.json','w') as outfile:
           json.dump(res,outfile)


inputs:

- id: query_tsv
  type: File
  inputBinding:
    position: 1

outputs:

- id: id_array
  type: string[]
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents))
