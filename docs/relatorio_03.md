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

## Entregas Fase 3

Aqui vão as entregas da fase atual

# Aprendizados

Aprendizados vão aqui

# Contribuições

- **Luiz Henrique**:
- **Larissa**:
- **Gabriel**: Integração da MMU com a CPU.
- **Yan**: Revisão de instruções já implementadas, merge da branch de instruções e implementação de novas instruções (set less e AUIPC).
- **Daniel**: Merge da branch de instruções e implementação de novas instruções do tipo A e tipo C.
- **Vinícius**:
