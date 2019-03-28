$(document).ready(function(){

    $('#afvUser').blur(function(){
     
       var codigoUsuario = $('#afvUser').val();
       //tratar se valor é diferente de 0 antes
        if(codigoUsuario.length == 0){
            $('#afvUser').focus()    
        }

        $.ajax({
            type: 'POST',
            url: 'get_vendedor.php', 
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
                    //$('#formapgto').prop('readonly', false);
                   // $('#condpgto').prop('readonly', false);
                    $('#limitecred').prop('readonly', false);


                    $('#cnpj').focus().val($('#cnpj').val());

                    

                    return false;    
                } else {
                    
                    $('#Modal').modal('show');
                    $("#erro").replaceWith("<h4>Usuário AFV não encontrado!</h4>");                                                
                    $('#afvUser').val("");                     
                }                           
        })

    });
    
});