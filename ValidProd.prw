#INCLUDE "PROTHEUS.CH"

// Função principal para validar produtos no Protheus
User Function ValidProd()
    // Declaração de variáveis locais
    Local cQuery := "" // Armazena a consulta SQL
    Local cAliasTop := "" // Armazena o alias retornado pela execução da consulta

    // Construção da consulta SQL para buscar informações dos produtos
    cQuery := "SELECT" + CRLF
    cQuery += "B1.B1_FILIAL" + CRLF
    cQuery += ",B1.B1_COD" + CRLF
    cQuery += ",B1.B1_DESC" + CRLF
    cQuery += ",B1.B1_TIPO" + CRLF
    cQuery += ",CASE" + CRLF
    cQuery += "	WHEN B1.B1_TIPO = 'PA' THEN 'PRODUTO ACABADO'" + CRLF
    cQuery += "	WHEN B1.B1_TIPO = 'MP' THEN 'MATÉRIA PRIMA'" + CRLF
    cQuery += "	ELSE 'OUTRO'" + CRLF
    cQuery += "END AS CATEGORIA" + CRLF
    cQuery += ",B1.B1_GRUPO" + CRLF
    cQuery += ",B1.B1_POSIPI" + CRLF
    cQuery += ",B1.B1_PROC" + CRLF
    cQuery += ",B1.B1_LOJPROC" + CRLF
    cQuery += ",B1.B1_CODBAR" + CRLF
    cQuery += ",BM.BM_DESC" + CRLF
    cQuery += ",B5.B5_DES" + CRLF
    cQuery += ",B5.B5_CEME" + CRLF
    cQuery += ",B5.B5_CODCLI" + CRLF
    cQuery += ",ISNULL(B2.B2_QATU, 0) AS QTD_ESTOQUE" + CRLF
    cQuery += ",ISNULL(B2.B2_CM1, 0) AS CUSTO_MEDIO" + CRLF
    cQuery += ",ISNULL(B2.B2_QATU, 0) * ISNULL(B2.B2_CM1, 0) AS VALOR_ESTOQUE" + CRLF
    cQuery += "FROM " + RetSQLName("SB1") + " B1" + CRLF
    cQuery += "INNER JOIN " + RetSQLName("SBM") + " BM" + CRLF
    cQuery += " ON B1.B1_GRUPO = BM.BM_GRUPO" + CRLF
    cQuery += " AND B1.B1_FILIAL = BM.BM_FILIAL" + CRLF
    cQuery += " AND BM.D_E_L_E_T_ = ''" + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SB5") + " B5" + CRLF
    cQuery += "  ON B1.B1_COD = B5.B5_COD" + CRLF
    cQuery += " AND B1.B1_FILIAL = B5.B5_FILIAL" + CRLF
    cQuery += " AND B5.D_E_L_E_T_ = ''" + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SB2") + " B2" + CRLF
    cQuery += "  ON B1.B1_COD = B2.B2_COD" + CRLF
    cQuery += " AND B1.B1_FILIAL = B2.B2_FILIAL" + CRLF
    cQuery += " AND B2.D_E_L_E_T_ = ''" + CRLF
    cQuery += "WHERE B1.D_E_L_E_T_ = ''" + CRLF
    cQuery += "ORDER BY B1.B1_COD" + CRLF

    // Executa a consulta SQL e retorna o alias para manipulação dos dados
    cAliasTop := MPSysOpenQuery(cQuery)

    // Verifica se houve erro na execução da consulta
    If Empty(cAliasTop)
        Alert("Erro ao executar a consulta SQL.")
    EndIf

    // Itera sobre os resultados da consulta
    While ! (cAliasTop)->(EOF())
        // Verifica se o produto está sem estoque
        If (cAliasTop)->QTD_ESTOQUE == 0
            // Exibe alerta informando que o produto está sem estoque
            Alert("Produto: " + AllTrim((cAliasTop)->B1_COD) + CRLF;
            +"Descrição: " + AllTrim((cAliasTop)->B1_DESC)+ CRLF;
            +"Desenho: " + AllTrim((cAliasTop)->B5_DES)+ CRLF;
            +"Nome cientifico: " + AllTrim((cAliasTop)->B5_CEME)+ CRLF;
            +"Está sem estoque!")
        Else
            // Exibe alerta informando a quantidade em estoque do produto
            Alert("Produto: " + AllTrim((cAliasTop)->B1_COD) + CRLF;
            +"Descrição: " + AllTrim((cAliasTop)->B1_DESC)+ CRLF;
            +"Desenho: " + AllTrim((cAliasTop)->B5_DES)+ CRLF;
            +"Nome cientifico: " + AllTrim((cAliasTop)->B5_CEME)+ CRLF;
              +"Tem em estoque: " + cValToChar((cAliasTop)->QTD_ESTOQUE)+ CRLF)
        EndIf
        // Chama a função auxiliar para validar o produto
        U_ValidAux((cAliasTop)->B1_COD, (cAliasTop)->B1_TIPO)
        // Avança para o próximo registro
        (cAliasTop)->(DbSkip())
    End


    // Retorna ao primeiro registro após a iteração
    (cAliasTop)->(DbGoTop())
    
    // Fecha o alias após o processamento
    (cAliasTop)->(DbCloseArea())
Return
