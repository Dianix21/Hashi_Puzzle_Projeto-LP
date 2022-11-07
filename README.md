# Hashi_Puzzle_Projeto-LP

O objetivo deste projecto é escrever a primeira parte de um programa em PROLOG para resolver puzzles hashi.

Um puzzle hashi é constituído por uma grelha n×m (n linhas, m colunas). Cada posição da grelha pode estar vazia,
ou conter uma ilha, com a indicação do número de pontes que essa ilha deverá ter, na solução do puzzle. 

Na seguinte figura mostra-se um exemplo de um puzzle 7 × 7, com 9 ilhas.

![Captura de ecrã 2022-11-07 213426](https://user-images.githubusercontent.com/78211740/200420318-43927ecf-5b9a-4ea1-bc54-66c86681ba29.jpg)

Na primeira linha deste puzzle existem 2 ilhas: uma na posição (1, 1), com a indicação de 4 pontes, 
e outra na posição (1, 7), com a indicação de 3 pontes. Para obter uma solução, as ilhas devem ser ligadas por pontes, 
de forma a respeitar o número de pontes indicado por cada ilha e as seguintes restrições:
  • Não há mais do que duas pontes entre quaisquer duas ilhas.
  • As pontes só podem ser verticais ou horizontais e não podem cruzar ilhas ou outras
    pontes.
  • Na solução do puzzle, as pontes permitem a passagem entre quaisquer duas ilhas.

Assim, o puzzle da Figura acima tem uma única solução, que é apresentada na Figura seguinte.

![image](https://user-images.githubusercontent.com/78211740/200420473-743c92f0-5f3a-4f37-9b0f-ed09b317b5c2.png)
