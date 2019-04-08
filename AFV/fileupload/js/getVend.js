/*
  @recebe dados do vendedor
  Código Protheus 
  Unidade de Faturamento
*/

$(document).ready(function(){

    /* Recebe dados do vendedor via código */ 
    $('#afvUser').blur(function(){  

       var codigoUsuario = $('#afvUser').val();
       var cnpj = $('#cnpj').val();

       //tratar se valor é diferente de 0 antes
        if(codigoUsuario.length == 0 && cnpj.length == 0){
            $('#afvUser').focus();    
        } else {

        $.ajax({
            type: 'POST',
            url: './controller/get_vendedor.php', 
            //data: $(this).serialize()
            data: {afvUser: codigoUsuario}
        })
        .done(function(data){ 
                var obj = JSON.parse(data);      
                //console.log(obj.nome);          
                if(data != 'null'){
                    $('#userlogin').text('Bem-Vindo ' + obj.nome);
                    $('#codigoSobel').val(obj.codvend);
                    $('#unidfat').val(obj.unidfat);

                    //Desbloquear campos do formulário
                    $('#cnpj').prop('readonly', false);
                    $('#inscricao').prop('readonly', false);
                    $('#razaosocial').prop('readonly', false);
                    $('#fantasia').prop('readonly', false);
                    $('#contato').prop('readonly', false);
                    $('#email').prop('readonly', false);
                    $('#dddfone').prop('readonly', false);
                    $('#telefone').prop('readonly', false);
                    $('#dddcel').prop('readonly', false);
                    $('#cel').prop('readonly', false);

                    $('#formapgto').prop('readonly', false);
                    $('#condpgto').prop('readonly', false);
                    
                    $('#formapgto').prop('disabled', false);
                    $('#condpgto').prop('disabled', false);
                    $('#limitecred').prop('readonly', false);

                    $('#cnpj').focus().val($('#cnpj').val());
                
                    return false;    

                } else {
                    
                    $('#Modal').modal('show');
                    $("#erro").replaceWith("<h4>Usuário AFV não encontrado!</h4>");                                                
                    $('#afvUser').val("");    
                    $('#afvUser').focus();                 
                }                           
        })
      }//endIf
    });
        
});