%batalha naval ~~<^>~~
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

atualizar(Matriz, L, C, NovoValor, NovaMatriz) :-
    nth0(L, Matriz, LinhaAntiga),
    substituir(LinhaAntiga, C, NovoValor, NovaLinha),
    substituir(Matriz, L, NovaLinha, NovaMatriz).

substituir(Lista, Indice, NovoElemento, NovaLista) :-
    nth0(Indice, Lista, _, Resto),
    nth0(Indice, NovaLista, NovoElemento, Resto).

exibir([]).
exibir([Linha|Resto]) :-
    writeln(Linha),
    exibir(Resto).
