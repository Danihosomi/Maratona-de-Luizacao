# Apresentação

## Entregas passadas

### Integração do MMU com a CPU

#### Desafio na integração com o pipeline

Como explicado na entrega passada, agora a _cache_ pode fazer com que a leitura e escrita de memória na fase do _DataMemory_ demore mais de um ciclo de _clock_. Isso faz com que precisemos de um hazard para que a _pipeline_ espere o DataMemory terminar uma leitura ou escrita na memória.

Para resolver o problema, foi criada a _FreezeUnit_: uma unidade que toma conta de quando precisamos congelar toda a execução da _pipeline_. Ela olha a partir do _DataMemorySuccess_ se a _pipeline_ precisa parar para que a operação na memória seja executada.

Vale lembrar que o valor do fio _DataMemorySuccess_ é:

- **1**, se a _MMU_ não estiver acessando a memória do _DataMemory_ e
- **0**, caso contrário.

#### Localização

A _FreezeUnit_ e a nova _CPU_ foram implementadas na branch **feat/MMU-CPU-Integration**.

### Instruções I e M

Na entrega passada realizamos a implementação de diversas instruções RV32I e RV32M que estavam na branch **feat-add-alu-instructions** mas essas alterações precisavam ser integradas na branch principal. Todas as instruções foram revisadas e testadas. Algumas ainda precisavam ser implementadas ou corrigidas.

Instruções do tipo I implementadas nesta etapa 
Function | ALUControl
--- | ---
STL, STLI | 100101
SLTU, SLTIU | 100110
AUIPC | Soma

A instrução AUIPC foi implementada com um condicional no próprio módulo da CPU, para utilizar pc como um dos operandos da ALU.

### Instruções A

Realizamos a implementação da instrução swap diretamente no módulo register file. O código está na branch **feat/type-a-instructions** 

## Entregas Fase 3

### Implementação da Matriz de Led como periférico

#### Conexão física

Aqui a Lari explica como foi fazer a conexão física da placa com o led e ajustar os fios no _top_.

#### Modo de Uso

Para escrever na matriz, é necessário fazer uma chamada de escrita para um endereço de memória, de acordo com a seguinte tabela:

| Endereço   | Descrição                                                                                           |
| ---------- | --------------------------------------------------------------------------------------------------- |
| 0xA0000000 | Os 8 primeiros bits do registrador dado são usados para sinalizar as **colunas** da matriz em ordem |
| 0xA0000001 | Os 8 primeiros bits do registrador dado são usados para sinalizar as **linhas** da matriz em ordem  |

Onde o bit menos significativo sinaliza a linha/coluna menos significativa.

Por exemplo, o seguinte código em RISCV

```assembly
addi x1, x0, 0b10101111
lui x2, 0xA0000
sw x1, 0(x2)
```

ativa as colunas 8, 6, 4, 3, 2, 1 da Matriz.

# Aprendizados

Aprendizados vão aqui

# Contribuições

- **Luiz Henrique**:
- **Larissa**:
- **Gabriel**: Integração da MMU com a CPU.
- **Yan**: Revisão de instruções já implementadas, merge da branch de instruções e implementação de novas instruções (set less e AUIPC)
- **Daniel**: Merge da branch de instruções e implementação de novas instruções do tipo A e tipo C.
- **Vinícius**: Revisão de instruções já implementadas, além do merge da branch de instruções.
