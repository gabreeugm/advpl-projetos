#INCLUDE "PROTHEUS.CH"   
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

User Function OlaMundo()

   Local cMensagem := "Ol�, Mundo!"
   
   MsgAlert(cMensagem)

   MsgAlert("Ol� Mundo, agora � " + Time(), "Aten��o")

   MsgAlert("Ol� Mundo," + Chr(13) + Chr(10) + "agora � " + Time(), "Aten��o")

   MsgAlert('<h1>Aten��o:</h1><br>Ol� <b>Mundo</b>, agora � <font color="#FF0000">' + Time() + '</font>', "Aten��o")


Return cMensagem
// Chama a fun��o para exibir a mensagem
