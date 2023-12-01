# Apresentação

# Entregas Passadas

## Instruções RV32I
Nesta entrega as instruções RV32I foram finalizadas, com o término da implementação dos jumps e das instruções de store/load.

### JAL e JALR
As instruções jal e jalr foram implementadas utilizando o módulo BranchUnit, que já era utilizado para as instruções de branch, utilizando sinais de controle adicionais. Para guardar o PC+4 no registrador, utilizamos a própria ALU para fazer a soma do sinal de PC com um sinal de 4.

# Suporte para código C
A toolchain de compilação foi alterada para escrever em um hex file e suportar
código C como fonte, em vez de apenas código assembly. Para isso, usamos várias
flags para acertar o output do gcc para que ficasse compatível com a nossa CPU.

Infelizmente não deu tempo de usar um arquivo .crt custom, e no momento estamos
inicializado o stack pointer hardcoded na ROM.

# Integração instruções do tipo C
Com a memória suportando endereços desalinhados foi possível reativar esse módulo.
Foi necessário realizar pequenas mudanças pois foi usado um padrão de código 
verilog que não era sintetizável, mas tirando isso foi necessário resolver alguns
bugs detectados. 

O princpial deles foi que a instrução de jal usava hardcoded um offset de 4. Foi
alterado para no caso de instruções compactas, usar `PC + 2` em vez de `PC + 4`.

# Aprendizados

## Habilidades de debugging
Debuggar hardware + software não é fácil. Ter que resolver vários problemas de 
integração da pipeline, que as vezes só apareciam em códigos mais complexos ou
as vezes eram intermitentes, definitivamente impactou nossa capacidade de 
debugging. Conseguir identificar e isolar cenários de teste foi vital para 
conseguir concluir essa fase.

Além disso, ter que debuggar tanto código assembly compilado nos deu muito mais
fluência em assembly, conseguindo identificar mais rapidamente padrões comuns
que aparecem nesse nível. Junto disso, conseguir olhar para uma instrução e ter
uma intuição muito boa de o que deveria estar acontecendo na pipeline e quais 
registradores da CPU vão ser afetados também foi algo que desenvolvemos.

## Conhecimentos de compilação
Apesar de ter noções rasas anteriormente, configurar uma toolchain de compilação 
pro hardware nos ensinou bastante sobre como o código compilado é estruturado no
binário. Tivemos um maior entendimento das seções que são geradas, quando certas
coisas vão para rodata, quando vão para data, como o tamanho dessas seções podem
ser configuradas, etc.

Sinto que isso deixou de ser uma black box para algo mais palpável.

## Lidando com ambientes restritos em memória
Por questões de limites da FPGA, tínhamos um cap de quanta memória conseguiríamos
usar em nossos programas. Isso nos fez ser muito mais intencional na arquitetura
do nosso código, otimizando o espaço de código sempre que possível. Além disso,
passamos a apreciar muito os benefícios da extensão C de instruções.

# Contribuições

- **Luiz Henrique**: 
- **Larissa**: 
- **Gabriel**: 
- **Yan**: JAL e JALR
- **Daniel**: 
- **Vinícius**: 