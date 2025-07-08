#INCLUDE "TOTVS.CH"
#include "TOTVS.CH"

/* {Protheus.doc} SQL Exemplo 02
Função para executar uma consulta SQL no Protheus, buscando informações de cliente e vendedor.

@author Gabriel Gama
@since 04/07/2025
@version 12/Superior
*/

User Function SQLExe02(cCodCli, cLojaCli)

    Local aSA1      := SA1 ->(GetArea()) // Armazena a área atual de SA1
    Local aArea     := GetArea() // Armazena a área atual

    //ChkFile("SZ0") 
    //DbSelectArea("SA1")  //Para abrir uma área que porventura pode estar fechada ChkFile("SZ0")

    SA1->(DbSetOrder(1))
    If   SA1->(DbSeek(xFilial("SA1") + cCodCli + cLojaCli))
        Alert("Cliente encontrado: " + AllTrim(SA1->A1_NOME))
        SA3->(DbSetOrder(1))
        SA3->(DbSeek(xFilial("SA3") + SA1->A1_VEND))
        Alert("Vendedor encontrado: " + SA3->A3_NOME)
   
    EndIf

    //DbCloseArea("SA1")

    RestArea(aSA1)
    RestArea(aArea)
Return

 
