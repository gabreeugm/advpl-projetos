#INCLUDE "TOTVS.CH"

/*{Protheus.doc}
Classe para uso de dados SX3 de um campo
@author Gabriel Gama
@since 04/07/2025
@version 12/Superior
*/

CLASS SX3Dados
    DATA cTabela
    DATA cCampo
    DATA cTitulo
    DATA nTamanho
    DATA nDecimal
    DATA lUSado
    DATA cPicture
    DATA cFolder
    DATA lTrigger

    METHOD New(cCampo) CONSTRUCTOR

ENDCLASS

/*{Protheus.doc} New
Método construtor da classe SX3Dados.
@author Gabriel Gama
@since 04/07/2025
@version 12/Superior
*/

METHOD New(cCampo) CLASS SX3Dados
    Local aArea     := GetArea()
    Local aSXA      := SXA->(GetArea())
    Local cQuery    := ""
    Local cAliasTop := ""

    cCampo          := Upper(cCampo)

    cQUERY          := "SELECT X3_CAMPO" + CRLF
    cQUery          += " FROM " + RetSQLName("SX3") + " SX3 "+ CRLF
    cQuery          += " WHERE " + CRLF
    cQuery          += " X3_CAMPO = '" + cCampo + "' " + CRLF
    cAliasTop       += MPSysOpenQuery(cQuery)

    If ! (cAliasTop)->(EOF())
        ::cTabela       := GetSx3Cache(cCampo, "X3_ARQUIVO")
        ::cCampo        := AllTrim(GetSx3Cache(cCampo, "X3_CAMPO"))
        ::cTitulo       := AllTrim(GetSx3Cache(cCampo, "X3_TITULO"))
        ::nTamanho      := GetSx3Cache(cCampo, "X3_TAMANHO")
        ::nDecimal      := GetSx3Cache(cCampo, "X3_DECIMAL")
        ::lUSado        := X3Usado(cCampo)
        ::cPicture      := AllTrim(GetSx3Cache(cCampo, "X3_PICTURE"))
        ::cFolder       := GetSx3Cache(cCampo, "X3_FOLDER")
        ::lTrigger      := GetSx3Cache(cCampo, "X3_TRIGGER") == "S"

        SXA->(DbSetOrder(1))
        If SXA->(DbSeek(::cTabela + ::cFolder))
            ::cFolder       := AllTrim(SXA->XA_DESCRIC)
        EndIf

        RestArea(aSXA)
    Else
        Help(,,"Não existe",,"O campo " + cCampo + " não existe no SX3.",1,0,,,,,.F.,{"Informe o campo correto."})
        ::cTabela       := ""
        ::cCampo        := ""
        ::cTitulo       := ""
        ::nTamanho      := 0
        ::nDecimal      := 0
        ::lUSado        := .F.
        ::cPicture      := ""
        ::cFolder       := ""
        ::lTrigger      := .F.
    EndIf

    RestArea(aArea)

RETURN Self
