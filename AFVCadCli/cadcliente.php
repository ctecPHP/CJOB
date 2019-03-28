
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Jekyll v3.8.5">
    <title>Cadastro de Clientes</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src="./js/getEndFaturamento.js"></script>
    <script type="text/javascript" src="./js/sintegra.js"></script>
    <script type="text/javascript" src="./js/validaCnpj.js"></script> 
    <script type="text/javascript" src="./js/copyEndFat.js"></script> 
    <script src="./js/jquery.maskedinput-1.1.4.pack.js" type="text/javascript"></script>
    <!--<script tyoe="text/javascript" src="./js/cidadeEstadoFaturamento.js"></script>-->
    <link rel="canonical" href="https://getbootstrap.com/docs/4.3/examples/navbar-fixed/">

    <!-- Bootstrap core CSS -->
    <link href="./css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript">
	$(document).ready(function(){

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
    </style>    
  </head>
  <body>
  
    <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
  <a class="navbar-brand" href="#">IVAN MARTINS</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarCollapse">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="#">3F <span class="sr-only">(current)</span></a>
      </li>    
    </ul>
  </div>
</nav>

<main role="main" class="container">
  <div class="jumbotron">
    <h3>Cadastro de Cliente - Dados Principais</h3>
    <p class="lead">
            <div class="row">
                    <div class="col-sm-3">
                            <div class="form-group">
                                    <label for="">CNPJ*</label>
                                    <input type="text" class="form-control" id="cnpj">                                    
                            </div>                             
                    </div>
                    <div class="col-sm-3">
                            <div class="form-group">
                                    <label for="">Inscrição Estadual*</label>
                                    <input type="text" class="form-control" id="inscricao">                                    
                            </div>  
                    </div>
                    <div class="col-sm">
                            <div class="form-group">
                                    <label for="">Razão Social*</label>
                                    <input type="text" class="form-control" id="razaosocial">                                   
                            </div>  
                    </div>
            </div>
            <div class="row">
                <div class="col-sm">
                    <div class="form-group">
                        <label for="">Fantasia*</label>
                        <input type="text" class="form-control" id="fantasia">
                    </div>
                </div>
                <div class="col-sm">
                    <div class="form-group">
                        <label for="">Contato*</label>
                        <input type="text" class="form-control" id="contato">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label for="">E-mail xml-NFe*</label>
                        <input type="text" class="form-control" id="email">                        
                    </div>
                </div>
                <div class="col-sm-1">
                    <div class="form-group">
                        <label for="">DDD*</label>
                        <input type="text" class="form-control" id="dddfone">                        
                    </div>
                </div>
                <div class="col-sm">
                        <div class="col-sm-20">
                                <div class="form-group">
                                    <label for="">Telefone.*</label>
                                    <input type="text" class="form-control" id="telefone">                        
                                </div>
                        </div>
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                            <label for="">DDD</label>
                            <input type="text" class="form-control" id="dddcel">                        
                        </div>
                    </div>
                    <div class="col-sm">
                            <div class="col-sm-20">
                                    <div class="form-group">
                                        <label for="">Celular</label>
                                        <input type="text" class="form-control" id="cel">                        
                                    </div>
                            </div>
                    </div>
            </div>
            <div class="col-sm-1">
                        <div class="form-group">
                            <label for="">Forma Pagamento*</label>
                            <input type="text" class="form-control" id="formapgto">                        
                        </div>
                    </div>
                    <div class="col-sm">
                            <div class="col-sm-1">
                                    <div class="form-group">
                                        <label for="">Condição de Pagamento</label>
                                        <input type="text" class="form-control" id="codpgto">                        
                                    </div>
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
                   <div class="col-sm">
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
                   <div class="col-sm">
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
                   <div class="col-sm">
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
                            <input type="text" class="form-control" id="cepfat">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecofat">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numerofat">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="complefat">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadofat"> 
                    </div>
                </div>
                <div class="col-sm">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadefat"> 
                            </div>
                </div>
                <div class="col-sm">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairrofat">
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
                            <input type="text" class="form-control" id="cepcob">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecocob">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numerocob">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="complecob">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadocob"> 
                    </div>
                </div>
                <div class="col-sm">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadecob"> 
                        </div>
                </div>
                <div class="col-sm">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairrocob">
                                </div>        
                        </div>
                </div>
            </div>
            <div class="row">
                    <div class="col-sm">&nbsp;</div>
            </div>
            <h3>Endereço de Entrega</h3>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                            <label for="">CEP*</label>
                            <input type="text" class="form-control" id="cepent">
                    </div>        
                </div>
                <div class="col-sm-6">
                        <div class="form-group">
                                <label for="">Endereço*</label>
                                <input type="text" class="form-control" id="enderecoent">
                        </div>        
                </div>
                <div class="col-sm-1">
                        <div class="form-group">
                                <label for="">Número*</label>
                                <input type="text" class="form-control" id="numeroent">
                        </div>        
                </div>
                <div class="col-sm-3">
                        <div class="form-group">
                                <label for="">Complemento</label>
                                <input type="text" class="form-control" id="compleent">
                        </div>        
                </div>
            </div>
            <div class="row">
                <div class="col-sm">
                    <div class="form-group">
                        <label for="">Estado</label>
                        <input type="text" class="form-control" id="estadoent"> 
                    </div>
                </div>
                <div class="col-sm">
                        <div class="form-group">
                                <label for="">Cidade*</label>
                                <input type="text" class="form-control" id="cidadeent"> 
                        </div>
                </div>
                <div class="col-sm">
                        <div class="col-sm">
                                <div class="form-group">
                                        <label for="">Bairro*</label>
                                        <input type="text" class="form-control" id="bairroent">
                                </div>        
                        </div>
                </div>
            </div>
            
    </p>
  </div>
</main>
</body>
</html>
