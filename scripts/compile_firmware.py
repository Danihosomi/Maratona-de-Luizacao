from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('--src', dest='srcPath', type=str)
parser.add_argument('--dest', dest='memoryPath', type=str)
args = parser.parse_args()

compiledMemory = []
instructionAddress = 0

with open(args.srcPath, 'rb') as machineCode:
  # It is 3 am, Im tired and Im sad that I will need to change this code because I was attached to it
  # This means that my changes will be ugly and trying to keep things in a way that doesnt work anymore
  # Please dont judge me Im literally this https://i.pinimg.com/originals/32/88/0a/32880ab7b64a1baa09e7a317445b5bb2.jpg
  currentMappedMemory = 0

  while (instruction := machineCode.read(4)):
    endiannessCorrectedInstruction = bytearray(instruction)
    endiannessCorrectedInstruction.reverse()

    compiledMemory.append(f'        {instructionAddress}: data = 32\'h{endiannessCorrectedInstruction.hex()};\n')
    instructionAddress += 1
    
    currentMappedMemory += 2
    machineCode.seek(currentMappedMemory)


compiledMemory.append(f'        default: data = 32\'h0;\n')

with open(args.memoryPath, 'r+') as memoryFile:
  memoryFileContent = memoryFile.readlines()

  memoryDeclarationBoundsStart = -1
  memoryDeclarationBoundsEnd = -1

  for index, line in enumerate(memoryFileContent):
    if 'case(address[9:1])' in line:
      memoryDeclarationBoundsStart = index + 1
    if memoryDeclarationBoundsStart != -1 and 'endcase' in line:
      memoryDeclarationBoundsEnd = index
      break
  
  del memoryFileContent[memoryDeclarationBoundsStart:memoryDeclarationBoundsEnd]
  memoryFileContent = memoryFileContent[:memoryDeclarationBoundsStart] + compiledMemory + memoryFileContent[memoryDeclarationBoundsStart:]

  memoryFile.seek(0)
  memoryFile.truncate()
  memoryFile.writelines(memoryFileContent)
