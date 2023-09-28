# Apresentação

Talvez explicitar aqui o que fizemos

# Aprendizados

### Memory-mapped I/O
Vou tentar falar um pouquinho das escolhas de endereço dos periféricos

### Branch
Para implementar o branch, nós precisamos expandir os códigos do ALUControl, responsável por determinar em qual modo a ALU deve operar.
Os novos códigos criados são:

Function | ALUControl
--- | ---
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

### Desenvolvimento em FPGA
Esta etapa foi marcada por diversas lutas pra fazer nosso circuito funcionar na FPGA.

(Talvez essa contextualização faça mais sentido ir na apresentação e aqui a gente foca no aprendizado só)
O primeiro desafio enfrentado foi conseguir sintetizar a placa sem erros. Tendo que passar por diversas mensagens de erros crípticas, vou comentar como isso ensinou a depurar circuitos grandes e a identificar alguns padrões que podem ter riscos, como cases sem defaults

Em seguida veio o desafio de entender um bug no circuito que só acontecia na FPGA enquanto que no emulador funcionava tudo certo. Vou comentar aqui sobre como isso ensinou a entender os diferentes elementos que compõe a FPGA, como acontece a inferência deles pelas ferramentas de sintese e como configurar alguns parâmetros dessas ferramentas.

Finalmente, com o circuito sintetizável e correto, veio o desafio de fazer ele caber na placa com uma frequência esperada. Vou desenvolver aqui o que eu aprendi sobre os recursos da FPGA

Acima de tudo, me ensinou a ter paciência.


# Contribuições
- **Luiz Henrique**: Implementação dos periféricos e ajustes para síntese do circuito na FPGA.
- **Larissa**: Implementação das funções de branch integradas na pipeline.