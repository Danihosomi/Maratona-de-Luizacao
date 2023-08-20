from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('--src', dest='srcPath', type=str)
parser.add_argument('--dest', dest='memoryPath', type=str)
args = parser.parse_args()

compiledMemory = []
instructionAddress = 0

with open(args.srcPath, 'rb') as machineCode:
  while (instruction := machineCode.read(4)):
    endiannessCorrectedInstruction = bytearray(instruction)
    endiannessCorrectedInstruction.reverse()

    compiledMemory.append(f'        {instructionAddress}: data <= 32\'h{endiannessCorrectedInstruction.hex()};\n')
    instructionAddress += 1



with open(args.memoryPath, 'r+') as memoryFile:
  memoryFileContent = memoryFile.readlines()

  memoryDeclarationBoundsStart = -1
  memoryDeclarationBoundsEnd = -1

  for index, line in enumerate(memoryFileContent):
    if 'case(address[9:2])' in line:
      memoryDeclarationBoundsStart = index + 1
    if memoryDeclarationBoundsStart != -1 and 'endcase' in line:
      memoryDeclarationBoundsEnd = index
      break
  
  del memoryFileContent[memoryDeclarationBoundsStart:memoryDeclarationBoundsEnd]
  memoryFileContent = memoryFileContent[:memoryDeclarationBoundsStart] + compiledMemory + memoryFileContent[memoryDeclarationBoundsStart:]

  memoryFile.seek(0)
  memoryFile.truncate()
  memoryFile.writelines(memoryFileContent)
