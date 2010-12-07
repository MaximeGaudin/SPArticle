import os
import shutil
import SCons

env = Environment(ENV=os.environ)

outputName = "MAIN"

texName = "main"
binPath = "bin/"
srcPath = "src/"
tmpPath = "tmp/"

buildRes = env.PDF(target = tmpPath + texName + ".pdf", source = srcPath + texName + ".tex") 

# Construction de l'index
if os.path.exists(tmpPath + texName + ".idx"): env.AddPreAction(buildRes, "makeindex " + tmpPath + texName + ".idx")

env.AddPostAction(buildRes, "cp " + tmpPath + texName + ".pdf " +  binPath + outputName + ".pdf") 
env.AddPostAction(buildRes, "open " + binPath + outputName + ".pdf")

