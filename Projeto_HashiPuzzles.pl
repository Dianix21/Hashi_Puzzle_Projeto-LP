%Diana Goulao - IST1102531

%:- [codigo_comum, puzzles_publicos].
:- set_prolog_flag(answer_write_options,[max_depth(0)]).


/* troca_elementos(Lista, Indice, El_Antigo, Novo_El, NovaLista) significa que NovaLista e a
Lista que resulta de Lista pela alteracao do El_antigo pelo Novo_El num determinado Indice */

troca_elementos(Lista, Indice, El_Antigo, Novo_El, NovaLista) :-
   nth1(Indice, Lista, El_Antigo, Resto),
   nth1(Indice, NovaLista, Novo_El, Resto).



/* extrai_ilhas_linha(Num_Linha, Linha, Ilhas) significa que Ilhas e
Lista que contem todas as ilhas de uma linha */

extrai_ilhas_linha(Num_Linha, Linha, Ilhas):-
    extrai_ilhas_linha(Num_Linha, Linha, Linha, [], Ilhas). %a repeticao do arg Linha e para obter o indice do elemento correspondente a coluna pois a outra lista esta a ser iterada

extrai_ilhas_linha(_, _, [], Ilhas, Ilhas).

extrai_ilhas_linha(Num_Linha, Linha, [N_Pontes|Resto], Ilhas_Aux, Ilhas):-
    N_Pontes > 0, !,
    nth1(Coluna, Linha , N_Pontes),
    troca_elementos(Linha, Coluna, N_Pontes, 0, NovaLinha), %a troca do arg N_pontes por 0 serve para em o caso de ilhas com o mesmo numero de pontes o predicado nth1 obter a coluna certa
    append(Ilhas_Aux, [ilha(N_Pontes,(Num_Linha, Coluna))], NovaIlha_Aux),
    extrai_ilhas_linha(Num_Linha, NovaLinha, Resto, NovaIlha_Aux, Ilhas).

extrai_ilhas_linha(Num_Linha, Linha, [_|Resto], Ilhas_Aux, Ilhas):-
    extrai_ilhas_linha(Num_Linha, Linha, Resto, Ilhas_Aux, Ilhas).



/* ilhas(Puzzle, Ilhas) significa que Ilhas e a
Lista ordenada que contem todas as ilhas de uma puzzle */

ilhas(Puzzle, Ilhas):- ilhas(Puzzle, Puzzle, [], Ilhas).

ilhas([],_, Ilhas, Ilhas).

ilhas([Cab|Resto], Puzzle, Aux_Ilhas, Ilhas):-
    nth1(Num_Linha, Puzzle, Cab),
    extrai_ilhas_linha(Num_Linha, Cab, Ilhas_linha),
    append(Aux_Ilhas, Ilhas_linha, NovaAux_Ilhas),
    troca_elementos(Puzzle,Num_Linha,Cab,[],NovoPuzzle),
    ilhas(Resto, NovoPuzzle, NovaAux_Ilhas, Ilhas).




/* vizinhas_aux(Lst1, ElResultado) significa que ElResultado e a lista que contem o ultimo elemento da lista Lst1 se esta nao for vazia */

vizinhas_aux(Lst1, ElResultado):-
   Lst1 == [] -> ElResultado=[];
   (last(Lst1,ElResultadoAux),
   ElResultado = [ElResultadoAux]).



/* vizinhas(Ilhas, Ilha, Vizinhas) significa que Vizinhas e a lista que contem todas as Ilhas vizinhas de Ilha */

vizinhas(Ilhas, Ilha, Vizinhas):- vizinhas(Ilhas, Ilha,0,[], [], [], [], [], Vizinhas). %O 0 serve para controlar onde o programa entra

vizinhas([],_,1, _, _, _, _, Vizinhas, Vizinhas).

vizinhas([],Ilha,0, IlhasCimaAux, IlhasBaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):- %concatena as ilhas vizinhas de ilha
  reverse(IlhasBaixoAux, IlhasBaixoreverse),
  reverse(IlhasDireitaAux, IlhasDireitareverse),
  vizinhas_aux(IlhasCimaAux, Cima),
  vizinhas_aux(IlhasEsquerdaAux, Esquerda),
  vizinhas_aux(IlhasBaixoreverse, Baixo),
  vizinhas_aux(IlhasDireitareverse, Direita),
  append(Viz_Aux, Cima, Vizinhas_C),
  append(Vizinhas_C, Esquerda, Vizinhas_E),
  append(Vizinhas_E, Direita, Vizinhas_D),
  append(Vizinhas_D, Baixo, Vizinhas_Final),
  vizinhas([],Ilha,1, IlhasCimaAux, IlhasBaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Vizinhas_Final, Vizinhas).

vizinhas([ilha(Num_Pontes, (Row, Col))|Resto], ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):-
   (Col == Coluna, Row < Linha), !,
   append(IlhasCimaAux, [ilha(Num_Pontes, (Row, Col))], IlhasCima),
   vizinhas(Resto, ilha(N_Pontes, (Linha, Coluna)),0, IlhasCima, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas).

vizinhas([ilha(Num_Pontes, (Row, Col))|Resto], ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):-
   (Col == Coluna, Row > Linha), !,
   append(IlhasbaixoAux, [ilha(Num_Pontes, (Row, Col))], Ilhasbaixo),
   vizinhas(Resto, ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, Ilhasbaixo, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas).

vizinhas([ilha(Num_Pontes, (Row, Col))|Resto], ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):-
   (Row == Linha, Col < Coluna), !,
   append(IlhasEsquerdaAux, [ilha(Num_Pontes, (Row, Col))], IlhasEsquerda),
   vizinhas(Resto, ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerda, IlhasDireitaAux, Viz_Aux, Vizinhas).

vizinhas([ilha(Num_Pontes, (Row, Col))|Resto], ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):-
   (Row == Linha, Col > Coluna), !,
   append(IlhasDireitaAux, [ilha(Num_Pontes, (Row, Col))], IlhasDireita),
   vizinhas(Resto, ilha(N_Pontes, (Linha, Coluna)),0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireita, Viz_Aux, Vizinhas).

vizinhas([_|Resto], Ilha,0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas):-
   vizinhas(Resto, Ilha,0, IlhasCimaAux, IlhasbaixoAux, IlhasEsquerdaAux, IlhasDireitaAux, Viz_Aux, Vizinhas).



/* estado(Ilhas, Estado) significa que Estado e a lista de entradas em que entrada e composta por uma ilha, as suas vizinhas e as pontes */

estado(Ilhas, Estado):- estado(Ilhas, Ilhas,[],Estado).

estado([],_, Estado, Estado).

estado([Cab|Resto],Ilhas, Estado_Aux, Estado):-
   vizinhas(Ilhas, Cab, Vizinhas),
   append(Estado_Aux,[[Cab, Vizinhas, []]], NovoAux),
   estado(Resto,Ilhas, NovoAux, Estado).




/* posicoes_entre(Pos1, Pos2, Posicoes) significa que Posicoes e a lista das posicoes que estao entre Pos1 e Pos2 */

posicoes_entre(Pos1, Pos2, Posicoes):- posicoes_entre(Pos1, Pos2,[],Posicoes).

posicoes_entre([],[], Pos, Pos).

posicoes_entre((Linha1, Coluna1),(Linha2, Coluna2),AuxL, Posicoes):-
   Coluna1 == Coluna2,Linha1<Linha2,!,
   Lim_Inf is Linha1+1,
   Lim_Sup is Linha2-1,
   findall((X,Coluna1), between(Lim_Inf, Lim_Sup, X), Posicoes),
   append(AuxL, Posicoes,NovaAuxLinhas),
   posicoes_entre([],[],NovaAuxLinhas, Posicoes).

posicoes_entre((Linha1, Coluna1),(Linha2, Coluna2),AuxC, Posicoes):-
   Linha1 == Linha2,Coluna1<Coluna2,!,
   Lim_Inf is Coluna1+1,
   Lim_Sup is Coluna2-1,
   findall((Linha1,Y), between(Lim_Inf, Lim_Sup, Y), Posicoes),
   append(AuxC, Posicoes,NovaAuxColunas),
   posicoes_entre([],[],NovaAuxColunas, Posicoes).

posicoes_entre((Linha1, Coluna1),(Linha2, Coluna2),AuxL, Posicoes):-
   Coluna1 == Coluna2,Linha1>Linha2,!,
   Lim_Inf is Linha2+1,
   Lim_Sup is Linha1-1,
   findall((X,Coluna1), between(Lim_Inf, Lim_Sup, X), Posicoes),
   append(AuxL, Posicoes,NovaAuxLinhas),
   posicoes_entre([],[],NovaAuxLinhas, Posicoes).

posicoes_entre((Linha1, Coluna1),(Linha2, Coluna2),AuxC, Posicoes):-
   Linha1 == Linha2,Coluna1>Coluna2,!,
   Lim_Inf is Coluna2+1,
   Lim_Sup is Coluna1-1,
   findall((Linha1,Y), between(Lim_Inf, Lim_Sup, Y), Posicoes),
   append(AuxC, Posicoes,NovaAuxColunas),
   posicoes_entre([],[],NovaAuxColunas, Posicoes).



/* cria_ponte(Pos1, Pos2, Ponte) significa que Ponte e resultado da criacao de uma ponte entre Pos1 e Pos2 */

cria_ponte((L1,C1),(L2,C2),Ponte):-
   L1==L2,C2>C1,!,
   cria_ponte((L1,C1),(L2,C2), ponte((L1,C1),(L2,C2)),Ponte).

cria_ponte((L1,C1),(L2,C2),Ponte):-
   L1==L2,C1>C2,!,
   cria_ponte((L1,C1),(L2,C2), ponte((L2,C2),(L1,C1)),Ponte).

cria_ponte((L1,C1),(L2,C2),Ponte):-
   C1==C2,L2>L1,!,
   cria_ponte((L1,C1),(L2,C2), ponte((L1,C1),(L2,C2)),Ponte).

cria_ponte((L1,C1),(L2,C2),Ponte):-
   C1==C2,L1>L2,!,
   cria_ponte((L1,C1),(L2,C2), ponte((L2,C2),(L1,C1)),Ponte).

cria_ponte(_,_,Ponte,Ponte).



/* caminho_livre(Pos1, Pos2, Posicoes, Ilha, Vizinha) devolve true se a adicao de uma ponte entre Pos1 e Pos2 nao faz com que Ilha e Vizinha deixem de ser Vizinhas*/

caminho_livre(_,_,[],_,_).

caminho_livre(Pos1,Pos2,[Cab|Resto],ilha(_,PosIlha1),ilha(_,PosIlha2)):-
   posicoes_entre(PosIlha1,PosIlha2,Posicoes),
   not(member(Cab,Posicoes)),!,
   caminho_livre(Pos1,Pos2, Resto,ilha(_,PosIlha1),ilha(_,PosIlha2)).

caminho_livre(Pos1,Pos2,Ilhas,ilha(_,PosIlha1),ilha(_,PosIlha2)):- %caso em que a ponte e criada entre Ilha e Vizinha, o que faz com que estas nao deixem de ser vizinhas
   posicoes_entre(PosIlha1,PosIlha2,Posicoes),
   (((Pos1 == PosIlha1, Pos2 == PosIlha2);(Pos1 == PosIlha2;  Pos2 ==PosIlha1)), Ilhas == Posicoes),!,caminho_livre(0,0,[],0,0).

caminho_livre(_,_,Ilhas,ilha(_,PosIlha1),ilha(_,PosIlha2)):-
%caso em que a ponte ocupa todas as posicoes entre ilha e Vizinha mas a ponte nao e criada entre estas ilhas (deixam de servizinhas)
   posicoes_entre(PosIlha1,PosIlha2,Posicoes),
   Ilhas == Posicoes,!,fail.

caminho_livre(_,_,[Cab|_],ilha(_,PosIlha1),ilha(_,PosIlha2)):-
   posicoes_entre(PosIlha1,PosIlha2,Posicoes),
   member(Cab,Posicoes),fail.



/* entrada_aux(Ilha, Vizinhas,Pontes, Entrada) em que Entrada e a lista resultada da criacao da entrada da Ilha com as vizinhas Vizinhas e com as pontes Pontes*/

entrada_aux(Ilha, Vizinhas,Pontes, Entrada):-
   entrada_aux(Ilha, Vizinhas,Pontes, [Ilha,Vizinhas,Pontes],Entrada).

entrada_aux(_,_,_,Entrada,Entrada).




/* actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_Entrada) significa que Nova_Entrada e igual a Entrada, excepto no que diz respeito a lista das ilhas vizinhas esta e atualizada removendo as ilhas que deixam de ser vizinhas apos a adicao de uma ponte entre Pos1 e Pos2*/

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_Entrada):-
% a lista vazia colocada como novo argumento vai ser preenchida apenas com as ilhas vizinhas para posteriormente ser usada para criar uma nova entrada
   actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada,[], Nova_Entrada).

actualiza_vizinhas_entrada([],[],[],[], NovaEntrada, NovaEntrada).

actualiza_vizinhas_entrada(_,_,_,[Ilha,[], Pontes],Aux_Vizinhas, NovaEntrada):-
   entrada_aux(Ilha, Aux_Vizinhas, Pontes, Entrada),
   actualiza_vizinhas_entrada([], [], [], [], Entrada, NovaEntrada).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, [Viz|Resto], Pontes], Viz_aux, Nova_entrada):-
   caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz), !,
   append(Viz_aux, [Viz], Aux_Vizinhas),
   actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Resto, Pontes], Aux_Vizinhas, Nova_entrada).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, [_|Resto], Pontes], Aux_Vizinhas, NovaEntrada):-
   actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Resto, Pontes], Aux_Vizinhas, NovaEntrada).



/*actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) significa que Novo_estado e o resultado de atualizar as vizinhas de cada entrada do Estado apos a colocacao de uma ponte entre Pos1 e Pos2*/

actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado):-
   actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, 0, [] ,[], Novo_estado).

actualiza_vizinhas_apos_pontes([], _, _, _, _, Novo_estado, Novo_estado).

actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, 0,_, [], Novo_estado):-
   posicoes_entre(Pos1, Pos2, Posicoes),
   actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, 1, Posicoes, [], Novo_estado).

actualiza_vizinhas_apos_pontes([Entrada|Resto], Pos1, Pos2, 1, Posicoes_entre, Aux_Estado, Novo_estado):-
   actualiza_vizinhas_entrada(Pos1,Pos2,Posicoes_entre, Entrada, Nova_entrada),
   append(Aux_Estado, [Nova_entrada], Estado_Auxiliar),
   actualiza_vizinhas_apos_pontes(Resto, Pos1, Pos2, 1, Posicoes_entre, Estado_Auxiliar, Novo_estado).



/*ilhas_terminadas(Estado, Ilhas_term) significa que Ilhas_term e a lista que contem todas as ilhas terminadas do Estado*/

ilhas_terminadas(Estado, Ilhas_term):- ilhas_terminadas(Estado, [], Ilhas_term).

ilhas_terminadas([], Ilhas_term, Ilhas_term).

ilhas_terminadas([[ilha(N_pontes,Pos),_,Pontes]|Resto],Aux_Ilhas, Ilhas_term):-
   length(Pontes,Comp),
   (N_pontes \== 'X',Comp == N_pontes),!,
   append(Aux_Ilhas,[ilha(N_pontes, Pos)], Terminadas_Aux),
   ilhas_terminadas(Resto, Terminadas_Aux, Ilhas_term).

ilhas_terminadas([_|Resto], Ilhas_Aux, Ilhas_term):-
   ilhas_terminadas(Resto, Ilhas_Aux, Ilhas_term).



/*tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, NovaEntrada) em que NovaEntrada e a entrada resultante de remover as Ilhas_term da lista de ilhas vizinhas de Entrada*/

tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, NovaEntrada):-
   tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, [], NovaEntrada).

tira_ilhas_terminadas_entrada([],[], NovaEntrada, NovaEntrada).

tira_ilhas_terminadas_entrada(_,[Ilha,[],Pontes],Vizinhas_Aux,NovaEntrada):-
   entrada_aux(Ilha, Vizinhas_Aux, Pontes, Entrada),
   tira_ilhas_terminadas_entrada([],[],Entrada,NovaEntrada).

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, [Vizinha|Resto], Pontes], Vizinhas_Aux, NovaEntrada):-
   not(member(Vizinha,Ilhas_term)),!,
   append(Vizinhas_Aux, [Vizinha], Nova_Aux),
   tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Resto, Pontes], Nova_Aux, NovaEntrada).

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, [_|Resto], Pontes], Vizinhas_Aux, NovaEntrada):-
   tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Resto, Pontes], Vizinhas_Aux, NovaEntrada).



/*tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) em que Novo_estado resulta de aplicar o predicado tira_ilhas_terminadas_entrada a cada entrada do Estado */

tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
   tira_ilhas_terminadas(Estado, Ilhas_term, [], Novo_estado).

tira_ilhas_terminadas([], _, Novo_estado, Novo_estado).

tira_ilhas_terminadas([Entrada|Resto], Ilhas_term, Estado_aux, Novo_estado):-
   tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, NovaEntrada),
   append(Estado_aux, [NovaEntrada], N_Estado),
   tira_ilhas_terminadas(Resto, Ilhas_term, N_Estado, Novo_estado).



/*marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada) significa que Nova_Entrada e a entrada obtida depois de substituir, em todas as ilhas terminadas, o numero de pontes por 'X'*/

marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada):-
   marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, [], Nova_entrada).

marca_ilhas_terminadas_entrada(_,[], Nova_entrada, Nova_entrada).

marca_ilhas_terminadas_entrada(Ilhas_term, [Ilha,Vizinhas, Pontes], _, Nova_entrada):-
   not(member(Ilha, Ilhas_term)),!,
   marca_ilhas_terminadas_entrada(Ilhas_term, [],[Ilha,Vizinhas,Pontes],Nova_entrada).

marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(_, (L,C)),Vizinhas, Pontes],_, Nova_entrada):-
   marca_ilhas_terminadas_entrada(Ilhas_term,[], [ilha('X', (L,C)),Vizinhas, Pontes], Nova_entrada).



/*marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) significa que Nova_Estado e o resultado de aplicar marca_ilhas_terminadas_entrada a todas as entradas do Estado */

marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
   marca_ilhas_terminadas(Estado, Ilhas_term, [], Novo_estado).

marca_ilhas_terminadas([], _, Novo_estado, Novo_estado).

marca_ilhas_terminadas([Entrada|Resto], Ilhas_term, Estado_aux, Novo_estado):-
   marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, NovaEntrada),
   append(Estado_aux, [NovaEntrada], N_Estado),
   marca_ilhas_terminadas(Resto, Ilhas_term, N_Estado, Novo_estado).



/*trata_ilhas_terminadas(Estado, Novo_estado) em que Novo_estado e o estado resultante de aplicar os predicados tira_ilhas_terminadas e marca_ilhas_terminadas */

trata_ilhas_terminadas(Estado, Novo_estado):-
   trata_ilhas_terminadas(Estado, [],[],Novo_estado).

trata_ilhas_terminadas([],_, Novo_estado, Novo_estado).

trata_ilhas_terminadas(Estado, Ilhas_term_aux, Novo_aux, Novo_estado):-
   ilhas_terminadas(Estado, Ilhas_term),
   append(Ilhas_term_aux, Ilhas_term, Ilhas_final),
   tira_ilhas_terminadas(Estado, Ilhas_final, N_estado),
   marca_ilhas_terminadas(N_estado, Ilhas_final, Estado_final),
   append(Novo_aux, Estado_final, NovoEstado),
   trata_ilhas_terminadas([],_, NovoEstado, Novo_estado).



/*junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado) em que Novo_estado e o estado resultante de adicionar N_pontes pontes entre Ilha1 e Ilha2 atraves dos predicados cria_ponte, actualiza_vizinhas_apos_pontes e actualiza_vizinhas_apos_pontes*/

junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado):-
   junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, _,0, [], Novo_estado).

junta_pontes([], [], _, _,_,2, Novo_estado, Novo_estado).

junta_pontes(Estado, Num_pontes, ilha(N1,Pos1), ilha(N2,Pos2), Pontes, 0, [], Novo_estado):-
   cria_ponte(Pos1, Pos2, Ponte),
   length(Pontes, Num_pontes),
   maplist(=(Ponte),Pontes),
   junta_pontes(Estado, [], ilha(N1,Pos1), ilha(N2,Pos2), Pontes,1, [], Novo_estado).


junta_pontes([[Ilha, Vizinhas, Pontes_Ilha]|Resto], [], Ilha1, Ilha2, Pontes,1, Estado_aux, Novo_estado):-
   (Ilha == Ilha1; Ilha==Ilha2),!,
   append(Pontes_Ilha, Pontes, Pontes_final),
   append(Estado_aux, [[Ilha, Vizinhas, Pontes_final]], Estado_final),
   junta_pontes(Resto, [], Ilha1, Ilha2, Pontes,1, Estado_final, Novo_estado).

junta_pontes([[Ilha, Vizinhas, Pontes_Ilha]|Resto],[],Ilha1,Ilha2,Pontes,1,Estado_aux, Novo_estado):-
   (Ilha \== Ilha1, Ilha \== Ilha2),
   append(Estado_aux,[[Ilha, Vizinhas, Pontes_Ilha]], Estado_final),
   junta_pontes(Resto, [], Ilha1, Ilha2, Pontes,1, Estado_final, Novo_estado).

junta_pontes([],[], ilha(_,Pos1), ilha(_,Pos2),_,1, Estado_aux, Novo_estado):-
   actualiza_vizinhas_apos_pontes(Estado_aux, Pos1, Pos2, Novissimo_estado),
   trata_ilhas_terminadas(Novissimo_estado, Estado_final),
   junta_pontes([],[],_,_,_,2,Estado_final,Novo_estado).
