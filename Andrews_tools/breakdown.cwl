label: breakdownfile-tool
id: breakdownfile-tool
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
         group_by_column=sys.argv[2]
         res = pd.read_csv(query_tsv,delimiter='\t')
         gdf = res.groupby(group_by_column)
         names = []
         mate1ids = []
         mate2ids = []
         for key,value in gdf:
            names.append(key)
            rps = gdf.get_group(key).groupby('readPair')
            ids1 = [i for i in rps.get_group(1)['id']]
            ids2 = [i for i in rps.get_group(2)['id']]
            assert(len(ids1) == len(ids2))
            mate1ids.append(ids1)
            mate2ids.append(ids2)
         assert(len(names) == len(mate1ids) ==  len(mate2ids))
         res={'names':names, 'mate1ids':mate1ids,'mate2ids': mate2ids}
         with open('cwl.json','w') as outfile:
           json.dump(res,outfile)


inputs:

- id: query_tsv
  type: File
  inputBinding:
    position: 1

- id: group_by_column
  type: string
  default: "individualID"
  inputBinding:
    position: 2

outputs:

- id: names
  type: string[]
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['names'])

- id: mate1_id_arrays
  type:
    type: array
    items:
      type: array
      items: string
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['mate1ids'])

- id: mate2_id_arrays
  type:
    type: array
    items:
      type: array
      items: string
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['mate2ids'])
