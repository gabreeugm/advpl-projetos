#INCLUDE "TOTVS.CH"
#include "TOTVS.CH"

/* {Protheus.doc} SQL Exemplo 01
Função para executar uma consulta SQL no Protheus.

@author Gabriel Gama
@since 04/07/2025
@version 12/Superior
*/

User Function SQLExe01()
    // Declaração de variáveis locais
    Local cQuery := "" // Armazena a consulta SQL
    Local cAliasTop := "" // Armazena o alias retornado pela execução da consulta

    // Construção da consulta SQL
    cQuery := "SELECT" + CRLF
    cQuery += "A1_COD" + CRLF
    cQuery += ",A1_NOME" + CRLF
    cQuery += ",A1_LC" + CRLF
    cQuery += ",CAST(A1_VENCLC AS DATE) VENCLC" + CRLF
    cQuery += ",C5_NUM" + CRLF
    cQuery += ",CAST(C5_EMISSAO AS DATE) EMISSAO_PV" + CRLF
    cQuery += ",SUM(C6_VALOR) VALOR_PV" + CRLF
    cQuery += "FROM " + RetSQLName("SC5") + " SC5" + CRLF
    cQuery += "INNER JOIN " + RetSQLName("SC6") + " SC6" + CRLF
    cQuery += "ON SC6.D_E_L_E_T_ = ''" + CRLF
    cQuery += "AND C6_FILIAL = C5_FILIAL" + CRLF
    cQuery += "AND C6_NUM  = C5_NUM" + CRLF
    cQuery += "INNER JOIN " + RetSQLName("SA1") + " SA1" + CRLF
    cQuery += "ON SA1.D_E_L_E_T_ = ''" + CRLF
    cQuery += "AND A1_FILIAL = '" + xFilial("SA1") + "'" + CRLF
    cQuery += "AND A1_COD = C5_CLIENTE" + CRLF
    cQuery += "AND A1_LOJA = C5_LOJACLI" + CRLF
    cQuery += "WHERE" + CRLF
    cQuery += "SC5.D_E_L_E_T_ = ''" + CRLF
    cQuery += "AND C5_FILIAL = '" + xFilial("SC5") + "'" + CRLF
    cQuery += "GROUP BY" + CRLF
    cQuery += "A1_COD" + CRLF
    cQuery += ",A1_LOJA" + CRLF
    cQuery += ",A1_NOME" + CRLF
    cQuery += ",A1_LC" + CRLF
    cQuery += ",A1_VENCLC " + CRLF
    cQuery += ",C5_NUM" + CRLF
    cQuery += ",C5_EMISSAO" + CRLF

    // Executa a consulta SQL e retorna o alias
    cAliasTop := MPSysOpenQuery(cQuery)

    // Itera sobre os resultados da consulta
    While ! (cAliasTop)->(EOF())
        // Verifica se o cliente tem crédito suficiente
        If (cAliasTop)->A1_LC >= (cAliasTop)->VALOR_PV
            Alert("Pode liberar, cliente tem crédito!") // Mensagem de liberação
        Else
            Alert("Não pode liberar, cliente não tem crédito! Valor PV = " + cValToChar((cAliasTop)->VALOR_PV);
             + " e LC = " + cValToChar((cAliasTop)->A1_LC)) // Mensagem de bloqueio
        EndIf
        
        // Avança para o próximo registro
        (cAliasTop)->(DBSkip())
    End

    // Fecha o alias após o processamento
    (cAliasTop)->(DBCloseArea())

Return


