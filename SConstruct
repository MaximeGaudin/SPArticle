import os
import shutil
import SCons

env = Environment(ENV=os.environ)

outputName = "MAIN"

texName = "main"
binPath = "bin/"
srcPath = "src/"
tmpPath = "tmp/"

if not os.path.exists(binPath): os.mkdir(binPath)
if not os.path.exists(srcPath): os.mkdir(srcPath)
if not os.path.exists(tmpPath): os.mkdir(tmpPath)

buildRes = env.PDF(target = tmpPath + texName + ".pdf", source = srcPath + texName + ".tex") 

env.AddPreAction(buildRes, "@echo '\\n**** Compiling " + srcPath + texName + ".tex ... ****\\n'" ); 
env.AddPreAction(buildRes, "@echo '** Converting files ....' && Scripts/convertEncoding src/latin1 LATIN1 UTF8")

# Construction de l'index
if os.path.exists(tmpPath + texName + ".idx"): env.AddPreAction(buildRes, "makeindex " + tmpPath + texName + ".idx")

#env.AddPostAction(buildRes, "@echo '\n**** Build succesfull ****\n'" ); 
env.AddPostAction(buildRes, "@cp " + tmpPath + texName + ".pdf " +  binPath + outputName + ".pdf") 
env.AddPostAction(buildRes, "@open " + binPath + outputName + ".pdf")
