#INCLUDE "TOTVS.CH"

/* {Protheus.doc} SX3Pergs
Classe para uso de perguntas SX3.
@author Gabriel Gama
@since 10/07/2025
@version 12/Superior
*/

User Function SX3Pergs()
    Local oSX3 := Nil
    Local aPergs := {}
    Local aResps := {}

    aAdd(aPergs,{1,"Campo",Space(10),"","",,"",50,.T.})
    While Parambox(aPergs,"",@aResps,,,.T.,,,,,.F.,.F.)
        oSX3 := SX3Dados():New(aResps[1])
        cResposta := "Campo: " + oSX3:cCampo + CRLF
        cResposta += "Título: " + oSX3:cTitulo + CRLF
        cResposta += "Tamanho: " + cValToChar(oSX3:nTamanho) + CRLF
        cResposta += "Decimal: " + cValToChar(oSX3:nDecimal) + CRLF
        cResposta += "Picture: " + oSX3:cPicture + CRLF
        cResposta += "Usado: " + cValToChar(oSX3:lUSado) + CRLF
        cResposta += "Trigger: " + cValToChar(oSX3:lTrigger) + CRLF
        cResposta += "Folder: " + oSX3:cFolder + CRLF
        Alert(cResposta)
        FreeObj(oSX3)
    EndDo

Return
