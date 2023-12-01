# Apresentação

# Entregas Passadas

## Instruções RV32I

Nesta entrega as instruções RV32I foram finalizadas, com o término da implementação dos jumps e das instruções de store/load.

### JAL e JALR

As instruções jal e jalr foram implementadas utilizando o módulo BranchUnit, que já era utilizado para as instruções de branch, utilizando sinais de controle adicionais. Para guardar o PC+4 no registrador, utilizamos a própria ALU para fazer a soma do sinal de PC com um sinal de 4.

### _Loads_ e _Stores_

A _Cache L1_ foi modificada para suportar novos loads e stores quebrados. Ela continua mantendo sua eficiente ao olhar o _hit_ do endereço atual e do próximo endereço (somente quando preciso).

Para implementar _loads_ desalinhados, foi necessário adicionar um fio _bigCacheData_ que guarda os dados guardados na _cache_ do endereço atual e do próximo endereço (de forma assíncrona). A _cache_ faz a leitura dos dados necessários através da sua máquina de estados e logo após devolve apenas os _bits_ requisitados, estendendo o sinal se a instrução for sinalizada e preenchendo com 0 caso contrário.

Para implementar _stores_, foi adicionado um fio _bigCacheDataToWrite_ que guarda os dados que devem ser escritos na memória. A _cache_ lê os endereços necessários (se for preciso) e modifica o _bigCacheDataToWrite_ (de forma assíncrona) com os novos bits que devem ser escritos. Depois da leitura os dados no _bigCacheDataToWrite_ são escritos na memória novamente (apenas o(s) endereço(s) necessário(s)). Essa transição de ações é feita com a máquina de estados e sinais de registradores de escrita e leitura.

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

# Driver da Matriz de LEDs

Mudamos a comunicação com o periférico para, ao invés de setarmos diretamente os bits
que serão enviados para o periférico (8 sinais de coluna e 8 sinais de linhas), indicarmos
qual posição da matriz queremos mudar de valor e qual é o novo valor dela. Dessa forma, o
próprio periférico guarda seu estado (valor de cada um dos 64 LEDs).
A partir do estado de cada LED, o periférico itera sobre cada uma das linhas da matriz e,
a cada ciclo, acende apenas os LEDs da linha em questão. Como isso acontece todos os ciclos
de clock, dá a ilusão de que todos os LEDs estão acesos ao mesmo tempo.

# Implementação do jogo Stacker

Como escolha de um programa escrito em linguagem alto nível, foi feita a implementação
do jogo Stacker na linguagem C. Sua implementação está no arquivo `main.c`.
Ela utiliza os drivers da matrix de led e do botão, com uma lógica simples de código em C.
A estrutura principal é o Bar que representa a barrinha que se move na matrix de LED.

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

## Conhecimentos sobre memória

Para conseguir utilizar corretamente as instruções do tipo C e poder implementar as instruções de _load_ e _store_ faltantes, tivemos que aprender melhor sobre como a memória lida com endereços desalinhados e como ela escreve em apenas uma parte de um endereço (como no _sb_ e _sh_, por exemplo). Isso nos fez ter uma ideia melhor do motivo de alocar quantidades múltiplas de 4 _bytes_ de tamanho ser eficiente para o processamento de um programa. Isto ajudou bastante a concretizar teorias aprendidas em outras disciplinas da graduação (como arquitetura de computadores e linguagem de máquina).

Também pudemos compreender o motivo da _cache_ deixar a leitura de instruções compactas tão mais eficiente, uma vez que muitas vezes ela já salva na _cache_ mais de uma instrução por vez. Pudemos ver essa eficiência na prática ao simularmos nosso jogo no _gtkwave_.

# Contribuições

- **Luiz Henrique**:
- **Larissa**: Implementação do driver da matriz por software (plano A, descartado), auxílio da implementação do jogo Stacker e auxílio na implementação do Rodolfofo.
- **Gabriel**: Novas implementações da _cache_, auxílio na integração das instruções de divisão na _pipeline_, _debug_ das funcionalidades adicionadas e auxílio na implementação do plano A- (nomeado errôneamente de plano B na branch _ploc/planb_).
- **Yan**: JAL e JALR
- **Daniel**: Elaboração do Jogo
- **Vinícius**:
