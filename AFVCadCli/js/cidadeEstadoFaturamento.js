$(document).ready(function () {
		
    $.getJSON('estados_cidades.json', function (data) {
        var items = [];
        var options = '<option value="">escolha um estado</option>';	
        $.each(data, function (key, val) {
            options += '<option value="' + val.nome + '">' + val.nome + '</option>';
        });					
        $("#estadofat").html(options);				
        
        $("#estadofat").change(function () {				
        
            var options_cidades = '';
            var str = "";					
            
            $("#estadofat option:selected").each(function () {
                str += $(this).text();
            });
            
            $.each(data, function (key, val) {
                if(val.nome == str) {							
                    $.each(val.cidades, function (key_city, val_city) {
                        options_cidades += '<option value="' + val_city + '">' + val_city + '</option>';
                    });							
                }
            });
            $("#cidadefat").html(options_cidades);
            
        }).change();		
    
    });

});