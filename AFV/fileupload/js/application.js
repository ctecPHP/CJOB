// This code assumes each file upload has a related DOM node
// set as data.context, which is true for the UI version:
$('#fileupload').bind('fileuploadsend', function (e, data) {
    // This feature is only useful for browsers which rely on the iframe transport:
    if (data.dataType.substr(0, 6) === 'iframe') {
        // Set PHP's session.upload_progress.name value:
        var progressObj = {
            name: 'PHP_SESSION_UPLOAD_PROGRESS',
            value: (new Date()).getTime()  // pseudo unique ID
        };
        data.formData.push(progressObj);
        // Start the progress polling:
        data.context.data('interval', setInterval(function () {
            $.get('./controller/progress.php', $.param([progressObj]), function (result) {
                // Trigger a fileupload progress event,
                // using the result as progress data:
                e = $.Event( 'progress', {bubbles: false, cancelable: true});
                $.extend(e, result);
                ($('#fileupload').data('blueimp-fileupload') ||
                    $('#fileupload').data('fileupload'))._onProgress(e, data);
            }, 'json');
        }, 1000)); // poll every second
    }
}).bind('fileuploadalways', function (e, data) {
    clearInterval(data.context.data('interval'));
});