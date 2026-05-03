# Trabalho Final Programação Lógica: Jogo Batalha Naval 

## Introdução
Com o objetivo de utilizar a programação lógica em Prolog, com a declaração de fatos e regras, foi desenvolvida a atividade final da disciplina. O jogo conta com inferências lógicas, sem o uso do controle imperativo explícito.

## Descrição do jogo
O jogo diz respeito a uma matriz, que compõe o tabuleiro do jogo. Esse tabuleiro, que representa o mar, possui equipamentos marítimos que devem ser encontrados pelos jogadores. Em três tentativas, o usuário tenta se aproximar cada vez mais de seu alvo, escolhendo as coordenadas (entre linhas e colunas). Se encontrar um dos submarinos, vitória. Caso as tentativas se esgotem: fim de jogo.

## Modelagem do conhecimento
```
tabuleiroInicial([
    ['~', '~', '~', '~', '~'],
    ['~', '~', '~', '~', '~'],
    ['~', '~', '~', '~', '~'],
    ['~', '~', '~', '~', '~'],
    ['~', '~', '~', '~', '~']
]).

submarino(1, 1).
submarino(2, 3).
submarino(4, 2).
submarino(0, 4).
```
É definido o tamanho do tabuleiro, bem como a posição dos submarinos. 

```
jogar :-
    writeln('Bem-vindo ao jogo Batalha Naval!'),
    writeln('O seu objetivo é encontrar os submarinos: <^>'),
    writeln('Você tem 3 chances, boa sorte!'),
    writeln('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'),
    tabuleiroInicial(Tabuleiro),
    exibir(Tabuleiro),
    jogadas(3, Tabuleiro).

jogadas(0, _) :-
    writeln('\nFim de jogo! Suas chances acabaram e não encontrou os submarinos...').

jogadas(Chances, Tabuleiro) :-
    Chances > 0, 
    format('\nVocê tem ~w chance(s).~n', [Chances]),
    writeln('Digite a LINHA (0, 1, 2, 3 ou 4):'),
    read(L),
    writeln('Digite a COLUNA (0, 1, 2, 3 ou 4):'),
    read(C),
    tiro(L, C, Tabuleiro, NovoTabuleiro, Resultado),
    resultado(Resultado, Chances, NovoTabuleiro).
```
Há um cabeçalho inicial, impresso no início da rodada. O tabuleiro inicial é exibido para o jogador, com todas as posições marcando “água”. São definidas as regras das jogadas, a quantidade de chances e os resultados. Caso o jogador encontre o submarino ou não tenha mais tentativas, o jogo encerra. Na regra recursiva do turno são aplicados backtracking (retrocesso) e unificação (que relaciona as jogadas ao tabuleiro, para verificação de acerto).

```
resultado(acertou, _, NovoTabuleiro) :-
    writeln('\n~~~~ Você atirou no submarino <^> e venceu o jogo! ~~~~'),
    writeln('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'),
    writeln('\n~~~~~~~~~~~~~~<~~^~>~~~~~~~~~~~~~~~~~~~~~~~~~~'),
    writeln('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'),
    exibir(NovoTabuleiro).

resultado(errou, Chances, NovoTabuleiro) :-
    writeln('\nSplashhhhh! Você atirou na água... não foi dessa vez!\n'),
    exibir(NovoTabuleiro),
    ChancesRestantes is Chances - 1,
    jogadas(ChancesRestantes, NovoTabuleiro).

tiro(L, C, Tabuleiro, NovoTabuleiro, acertou) :-
    submarino(L, C),
    atualizar(Tabuleiro, L, C, '<^>', NovoTabuleiro).

tiro(L, C, Tabuleiro, NovoTabuleiro, errou) :-
    \+ submarino(L, C),
    atualizar(Tabuleiro, L, C, 'x', NovoTabuleiro).
```
Verificação do resultado, se o jogador escolheu a posição da linha e coluna correta em relação ao submarino. É exibido também o tabuleiro com o que havia na posição, um “x” para erro e “<^>” para o submarino.

```
atualizar(Matriz, L, C, NovoValor, NovaMatriz) :-
    nth0(L, Matriz, LinhaAntiga),
    substituir(LinhaAntiga, C, NovoValor, NovaLinha),
    substituir(Matriz, L, NovaLinha, NovaMatriz).

substituir(Lista, Indice, NovoElemento, NovaLista) :-
    nth0(Indice, Lista, _, Resto),
    nth0(Indice, NovaLista, NovoElemento, Resto).
```
Como as listas são imutáveis, a exibição ocorre com cópias que alteram alguns elementos. O predicado nth0 é utilizado para manipulação das listas. Ele localiza o elemento da posição desejada, pode inserir um novo elemento ou isolar os demais, separando o resto.
Primeiramente é alterado o elemento da lista e depois alterada a lista entre as listas. 

```
exibir([]).
exibir([Linha|Resto]) :-
    writeln(Linha),
    exibir(Resto).
```
Recursividade de listas para imprimir no formato de matriz, como uma lista de listas.

## Regras principais
- O tabuleiro possui 25 posições, onde foram distribuídos 4 submarinos. 
- Serão 3 tentativas para acertar a localização do submarino.
- O jogador deve selecionar a linha e a coluna da posição que acredita estar o submarino, inserindo números de 0 a 4. 
- A jogada será verificada, caso a coordenada linha/coluna esteja certa o jogador vence e encerra o jogo. 
- Caso contrário, segue até o final de suas tentativas. 
- Se finalizarem as tentativas sem acerto, o jogador perde a batalha!

## Exemplos de consultas e resultados
### Teste 01: Derrota

<img width="382" height="320" alt="image" src="https://github.com/user-attachments/assets/345fa438-b081-4373-9d0f-953d9c9658f8" />

```
jogar.
```
Inicia o jogo!

```
Digite a LINHA (0, 1, 2, 3 ou 4):
3
Digite a COLUNA (0, 1, 2, 3 ou 4):
4

[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, x]
[~, ~, ~, ~, ~] 
Splashhhhh! Você atirou na água... não foi dessa vez!
```
Resultado da jogada [3, 4].

```
Você tem 2 chance(s).
Digite a LINHA (0, 1, 2, 3 ou 4):
2
Digite a COLUNA (0, 1, 2, 3 ou 4):
1
Splashhhhh! Você atirou na água... não foi dessa vez!
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, x, ~, ~, ~]
[~, ~, ~, ~, x]
[~, ~, ~, ~, ~] 
```
Resultado da jogada [2, 1]

```
Você tem 1 chance(s).
Digite a LINHA (0, 1, 2, 3 ou 4):
4
Digite a COLUNA (0, 1, 2, 3 ou 4):
0
Splashhhhh! Você atirou na água... não foi dessa vez!
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, x, ~, ~, ~]
[~, ~, ~, ~, x]
[x, ~, ~, ~, ~]
Fim de jogo! Suas chances acabaram e não encontrou os submarinos... 
```
Resultado da jogada [4, 0]. Três tentativas sem acertos, jogo encerrado sem vitória.

<img width="719" height="371" alt="image" src="https://github.com/user-attachments/assets/b991e30e-9a1c-43e3-b5cb-c8e7b0534572" />

### Teste 02: Vitória

```
Bem-vindo ao jogo Batalha Naval!
O seu objetivo é encontrar os submarinos: <^>
Você tem 3 chances, boa sorte!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]

Você tem 3 chance(s).
Digite a LINHA (0, 1, 2, 3 ou 4):
4
Digite a COLUNA (0, 1, 2, 3 ou 4):
2
~~~~ Você atirou no submarino <^> e venceu o jogo! ~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~<~~^~>~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, ~, ~, ~]
[~, ~, <^>, ~, ~] 
```
Resultado da jogada [4, 2]. Jogador venceu o jogo e encerrou as tentativas.

<img width="573" height="681" alt="image" src="https://github.com/user-attachments/assets/95e45ae5-9e51-479a-849a-c6ad3237be3c" />

## Conclusão
O desenvolvimento do projeto permitiu a compreensão do paradigma de programação lógica, na solução de problemas através de fatos e relações lógicas, utilizando regras ao invés de comandos imperativos. 

A implementação do jogo Batalha Naval, utilizou métodos como backtracking, unificação, listas e demais conceitos para gestão do estado do jogo, realização de consultas, verificação de coordenadas e atualização do tabuleiro. Aplicando a recursividade e a manipulação de listas foi possível lidar com a imutabilidade dos dados e utilizar o Prolog como uma alternativa viável para aplicar os fundamentos da disciplina.
