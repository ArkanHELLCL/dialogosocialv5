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

$(function () {
    'use strict';
    //Upload normal
	$('#fileupload').fileupload({
		//url: 'appl/uploadfile/server/php/'
		//url: 'appl/uploadfile/server/php/index.php?PRY_Id=' + PRY_Id.value + '&PRY_Identificador=' + PRY_Identificador.value + '&USR_Id=' + USR_Id.value + '&USR_Identificador=' + USR_Identificador.value + '&TPO_Id=' + TPO_Id.value + '&PRY_Hito=' + PRY_Hito.value
		url: "https://" + window.location.hostname + '/appl/uploadfile/server/php/index.php?PRY_Id=' + $('#PRY_Id').val() + '&PRY_Identificador=' + $('#PRY_Identificador').val() + '&USR_Id=' + $('#USR_Id').val() + '&USR_Identificador=' + $('#USR_Identificador').val() + '&TPO_Id=' + $('#TPO_Id').val() + '&PRY_Hito=' + $('#PRY_Hito').val()
	}).on('fileuploadsubmit', function (e, data) {
		data.formData = data.context.find(':input').serializeArray();
	});

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
			//cors/result.html?%s'
            'appl/uploadfile/cors/result.html?%s'
        )
    );		
    
	// Load existing files:
	$('#fileupload').addClass('fileupload-processing');
	$.ajax({
		// Uncomment the following to send cross-domain cookies:
		//xhrFields: {withCredentials: true},
		url: $('#fileupload').fileupload('option', 'url'),
		dataType: 'json',
		context: $('#fileupload')[0]
	}).always(function () {
		$(this).removeClass('fileupload-processing');
	}).done(function (result) {
		$(this).fileupload('option', 'done')
			.call(this, $.Event('done'), {result: result});
	});
	
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
	
	//upload de medios graficos	
	if(document.getElementById('mediosgraficosupload')){
		$('#mediosgraficosupload').fileupload({
			//downloadTemplateId : "template-mediosgraficosupload",
			//downloadTemplate : "template-mediosgraficosdownload",
			url: "https://" + window.location.hostname + '/appl/uploadfile/server/php/index.php?PRY_Id=' + $('#PRY_Id').val() + '&PRY_Identificador=' + $('#PRY_Identificador').val() + '&TPO_Id=1&PRY_Hito=99'
		}).on('mediosgraficosuploadsubmit', function (e, data) {
			//console.log(data.context.find(':input').serializeArray());
			data.formData = data.context.find(':input').serializeArray();
		});
	
		// Enable iframe cross-domain access via redirect option:
		$('#mediosgraficosupload').fileupload(
			'option',
			'redirect',
			window.location.href.replace(
				/\/[^\/]*$/,
				//cors/result.html?%s'
				'appl/uploadfile/cors/result.html?%s'
			)
		);		
		
		// Load existing files:
		$('#mediosgraficosupload').addClass('mediosgraficosupload-processing');
		$.ajax({
			// Uncomment the following to send cross-domain cookies:
			//xhrFields: {withCredentials: true},
			url: $('#mediosgraficosupload').fileupload('option', 'url'),
			dataType: 'json',
			context: $('#mediosgraficosupload')[0]
		}).always(function () {
			$(this).removeClass('mediosgraficosupload-processing');
		}).done(function (result) {
			$(this).fileupload('option', 'done')
				.call(this, $.Event('done'), {result: result});
		});
	}
	
});
