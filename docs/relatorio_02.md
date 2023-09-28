# Apresentação

Talvez explicitar aqui o que fizemos

# Aprendizados

### Memory-mapped I/O
Vou tentar falar um pouquinho das escolhas de endereço dos periféricos

### Desenvolvimento em FPGA
Esta etapa foi marcada por diversas lutas pra fazer nosso circuito funcionar na FPGA.

(Talvez essa contextualização faça mais sentido ir na apresentação e aqui a gente foca no aprendizado só)
O primeiro desafio enfrentado foi conseguir sintetizar a placa sem erros. Tendo que passar por diversas mensagens de erros crípticas, vou comentar como isso ensinou a depurar circuitos grandes e a identificar alguns padrões que podem ter riscos, como cases sem defaults

Em seguida veio o desafio de entender um bug no circuito que só acontecia na FPGA enquanto que no emulador funcionava tudo certo. Vou comentar aqui sobre como isso ensinou a entender os diferentes elementos que compõe a FPGA, como acontece a inferência deles pelas ferramentas de sintese e como configurar alguns parâmetros dessas ferramentas.

Finalmente, com o circuito sintetizável e correto, veio o desafio de fazer ele caber na placa com uma frequência esperada. Vou desenvolver aqui o que eu aprendi sobre os recursos da FPGA

Acima de tudo, me ensinou a ter paciência.


# Contribuições
- **Luiz Henrique**: Implementação dos periféricos e ajustes para síntese do circuito na FPGA.