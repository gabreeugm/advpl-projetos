#INCLUDE "TOTVS.CH"

/* {Protheus.doc} ValidAux
Função auxiliar para validar produtos no Protheus.
@author Gabriel Gama
@since 04/07/2025
@version 12/Superior
*/

User Function ValidAux(cCod)
    Local aArea := GetArea()
    Local aSB5 := SB5->(GetArea())

    SB5->(DbSetOrder(1))
    If SB5->(DbSeek(xFilial("SB5") + cCod))
        Alert("Código no cliente: " + AllTrim(SB5->B5_CODCLI))
    Else
        Alert("Produto sem código do cliente na SB5.")
    EndIf

    RestArea(aSB5)
    RestArea(aArea)
Return
