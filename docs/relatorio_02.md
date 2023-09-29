# Apresentação

Talvez explicitar aqui o que fizemos

Acho que seria legal fazer isso por slide (mas podemos botar um resumo aqui)

# Aprendizados

- **Daniel**: Entendimento do funcionamento das instruções do tipo A, da ALU, ALUControl e do Control. Assim como um conhecimento maior sobre Verilog para implementação das instruções do tipo A e para modificar todo o sistema da ALU para aumentar o número de operações suportadas.


### Memory-mapped I/O
Vou tentar falar um pouquinho das escolhas de endereço dos periféricos

### Branch
Para implementar o branch, nós precisamos expandir os códigos do ALUControl, responsável por determinar em qual modo a ALU deve operar.
Os novos códigos criados são:

Function | ALUControl
--- | ---
BEQ | 1000
BNE | 1001
BLT | 1010
BGE | 1011
BLTU | 1100
BGEU | 1101

Em cada uma dessas operações, os operandos são comparados entre si e, caso o resultado da comparação seja verdadeiro, então o resultado da ALU é setado como zero, implicando que a saída "zero" da ALU (que sinaliza quando o resultado da ALU é zero) seja positiva, triggando então o branch.
É importante ressaltar também que a diferenciação das instruções signed e unsigned foram feitas da seguinte forma:
- Unsigned: a comparação foi feita normalmente
- Signed: checamos o bit mais significativo dos operadores pra checar se estamos comparando um número negativo com um positivo. Se sim, o número positivo é maior, se não, comparamos eles normalmente.

Além das modificação na ALU, foi implementada a BranchUnit, responsável por:
- Detectar se um branch deve ser feito, a partir do sinal zero da ALU e do sinal branch do controle
- Calcular o endereço de destino do branch, somando o valor do program counter com o imediato
- Refazer o branch caso a pipeline esteja Stalled

Os principais desafios dessa parte foram tratar instruções do tipo signed e unsigned e lidar com comportamentos não esperados, como por exemplo quando o branch é detectado e a pipeline está stalled, necessitanto guardar o branch para executar novamente.

### Cache L1 e MMU

#### Implementação Cache

Nesta etapa foi implementado um módulo de *cache L1* com 32 índices com os seguintes dados:

- **clean**: Guarda se o dado guardado naquela posição da cache está 'limpo' (corresponde ao valor da memória)
- **data**: Guarda o valor da memória guardado na Cache
- **tag**: Guarda os 4 bits mais significativos da memória que foi guardada no *data*

Os 5 bits menos significativos da memória são usados para definir o índice dela na cache. O padrão de cache utilizado foi uma *direct-mapped cache*.

Para a implementação, também foi usada uma máquina de estados com 4 fases:
- **IDLE**: A *cache* não está fazendo nada e espera uma requisição. Caso ela receba uma requisição de leitura que dê *hit*, marca a leitura como feita e aciona o sinal de *cacheReady* e continua no mesmo estado. Caso contrário, vai para o estado de **READ** ou **WRITE**, a depender da requisição. 
- **READ**: A *cache* está lendo da memória. Continua no mesmo estado até receber um sinal de *memoryReady*. Daí escreve o dado lido na *cache* e vai para o estado **READY**.
- **WRITE**: A *cache* está escrevendo na memória. Continua no mesmo estado até receber um sinal de *memoryReady*. Marca o dado da *cache* como sujo, caso o endereço esteja na *cache*, e muda para o estado **READY**. 
- **READY**: A *cache* está pronta. Manda o sinal de *cacheReady* e volta para o estado **IDLE** no final do ciclo de *clock*.

#### Implementação MMU

Também foi implementado um módulo MMU (*Memory Management Unit*) para organizar melhor a memória no design do processador e facilitar a integração dos *caches* na pipeline. O MMU guarda os seguintes módulos:
- **InstructionMemoryCacheL1**: *Cache* de leitura das instruções.
- **DataMemoryCacheL1**: *Cache* da memória do processador.
- **MemoryHandler**: Módulo que faz a arbitragem de quem vai poder ler e escrever na memória em cada momento. Ele também decide se a leitura/escrita deve ser feita em um periférico.

Também foi tomado o cuidado de não escrever nem ler da cache memórias reservadas para periféricos (as *caches* ficam no estado IDLE nesse momento e os sinais de *success* são dados pela memória diretamente)

#### Desafio na integração com o pipeline

O *cache* faz a escrita na memória ser mais lenta e a leitura, quando não há *hit*, também. Esse fato faz com que a pipeline atrase em alguns momentos de acesso à memória. Este fato faz com que seja necessário implementar mais *hazards* para congelar a pipeline enquanto espera por esse acesso.

Já havia um hazard para lidar com esperas na leitura de instruções, mas nenhum para esperas na fase de leitura e escrita na memória no pipeline. O *hazard* implementado faz com que a pipeline espere essa leitura.

### Desenvolvimento em FPGA
Esta etapa foi marcada por diversas lutas pra fazer nosso circuito funcionar na FPGA.

(Talvez essa contextualização faça mais sentido ir na apresentação e aqui a gente foca no aprendizado só)
O primeiro desafio enfrentado foi conseguir sintetizar a placa sem erros. Tendo que passar por diversas mensagens de erros crípticas, vou comentar como isso ensinou a depurar circuitos grandes e a identificar alguns padrões que podem ter riscos, como cases sem defaults

Em seguida veio o desafio de entender um bug no circuito que só acontecia na FPGA enquanto que no emulador funcionava tudo certo. Vou comentar aqui sobre como isso ensinou a entender os diferentes elementos que compõe a FPGA, como acontece a inferência deles pelas ferramentas de sintese e como configurar alguns parâmetros dessas ferramentas.

Finalmente, com o circuito sintetizável e correto, veio o desafio de fazer ele caber na placa com uma frequência esperada. Vou desenvolver aqui o que eu aprendi sobre os recursos da FPGA

Acima de tudo, me ensinou a ter paciência.

### Instruções RISCV32 da ALU
Todas as instruções implementadas nessa entrega estão na branch: feat-add-alu-instructions.
Para questões de avaliações e implementações, por favor mudar para aquela Branch.

### Instruções RISCV32I na ALU
Esta etapa foi uma continuação da última fase do projeto, onde implementamos as instruções mais básicas apresentadas pelo livro. Aqui continuamos o processo, adicionando suporte da ALU para mais instruções do conjunto I.

Function | ALUControl
--- | ---
XOR | 0101
SLL | 0011
SRL | 0100
SRA | 0111

Além destas, suas respectivas versões com imediato também foram implementadas e testadas. O maior desafio aqui foi perceber que todos os fios e registradores representavam, por padrão, valores não sinalizados. Para o shift aritmético isso era um problema por exemplo, uma vez que ele se tornava essencialmente igual ao shift lógico.

Apesar de parecer que precisaríamos mudar muita coisa, foi suficiente alterar os operandos e resultado da ALU para o tipo signed.

### Intruções RISCV32A na ALU
Nessa etapa foi implementada as instruções Atômicas do RISCV32.

Function | ALUControl
--- | ---
AMOADD.W | 000010
AMOXOR.W | 000101
AMOAND.W | 000000
AMOOR.W | 000001
AMOMIN.W | 100000
AMOMINU.W | 100010
AMOMAX.W | 100001
AMOMAXU.W | 100011

Os principais desafios dessa implementação foi uma adaptação da ALU para a inserção de mais instruções e a codificação dessas operações para novas instruções. Fora isso, a implementação não foi
das mais complexas pois muito código foi reutilizado das outras operações do tipo I.


# Contribuições
- **Luiz Henrique**: Implementação dos periféricos e ajustes para síntese do circuito na FPGA.
- **Larissa**: Implementação das funções de branch integradas na pipeline.
- **Gabriel**: Implementação da Cache L1, MMU e parte da integração com a pipeline.
- **Yan**: Continuação das instruções do conjunto I e testes de instruções.
- **Daniel**: Implementação das intruções do conjunto A e refatoração da ALU.
- **Vinícius**: Implementação das intruções do conjunto M e refatoração da ALU.