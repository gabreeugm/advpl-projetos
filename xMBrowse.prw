#INCLUDE "PROTHEUS.CH"

/* {Protheus.doc} xMBrowse
Exemplo de como criar uma tela (modelo 1 - CRUD)
@author Gabriel Gama
@since 10/07/2025
@version 12/Superior
*/

User Function xMBrowse()
    Local cAlias      := "SZ0"

    Private cCadastro := "Carteira de Clientes"
    Private aRotina   := { }

    aadd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1}) // Bot�o de pesquisa
    aadd(aRotina, {"Visualizar", "AxVisual", 0, 2}) // Bot�o de visualiza��o
    aadd(aRotina, {"Incluir"   , "AxInclui", 0, 3}) // Bot�o de inclus�o
    aadd(aRotina, {"Alterar"   , "AxAltera", 0, 4}) // Bot�o de altera��o
    aadd(aRotina, {"Excluir"   , "AxDeleta", 0, 5}) // Bot�o de exclus�o

    DBSelectArea(cAlias)
    DBSetOrder(1)

    mBrowse(6, 1, 22, 75, cAlias)
Return Nil
