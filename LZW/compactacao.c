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

  Nome(s) :
  NUSP(s) :

  Referências: Com exceção das rotinas fornecidas no enunciado e em
  sala de aula, caso você(s) tenha(m) utilizado alguma referência,
  liste(m) abaixo para que o programa não seja considerado plágio ou
  irregular.
 
  Exemplo:
  - O algoritmo Quicksort foi baseado em
  http://www.ime.usp.br/~pf/algoritmos/aulas/quick.html
*/

#include "compactacao.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int TamanhoArquivo(FILE *arq)
{
    int pos_atual, tamanho;

    /* Obtém a posição atual no arquivo */
    pos_atual = ftell(arq);

    /* Vai para o fim do arquivo
       Posição no fim corresponde ao tamanho em bytes do arquivo */
    fseek(arq, 0L, SEEK_END);
    tamanho = ftell(arq);

    /* Volta para a posição onde estava inicialmente */
    fseek(arq, pos_atual, SEEK_SET);

    return tamanho;
}

tDicionario *compactaComLZW(FILE *arq_texto_entrada, FILE *arq_binario_saida){
    tDicionario * dicionario = criaDicionario(TamanhoArquivo(arq_texto_entrada)/(4*3)+1);
    
    short aux_num;
    char aux[TAM_MAX_ENTRADA] = "", c[2] = "", entrada[TAM_MAX_ENTRADA] = "";
    
    while((c[0] = fgetc(arq_texto_entrada)) != EOF) {
        
        if((strlen(entrada + c[0]) > 1) && (obtemCodigo(dicionario, entrada + c[0]) == -1)) {
            if(strlen(entrada) == 1)
                aux_num = entrada[0];
            else
                aux_num = obtemCodigo(dicionario, entrada) + 128;
            snprintf(aux, sizeof(aux), "%d", aux_num);
            strcat(aux, " ");
            fwrite(aux, sizeof(char), strlen(aux), arq_binario_saida);
            adicionaEntrada(dicionario, entrada + c[0]);
            strcpy(entrada, c);
        } else {
            strcat(entrada, c);
        }
    }
    if(strlen(entrada) == 1)
        aux_num = entrada[0];
    else
        aux_num = obtemCodigo(dicionario, entrada) + 128;
    snprintf(aux, sizeof(aux), "%d", aux_num);
    strcat(aux, " ");
    fwrite(aux, sizeof(char), strlen(aux), arq_binario_saida);
    
    return dicionario;
}

tDicionario *descompactaComLZW(FILE *arq_binario_entrada, FILE *arq_texto_saida) {
    tDicionario * dicionario = criaDicionario(TamanhoArquivo(arq_binario_entrada)/(4*3)+1);
    
    return dicionario;
}

void imprimeDicionarioLZW(tDicionario *dicionario){
  short i = 0;
  if(dicionario->tamanho == 0){
    puts("dicionario vazio!");
    return;
  }
  for(i = 0; i < dicionario->tamanho; i++)
    printf("%05d | %s\n", i + 128, dicionario->entradas[i]);
  return;
}
