/*
  AO PREENCHER(MOS) ESTE CABEÇALHO COM O(S) MEU(NOSSOS) NOME(S) E
  O(S) MEU(NOSSOS) NÚMERO(S) USP, DECLARO(AMOS) QUE SOU(SOMOS) O(S)
  ÚNICO(S) AUTOR(ES) E RESPONSÁVEL(IS) POR ESTE ARQUIVO. TODAS AS
  PARTES ORIGINAIS DO EXERCÍCIO PROGRAMA (EP) FORAM DESENVOLVIDAS
  E IMPLEMENTADAS POR MIM(NÓS) SEGUINDO AS INSTRUÇÕES DO EP E, 
  PORTANTO, NÃO CONSTITUEM DESONESTIDADE ACADÊMICA OU PLÁGIO.  
  DECLARO TAMBÉM QUE SOU(SOMOS) RESPONSÁVEL(IS) POR TODAS AS CÓPIAS
  DESTE ARQUIVO E QUE EU(NÓS) NÃO DISTRIBUÍ(MOS) OU FACILITEI(AMOS)
  A SUA DISTRIBUIÇÃO. ESTOU(AMOS) CIENTE(S) DE QUE OS CASOS DE PLÁGIO 
  E DESONESTIDADE ACADÊMICA SERÃO TRATADOS CONFORME SUA GRAVIDADE.
  ENTENDO(EMOS) QUE EPS SEM ASSINATURA NÃO SERÃO CORRIGIDOS E, 
  AINDA ASSIM, PODERÃO SER PUNIDOS POR DESONESTIDADE ACADÊMICA.

  Nome(s) : Eike Souza da Silva, Debora
  NUSP(s) : 4618653,

  Referências: Com exceção das rotinas fornecidas no enunciado e em
  sala de aula, caso você(s) tenha(m) utilizado alguma referência,
  liste(m) abaixo para que o programa não seja considerado plágio ou
  irregular.
 
  Exemplo:
  - O algoritmo Quicksort foi baseado em
  http://www.ime.usp.br/~pf/algoritmos/aulas/quick.html
*/

#include "dicionario.h"
#include <stdlib.h>
#include <stdio.h>

tDicionario* criaDicionario (short qtde_maxima_entradas){
  int i;
  tDicionario *dicionario = malloc(sizeof(tDicionario));
  dicionario->tamanho = 0;

  dicionario->capacidade = qtde_maxima_entradas;
  dicionario->entradas = malloc(dicionario->capacidade * sizeof(char*));
  for(i = 0; i < dicionario->capacidade; i++)
    dicionario->entradas[i] = malloc(TAM_MAX_ENTRADA * sizeof(char));

  return dicionario;

}

void destroiDicionario (tDicionario *dicionario){
  short i;
  for(i = 0; i < dicionario->capacidade; i++)
    free(dicionario->entradas[i]);
  free(dicionario->entradas);
  free(dicionario);
}

short adicionaEntrada(tDicionario *dicionario, char *entrada){
  if(dicionario->tamanho == dicionario->capacidade)
    return -1;
  dicionario->entradas[dicionario->tamanho++] = entrada;
  return 1;
}

char* obtemEntrada(tDicionario *dicionario, short codigo){
  if((codigo < 0 || codigo >= dicionario->tamanho)) return NULL;
  return dicionario->entradas[codigo];
}

short obtemCodigo(tDicionario *dicionario, char *entrada){
  short i;
  for(i = 0; i < dicionario->tamanho; i++)
    if(dicionario->entradas[i] == entrada)
      return i;
  return -1;
}
