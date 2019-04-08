
$(document).ready(function() {

            function limpa_formulário_cep() {
                // Limpa valores do formulário de cep.
                $("#enderecofat").val("");
                $("#bairrofat").val("");
                $("#cidadefat").val("");
                $("#estadofat").val("");
                $("#ibge").val("");
            }
            
            //Quando o campo cep perde o foco.
            $("#cepfat").blur(function() {

                //Nova variável "cep" somente com dígitos.
                var cep = $("#cepfat").val().replace(/\D/g, '');

                //Verifica se campo cep possui valor informado.
                if (cep != "") {

                    //Expressão regular para validar o CEP.
                    var validacep = /^[0-9]{8}$/;

                    //Valida o formato do CEP.
                    if(validacep.test(cep)) {

                        //Preenche os campos com "..." enquanto consulta webservice.
                        $("#enderecofat").val("...");
                        $("#bairrofat").val("...");
                        $("#cidadefat").val("...");
                        $("#estadofat").val("...");
                        $("#ibge").val("...");

                        //Consulta o webservice viacep.com.br/
                        $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {

                            if (!("erro" in dados)) {
                                //Atualiza os campos com os valores da consulta.
                                $("#enderecofat").val(dados.logradouro);
                                $("#bairrofat").val(dados.bairro);
                                $("#cidadefat").val(dados.localidade);
                                $("#estadofat").val(dados.uf);
                                $("#numerofat").val("");
                                $("#ibge").val(dados.ibge);
                            } //end if.
                            else {
                                //CEP pesquisado não foi encontrado.
                                limpa_formulário_cep();
                                alert("CEP não encontrado.");
                            }
                        });
                    } //end if.
                    else {
                        //cep é inválido.
                        limpa_formulário_cep();
                        alert("Formato de CEP inválido.");
                    }
                } //end if.
                else {
                    //cep sem valor, limpa formulário.
                    limpa_formulário_cep();
                }
            });

            //Quando o campo cep perde o foco.
            $("#cepent").blur(function() {

                //Nova variável "cep" somente com dígitos.
                var cep = $("#cepent").val().replace(/\D/g, '');

                //Verifica se campo cep possui valor informado.
                if (cep != "") {

                    //Expressão regular para validar o CEP.
                    var validacep = /^[0-9]{8}$/;

                    //Valida o formato do CEP.
                    if(validacep.test(cep)) {

                        //Preenche os campos com "..." enquanto consulta webservice.
                        $("#enderecoent").val("...");
                        $("#bairroent").val("...");
                        $("#cidadeent").val("...");
                        $("#estadoent").val("...");
                        //$("#ibge").val("...");

                        //Consulta o webservice viacep.com.br/
                        $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {

                            if (!("erro" in dados)) {
                                //Atualiza os campos com os valores da consulta.
                                $("#enderecoent").val(dados.logradouro);
                                $("#bairroent").val(dados.bairro);
                                $("#cidadeent").val(dados.localidade);
                                $("#estadoent").val(dados.uf);
                                $("#numeroent").val("");
                               // $("#ibge").val(dados.ibge);
                            } //end if.
                            else {
                                //CEP pesquisado não foi encontrado.
                                limpa_formulário_cep();
                                alert("CEP não encontrado.");
                            }
                        });
                    } //end if.
                    else {
                        //cep é inválido.
                        limpa_formulário_cep();
                        alert("Formato de CEP inválido.");
                    }
                } //end if.
                else {
                    //cep sem valor, limpa formulário.
                    limpa_formulário_cep();
                }
            });

            //Quando o campo cep perde o foco.
            $("#cepcob").blur(function() {

                //Nova variável "cep" somente com dígitos.
                var cep = $("#cepcob").val().replace(/\D/g, '');

                //Verifica se campo cep possui valor informado.
                if (cep != "") {

                    //Expressão regular para validar o CEP.
                    var validacep = /^[0-9]{8}$/;

                    //Valida o formato do CEP.
                    if(validacep.test(cep)) {

                        //Preenche os campos com "..." enquanto consulta webservice.
                        $("#enderecocob").val("...");
                        $("#bairrocob").val("...");
                        $("#cidadecob").val("...");
                        $("#estadocob").val("...");
                       // $("#ibge").val("...");

                        //Consulta o webservice viacep.com.br/
                        $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {

                            if (!("erro" in dados)) {
                                //Atualiza os campos com os valores da consulta.
                                $("#enderecocob").val(dados.logradouro);
                                $("#bairrocob").val(dados.bairro);
                                $("#cidadecob").val(dados.localidade);
                                $("#estadocob").val(dados.uf);
                                $("#numerocob").val("");
                            //    $("#ibge").val(dados.ibge);
                            } //end if.
                            else {
                                //CEP pesquisado não foi encontrado.
                               // limpa_formulário_cep();
                                alert("CEP não encontrado.");
                            }
                        });
                    } //end if.
                    else {
                        //cep é inválido.
                        //limpa_formulário_cep();
                        alert("Formato de CEP inválido.");
                    }
                } //end if.
                else {
                    //cep sem valor, limpa formulário.
                    limpa_formulário_cep();
                }
            });
});