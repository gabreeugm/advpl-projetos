#INCLUDE "PROTHEUS.CH"   
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

User Function OlaMundo()

   Local cMensagem := "Olá, Mundo!"
   
   MsgAlert(cMensagem)

   MsgAlert("Olá Mundo, agora é " + Time(), "Atenção")

   MsgAlert("Olá Mundo," + Chr(13) + Chr(10) + "agora é " + Time(), "Atenção")

   MsgAlert('<h1>Atenção:</h1><br>Olá <b>Mundo</b>, agora é <font color="#FF0000">' + Time() + '</font>', "Atenção")


Return cMensagem
// Chama a função para exibir a mensagem
