#!/python
#
#import re
from pymatgen import MPRester, Composition
import re
import os
import pprint

def isexistf(filename = 'test.txt'):
    if os.path.isfile(filename):
        os.remove(filename)

m = MPRester('Insert Your API KEYS IN MaterialsProject(https://materialsproject.org/open)')

elastic_data = m.query({"elasticity": {"$exists": True}}, 
                         properties=["task_id", "full_formula", "elasticity.elastic_tensor"])

isexistf('CIJ.txt')
Allfile = open('CIJ.txt', 'a')
for i in xrange(0,len(elastic_data)):
    Allfile.write(str(elastic_data[i]['full_formula']) + "\t" + str(elastic_data[i]['task_id']) + "\n")
    for j in xrange(0, 6):
        for k in xrange(0, 6):
            Allfile.write(str(elastic_data[i]['elasticity.elastic_tensor'][j][k]) + "\t")
        Allfile.write("\n")
    Allfile.write("\n")
Allfile.close()
