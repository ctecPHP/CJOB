
function CopyEndFat() {
    // recebe dados.
    var endereco = $("#enderecofat").val();
    var bairro   = $("#bairrofat").val();
    var cidade   = $("#cidadefat").val();
    var cep      = $("#cepfat").val();
    var numero   = $("#numerofat").val();
    var comple   = $("#complefat").val();
    var estado   = $("#estadofat").val();
    
    //cobranca
        $("#enderecocob").val(endereco)
        $("#bairrocob").val(bairro);
        $("#cidadecob").val(cidade);
        $("#numerocob").val(numero);
        $("#complecob").val(comple);
        $("#estadocob").val(estado);
        $("#cepcob").val(cep);

    //Entrega
    $("#enderecoent").val(endereco)
    $("#bairroent").val(bairro);
    $("#cidadeent").val(cidade);
    $("#numeroent").val(numero);
    $("#compleent").val(comple);
    $("#estadoent").val(estado);
    $("#cepent").val(cep);

}