#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function A010TOK
Ponto de entrada para incluir um produto em uma tabela complementar, verificando se já está cadastrado na tabela.
Esta função permite a inclusão ou alteração de produtos, garantindo que apenas grupos permitidos sejam considerados de acordo com os critérios dos produtos.
@type  Function
@since 01/07/2025
@author Gabriel Gama
@obs Exemplo para fins de estudo.
*/

User Function A010TOK()
    // Declaração de variáveis 
    Local lExecuta := .T.             // Controla a execução da função
    Local cFilial := FWxFilial("SB1") // Filial atual
    Local cProduto := SB1->B1_COD     // Código do produto
    Local cGrupo := ""                // Grupo do produto
    Local aGruposPermit := {"001","002","003"} // Grupos permitidos

    // Obtém o grupo atualizado ou usa o valor antigo
    If Type("M->B1_GRUPO") == "C"
        cGrupo := M->B1_GRUPO
    Else
        cGrupo := SB1->B1_GRUPO
    EndIf

    // Confirma inclusão ou alteração do produto
    If MSGYESNO("Deseja incluir ou alterar o produto?")
        // Verifica se o grupo pertence aos permitidos
        If AScan(aGruposPermit, cGrupo) > 0
            DbSelectArea("Z01"+cFilial)
            DbSetOrder(1)
            // Verifica se o produto já está cadastrado
            If !DbSeek(cFilial + cProduto)
                // Pergunta ao usuário se deseja incluir o produto na tabela complementar
                If MSGYESNO("Incluir produto na tabela complementar?")
                    DbAppend()
                    Z01->Z01_FILIAL := cFilial
                    Z01->Z01_COD    := cProduto
                    Z01->Z01_LOGICO := .T.
                    DbCommit()
                    MsgInfo("Produto incluído na tabela com sucesso.")
                EndIf
            EndIf
        EndIf
    Else
        lExecuta := .F.
    EndIf

Return lExecuta
