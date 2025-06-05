#INCLUDE "TOTVS.CH"

/* {Protheus.doc} VerificaCPF
Função que verifica se um CPF é válido.
A validação é feita verificando se o CPF contém exatamente 11 dígitos numéricos.
Caso o CPF seja válido, ele é formatado e exibido ao usuário.
Caso contrário, uma mensagem de erro é exibida.

@author Gabriel Gama
@since 04/06/2025
@version 12/Superior
*/

User Function VerificaCPF()
    // Declaração de variáveis locais
    Local aPergs := {} // Array para configurar os campos de entrada no ParamBox
    Local aResps := {} // Array para armazenar as respostas do usuário
    Local cCPF := ""   // Variável para armazenar o CPF informado pelo usuário

    // Configuração dos campos de entrada no ParamBox
    aAdd(aPergs, {9, "Digite abaixo seu CPF (somente números) para verificar se é válido.", 200, 10, .T.}) // Título
    aAdd(aPergs, {1, "Informe o CPF (apenas números): ", 0, "@E 99999999999",,,,50,.T.}) // Campo para CPF

    // Loop para interação com o usuário
    While Parambox(aPergs, "Validação de CPF", @aResps)
        // Obtém o CPF informado pelo usuário e remove espaços em branco
        cCPF := AllTrim(cValToChar(aResps[2]))

        // Verifica se o CPF é válido
        If ValidaCPF(cCPF)
            // Exibe mensagem de CPF válido com formatação
            Alert("O CPF " + SubStr(cCPF, 1, 3) + "." + SubStr(cCPF, 4, 3) + "." + SubStr(cCPF, 7, 3) + "-" + SubStr(cCPF, 10, 2) + " é válido.")
        Else
            // Exibe mensagem de CPF inválido com formatação
            Alert("O CPF " + SubStr(cCPF, 1, 3) + "." + SubStr(cCPF, 4, 3) + "." + SubStr(cCPF, 7, 3) + "-" + SubStr(cCPF, 10, 2) + " é inválido.")
        EndIf

        // Pergunta ao usuário se deseja verificar outro CPF
        If ! MsgYesNo("Deseja verificar outro CPF?")
            Exit // Sai do loop caso o usuário não queira continuar
        EndIf
    EndDo

Return

/* {Protheus.doc} ValidaCPF
Função estática que verifica se o CPF informado é válido.
A validação é feita verificando se o CPF contém exatamente 11 dígitos numéricos.

@param cCPF CPF informado pelo usuário (string)
@return Lógico Retorna .T. se o CPF for válido, ou .F. caso contrário
*/
Static Function ValidaCPF(cCPF)
    Local lValido := .F. // Variável para armazenar o resultado da validação

    // Verifica se o CPF contém 11 dígitos e se é composto apenas por números
    If Len(cCPF) == 11 .And. SoNumeros(cCPF)
        lValido := .T. // CPF válido
    Else
        // Exibe mensagem de erro caso o CPF seja inválido
        Alert("CPF inválido. Deve conter 11 dígitos numéricos.")
    EndIf

Return lValido

/* {Protheus.doc} SoNumeros
Função estática que verifica se uma string contém apenas números.

@param cCPF CPF informado pelo usuário (string)
@return Lógico Retorna .T. se a string contiver apenas números, ou .F. caso contrário
*/
Static Function SoNumeros(cCPF)
    Local i // Variável de controle do loop
    Local lApenasNumeros := .T. // Variável para armazenar o resultado da verificação

    // Percorre cada caractere da string
    For i := 1 To Len(cCPF)
        // Verifica se o caractere atual não é um número
        If !IsDigit(SubStr(cCPF, i, 1))
            lApenasNumeros := .F. // Define como falso se encontrar um caractere não numérico
            Exit // Sai do loop
        EndIf
    Next

Return lApenasNumeros




