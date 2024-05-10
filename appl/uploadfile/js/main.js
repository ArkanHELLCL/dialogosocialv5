/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/* global $, window */
$(document).bind('drop dragover', function (e) {
	'use strict';
    e.preventDefault();
	e.stopImmediatePropagation();
	e.stopPropagation();
});

$(function () {
    'use strict';
    //Upload normal
	$('.fileupload').each(function () {
		$(this).find("table tbody.files").empty();
		$(this).fileupload({
			url		 : "https://" + window.location.hostname + '/appl/uploadfile/server/php/index.php?PRY_Id=' + $(this).find("#PRY_Id").val() + '&PRY_Identificador=' + $(this).find("#PRY_Identificador").val() + '&USR_Id=' + $(this).find("#USR_Id").val() + '&USR_Identificador=' + $(this).find("#USR_Identificador").val() + '&TPO_Id=' + $(this).find("#TPO_Id").val() + '&PRY_Hito=' + $(this).find("#PRY_Hito").val(),
			dropZone: $(this)
		}).on('fileuploadsubmit', function (e, data) {
			data.formData = data.context.find(':input').serializeArray();
		});
		
		// Load existing files:
		$(this).addClass('fileupload-processing');
		$.ajax({
			// Uncomment the following to send cross-domain cookies:
			//xhrFields: {withCredentials: true},
			url: $(this).fileupload('option', 'url'),
			dataType: 'json',
			context: $(this)[0]
		}).always(function () {
			$(this).removeClass('fileupload-processing');
		}).done(function (result) {
			$(this).fileupload('option', 'done')
				.call(this, $.Event('done'), {result: result});
		});				
	});		
	$(".fileupdate").fileupload(
		'option',
		'redirect',
		window.location.href.replace(
			/\/[^\/]*$/,
			//cors/result.html?%s'
			'appl/uploadfile/cors/result.html?%s'
		)
	);		
		
	//upload de alumnos
	if(document.getElementById('alumnoupload')){
		$('#alumnoupload').fileupload({			
			url: "https://" + window.location.hostname + '/appl/uploadfile/server/php/index.php?PRY_Id=' + $('#PRY_Id').val() + '&PRY_Identificador=' + $('#PRY_Identificador').val() + '&USR_Id=' + $('#USR_Id').val() + '&USR_Identificador=' + $('#USR_Identificador').val() + '&TPO_Id=' + $('#TPO_Id').val() + '&PRY_Hito=' + $('#PRY_Hito').val() + '&ALU_Rut=' + $('#ALU_Rut').val()
		}).on('alumnouploadsubmit', function (e, data) {
			data.formData = data.context.find(':input').serializeArray();
		});
	
		// Enable iframe cross-domain access via redirect option:
		$('#alumnoupload').fileupload(
			'option',
			'redirect',
			window.location.href.replace(
				/\/[^\/]*$/,
				//cors/result.html?%s'
				'appl/uploadfile/cors/result.html?%s'
			)
		);		
		
		// Load existing files:
		$('#alumnoupload').addClass('alumnoupload-processing');
		$.ajax({
			// Uncomment the following to send cross-domain cookies:
			//xhrFields: {withCredentials: true},
			url: $('#alumnoupload').fileupload('option', 'url'),
			dataType: 'json',
			context: $('#alumnoupload')[0]
		}).always(function () {
			$(this).removeClass('alumnoupload-processing');
		}).done(function (result) {
			$(this).fileupload('option', 'done')
				.call(this, $.Event('done'), {result: result});
		});
	}
	
});
