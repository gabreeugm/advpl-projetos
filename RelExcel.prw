#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/* {Protheus.doc} RelExcel
Cria��o de um relat�rio personalizado realizado consultando o banco de dados que ir� ser exportado para o Excel.
@author Gabriel Gama
@since 15/07/2025
@version 12/Superior
*/

User Function RelExcel()
    Local oFWMsExcel          								 // Objeto para manipula��o do Excel
    Local oExcel              								 // Objeto para abrir o Excel
    Local cArquivo  := GetTempPath() + "RelatorioExcel.xml"  // Caminho do arquivo tempor�rio
    Local aProdutos := {}     								 // Array para armazenar os produtos
    Local aPedidos := {}      								 // Array para armazenar os pedidos
    Local nX := 0             								 // Vari�vel de controle para loops

    // Monta as queries e preenche os arrays aProdutos e aPedidos
    MontaQry(@aProdutos, @aPedidos)

    // Cria uma nova inst�ncia do objeto FWMsExcel
    oFWMsExcel := FWMsExcel():New()

    // Adiciona uma nova planilha chamada "Produtos"
    oFWMsExcel:AddWorkSheet("Produtos")

    // Adiciona uma tabela chamada "Produtos" na planilha "Produtos"
    oFWMsExcel:AddTable("Produtos", "Produtos")

    // Adiciona colunas � tabela "Produtos"
    oFWMsExcel:AddColumn("Produtos", "Produtos", "C�digo", 1, 1)
    oFWMsExcel:AddColumn("Produtos", "Produtos", "Descri��o", 1, 1)
    oFWMsExcel:AddColumn("Produtos", "Produtos", "Armaz�m Principal", 1, 1)

    // Adiciona as linhas � tabela "Produtos" com base no array aProdutos
    For nX := 1 To Len(aProdutos)
        oFWMsExcel:AddRow("Produtos", "Produtos", {aProdutos[nX, 1],;
                                                   aProdutos[nX, 2],;
                                                   aProdutos[nX, 3]})
    Next

    nX := 0  // Reinicia a vari�vel de controle

    
    /* Cria��o da segunda planilha com os pedidos de compra que est�o relacionados com os produtos da primeira planilha 
	   e que possuem o mesmo c�digo de produto.
	   A tabela ser� chamada "Pedidos" e conter� as seguintes colunas:
	   - C�digo
	   - Descri��o
	   - Armaz�m Principal
	   - N�mero do pedido de compras
	   - Item do pedido
	   - Data de emiss�o
	   - C�digo de Fornecedor
	   - Raz�o Social         
    */ 
    

    // Adiciona uma nova planilha chamada "ProdutosVsPedidosCompra"
    oFWMsExcel:AddWorkSheet("ProdutosVsPedidosCompra")

    // Adiciona uma tabela chamada "Pedidos" na nova planilha
    oFWMsExcel:AddTable("ProdutosVsPedidosCompra", "Pedidos")

    // Adiciona colunas � tabela "Pedidos"
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "C�digo", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Descri��o", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Armaz�m Principal", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "N�mero do pedido de compras", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Item do pedido", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Data de emiss�o", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "C�digo de Fornecedor", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Raz�o Social", 1, 1)

    // Adiciona as linhas � tabela "Pedidos" com base no array aPedidos
    For nX := 1 To Len(aPedidos)
        oFWMsExcel:AddRow("ProdutosVsPedidosCompra", "Pedidos", {aPedidos[nX, 1],;
                                                                 aPedidos[nX, 2],;
                                                                 aPedidos[nX, 3],;
                                                                 aPedidos[nX, 4],;
                                                                 aPedidos[nX, 5],;
                                                                 aPedidos[nX, 6],;
                                                                 aPedidos[nX, 7],;
                                                                 aPedidos[nX, 8]})
    Next

    // Ativa o arquivo Excel gerado
    oFWMsExcel:Activate()

    // Salva o arquivo Excel no caminho especificado
    oFWMsExcel:GetXMLFile(cArquivo)

    // Abre o arquivo Excel gerado no aplicativo Excel
    oExcel := MsExcel():New()
    oExcel:WorkBooks:Open(cArquivo)
    oExcel:SetVisible(.T.)  // Torna o Excel vis�vel para o usu�rio
    oExcel:Destroy()        // Libera o objeto Excel da mem�ria

Return


Static Function MontaQry(aProdutos, aPedidos)
    Local cQuery := ""  // Vari�vel para armazenar a query SQL

    // Monta a query para buscar os produtos
    cQuery := "SELECT DISTINCT  " + CRLF
    cQuery += "B1_COD AS CODIGO " + CRLF
    cQuery += ",B1_DESC AS DESCRICAO " + CRLF
    cQuery += ",B1_LOCPAD AS LOCPAD " + CRLF
    cQuery += "FROM " + RetSQLName("SB1") + " B1(NOLOCK) " + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SC7") + " C7(NOLOCK)  " + CRLF
    cQuery += "ON B1_COD = C7_PRODUTO " + CRLF
    cQuery += "AND C7.D_E_L_E_T_ = '' " + CRLF
    cQuery += "AND C7_FILIAL = '" + xFilial("SC7") + "' " + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SA2") + " A2(NOLOCK)  " + CRLF
    cQuery += "ON C7_FORNECE = A2_COD  " + CRLF
    cQuery += "AND C7_LOJA = A2_LOJA  " + CRLF
    cQuery += "AND A2.D_E_L_E_T_ = '' " + CRLF
    cQuery += "AND A2_FILIAL = '" + xFilial("SA2") + "' " + CRLF
    cQuery += "WHERE B1.D_E_L_E_T_ = '' " + CRLF

    // Executa a query e preenche o array aProdutos
    TCQuery cQuery New Alias "QRY1"
    While !(QRY1->(EOF()))
        AAdd(aProdutos, {QRY1->(CODIGO),;
						 QRY1->(DESCRICAO),;
						 QRY1->(LOCPAD)})
        QRY1->(DbSkip())
    EndDo

    cQuery := ""  // Reinicia a vari�vel para a pr�xima query

    // Monta a query para buscar os pedidos
    cQuery := "SELECT DISTINCT  " + CRLF
    cQuery += "B1_COD AS CODIGO " + CRLF
    cQuery += ",B1_DESC AS DESCRICAO " + CRLF
    cQuery += ",B1_LOCPAD AS LOCPAD " + CRLF
    cQuery += ",C7_NUM AS PEDIDO " + CRLF
    cQuery += ",C7_ITEM AS ITEM " + CRLF
    cQuery += ",C7_EMISSAO AS EMISSAO " + CRLF
    cQuery += ",C7_FORNECE AS FORNECEDOR " + CRLF
    cQuery += ",A2_NOME AS NOME " + CRLF
    cQuery += "FROM " + RetSQLName("SB1") + " B1(NOLOCK) " + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SC7") + " C7(NOLOCK)  " + CRLF
    cQuery += "ON B1_COD = C7_PRODUTO " + CRLF
    cQuery += "AND C7.D_E_L_E_T_ = '' " + CRLF
    cQuery += "AND C7_FILIAL = '" + xFilial("SC7") + "' " + CRLF
    cQuery += "LEFT JOIN " + RetSQLName("SA2") + " A2(NOLOCK)  " + CRLF
    cQuery += "ON C7_FORNECE = A2_COD  " + CRLF
    cQuery += "AND C7_LOJA = A2_LOJA  " + CRLF
    cQuery += "AND A2.D_E_L_E_T_ = '' " + CRLF
    cQuery += "AND A2_FILIAL = '" + xFilial("SA2") + "' " + CRLF
    cQuery += "WHERE B1.D_E_L_E_T_ = '' " + CRLF

    // Executa a query e preenche o array aPedidos
    TCQuery cQuery New Alias "QRY2"
    While !(QRY2->(EOF()))
        AAdd(aPedidos, {QRY2->(CODIGO),;
						QRY2->(DESCRICAO),;
						QRY2->(LOCPAD),;
                        QRY2->(PEDIDO),;
						QRY2->(ITEM),;
						QRY2->(EMISSAO),;
                        QRY2->(FORNECEDOR),;
						QRY2->(NOME)})
        QRY2->(DbSkip())
    EndDo

Return
