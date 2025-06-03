#Include "TOTVS.ch"

/* {Protheus.doc} Calculadora de IMC
Calcula o IMC (Índice de Massa Corporal) com base no peso e altura informados pelo usuário.
O IMC é calculado utilizando a fórmula: peso / (altura * altura), onde a altura é convertida de centímetros para metros.

@author Gabriel Gama
@since 03/06/2025
@version 12/Superior
@return Lógico
*/

User Function CalcImc()
    // Declaração de variáveis locais
    Local aPergs := {} // Array para configurar os campos de entrada no ParamBox
    Local aResps := {} // Array para armazenar as respostas do usuário
    Local aOpcoes := {"1-Masculino", "2-Feminino", "3-Outro"} // Opções de gênero
    Local nIMC := 0 // Variável para armazenar o resultado do IMC

    // Configuração dos campos de entrada
    aAdd(aPergs, {1, "Informe o peso (KG):", 0, "@E 999.99",,,,50,.T.}) // Campo para peso
    aAdd(aPergs, {1, "Informe a altura (CM):", 0, "@E 999.99",,,,50,.T.}) // Campo para altura
    aAdd(aPergs, {2, "Selecione o gênero:", "1-Masculino", aOpcoes, 50, "", .T.}) // Campo para gênero

    // Inicializa o array de respostas com valores padrão
    aResps := {0.0, 0.0, aOpcoes[1]}  

    // Loop para interação com o usuário
    While ParamBox(aPergs, "Calculadora de IMC", @aResps)

        // Calcula o IMC com base nas respostas do usuário
        nIMC := fCalcImc(aResps[1], aResps[2]) // Peso e altura

        // Exibe o resultado ou mensagem de erro
        If nIMC > 0
            Alert("O seu IMC é: " + Str(nIMC, 5, 2))
        Else
            Alert("Erro ao calcular o IMC. Verifique os valores informados.")
        EndIf

        // Pergunta ao usuário se deseja realizar outro cálculo
        If ! MsgYesNo("Deseja calcular outro IMC?")
            Exit
        EndIf
    EndDo

Return

/* {Protheus.doc} Função estática para cálculo do IMC
Recebe o peso e a altura como parâmetros e calcula o IMC utilizando a fórmula:
IMC = peso / (altura * altura), onde a altura é convertida de centímetros para metros.
@param nPeso Peso informado pelo usuário (em KG)
@param nAltura Altura informada pelo usuário (em CM)
@return Número Retorna o valor do IMC ou 0 em caso de erro
*/
Static Function fCalcImc(nPeso, nAltura)
    Local nIMC := 0 // Variável para armazenar o resultado do IMC

    // Verifica se a altura é válida e realiza o cálculo
    If nAltura > 0
        nAltura := nAltura / 100 // Converte altura de centímetros para metros
        nIMC := nPeso / (nAltura * nAltura) // Calcula o IMC
    Else
        Return 0 // Retorna 0 em caso de erro
    EndIf

Return nIMC
