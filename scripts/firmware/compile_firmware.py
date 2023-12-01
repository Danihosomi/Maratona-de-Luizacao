from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('--src', dest='srcPath', type=str)
parser.add_argument('--dest', dest='memoryPath', type=str)
args = parser.parse_args()

compiledMemory = []
instructionAddress = 0

# Starting at address 8
compiledMemory.append(f'00000000\n')
compiledMemory.append(f'00000000\n')

with open(args.srcPath, 'rb') as machineCode:
  while (instruction := machineCode.read(4)):
    endiannessCorrectedInstruction = bytearray(instruction)
    endiannessCorrectedInstruction.reverse()

    compiledMemory.append(f'{endiannessCorrectedInstruction.hex()}\n')
    instructionAddress += 1


compiledMemory.append(f'00000000\n')

with open(args.memoryPath, 'w') as memoryFile:
  for line in compiledMemory:
    memoryFile.write(line)
