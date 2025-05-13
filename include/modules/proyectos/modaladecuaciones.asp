<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	   response.Write("403\\Error Perfil no autorizado")
	   response.End() 
	end if
	splitruta=split(ruta,"/")		
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	
	if(xm="modificar") then
		modo=2
		mode="mod"
		required="required"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
		modo=4
		mode="vis"
		required="disabled"
	end if		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_IdLicitacion=rs("PRY_IdLicitacion")
		PRY_NombreLicitacion=rs("PRY_NombreLicitacion")
		FON_Nombre=rs("FON_Nombre")
		PRY_NumResAprueba=rs("PRY_NumResAprueba")
		PRY_FechaResolucion=rs("PRY_FechaResolucion")
		PRY_Adjunto=rs("PRY_Adjunto")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
		PRY_EmpresaEjecutora=rs("PRY_EmpresaEjecutora")
		PRY_Nombre=rs("PRY_Nombre")
		REG_Nombre=rs("REG_Nombre")
		PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
		PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if	
	if(PRY_InformeSistematizacionEstado="" or IsNULL(PRY_InformeSistematizacionEstado)) then
		PRY_InformeSistematizacionEstado=0
	end if
	if(LFO_Id=10 or LFO_Id=12) then
		PRY_InfFinal = PRY_InformeFinalEstado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionEstado
	end if
	columnsDefsadecuaciones="[]"
	response.write("200\\#adecuacionesModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-edit"></i> Adecuaciones</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">																				
				<div id="frmadecuacion" class="px-4">

												
								
				</div>
				<!--div frmAdecuacionadd-->
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-adecuaciones">
							<!--Table-->
							<table id="tbl-adecuaciones" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="adecuaciones" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>	
									<tr>			
										<th style="display:none">PRY</th>
										<th>Id</th>										
										<th>Usr.Solicitante</th>
										<th>Fch.Solicitud</th>
										<th>#</th>
										<th>Tipo Adecuación</th>
										<th>Descripción</th>																				
										<th>Usr.Respuesta</th>
										<th>Fch.Respuesta</th>																				
										<th>Estado</th>
										<th>Acciones</th>
										<th style="display:none">Justificación</th>
										<th style="display:none">Observaciones</th>
										<th style="display:none">ID_Estado</th><%
											columnsDefsadecuaciones = "[{""targets"": [ 0 ],""visible"": false,""searchable"": false},{""targets"": [ 11 ],""visible"": false,""searchable"": false},{""targets"": [ 12 ],""visible"": false,""searchable"": false},{""targets"": [ 13 ],""visible"": false,""searchable"": false}]"%>
									</tr>
								</thead>									
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (PRY_InfFinal=0 and PRY_Estado=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nueva Solicitud de Adecuación" id="btn_agregaadecuacion" name="btn_agregaadecuacion"><i class="fas fa-angle-up ml-1"></i></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="adecuaciones"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->

<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);						
				
		var adecuacionesTable;
		var tablaadecuacionesAlto;
		var disabled={};
		var iTermGPACounter = 1;
		var difhoras = 0;
		$("#adecuacionesModal").on('show.bs.modal', function(e){					
			
		})		
					
		function loadTableadecuaciones(){
			if($.fn.DataTable.isDataTable( "#tbl-adecuaciones")){
				$('#tbl-adecuaciones').dataTable().fnClearTable();
				$('#tbl-adecuaciones').dataTable().fnDestroy();				
			}	
			adecuacionesTable = $('#tbl-adecuaciones').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/adecuaciones",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				"order": [[ 13, "asc" ]],
				"columnDefs": <%=columnsDefsadecuaciones%>,				
				"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {										
					$(nRow).each(function(e){
						var largo = $(nRow).find("td").length - 2;
						if($(nRow).find("td")[8].innerText.trim() =="Pendiente"){
							$($(nRow).find("td")[8]).css("background","rgba(217, 83, 79, .3)");							
						}
						if($(nRow).find("td")[8].innerText=="Aceptado"){
							$($(nRow).find("td")[8]).css("background","rgba(92, 184, 92, .3)");
						}
						if($(nRow).find("td")[8].innerText=="Rechazado"){
							$($(nRow).find("td")[8]).css("background","rgba(240, 173, 78, .3)");
						}						
					})
				}
			});	
		}								
		
		$("#adecuacionesModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();									
			
			$(document).off('focusin.modal');
			$("body").addClass("modal-open");
			loadTableadecuaciones();			
													
			$("#ADE_AdjuntoX").click(function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				$("#ADE_Adjunto").click();
			})
			$("#ADE_Adjunto").change(function(click){								
				click.preventDefault();
				click.stopImmediatePropagation();
				click.stopPropagation();
				var fakepath_1 = "C:" + ss + "fakepath" + ss
				var fakepath_2 = "C:" + bb + "fakepath" + bb
				var fakepath_3 = "C:" + s + "fakepath" + s
				var fakepath_4 = "C:" + b + "fakepath" + b	
								
				var cont = 0;
				$.each (this.files,function(e){					
					cont = cont +1;
				});				
				$('#ADE_AdjuntoX').val("Archivo(s) adjunto(s) : " + cont);
			})															
			
			exportTable();
		});		
		
		$("#adecuacionesModal").on("click","#btn_frmaddadecuaciones",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var mod = false;
			var form;
			var formdata = new FormData();
			formValidate("#frmAdecuacionadd");
			if($("#TAD_Id").val()==1){				
				formValidate("#frmCalendarizacion");
				if($("#frmCalendarizacion").valid()){
					mod=true;
					form="#frmCalendarizacion";
					var data2 = $("#frmCalendarizacion").serializeArray();
					$.each(data2, function(i, field) { 
						formdata.append(field.name,field.value);
					});
				}				
			}else{
				if($("#TAD_Id").val()==3){
					formValidate("#frmCoordinadorProyecto");					
					if($("#frmCoordinadorProyecto").valid()){
						mod=true;
						form="#frmCoordinadorProyecto";
						var data2 = $("#frmCoordinadorProyecto").serializeArray();
						
						if($('#CAD_Adjunto').prop('files')!=undefined){
							var file_coordinador = $('#CAD_Adjunto').prop('files');
							if(file_coordinador[0]!=undefined){					
								formdata.append("CAD_Adjunto", "1")
								for (var i = 0; i < file_coordinador.length; i++) {
									formdata.append(file_coordinador[i].name, file_coordinador[i])
								}	
							}else{
								formdata.append("CAD_Adjunto", "0")
							}							
						}else{
							formdata.append("CAD_Adjunto", "0")
						}																		
						$.each(data2, function(i, field) { 
						   formdata.append(field.name,field.value);
						});						
					}
				}else{
					if($("#TAD_Id").val()==4){
						formValidate("#frmEncargadoActividades");
						if($("#frmEncargadoActividades").valid()){
							mod=true;
							form="#frmEncargadoActividades";
							var data2 = $("#frmEncargadoActividades").serializeArray();
							
							if($('#EAD_Adjunto').prop('files')!=undefined){
								var file_encargado = $('#EAD_Adjunto').prop('files');
								if(file_encargado[0]!=undefined){					
									formdata.append("EAD_Adjunto", "1")
									for (var i = 0; i < file_encargado.length; i++) {
										formdata.append(file_encargado[i].name, file_encargado[i])
									}	
								}else{
									formdata.append("EAD_Adjunto", "0")
								}							
							}else{
								formdata.append("EAD_Adjunto", "0")
							}							
							$.each(data2, function(i, field) { 
							   formdata.append(field.name,field.value);
							});
						}
					}else{
						if($("#TAD_Id").val()==5){
							formValidate("#frmRelator");
							if($("#frmRelator").valid()){
								mod=true;
								form="#frmRelator";
								var data2 = $("#frmRelator").serializeArray();						
								$.each(data2, function(i, field) { 
								   formdata.append(field.name,field.value);
								});
							}
						}else{
							if($("#TAD_Id").val()==6){
								formValidate("#frmJustificacion");
								if($("#frmJustificacion").valid()){
									mod=true;
									form="#frmJustificacion";
									var data2 = $("#frmJustificacion").serializeArray();						
									$.each(data2, function(i, field) { 
									   formdata.append(field.name,field.value);
									});
								}
							}else{							
								if($("#TAD_Id").val()==7){
									mod=true;
									form="";
								}else{
									if($("#TAD_Id").val()==8){
										formValidate("#frmDesvinculacion");
										if($("#frmDesvinculacion").valid()){
											mod=true;
											form="#frmDesvinculacion";
											var data2 = $("#frmDesvinculacion").serializeArray();						
											$.each(data2, function(i, field) { 
											   formdata.append(field.name,field.value);
											});
										}
									}else{
										if($("#TAD_Id").val()==9){
											formValidate("#frmFacilitador");
											if($("#frmFacilitador").valid()){
												mod=true;
												form="#frmFacilitador";
												var data2 = $("#frmFacilitador").serializeArray();						
												$.each(data2, function(i, field) { 
												   formdata.append(field.name,field.value);
												});
											}
										}else{
											if($("#TAD_Id").val()==12){
												formValidate("#frmPorcentajeFocalizacion");
												if($("#frmPorcentajeFocalizacion").valid()){
													mod=true;
													form="#frmPorcentajeFocalizacion";
													var data2 = $("#frmPorcentajeFocalizacion").serializeArray();						
													$.each(data2, function(i, field) { 
														formdata.append(field.name,field.value);
													});
												}
											}else{
												if($("#TAD_Id").val()==13){
													formValidate("#frmPorcentajeMetodologias");
													if($("#frmPorcentajeMetodologias").valid()){
														mod=true;
														form="#frmPorcentajeMetodologias";
														var data2 = $("#frmPorcentajeMetodologias").serializeArray();						
														$.each(data2, function(i, field) { 
															formdata.append(field.name,field.value);
														});
													}
												}else{
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			if($("#frmAdecuacionadd").valid() && mod){
				var data1 = $("#frmAdecuacionadd").serializeArray();								
				var file_data = $('#ADE_Adjunto').prop('files');
				var file_data1 = $('#CAD_Adjunto').prop('files');
				var file_data2 = $('#EAD_Adjunto').prop('files');
				var sizerror=false;
				var tipo=0;
				var errorfile=false;
				var sumsize=0;
				if(file_data[0]!=undefined){					
					formdata.append("ADE_Adjunto", "1")
				}else{
					formdata.append("ADE_Adjunto", "0")
				}
				
				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i]);
					if((file_data[i].name==$("#CAD_AdjuntoX").val()) || (file_data[i].name==$("#EAD_AdjuntoX").val())){
						errorfile=true
					};
					sumsize=sumsize+file_data[i].size;
					if(file_data[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
						tipo=1
					};
				}
				if(file_data1!=undefined){
					if(file_data1[0]!=undefined){
						if(file_data1[0].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
							tipo=2
						};
						sumsize=sumsize+file_data1[0].size;
					}
				}
				if(file_data2!=undefined){
					if(file_data2[0]!=undefined){
						if(file_data2[0].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
							tipo=3
						};
						sumsize=sumsize+file_data2[0].size;
					};
				}
				if((tipo==0) && (sumsize>parseInt(maxupload[maxsize].size))){
					sizerror=true;
					tipo=4
				}
				$.each(data1, function(i, field) { 
                   formdata.append(field.name,field.value);
                });
				if(errorfile){
					$("#ADE_AdjuntoX").removeClass("is-valid");
					$("#ADE_AdjuntoX").addClass("is-invalid");
					$("#ADE_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
					$("#ADE_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
					$("#ADE_AdjuntoX").parent().after('<div id="ADE_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">No puedes repetir el mismo archivo</div>');
					if($("#CAD_AdjuntoX").length>0){
						$("#CAD_AdjuntoX").removeClass("is-valid");
						$("#CAD_AdjuntoX").addClass("is-invalid");
						$("#CAD_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#CAD_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#CAD_AdjuntoX").parent().after('<div id="CAD_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">No puedes repetir el mismo archivo</div>');
					};
					if($("#EAD_AdjuntoX").length>0){
						$("#EAD_AdjuntoX").removeClass("is-valid");
						$("#EAD_AdjuntoX").addClass("is-invalid");
						$("#EAD_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#EAD_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#EAD_AdjuntoX").parent().after('<div id="EAD_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">No puedes repetir el mismo archivo</div>');
					}
					Toast.fire({
						icon: 'error',
						title: 'Debes anexar documentos diferentes antes de solicitar la adecuación'
					});
				}else{
					if(sizerror){	
						if((tipo==1) || (tipo=4)){
							$("#ADE_AdjuntoX").removeClass("is-valid");
							$("#ADE_AdjuntoX").addClass("is-invalid");
							$("#ADE_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
							$("#ADE_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
							$("#ADE_AdjuntoX").parent().after('<div id="ADE_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
						}
						if((tipo==2) || (tipo=4)){
							$("#CAD_AdjuntoX").removeClass("is-valid");
							$("#CAD_AdjuntoX").addClass("is-invalid");
							$("#CAD_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
							$("#CAD_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
							$("#CAD_AdjuntoX").parent().after('<div id="CAD_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
						}
						if((tipo==3) || (tipo=4)){
							$("#EAD_AdjuntoX").removeClass("is-valid");
							$("#EAD_AdjuntoX").addClass("is-invalid");
							$("#EAD_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
							$("#EAD_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
							$("#EAD_AdjuntoX").parent().after('<div id="EAD_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
						}
						Toast.fire({
							icon: 'error',
							title: maxupload[maxsize]['msg-toast']
						});
					}else{
						if($("#TAD_Id").val()==1){
							var difnorasnew = calculardiferencia('m',$("#PLN_HoraInicio").val(),$("#PLN_HoraFin").val());
							if(difhoras<=difnorasnew){
								$.ajax({
									url: "/agregar-adecuacion",
									method: 'POST',					
									data:formdata,
									enctype: 'multipart/form-data',
									cache: false,
									contentType: false,
									processData: false,
									dataType: "json",
									success: function (data) {						
										if(data.state==200){
											$("#frmAdecuacionadd")[0].reset();	
											if(form!=""){
												$(form)[0].reset();
												$("#TAD_Id option:selected").prop('selected',false)
												$('#TAD_Id option[value=""]').attr("selected","selected");
												$("#REL_Id option:selected").prop('selected',false)
												$('#REL_Id option[value=""]').attr("selected","selected");
											};
											$(".error.invalid-feedback").remove();
											$(".is-invalid").removeClass("is-invalid");
											Toast.fire({
											icon: 'success',
											title: 'Solicitud de Adecuación agregada exitosamente.'
											});
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Ingreso Fallido',
												text:data.message
											});
										}
									}
								});
							}else{
								$("#PLN_HoraInicio, #PLN_HoraFin").removeClass("is-valid");
								$("#PLN_HoraInicio, #PLN_HoraFin").addClass("is-invalid");
								$("#PLN_HoraInicio, #PLN_HoraFin").siblings('.select-bar').removeClass("is-valid");
								$("#PLN_HoraInicio, #PLN_HoraFin").siblings('.select-bar').addClass("is-invalid");
								$("#PLN_HoraInicio").parent().after('<div id="PLN_HoraInicio-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">Corregir horario</div>');
								$("#PLN_HoraFin").parent().after('<div id="PLN_HoraFin-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">Corregir horario</div>');
								Toast.fire({
									icon: 'error',
									title: 'Debes ingresar total de horas igual o mayores a las orginales'
								});
							}
						}else{
							$.ajax({
								url: "/agregar-adecuacion",
								method: 'POST',					
								data:formdata,
								enctype: 'multipart/form-data',
								cache: false,
								contentType: false,
								processData: false,
								dataType: "json",
								success: function (data) {						
									if(data.state==200){
										$("#frmAdecuacionadd")[0].reset();	
										if(form!=""){
											$(form)[0].reset();
											$("#TAD_Id option:selected").prop('selected',false)
											$('#TAD_Id option[value=""]').attr("selected","selected");
											$("#REL_Id option:selected").prop('selected',false)
											$('#REL_Id option[value=""]').attr("selected","selected");
										};
										$(".error.invalid-feedback").remove();
										$(".is-invalid").removeClass("is-invalid");
										Toast.fire({
										icon: 'success',
										title: 'Solicitud de Adecuación agregada exitosamente.'
										});
									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Ingreso Fallido',
											text:data.message
										});
									}
								}
							});
						}
					}
				}
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los campos con error antes de guardar'
				});
			}
		})
		
		$("#adecuacionesModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmadecuacion").css("height","0");			
			$("#btn_agregaadecuacion").find('i').toggleClass('openmenu');			
			$('#container-table-adecuaciones').animate({
				height: $('#container-table-adecuaciones').get(0).scrollHeight
			}, 700, function(){
				$(this).height('auto');
			});
			var PAR_Hito = window.location.href.split("/")[8];
			var PAR_Step = window.location.href.split("/")[9];
			var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,PRY_Hito:PAR_Hito,CRT_Step:PAR_Step};
			$.ajax( {
				type:'POST',					
				url: '/mnu-<%=LFO_Id%>',
				data: data,
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){						
						$("#pry-menucontent").html(param[1]);
						moveMark(false);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
							text:param[1]
						});				
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){					
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				}
			});

		});
		
		$("#adecuacionesModal").on("click","#btn_agregaadecuacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			adecuaciones_ingreso(e)
			$( "div[id*='ade-']" ).hide();
			$("#btn_frmaddadecuaciones").show();
			if($("#frmadecuacion").css("height")=="500px"){				
				$("#frmadecuacion").css("height","0");				
				$("#btn_agregaadecuacion").find('i').toggleClass('openmenu');				
				$('#container-table-adecuaciones').animate({
					height: $('#container-table-adecuaciones').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});								
			}else{								
				$("#frmadecuacion").css("height","500px");								
				$("#btn_agregaadecuacion").find('i').toggleClass('openmenu');
				$("#container-table-adecuaciones").css("height","0");				
			}						
		})
		
		$("#adecuacionesModal").on("click","#btn_saliradecuaciones",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			adecuacionesTable.ajax.reload();
			$( "div[id*='ade-']" ).hide();
			$("#frmAdecuacion").find(":input").each(function(){
				if(disabled[$(this).attr("id")]=="disabled"){
					$(this).attr("disabled","disbaled");
				}else{
					$(this).removeAttr("disabled");
				}
				disabled={}				
			});
			if($("#frmadecuacion").css("height")=="500px"){				
				$("#frmadecuacion").css("height","0");				
				$("#btn_agregaadecuacion").find('i').toggleClass('openmenu');				
				$('#container-table-adecuaciones').animate({
					height: $('#container-table-adecuaciones').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})	
		
		$("#adecuacionesModal").on("click",".arcalm",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var PRY_Id=$(this).data("pry");
			var INF_Arc=$(this).data("arc");
			var PRY_Identificador=$(this).data("token");
			var PRY_Hito=$(this).data("hito");
			var ALU_Rut=$(this).data("rut");
			
			var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador, INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut};			
			$.ajax({
				url: "/bajar-archivo",
				method: 'POST',
				data:data,
				xhrFields: {
					responseType: 'blob'
				},
				success: function (data) {
					var a = document.createElement('a');
					var url = window.URL.createObjectURL(data);
					a.href = url;
					a.download = INF_Arc;
					document.body.append(a);
					a.click();
					a.remove();
					window.URL.revokeObjectURL(url);
				}
			});
		})				
		
		function adecuaciones_ingreso(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/adecuaciones-modal-ingreso',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmadecuacion").html(param[1]);
						$("#TAD_Id").on("change",function(){
							var TAD_Id = $(this).val();
							$(".error.invalid-feedback").remove();
							$(".is-invalid").removeClass("is-invalid");							
							$( "div[id*='ade-']" ).hide();							
							$("#ade-" + TAD_Id).find("h5,h6").hide();
							$("#ade-" + TAD_Id).slideDown("slow",function(){
								var titani = setInterval(function(){
										$("h5").slideDown("slow",function(){
											$("h6").slideDown("slow",function(){
												clearInterval(titani)
											});
										})
									},3600);
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
								$('.hora').timepicker({
									timeFormat: 'H:mm',
									interval: 5,
									minTime: '6',
									maxTime: '22:00',
									startTime: '6:00',
									dynamic: true,
									dropdown: true,
									scrollbar: true,
									change:function(time){									
										$(this).siblings("label").addClass("active");								
									},
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
																								
								$("#frmCalendarizacion").on("click","#PLN_Sesion",function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									ajax_icon_handling('load','Buscando planificaciones','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-planificacion',			
										data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
										success: function(data) {
											var param=data.split(bb);			
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de Planificaciones creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");
												$("#tbl-listplanificacion").dataTable({
													lengthMenu: [ 5,10,20 ],
													"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
														$(nRow).click(function(e){
															e.preventDefault();
															e.stopImmediatePropagation();
															e.stopPropagation();

															$(this).find("td").each(function(e){
																if([e]<5){
																	$($("#frmCalendarizacion input")[e]).val(this.innerText)
																	$($("#frmCalendarizacion input")[e]).siblings("label").addClass("active")
																}
																if([e]==7){																	
																	$($("#frmCalendarizacion select")[0]).val(this.innerText);
																}
															});
															difhoras = calculardiferencia('m',$("#PLN_HoraInicio").val(),$("#PLN_HoraFin").val());
															Swal.close();
														});
													}
												});

											}else{
												ajax_icon_handling(false,'No fue posible crear el listado de planificaciones.','','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de planificaciones.','','');	
										},
										complete: function(){																		
										}
									})
								})
								
								$("#frmCalendarizacion").on("click","#TED_Id",function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									ajax_icon_handling('load','Buscando plan de trabajo','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-plan-de-trabajo',			
										data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
										success: function(data) {
											var param=data.split(bb);			
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de Plan de Trabajo creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");
												$("#tbl-listplandetrabajo").dataTable({
													lengthMenu: [ 5,10,20 ],
													"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
														$(nRow).click(function(e){
															e.preventDefault();
															e.stopImmediatePropagation();
															e.stopPropagation();

															$(this).find("td").each(function(e){																
																$($("#frmCalendarizacion input")[e]).val(this.innerText);
																$($("#frmCalendarizacion input")[e]).siblings("label").addClass("active");	
															})
															Swal.close();
														})
													}
												});

											}else{
												ajax_icon_handling(false,'No fue posible crear el listado de plan de trabajo.','','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de plan de trabajo.','','');	
										},
										complete: function(){																		
										}
									})
								})
								
								$("#frmRelator").on("click","#TED_Id",function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									ajax_icon_handling('load','Buscando plan de trabajo','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-plan-de-trabajo',			
										data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
										success: function(data) {
											var param=data.split(bb);			
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de Plan de Trabajo creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");
												$("#tbl-listplandetrabajo").dataTable({
													lengthMenu: [ 5,10,20 ],
													"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
														$(nRow).click(function(e){
															e.preventDefault();
															e.stopImmediatePropagation();
															e.stopPropagation();

															$(this).find("td").each(function(e){																
																$($("#frmRelator input")[e]).val(this.innerText);
																$($("#frmRelator input")[e]).siblings("label").addClass("active");	
															})
															Swal.close();
														})
													}
												});

											}else{
												ajax_icon_handling(false,'No fue posible crear el listado de plan de trabajo.','','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de plan de trabajo.','','');	
										},
										complete: function(){																		
										}
									})
								})
								
								$("#frmRelator").on("click","#PLN_Sesion",function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									ajax_icon_handling('load','Buscando planificaciones','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-planificacion',			
										data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
										success: function(data) {
											var param=data.split(bb);			
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de Planificaciones creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");										
												$("#tbl-listplanificacion").dataTable({
													lengthMenu: [ 5,10,20 ],
													"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
														$(nRow).click(function(e){
															e.preventDefault();
															e.stopImmediatePropagation();
															e.stopPropagation();
															
															$($("#frmRelator input")[0]).val($(this).find("td")[0].innerText);
															$($("#frmRelator input")[1]).val($(this).find("td")[1].innerText);
															$('#REL_Id option[value="' + $(this).find("td")[5].innerText + '"]').attr("selected","selected");

															$($("#frmRelator input")[0]).next().next().addClass("active");
															$($("#frmRelator input")[1]).next().next().addClass("active");
															Swal.close();
														})
													}
												});

											}else{
												ajax_icon_handling(false,'No fue posible crear el listado de planificaciones.','','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de planificaciones.','','');	
										},
										complete: function(){																		
										}
									})
								})
								
								$("#frmJustificacion").on("click","#ALU_Rut",function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();
									var ALU_Rut;
																											
									ajax_icon_handling('load','Buscando alumnos','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-alumnos',			
										data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
										success: function(data) {
											var param=data.split(bb);											
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de Alumnos creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");										
												$("#tbl-alumnosproyecto").dataTable({
													lengthMenu: [ 5,10,20 ],
													"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
														$(nRow).click(function(e){
															e.preventDefault();
															e.stopImmediatePropagation();
															e.stopPropagation();
															
															if($(this).find("td div")[0]!=undefined){
																$(this).find("td div")[0].remove();
															}
															ALU_Rut = $(this).find("td")[0].innerHTML.split("-")[0];
															$($("#frmJustificacion input")[0]).val($(this).find("td")[0].innerHTML);
															Swal.close();
																																													
															ajax_icon_handling('load','Buscando asistencia','','');
															$.ajax({
																type: 'POST',								
																url:'/listar-asistencia',			
																data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',ALU_Rut:ALU_Rut},
																success: function(data) {
																	var param=data.split(bb);											
																	if(param[0]=="200"){				
																		ajax_icon_handling(true,'Listado de Asistencia creado.','',param[1]);
																		$(".swal2-popup").css("width","60rem");										
																		$("#tbl-listinasistencia").dataTable({
																			lengthMenu: [ 5,10,20 ],
																			"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
																				$(nRow).click(function(e){
																					e.preventDefault();
																					e.stopImmediatePropagation();
																					e.stopPropagation();

																					$(this).find("td").each(function(e){																
																						if([e]){
																							$($("#frmJustificacion input")[e+1]).val(this.innerText)
																							$($("#frmJustificacion input")[e+1]).siblings("label").addClass("active")
																						}
																					})
																					Swal.close();
																				})
																			}
																		});

																	}else{
																		ajax_icon_handling(false,param[1],'','');
																		$("#frmJustificacion")[0].reset();
																	}						
																},
																error: function(XMLHttpRequest, textStatus, errorThrown){				
																	ajax_icon_handling(false,'No fue posible crear el listado de asistencia.','','');	
																},
																complete: function(){																		
																}
															})				
															
															
															
															
														})
													}
												});

											}else{
												ajax_icon_handling(false,param[1],'','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de alumnos.','','');	
										},
										complete: function(){																		
										}
									})	
								})								
								
							});							
						});
						
						//Adjunto coordinador
						$("#frmCoordinadorProyecto").on("click","#CAD_AdjuntoX",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#CAD_Adjunto").click();
						})
						$("#CAD_Adjunto").on("change",function(click){								
							click.preventDefault();
							click.stopImmediatePropagation();
							click.stopPropagation();
							var fakepath_1 = "C:" + ss + "fakepath" + ss
							var fakepath_2 = "C:" + bb + "fakepath" + bb
							var fakepath_3 = "C:" + s + "fakepath" + s
							var fakepath_4 = "C:" + b + "fakepath" + b	

							var cont = 0;
							$.each (this.files,function(e){					
								cont = cont +1;
							});									
							$('#CAD_AdjuntoX').val($("#CAD_Adjunto").val().replace(fakepath_4,""));
						})
						
						//Adjunto encargado
						$("#frmEncargadoActividades").on("click","#EAD_AdjuntoX",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#EAD_Adjunto").click();
						})
						$("#EAD_Adjunto").on("change",function(click){								
							click.preventDefault();
							click.stopImmediatePropagation();
							click.stopPropagation();
							var fakepath_1 = "C:" + ss + "fakepath" + ss
							var fakepath_2 = "C:" + bb + "fakepath" + bb
							var fakepath_3 = "C:" + s + "fakepath" + s
							var fakepath_4 = "C:" + b + "fakepath" + b	

							var cont = 0;
							$.each (this.files,function(e){					
								cont = cont +1;
							});							
							$('#EAD_AdjuntoX').val($("#EAD_Adjunto").val().replace(fakepath_4,""));
						})
						
						//Adjunto facilitador
						$("#frmFacilitador").on("click","#FAD_AdjuntoX",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#FAD_Adjunto").click();
						})
						$("#FAD_Adjunto").on("change",function(click){
							click.preventDefault();
							click.stopImmediatePropagation();
							click.stopPropagation();
							var fakepath_1 = "C:" + ss + "fakepath" + ss
							var fakepath_2 = "C:" + bb + "fakepath" + bb
							var fakepath_3 = "C:" + s + "fakepath" + s
							var fakepath_4 = "C:" + b + "fakepath" + b	

							var cont = 0;
							$.each (this.files,function(e){					
								cont = cont +1;
							});							
							$('#FAD_AdjuntoX').val($("#FAD_Adjunto").val().replace(fakepath_4,""));
						})
						
						//Desvinculacion Alumno
						$("#ALU_RutDes").Rut();
						$("#ALU_RutDes").on("change",function(){
							var ALU_Rut = $(this).val().replace(/[($)\s\._\-]+/g, '');							
							$.ajax({
								type: 'POST',
								url: '/consultar-alumno',
								data: {PRY_Id:<%=PRY_Id%>,ALU_Rut:ALU_Rut},
								dataType: "json",										
								success: function(json) {
									if($(json.data).length>0){
										if($(json.data)[0][41]!=1){
											$('[data-toggle="tooltip"]').tooltip({
												trigger : 'hover'
											})
											$('[data-toggle="tooltip"]').on('click', function () {
												$(this).tooltip('hide')
											});
											
											$("#ALU_RutDes").val($(json.data)[0][0]);
											$("#ALU_RutDes").siblings("label").addClass("active");
											$("#ALU_RutDes").Rut();

											$("#ALU_NombreDes").val($(json.data)[0][1]);
											$("#ALU_NombreDes").siblings("label").addClass("active");
											$("#ALU_ApellidoPaternoDes").val($(json.data)[0][2]);
											$("#ALU_ApellidoPaternoDes").siblings("label").addClass("active");
											$("#ALU_ApellidoMaternoDes").val($(json.data)[0][3]);
											$("#ALU_ApellidoMaternoDes").siblings("label").addClass("active");
											$("#ALU_FechaNacimientoDes").val($(json.data)[0][4]);
											$("#ALU_FechaNacimientoDes").siblings("label").addClass("active");
											
										}else{
											//El alumno que estas tratando de agregar ya pertenece a otro proyecto de la misma línea
										}
									}else{
										swalWithBootstrapButtons.fire({
										  icon: 'error',
										  title: 'ERROR!',
										  text: 'El alumno que estas tratando de desvincular no existe o no pertenece a este proyecto',										  
										}).then((result) => {
											$("#ALU_RutDes").val("");
										});
									}
								}
							})
						})																		
												
						$("#frmadecuacion").on("click","#ADE_AdjuntoX",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#ADE_Adjunto").click();
						})
						$("#ADE_Adjunto").on("change",function(click){								
							click.preventDefault();
							click.stopImmediatePropagation();
							click.stopPropagation();
							var fakepath_1 = "C:" + ss + "fakepath" + ss
							var fakepath_2 = "C:" + bb + "fakepath" + bb
							var fakepath_3 = "C:" + s + "fakepath" + s
							var fakepath_4 = "C:" + b + "fakepath" + b	

							var cont = 0;
							$.each (this.files,function(e){					
								cont = cont +1;
							});
							$('#ADE_AdjuntoX').val("Archivo(s) adjunto(s) : " + cont);								
						})
												
					}
				}
			})
		}
		
		$("#adecuacionesModal").on("click",".dowade",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ADE_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando adjuntos','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-adjuntos-adecuaciones',			
				data:{ADE_Id:ADE_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de adjuntos creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:96, ALU_Rut:ALU_Rut,ADE_Id:ADE_Id};
							$.ajax({
								url: "/bajar-archivo",
								method: 'POST',
								data:data,
								xhrFields: {
									responseType: 'blob'
								},
								success: function (data) {

									var a = document.createElement('a');
									var url = window.URL.createObjectURL(data);
									a.href = url;
									a.download = INF_Arc;
									document.body.append(a);
									a.click();
									a.remove();
									window.URL.revokeObjectURL(url);
								}
							});			
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de adjuntos.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#adecuacionesModal").on("click", ".vermod", function() {
			var tr = $(this).closest('tr');
			var row = adecuacionesTable.row(tr);			
			var id=$(this).data("id");			
			
			$(this).toggleClass('openmenu');
			var TAD_Id = $(this).parent().parent().find("td")[3].innerHTML;
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".vermod").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-adeMOD_" + iTermGPACounter ,TAD_Id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".vermod").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuesta(rowData,table_id,TAD_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/ver-modificaciones-solicitadas',
				data: {ADE_Id: rowData[1],table: table_id,TAD_Id:TAD_Id,PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'},        
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 4, 6, 10 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}
		
		$("#adecuacionesModal").on("click",".acemod",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ADE_Id = $(this).data("id");			
			var TAD_Id = $(this).parent().parent().find("td")[3].innerHTML;
			
			swalWithBootstrapButtons.fire({
			  title: 'Aceptar adecuación',
			  text: "Con esta acción estaras aceptando la adecuación y el sistema actualzará automáticamente los datos que se solicitaron cambiar.",
			  icon: 'success',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Aceptar',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax( {
						type:'POST',
						url: '/acepta-adecuacion',
						data: {ADE_Id: ADE_Id,PRY_Id:<%=PRY_Id%>,TAD_Id:TAD_Id},
						dataType: "json",
						success: function ( data ) {					
							if(data.state==200){
								adecuacionesTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Solicitud de Adecuación aceptada exitosamente.'
								});
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Aceptación Fallida',
									text:data.message
								});
							}
							
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){				

						}
					} );
			  	}
			})

		});
		
		$("#adecuacionesModal").on("click",".recmod",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ADE_Id = $(this).data("id")	
			var TAD_Id = $(this).parent().parent().find("td")[3].innerHTML;
			
			swalWithBootstrapButtons.fire({
			  title: 'Rechaza adecuación',
			  text: "Con esta acción estaras rechazando la adecuación y el sistema mantendrá los datos originales y dando aviso al ejecutor del rechazo.",
			  icon: 'error',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Rechazar',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
			 	if (result.value) {
					$.ajax( {
						type:'POST',
						url: '/rechaza-adecuacion',
						data: {ADE_Id: ADE_Id,PRY_Id:<%=PRY_Id%>,TAD_Id:TAD_Id},
						dataType: "json",
						success: function ( data ) {					
							if(data.state==200){								
								adecuacionesTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Solicitud de Adecuación rechazada exitosamente.'
								});
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Rechazo Fallido',
									text:data.message
								});
							}
							
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){				

						}
					} );
			 	}
			})

		});
		
		function exportTable(){
			$(".buttonExport").click(function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				var idTable = $(this).data("id")
						
				const inputValue=idTable + '.csv';
				const { value: csvFilename } = swalWithBootstrapButtons.fire({
					icon:'info',
					title: 'Ingresa el nombre del archivo',
					input: 'text',
					inputValue: inputValue,
					showCancelButton: true,
					confirmButtonText: '<i class="fas fa-sync-alt"></i> Generar',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
					inputValidator: (value) => {
					if (!value) {
					  return 'Debes escribir un nombre de archivo!';
					}
				  }
				}).then((result) => {
					if(result.value){				
						$('#tbl-'+idTable).exporttocsv({
							fileName  : result.value,
							separator : ';',
							table	  : 'dt'
						});				
					}

				});							
			});
		}				
				
		$("body").append("<button id='btn_modaladecuaciones' name='btn_modaladecuaciones' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modaladecuaciones").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#adecuacionesModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modaladecuaciones").click();		
		$("#btn_modaladecuaciones").remove();
	})
</script>