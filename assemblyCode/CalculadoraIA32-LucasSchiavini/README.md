# Calculadora IA32

## Resumo:

Calculadora em assembly IA32.

## Operações
```
1 - soma, 
2 - subtração
3 - multiplicação,
4 - dividir, 
5 - potenciação, 
6 - fatorial 
7 - soma (concatenaçao) de strings 
8 - multiplicação (repetição) de strings 
9 - sair. A opção 9 termina o programa. 
```

## Requisitos

Depois, cada opção deve pedir dois operandos (sem pedir mensagem, após digitar as opções de 1 a 5 o programa fica esperando digitar um número+ENTER e depois outro número+ENTER). 


Os números podem ser positivos ou negativos sempre em decimal. 
Após a opção 6 deve esperar só um número. 

Os números podem ter vários dígitos. 

A calculadora deve trabalhar com números de 16 bits (deve ser verificado que os números estejam na faixa de 16 bits com sinal).

Deve verificar se deu overflow (se a saída é maior a 16 bits - indicando o resultado obtido e a mensagem DEU OVERFLOW).

A leitura e saída de dados deve ser feita por funções. 

A opção 7 deve esperar o usuário digitar um STRING + ENTER e depois digitar um segundo STRING+ENTER. 

A opção 8, o usuário vai digitar primeiro um STRING+ENTER e depois um número+ENTER. 

Assumir que os strings nunca vão ser maiores a 20 caracteres. 

A opção 7 deve concatenar os 2 strings (SEM adicionar espaço entre eles) num único string e mostrar isso na tela.

 A opção 8 deve repetir o string como se fossem vários concatenando os strings até às vezes indicadas pelo número. 

Exemplo: Se o usuário digitar “Assembly” e “3”, então a saída deve ser um string “AssemblyAssemblyAssembly”. 

Assumir que no máximo o número será 9 (ou seja um único dígito, para poder reservar no máximo um string de tamanho 20x9 para a saída).


## Estrutura do Projeto:
```
  calculadora.asm
  README.md
  run.sh
```
## Ambiente:
```
OS: Linux
gcc: version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)
cmake: version 3.16.3
```
## Como rodar:

Rodar com script e gdb:

```
> chmod -x run.sh
> ./run.sh
> (gdb) run
```
Rodar sem script:

```
> nasm -f elf32 -g -F dwarf -o calculadora.o calculadora.asm

> ld -m elf_i386 -o calculadora calculadora.o

> chmod -x calculadora && ./calculadora
```


OutPut Files :
 - calculadora.o



