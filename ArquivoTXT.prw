#include "TOTVS.CH"

/* {Protheus.doc} ArquivoCSV
Função para ler e escrever dados de um arquivo TXT.

@author Gabriel Gama
@since 16/06/2025
@version 12/Superior
*/

User Function ArquivoTXT(cArquivo)
    Local aPergs   := {}
    Local aResps   := {}
    Local cTitulo  := "Leitura de Arquivo TXT"
    Local cArquivo := ""

    aAdd(aPergs, {6, "Selecione o arquivo:", "", "", "", "", 80, .F., "Arquivo CSV |*.CSV", "", GETF_LOCALHARD+GETF_NETWORKDRIVE})

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
Static Function xReadArq(cArquivo)  
    Local nHandle  := 0
    Local cLinha   := ""
    Local aDados   := {}
    Local aCabec   := {}
    Local lLinPrim := .T.
    Local cArqLog  := "LogProc_" + DToS(Date()) + StrTran(Time(), ":", "") + ".LOG"
    Local cDir     := "D:\Log_Protheus\"
    Local nDir     := -1
    Local cLogProc := ""
    Local nCount  := 0

    If ! ExistDir(cDir)
        nDir := MakeDir(cDir)
        If nDir != 0
            Help(,,"Atenção",,"Não foi possível criar o diretório. Erro: " + cValToChar( FError()), 1, 0,,,,,,{"Fale com um técnico e informe o programa XXXXXXX!"})
            Return
        EndIf
    EndIf

    nHandle := ft_fUse(cArquivo)
    If nHandle > 0
        While ! ft_fEOF()
            cLinha := ft_fReadLn()
            If lLinPrim
                aCabec := Separa(cLinha, ";")
                lLinPrim := .F.
            Else
                aDados := Separa(cLinha, ";")
                If ! Empty(aDados[1])
                    xProcessa(aDados,@cLogProc)
                Else
                    cLogProc += "Linha " + cValToChar(nCount) + "está vazia ou inválida." + CRLF
                EndIf
            EndIf
            ft_fSkip()
        EndDo
    EndIf

    If ! Empty(cLogProc)
        //Escreve o log de processamento
        cLogProc := "Log de Processamento - " + CRLF + cLogProc
        nHandle := fCreate(cDir + cArqLog,0)
        fWrite(nHandle, cLogProc)
        fClose(nHandle)
        Help(,,"Atenção",,"Arquivo processado com sucesso!  Veja o log em: " + cDir + cArqLog, 1, 0,,,,,.F.,{"Verifique o log!"})
        ShellExecute("Open","NOTEPAD.EXE",cDir + cArqLog, "",1)
    EndIf

    //Fecha o arquivo de parâmetros
    fClose(nHandle)
Return

Static Function xProcessa(aDados, cLogProc)
    //Nome;Idade;Cargo;Setor;Data de admissão
    Local cNome := Upper(aDados[1])
    Local nIdade := Val(aDados[2])
    Local cCargo := Upper(aDados[3])
    Local cSetor := Upper(aDados[4])
    Local dDtAdm := CToD(aDados[5])

    cLogProc += "O colaborador " + cNome + "trabalha no setor " + cSetor + " como " + cCargo + "." + CRLF
Return
