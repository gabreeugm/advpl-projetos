#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/* {Protheus.doc} RelExcel
Criação de um relatório personalizado realizado consultando o banco de dados que irá ser exportado para o Excel.
@author Gabriel Gama
@since 15/07/2025
@version 12/Superior
*/

User Function RelExcel()
    Local oFWMsExcel          								 // Objeto para manipulação do Excel
    Local oExcel              								 // Objeto para abrir o Excel
    Local cArquivo  := GetTempPath() + "RelatorioExcel.xml"  // Caminho do arquivo temporário
    Local aProdutos := {}     								 // Array para armazenar os produtos
    Local aPedidos := {}      								 // Array para armazenar os pedidos
    Local nX := 0             								 // Variável de controle para loops

    // Monta as queries e preenche os arrays aProdutos e aPedidos
    MontaQry(@aProdutos, @aPedidos)

    // Cria uma nova instância do objeto FWMsExcel
    oFWMsExcel := FWMsExcel():New()

    // Adiciona uma nova planilha chamada "Produtos"
    oFWMsExcel:AddWorkSheet("Produtos")

    // Adiciona uma tabela chamada "Produtos" na planilha "Produtos"
    oFWMsExcel:AddTable("Produtos", "Produtos")

    // Adiciona colunas à tabela "Produtos"
    oFWMsExcel:AddColumn("Produtos", "Produtos", "Código", 1, 1)
    oFWMsExcel:AddColumn("Produtos", "Produtos", "Descrição", 1, 1)
    oFWMsExcel:AddColumn("Produtos", "Produtos", "Armazém Principal", 1, 1)

    // Adiciona as linhas à tabela "Produtos" com base no array aProdutos
    For nX := 1 To Len(aProdutos)
        oFWMsExcel:AddRow("Produtos", "Produtos", {aProdutos[nX, 1],;
                                                   aProdutos[nX, 2],;
                                                   aProdutos[nX, 3]})
    Next

    nX := 0  // Reinicia a variável de controle

    
    /* Criação da segunda planilha com os pedidos de compra que estão relacionados com os produtos da primeira planilha 
	   e que possuem o mesmo código de produto.
	   A tabela será chamada "Pedidos" e conterá as seguintes colunas:
	   - Código
	   - Descrição
	   - Armazém Principal
	   - Número do pedido de compras
	   - Item do pedido
	   - Data de emissão
	   - Código de Fornecedor
	   - Razão Social         
    */ 
    

    // Adiciona uma nova planilha chamada "ProdutosVsPedidosCompra"
    oFWMsExcel:AddWorkSheet("ProdutosVsPedidosCompra")

    // Adiciona uma tabela chamada "Pedidos" na nova planilha
    oFWMsExcel:AddTable("ProdutosVsPedidosCompra", "Pedidos")

    // Adiciona colunas à tabela "Pedidos"
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Código", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Descrição", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Armazém Principal", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Número do pedido de compras", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Item do pedido", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Data de emissão", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Código de Fornecedor", 1, 1)
    oFWMsExcel:AddColumn("ProdutosVsPedidosCompra", "Pedidos", "Razão Social", 1, 1)

    // Adiciona as linhas à tabela "Pedidos" com base no array aPedidos
    For nX := 1 To Len(aPedidos)
        oFWMsExcel:AddRow("ProdutosVsPedidosCompra", "Pedidos", {aPedidos[nX, 1],;
                                                                 aPedidos[nX, 2],;
                                                                 aPedidos[nX, 3],;
                                                                 aPedidos[nX, 4],;
                                                                 aPedidos[nX, 5],;
                                                                 SToD(aPedidos[nX, 6]),;
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
    oExcel:SetVisible(.T.)  // Torna o Excel visível para o usuário
    oExcel:Destroy()        // Libera o objeto Excel da memória

Return


Static Function MontaQry(aProdutos, aPedidos)
    Local cQuery := ""  // Variável para armazenar a query SQL

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

    cQuery := ""  // Reinicia a variável para a próxima query

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
