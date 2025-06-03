#Include "TOTVS.ch"

/* {Protheus.doc} Calculadora de IMC
Calcula o IMC (�ndice de Massa Corporal) com base no peso e altura informados pelo usu�rio.
O IMC � calculado utilizando a f�rmula: peso / (altura * altura), onde a altura � convertida de cent�metros para metros.

@author Gabriel Gama
@since 03/06/2025
@version 12/Superior
@return L�gico
*/

User Function CalcImc()
    // Declara��o de vari�veis locais
    Local aPergs := {} // Array para configurar os campos de entrada no ParamBox
    Local aResps := {} // Array para armazenar as respostas do usu�rio
    Local aOpcoes := {"1-Masculino", "2-Feminino", "3-Outro"} // Op��es de g�nero
    Local nIMC := 0 // Vari�vel para armazenar o resultado do IMC

    // Configura��o dos campos de entrada
    aAdd(aPergs, {1, "Informe o peso (KG):", 0, "@E 999.99",,,,50,.T.}) // Campo para peso
    aAdd(aPergs, {1, "Informe a altura (CM):", 0, "@E 999.99",,,,50,.T.}) // Campo para altura
    aAdd(aPergs, {2, "Selecione o g�nero:", "1-Masculino", aOpcoes, 50, "", .T.}) // Campo para g�nero

    // Inicializa o array de respostas com valores padr�o
    aResps := {0.0, 0.0, aOpcoes[1]}  

    // Loop para intera��o com o usu�rio
    While ParamBox(aPergs, "Calculadora de IMC", @aResps)

        // Calcula o IMC com base nas respostas do usu�rio
        nIMC := fCalcImc(aResps[1], aResps[2]) // Peso e altura

        // Exibe o resultado ou mensagem de erro
        If nIMC > 0
            Alert("O seu IMC �: " + Str(nIMC, 5, 2))
        Else
            Alert("Erro ao calcular o IMC. Verifique os valores informados.")
        EndIf

        // Pergunta ao usu�rio se deseja realizar outro c�lculo
        If ! MsgYesNo("Deseja calcular outro IMC?")
            Exit
        EndIf
    EndDo

Return

/* {Protheus.doc} Fun��o est�tica para c�lculo do IMC
Recebe o peso e a altura como par�metros e calcula o IMC utilizando a f�rmula:
IMC = peso / (altura * altura), onde a altura � convertida de cent�metros para metros.
@param nPeso Peso informado pelo usu�rio (em KG)
@param nAltura Altura informada pelo usu�rio (em CM)
@return N�mero Retorna o valor do IMC ou 0 em caso de erro
*/
Static Function fCalcImc(nPeso, nAltura)
    Local nIMC := 0 // Vari�vel para armazenar o resultado do IMC

    // Verifica se a altura � v�lida e realiza o c�lculo
    If nAltura > 0
        nAltura := nAltura / 100 // Converte altura de cent�metros para metros
        nIMC := nPeso / (nAltura * nAltura) // Calcula o IMC
    Else
        Return 0 // Retorna 0 em caso de erro
    EndIf

Return nIMC
