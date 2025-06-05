#INCLUDE "TOTVS.CH"

/* {Protheus.doc} VerificaCPF
Fun��o que verifica se um CPF � v�lido.
A valida��o � feita verificando se o CPF cont�m exatamente 11 d�gitos num�ricos.
Caso o CPF seja v�lido, ele � formatado e exibido ao usu�rio.
Caso contr�rio, uma mensagem de erro � exibida.

@author Gabriel Gama
@since 04/06/2025
@version 12/Superior
*/

User Function VerificaCPF()
    // Declara��o de vari�veis locais
    Local aPergs := {} // Array para configurar os campos de entrada no ParamBox
    Local aResps := {} // Array para armazenar as respostas do usu�rio
    Local cCPF := ""   // Vari�vel para armazenar o CPF informado pelo usu�rio

    // Configura��o dos campos de entrada no ParamBox
    aAdd(aPergs, {9, "Digite abaixo seu CPF (somente n�meros) para verificar se � v�lido.", 200, 10, .T.}) // T�tulo
    aAdd(aPergs, {1, "Informe o CPF (apenas n�meros): ", 0, "@E 99999999999",,,,50,.T.}) // Campo para CPF

    // Loop para intera��o com o usu�rio
    While Parambox(aPergs, "Valida��o de CPF", @aResps)
        // Obt�m o CPF informado pelo usu�rio e remove espa�os em branco
        cCPF := AllTrim(cValToChar(aResps[2]))

        // Verifica se o CPF � v�lido
        If ValidaCPF(cCPF)
            // Exibe mensagem de CPF v�lido com formata��o
            Alert("O CPF " + SubStr(cCPF, 1, 3) + "." + SubStr(cCPF, 4, 3) + "." + SubStr(cCPF, 7, 3) + "-" + SubStr(cCPF, 10, 2) + " � v�lido.")
        Else
            // Exibe mensagem de CPF inv�lido com formata��o
            Alert("O CPF " + SubStr(cCPF, 1, 3) + "." + SubStr(cCPF, 4, 3) + "." + SubStr(cCPF, 7, 3) + "-" + SubStr(cCPF, 10, 2) + " � inv�lido.")
        EndIf

        // Pergunta ao usu�rio se deseja verificar outro CPF
        If ! MsgYesNo("Deseja verificar outro CPF?")
            Exit // Sai do loop caso o usu�rio n�o queira continuar
        EndIf
    EndDo

Return

/* {Protheus.doc} ValidaCPF
Fun��o est�tica que verifica se o CPF informado � v�lido.
A valida��o � feita verificando se o CPF cont�m exatamente 11 d�gitos num�ricos.

@param cCPF CPF informado pelo usu�rio (string)
@return L�gico Retorna .T. se o CPF for v�lido, ou .F. caso contr�rio
*/
Static Function ValidaCPF(cCPF)
    Local lValido := .F. // Vari�vel para armazenar o resultado da valida��o

    // Verifica se o CPF cont�m 11 d�gitos e se � composto apenas por n�meros
    If Len(cCPF) == 11 .And. SoNumeros(cCPF)
        lValido := .T. // CPF v�lido
    Else
        // Exibe mensagem de erro caso o CPF seja inv�lido
        Alert("CPF inv�lido. Deve conter 11 d�gitos num�ricos.")
    EndIf

Return lValido

/* {Protheus.doc} SoNumeros
Fun��o est�tica que verifica se uma string cont�m apenas n�meros.

@param cCPF CPF informado pelo usu�rio (string)
@return L�gico Retorna .T. se a string contiver apenas n�meros, ou .F. caso contr�rio
*/
Static Function SoNumeros(cCPF)
    Local i // Vari�vel de controle do loop
    Local lApenasNumeros := .T. // Vari�vel para armazenar o resultado da verifica��o

    // Percorre cada caractere da string
    For i := 1 To Len(cCPF)
        // Verifica se o caractere atual n�o � um n�mero
        If !IsDigit(SubStr(cCPF, i, 1))
            lApenasNumeros := .F. // Define como falso se encontrar um caractere n�o num�rico
            Exit // Sai do loop
        EndIf
    Next

Return lApenasNumeros




