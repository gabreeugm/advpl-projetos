#include "TOTVS.CH"

/* {Protheus.doc} ArquivoCSV
Função para ler e escrever dados de um arquivo CSV.

@author Gabriel Gama
@since 16/06/2025
@version 12/Superior
*/

User Function ArquivoCSV(cArquivo)
    Local aPergs := {}
    Local aResps := {}
    Local cTitulo := "Leitura de Arquivo CSV"
    Local cArquivo := ""

    aAdd(aPergs, {6, "Selecione o arquivo CSV:", "", "", "", "", 80, .F., "Arquivo CSV |*.CSV", "", GETF_LOCALHARD+GETF_NETWORKDRIVE})

    If Parambox(aPergs, cTitulo, @aResps)
    cArquivo := AllTrim(aResps[1])
        If File(cArquivo)
        xReadArq(@cArquivo)
        Else
            Help(,,"Atenção",,"Caminho do arquivo a ser importado não encontrado!", 1, 0,,,,,.F.,{"Verifique o caminho do arquivo!"})
        EndIf
    EndIf

Return

/* {Protheus.doc} xReadArq
Leitura de arquivo CSV e processamento dos dados
O arquivo deve conter as colunas: Nome;Idade;Cargo;Setor;Data de admissão

@author Gabriel Gama
@since 16/06/2025
@version 12/Superior
*/
Static Function xReadArq()  
    Local nHandle := 0
    Local cLinha := ""
    Local aDados := {}
    Local aCabec := {}
    Local lLinPrim := .T.

    nHandle := ft_fUse(cArquivo)
    If nHandle > 0
        While ! ft_fEOF()
            cLinha := ft_fReadLn()
            If lLinPrim
                aCabec := Separa(cLinha, ";")
                lLinPrim := .F.
            Else
                aDados := Separa(cLinha, ";")
                xProcessa(aDados)
            EndIf
            ft_fSkip()
        EndDo
    EndIf

    //Fecha o arquivo de parâmetros
    fClose(nHandle)
Return

Static Function xProcessa(aDados)
    //Nome;Idade;Cargo;Setor;Data de admissão
    Local cNome := Upper(aDados[1])
    Local nIdade := Val(aDados[2])
    Local cCargo := Upper(aDados[3])
    Local cSetor := Upper(aDados[4])
    Local dDtAdm := DToC(aDados[5])
Return
