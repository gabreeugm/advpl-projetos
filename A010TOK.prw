#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function A010TOK
Ponto de entrada para incluir um produto em uma tabela complementar, verificando se j� est� cadastrado na tabela.
Esta fun��o permite a inclus�o ou altera��o de produtos, garantindo que apenas grupos permitidos sejam considerados de acordo com os crit�rios dos produtos.
@type  Function
@since 01/07/2025
@author Gabriel Gama
@obs Exemplo para fins de estudo.
*/

User Function A010TOK()
    // Declara��o de vari�veis 
    Local lExecuta := .T.             // Controla a execu��o da fun��o
    Local cFilial := FWxFilial("SB1") // Filial atual
    Local cProduto := SB1->B1_COD     // C�digo do produto
    Local cGrupo := ""                // Grupo do produto
    Local aGruposPermit := {"001","002","003"} // Grupos permitidos

    // Obt�m o grupo atualizado ou usa o valor antigo
    If Type("M->B1_GRUPO") == "C"
        cGrupo := M->B1_GRUPO
    Else
        cGrupo := SB1->B1_GRUPO
    EndIf

    // Confirma inclus�o ou altera��o do produto
    If MSGYESNO("Deseja incluir ou alterar o produto?")
        // Verifica se o grupo pertence aos permitidos
        If AScan(aGruposPermit, cGrupo) > 0
            DbSelectArea("SZ2"+cFilial)
            DbSetOrder(1)
            // Verifica se o produto j� est� cadastrado
            If !DbSeek(cFilial + cProduto)
                // Pergunta ao usu�rio se deseja incluir o produto na tabela complementar
                If MSGYESNO("Incluir produto na tabela complementar?")
                    DbAppend()
                    SZ2->SZ2_FILIAL := cFilial
                    SZ2->SZ2_COD    := cProduto
                    SZ2->SZ2_LOGICO := .T.
                    DbCommit()
                    MsgInfo("Produto inclu�do na tabela com sucesso.")
                EndIf
            EndIf
        EndIf
    Else
        lExecuta := .F.
    EndIf

Return lExecuta
