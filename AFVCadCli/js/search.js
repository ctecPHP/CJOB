$('#txtCountry').keyup(function(){
    var txtInput = $('#txtCountry').val();
    if(txtInput.length == 0){
        $('#output div').html('');
        $('#output').hide();
        return;
    }
    var html = '';
    $.ajax({
        type: "GET",
        url: 'countries.php',
        data: {search: txtInput},
        success: function(data){
            if(data != null){
                var regex = new RegExp(txtInput, 'gi');
                $.each(data, function(id, country){
                    highlightedCountry = country.replace(regex, function(str) {return '<b>'+str+'</b>'});
                    html += highlightedCountry + '<br>';
                });
            $('#output div').html(html);
            } else {
                $('#output div').html('Nenhuma sugestão encontrada.');
            }
            $('#output').show();
        }
    });
});