
/**/

function getSintegra()
{
  var token = "F9FC2E73-CA5C-46DB-8639-C814EA0F8442";
  var cnpj = $("#cnpj").val().replace(/[^\d]+/g,'');
  var plugin = "ST";

  limpaCampos () //Limpa dados do formulário para nova consulta
   
  if (valida_cnpj(cnpj)) 
  {          
    $.ajax({       
      url: "https://sintegraws.com.br/api/v1/execute-api.php?token="+token+"&cnpj="+cnpj+"&plugin="+ plugin,
      method:'GET',
      complete: function(xhr){
    
        // Aqui recuperamos o JSON retornado
        response = xhr.responseJSON;
        
        if(response.status == 'OK') {
        
          // Agora preenchemos os campos com os valores retornados
          $('#razaosocial').val(response.nome_empresarial);  
          $('#fantasia').val(response.nome_fantasia);  
          $('#enderecofat').val(response.logradouro); 
          $('#inscricao').val(response.inscricao_estadual); 
          $('#cepfat').val(response.cep);
          $('#complefat').val(response.complemento);
          $('#cidadefat').val(response.municipio);    
          $('#estadofat').val(response.uf);
          $('#bairrofat').val(response.bairro); 
          $('#numerofat').val(response.numero);

          $('#cnae').val(response.cnae_principal.code);
          $('#atividade').val(response.cnae_principal.text);
          $('#data_inicio_atividade').val(response.data_inicio_atividade);
          $('#regime_tributacao').val(response.regime_tributacao);

          $('#situacao_cnpj').val(response.situacao_cnpj);
          $('#situacao_ie').val(response.situacao_ie);
          
          //buscar código ibge aqui
           //Consulta o webservice viacep.com.br/
           getIBGE();
           return false;

        } else {
          $('#cnpj').focus().val($('#cnpj').val());
          $("#cnpj").val("CNPJ-Inválido");     
        }
      }
    });
  }else{
      $('#Modal').modal('show');
      $("#erro").replaceWith("<h4>CNPJ Inválido</h4>");           
      $('#cnpj').focus().val($('#cnpj').val());

  } 
}
   

        
/***/
function getIBGE() {
  var cep = $('#cepfat').val();
  $.getJSON("https://viacep.com.br/ws/" + cep + "/json/?callback=?", function (dados) {
    if (!("erro" in dados)) {

          resultado = dados.ibge;
          ibge = resultado.substring(2);

      $("#ibge").val(ibge);
    } //end if.
    else {
      //CEP pesquisado não foi encontrado.
      alert("Código IBGE não encontrado.");
    }
  });
}


function limpaCampos ()
{
  $('#razaosocial').val("");  
  $('#fantasia').val("");  
  $('#enderecofat').val(""); 
  $('#inscricao').val(""); 
  $('#cepfat').val("");
  $('#complefat').val("");
  $('#cidadefat').val("");    
  $('#estadofat').val("");
  $('#bairrofat').val(""); 
  $('#numerofat').val("");
  $('#contato').val("");
  $('#email').val("");
  $('#dddfone').val("");
  $('#telefone').val("");
  $('#dddcel').val("");
  $('#cel').val("");
  

  $('#cnae').val("");
  $('#atividade').val("");
  $('#data_inicio_atividade').val("");
  $('#regime_tributacao').val("");

  $('#situacao_cnpj').val("");
  $('#situacao_ie').val("");

      //cobranca
      $("#enderecocob").val("");
      $("#bairrocob").val("");
      $("#cidadecob").val("");
      $("#numerocob").val("");
      $("#complecob").val("");
      $("#estadocob").val("");
      $("#cepcob").val("");

  //Entrega
  $("#enderecoent").val("");
  $("#bairroent").val("");
  $("#cidadeent").val("");
  $("#numeroent").val("");
  $("#compleent").val("");
  $("#estadoent").val("");
  $("#cepent").val("");

}
/*
 valida_cnpj
 @param string cnpj
 @return bool true para CNPJ correto
*/
function valida_cnpj ( valor ) {

  // Garante que o valor é uma string
  valor = valor.toString();
  
  // Remove caracteres inválidos do valor
  valor = valor.replace(/[^0-9]/g, '');

  
  // O valor original
  var cnpj_original = valor;

  // Captura os primeiros 12 números do CNPJ
  var primeiros_numeros_cnpj = valor.substr( 0, 12 );

  // Faz o primeiro cálculo
  var primeiro_calculo = calc_digitos_posicoes( primeiros_numeros_cnpj, 5 );

  // O segundo cálculo é a mesma coisa do primeiro, porém, começa na posição 6
  var segundo_calculo = calc_digitos_posicoes( primeiro_calculo, 6 );

  // Concatena o segundo dígito ao CNPJ
  var cnpj = segundo_calculo;

  // Verifica se o CNPJ gerado é idêntico ao enviado
  if ( cnpj === cnpj_original ) {
      return true;
  }
  
  // Retorna falso por padrão
  return false;
  
} // valida_cnpj


/*
 calc_digitos_posicoes
 
 Multiplica dígitos vezes posições
 
 @param string digitos Os digitos desejados
 @param string posicoes A posição que vai iniciar a regressão
 @param string soma_digitos A soma das multiplicações entre posições e dígitos
 @return string Os dígitos enviados concatenados com o último dígito
*/
function calc_digitos_posicoes( digitos, posicoes = 10, soma_digitos = 0 ) {

  // Garante que o valor é uma string
  digitos = digitos.toString();

  // Faz a soma dos dígitos com a posição
  // Ex. para 10 posições:
  //   0    2    5    4    6    2    8    8   4
  // x10   x9   x8   x7   x6   x5   x4   x3  x2
  //   0 + 18 + 40 + 28 + 36 + 10 + 32 + 24 + 8 = 196
  for ( var i = 0; i < digitos.length; i++  ) {
      // Preenche a soma com o dígito vezes a posição
      soma_digitos = soma_digitos + ( digitos[i] * posicoes );

      // Subtrai 1 da posição
      posicoes--;

      // Parte específica para CNPJ
      // Ex.: 5-4-3-2-9-8-7-6-5-4-3-2
      if ( posicoes < 2 ) {
          // Retorno a posição para 9
          posicoes = 9;
      }
  }

  // Captura o resto da divisão entre soma_digitos dividido por 11
  // Ex.: 196 % 11 = 9
  soma_digitos = soma_digitos % 11;

  // Verifica se soma_digitos é menor que 2
  if ( soma_digitos < 2 ) {
      // soma_digitos agora será zero
      soma_digitos = 0;
  } else {
      // Se for maior que 2, o resultado é 11 menos soma_digitos
      // Ex.: 11 - 9 = 2
      // Nosso dígito procurado é 2
      soma_digitos = 11 - soma_digitos;
  }

  // Concatena mais um dígito aos primeiro nove dígitos
  // Ex.: 025462884 + 2 = 0254628842
  var cpf = digitos + soma_digitos;

  // Retorna
  return cpf;
  
} // calc_digitos_posicoes