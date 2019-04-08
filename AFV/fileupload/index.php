<?php

    define('DB_HOST'        , "DESKTOP-0DD5KKR\SQLSERVER");
    define('DB_USER'        , "sa");
    define('DB_PASSWORD'    , "adeade4522");
    define('DB_NAME'        , "P12");
    define('DB_DRIVER'      , "sqlsrv");
   
    require_once "Class/Conexao.php";
   
    try
    {
   
        $Conexao    = Conexao::getConnection();

        $sql  = "SELECT E4_CODIGO, E4_DESCRI ";
        $sql .= "FROM SE4010 WHERE E4_TIPO = '1' ";
        $sql .= "AND E4_CODIGO <> '093' ";
        $sql .= "AND D_E_L_E_T_ = '' " ;

        $query       = $Conexao->query($sql);
        $condPgtos   = $query->fetchAll();
   
    }
    catch(Exception $e)
    {
        echo $e->getMessage();
        exit;
    }    
    
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="theme-color" content="#ffffff">

    <title>Cadastro de Clientes</title>
    <link rel="shortcut icon" href="favicon.ico" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>   
    <script type="text/javascript" src="./js/getEndFaturamento.js"></script>
    <link href="./css/afv.css" rel="stylesheet"/>

     <!-- Libs customizadas -->
    <script type="text/javascript" src="./js/sintegra.js"></script>
    <script type="text/javascript" src="./js/getVend.js"></script>

    <script type="text/javascript" src="./js/copyEndFat.js"></script> 
    <script src="./js/jquery.maskedinput-1.1.4.pack.js" type="text/javascript"></script>
    <!--<script src="./js/jquery.markMoney.js" type="text/javascript"></script>    -->

    <link rel="canonical" href="https://getbootstrap.com/docs/4.3/examples/navbar-fixed/">

        <!-- blueimp Gallery styles -->
        <link rel="stylesheet" href="https://blueimp.github.io/Gallery/css/blueimp-gallery.min.css">
        <!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
        <link rel="stylesheet" href="./css/jquery.fileupload.css">
        <link rel="stylesheet" href="./css/jquery.fileupload-ui.css">
        <!-- CSS adjustments for browsers with JavaScript disabled -->
        <noscript><link rel="stylesheet" href="./css/jquery.fileupload-noscript.css"></noscript>
        <noscript><link rel="stylesheet" href="./css/jquery.fileupload-ui-noscript.css"></noscript>
   
    
    <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
    <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>

    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,300,500,700" />

  <!--
    <script type="text/javascript">
        $("#limitecred").maskMoney({symbol:'R$ ', thousands:'.', decimal:',', symbolStay: true});
    </script>
   -->

 <script type="text/javascript">
	$(document).ready(function(){

        /*Desliga campos*/
        $("#condpgto").prop('disabled', true);
        $("#formapgto").prop('disabled', true);
        $('#afvUser').focus().val($('#afvUser').val());
         
        /* Formata mascara CNPJ */
        $("#cnpj").mask("99.999.999/9999-99");        
	});
</script>

    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }       
    }
    </style>  
  </head>
  <body class="top-navigation">
  <div id="wrapper">
        <div id="page-wrapper" class="gray-bg">
            <div class="row border-bottom white-bg">
                <nav class="navbar navbar-static-top" role="navigation">
                    <div class="navbar-header">
                        <button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse"
                                class="navbar-toggle collapsed" type="button">
                            <i class="fa fa-reorder"></i>
                        </button>
                        <a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/Principal" class="navbar-brand">AFVWeb Sobel</a>
                    </div>
                    <div class="navbar-collapse collapse" id="navbar">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Comercial <span class="caret"></span>
                                </a>
                                <ul role="menu" class="dropdown-menu">
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/PlanejamentoDeVisitas">Planejamento de Visitas</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeClientes?operacao=VisitaForaDoPlanejamento">Novo Pedido</a></li>
                                    <li class="divider"></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/VendasNaoTransmitidas">Vendas Não Transmitidos</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeClientes?operacao=ConsultaDeCliente">Consultar Clientes</a></li>
                                    <li><a href="#">Cadastro Clientes</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeAniversariantes">Aniversariantes</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Gerencial <span class="caret"></span>
                                </a>
                                <ul role="menu" class="dropdown-menu">
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaResumoDeVendas">Resumo de Vendas</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaClienteSemVenda">Clientes Sem Venda</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaClienteSemVisita">Clientes Sem Visita</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaProdutoSemVenda">Produto Sem Venda</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a aria-expanded="false" role="button" href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Consultas <span class="caret"></span>
                                </a>
                                <ul role="menu" class="dropdown-menu">
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaRetornoDePedidos">Retorno de Pedidos</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaRetornoDePedidoWorkflow">Retorno de Pedidos Workflow</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeTitulos">Títulos</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaAnaliseDeGiro">Análise de Giro</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaCurvaAbc">Curva ABC</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeDevolucoes">Devoluções gerais</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaDeClientes?operacao=VisitaForaDoPlanejamento#">Tabela de Preços</a></li>
                                    <li><a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/ConsultaObjetivoDeVendas">Objetivo de Vendas afv-s</a></li>
                                    <li><a data-toggle="modal" data-target="#modalSaldoFlex">Saldo Flex</a></li>
                                    <li><a onclick="#">Pedidos sem retorno afv-server</a></li>
                                </ul>
                            </li>
                            <li>
                                <a aria-expanded="false" role="button" href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/AlterarSenha"> Trocar a Senha</a>
                            </li>
                            <li>
                                <a aria-expanded="false" role="button" href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/Sobre"> Sobre</a>
                            </li>

                        </ul>
                        <ul class="nav navbar-top-links navbar-right">
                            <li>
                                <span class="m-r-sm text-muted welcome-message" id="userlogin">Bem-vindo</span>
                            </li>                            
                            <li>
                                <a href="http://www.totvs.sobelmaster.com.br:8081/AFVWeb/Login">
                                    <i class="fa fa-sign-out"></i> Sair
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>                    
<main role="main" class="container">
  <div class="jumbotron">

    <p class="lead"> 
    <h3>Identificação do Vendedor</h3>
    <form id="fileupload" action="controller/fileupload.php" method="POST" enctype="multipart/form-data">
        <div class="row">
            <div class="col-sm-3">
                <div class="form-group">
                    <label for="">Usuário AFV*</label>
                    <input type="text" class="form-control" id="afvUser">
                </div>
            </div>
            <div class="col-sm-3">
                <div class="form-group">
                    <label for="">Código Sobel*</label>
                    <input type="text" class="form-control" id="codigoSobel" readonly="readonly">
                </div>
            </div>
            <div class="col-sm-3">
                <div class="form-group">
                    <label for="">Unidade Faturamento*</label>
                    <input type="text" class="form-control" id="unidfat" readonly="readonly">
                </div>
            </div>
        </div>
    </p>
    <h3>Dados Principais</h3>
    <p class="lead">
            <div class="row">
                    <div class="col-sm-3">
                            <div class="form-group">
                                    <label for="">CNPJ*</label>
                                    <input type="text" class="form-control" id="cnpj" readonly="readonly">                                                                                               
                            </div> 
                    </div>
                    <div class="col-sm-2">
                            <div class="form-group">
                                    <label for="">Inscrição Estadual*</label>
                                    <input type="text" class="form-control" id="inscricao" readonly="readonly">                                    
                            </div>  
                    </div>
                    <div class="col-sm-6">
                            <div class="form-group">
                                    <label for="">Razão Social*</label>
                                    <input type="text" class="form-control" id="razaosocial" readonly="readonly">                                   
                            </div>  
                    </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label for="">Fantasia*</label>
                        <input type="text" class="form-control" id="fantasia" readonly="readonly">
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label for="">Contato*</label>
                        <input type="text" class="form-control" id="contato" readonly="readonly">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label for="">E-mail xml-NFe*</label>
                        <input type="text" class="form-control" id="email" readonly="readonly">                        
                    </div>
                </div>
                <div class="col-sm-1">
                    <div class="form-group">
                        <label for="">DDD*</label>
                        <input type="text" class="form-control" id="dddfone" readonly="readonly">                        
                    </div>
                </div>
                <div class="col-sm">
                        <div class="col-sm-2">
                                <div class="form-group">
                                    <label for="">Telefone*</label>
                                    <input type="text" class="form-control" id="telefone" readonly="readonly">                        
                                </div>
                        </div>
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                            <label for="">DDD</label>
                            <input type="text" class="form-control" id="dddcel" readonly="readonly">                        
                        </div>
                    </div>
                    <div class="col-sm">
                            <div class="col-sm-2">
                                    <div class="form-group">
                                        <label for="">Celular</label>
                                        <input type="text" class="form-control" id="cel" readonly="readonly">                        
                                    </div>
                            </div>
                    </div>
            </div>
            
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="">Forma de Pagamento*</label>
                        <select class="form-control cbfiltro" id="formapgto" readonly="readonly">
                            <!--<option value="C">Carteira</option>-->
                            <option value="B">Boleto</option>
                            <option value="D">Deposito</option>
                            <option value="H">Cheque</option>
                        </select>
                   </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="">Condição de Pagamento*</label>
                        <select class="form-control cbfiltro" id="condpgto" readonly="readonly">

                          <?php
                               /* Popula Combo forma de pagamento */
                               foreach($condPgtos as $condPgto) 
                               {
                                   echo "<option value ='" . $condPgto['E4_CODIGO'] . "'>" . $condPgto['E4_DESCRI'] . '</option>';
                               }
                          ?>

                        </select>
                   </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="">Limite de Crédito Sugerido*</label>
                        <input type="text" class="form-control" id="limitecred" readonly="readonly">            
                   </div>
                </div>
            </div>    
            <div class="row">                    
                    <div class="col-sm-2">
                            <div class="form-group">
                            <label for="">Situação CNPJ</label>
                                <input type="text" class="form-control" id="situacao_cnpj" readonly="readonly">   
                            </div>
                   </div>
                   <div class="col-sm-10">
                            <div class="form-group">
                            <label for="">Situação Inscrição Estadual</label>
                                <input type="text" class="form-control" id="situacao_ie" readonly="readonly">   
                            </div>
                   </div>
            </div>
            <div class="row">                    
                    <div class="col-sm-2">
                            <div class="form-group">
                            <label for="">CNAE Principal</label>
                                <input type="text" class="form-control" id="cnae" readonly="readonly">   
                            </div>
                   </div>
                   <div class="col-sm-10">
                            <div class="form-group">
                            <label for="">Atividade econômica exercida</label>
                                <input type="text" class="form-control" id="atividade" readonly="readonly">   
                            </div>
                   </div>
            </div>
            <div class="row">                    
                    <div class="col-sm-2">
                            <div class="form-group">
                            <label for="">Data início Atividade</label>
                                <input type="text" class="form-control" id="data_inicio_atividade" readonly="readonly">   
                            </div>
                   </div>
                   <div class="col-sm-10">
                            <div class="form-group">
                            <label for="">Regime de tributação</label>
                                <input type="text" class="form-control" id="regime_tributacao" readonly="readonly">   
                            </div>
                   </div>
            </div>
            <h3>Endereço de Faturamento</h3>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                            <label for="">CEP*</label>
                            <input type="text" class="form-control" id="cepfat" readonly="readonly">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecofat" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numerofat" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="complefat" readonly="readonly">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadofat" readonly="readonly"> 
                    </div>
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadefat" readonly="readonly"> 
                            </div>
                </div>
                <div class="col-sm-3">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairrofat" readonly="readonly">
                                </div>
                                <div class="form-group">
                                        <input type="hidden" class="form-control" id="ibge">
                                </div>        
                        </div>
                </div>
            </div>           
            <div class="row">                    
                    <div class="col-sm">
                            <button type="button" class="btn btn-primary" onclick="CopyEndFat()">Copiar endereço de faturamento</button>
                   </div>
            </div>
            <div class="row">    
                      <div class="col-sm">&nbsp;</div>  
                 </div>
            <h3>Endereço de Cobrança</h3>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                            <label for="">CEP*</label>
                            <input type="text" class="form-control" id="cepcob" readonly="readonly">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecocob" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numerocob" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="complecob" readonly="readonly">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadocob" readonly="readonly"> 
                    </div>
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadecob" readonly="readonly"> 
                        </div>
                </div>
                <div class="col-sm-3">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairrocob" readonly="readonly">
                                </div>        
                        </div>
                </div>
            </div>
            <div class="row">
                    <div class="col-sm">&nbsp;</div>
            </div>
            <h3>Dados Logística</h3>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                            <label for="">CEP*</label>
                            <input type="text" class="form-control" id="cepent" readonly="readonly">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecoent" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numeroent" readonly="readonly">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="compleent" readonly="readonly">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadoent" readonly="readonly"> 
                    </div>
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadeent" readonly="readonly"> 
                        </div>
                </div>
                <div class="col-sm-3">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairroent" readonly="readonly">
                                </div>        
                        </div>
                </div>

                <div class="row fileupload-buttonbar">
                <div class="col-sm-6">
                    <!-- The fileinput-button span is used to style the file input field as button -->
                    <span class="btn btn-success fileinput-button">
                        <i class="glyphicon glyphicon-plus"></i>
                        <span>Add files...</span>
                        <input type="file" name="files[]" multiple>           
                        <input type="hidden" class="form-control" name="path" id="path" placeholder="" value="">
                        
                    </span>
                    <button type="submit" class="btn btn-primary start">                        
                        <span>Iniciar Upload</span>
                    </button>
                    <button type="reset" class="btn btn-warning cancel">                       
                        <span>Cancelar upload</span>
                    </button>            
                    <button type="button" class="btn btn-danger delete">                       
                        <span>Delete</span>
                    </button>
                    <input type="checkbox" class="toggle">
                    <!-- The global file processing state -->
                    <span class="fileupload-process"></span>
                </div>
                <!-- The global progress state -->
                <div class="col-lg-5 fileupload-progress fade">
                    <!-- The global progress bar -->
                    <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar progress-bar-success" style="width:0%;"></div>
                    </div>
                    <!-- The extended global progress state -->
                    <div class="progress-extended">&nbsp;</div>
                </div>
            </div>
            <!-- The table listing the files available for upload/download -->
            <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>

</form>

               
</main>
<!-- Modal -->
<div class="modal fade" id="Modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="">Atenção</h3>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
       <span id="erro"></span>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>   
      </div>
    </div>
  </div>
</div>
<div class="footer">
                <div class="pull-right">
                    Versão 01.10 - 26/03/2019 - Sobel
                </div>
                <div>
                    <strong>Copyright</strong> Acácia Consultoria &copy; 2018-2019
                </div>
            </div>
            
            
<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            <strong class="error text-danger"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" disabled>                
                    <span>Iniciar</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">                   
                    <span>Cancelar</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <span class="preview">
                {% if (file.thumbnailUrl) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            <p class="name">
                {% if (file.url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
                {% } else { %}
                    <span>{%=file.name%}</span>
                {% } %}
            </p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
            {% if (file.deleteUrl) { %}
                <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>Delete</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } else { %}
                <button class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha384-xBuQ/xzmlsLoJpyjoggmTEz8OWUFM0/RC5BsqQBDX2v5cMvDHcMakNTNrHIW2I5f" crossorigin="anonymous"></script> -->
<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="./js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="https://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="https://blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="https://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<!-- blueimp Gallery script -->
<script src="https://blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="./js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="./js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="./js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="./js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="./js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="./js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="./js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="./js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="./js/main.js"></script>
<script src="./js/application.js"></script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="js/cors/jquery.xdr-transport.js"></script>
<![endif]-->            
</body>
</html>
