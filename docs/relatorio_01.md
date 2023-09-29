# Aprendizados

### Ambiente de testes
Ao longo do projeto, conforme o código ficava mais complexo surgiu cada vez mais a necessidade de visualizar e testar
nossas mudanças. Aprendemos bastante como esse ambiente funciona, usando o verilator para gerar código c++ e implementar
testbenches e usando o gtkwave pra visualizar as formas de onda.

### Ambiente de desenvolvimento
Para organizar nosso ambiente de desenvolvimento, usamos MakeFile como ferramenta de build. Foi minha primeira vez
mexendo com ela e foi importante pra entender a sua filosofia e entender melhor outros projetos, já que é uma 
ferramenta bem comum nessa área.

Além disso, para facilitar nossos testes, desenvolvemos ferramentas automatizadas para converter assembly pra 
machine code. Foi bom pra melhorar o entendimento da anatomia das instruções RISC e pegar alguns detalhes,
como endianess.

### Entendimento da pipeline
Implementar a pipeline possibilitou um entendimento muito mais fundo de como ela funciona. Isso desmistificou 
o que são os registradores de pipeline, como organizá-los e porque forma-se as etapas. 

Além disso, a implementação dos hazards nos ensinou a ver o quão complexo é a interação entre os estágios da
pipeline, duplicação de hardware pra cobrir esses casos, etc. Com isso, aprofundamos muito mais o conhecimento
visto na materia de arquitetura de computadores.
