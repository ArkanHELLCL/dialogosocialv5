<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<% Response.Buffer = False 
   Server.ScriptTimeout = 36000 %>   
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
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
		LFO_Calif = rs("LFO_Calif")
		
		PRY_InformeFinalEstado = rs("PRY_InformeFinalEstado")		
	end if
	
	if(PRY_Estado=9) then
		msg="(Archivado)"
	end if	
	
	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs3 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()
	End If	

	TotSes=0
	do while not rs3.eof		
		TotSes=TotSes+1
		rs3.movenext
	loop
	rs3.close	

	'Horas Ejecutadas
	sqlx = "exec spPlanificacionHoras_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	'response.write(sqlx)
	set rsx = cnn.Execute(sqlx)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()		
	End If	
	if not rsx.eof then
		HorasTotalesRealizadas=rsx("HorasTotalesRealizadas")
		HorasTotalesPedagogicasRealizadas=rsx("HorasTotalesPedagogicasRealizadas")
	end if

	sql="exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()
	End If
	TotalHorasProyecto=0
	do while not rs.eof		
		TotalHorasProyecto=TotalHorasProyecto+CInt(rs("TEM_Horas"))
		rs.movenext
	loop
	PorHoras=round((cint(HorasTotalesPedagogicasRealizadas)*100)/cint(TotalHorasProyecto),1)			
	
	columnsDefsAsistencia="[]"
	response.write("200\\#asistenciaModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-users"></i> Asistencia</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="frmAsistencia" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">
						<form role="form" action="" method="POST" name="frmaddasistencia" id="frmaddasistencia" class="needs-validation"><%
							
							sql="exec [spPlanificacionLista_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'"
							set rs3 = cnn.Execute(sql)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								cnn.close
								response.Write("503//Error Conexión 1:" & ErrMsg)
								response.End() 
							End If	
							
							dim sesid(200)
							dim sesnom(200)
							dim sesfec(200)
							dim seshra(200)
							TotSes=0%>
							<table id="tbl-modasis" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="modasis">
								<thead>
									<tr>				
										<th colspan="5">Evidencias</th><%
										TotArc=0
										do while not rs3.eof
											sesid(TotSes)	= rs3("PLN_Sesion")
											sesnom(TotSes)	= rs3("TEM_Nombre")
											sesfec(TotSes)	= rs3("PLN_Fecha")
											seshra(TotSes)	= rs3("PLN_HoraInicio")
											TotSes=TotSes+1										
																											
											dbfileName=""										
											dbfileName=rs3("EVI_Nombre")
										
											if dbfileName<>"" then
												colorup="text-white-50"
												disabledup="disabled"
												cursorup="not-allowed"
												tooltipup=""

												colordw="text-success"
												disableddw=""
												cursordw="pointer"
												tooltipdw="Bajar Evidencia de " & rs3("TEM_Nombre")

												colordel="text-danger"
												disableddel=""
												cursordel="pointer"
												tooltipdel="Eliminar Evidencia de " & rs3("TEM_Nombre")						

												'background="#b0e0b0;"
												background="transparent"

												TotArc=TotArc+1						
											else
												colorup="text-primary"
												disabledup=""
												cursorup="pointer"
												tooltipup="Subir Evidencia de " & rs3("TEM_Nombre")

												colordw="text-white-50"
												disableddw="disabled"
												cursordw="not-allowed"
												tooltipdw=""

												colordel="text-white-50"
												disableddel="disabled"
												cursordel="not-allowed"
												tooltipdel=""
												functiondel=""

												'background="#2577d466"
												background="transparent"						
											end if
											%>
										<th style="text-align: center;padding: 0;margin: 0;background-color:<%=background%>;" id="evi-<%=rs3("PLN_Sesion")%>" name="evi-<%=rs3("PLN_Sesion")%>" class="evi" data-sesion="<%=rs3("PLN_Sesion")%>"><%
											
											'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then
											if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and ((USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1))) then%>
												<i class="fas fa-cloud-upload-alt upload <%=colorup%>" style="cursor:<%=cursorup%>" title="<%=tooltipup%>" id="upd_evi-<%=rs3("PLN_Sesion")%>" name="upd_evi-<%=rs3("PLN_Sesion")%>" data-modulo="<%=rs3("PLN_Sesion")%>" data-mode="upload" data-modulodes="<%=rs3("TEM_Nombre")%>" <%=disabledup%> data-sesion="<%=rs3("PLN_Sesion")%>"></i><%
											else%>
												<i class="fas fa-cloud-upload-alt text-white-50" style=";cursor:not-allowed" disabled></i><%
											end if%>
											<i class="fas fa-cloud-download-alt download <%=colordw%>" style="cursor:<%=cursordw%>" title="<%=tooltipdw%>" id="dwn_evi-<%=rs3("PLN_Sesion")%>" name="dwn_evi-<%=rs3("PLN_Sesion")%>" data-modulo="<%=rs3("PLN_Sesion")%>" data-mode="download" data-modulodes="<%=rs3("TEM_Nombre")%>" <%=disableddw%> data-sesion="<%=rs3("PLN_Sesion")%>" data-arc="<%=dbfileName%>"></i><span style="display:none"><%=dbfileName%></span>
											<%if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) and (mode="mod") then%>
												<i class="fas fa-trash delete <%=colordel%>" style="cursor:<%=cursordel%>" title="<%=tooltipdel%>" id="del_evi-<%=rs3("PLN_Sesion")%>" name="del_evi-<%=rs3("PLN_Sesion")%>" data-modulo="<%=rs3("PLN_Sesion")%>" data-mode="delete" data-modulodes="<%=rs3("TEM_Nombre")%>" <%=disableddel%> data-sesion="<%=rs3("PLN_Sesion")%>"></i><%
											else%>
												<i class="fas fa-trash text-white-50>" style="cursor:not-allowed" disabled></i><%
											end if%>
											<div class="progress-bar"><div class="progress"></div></div>
										</th><%
										rs3.movenext
									loop
									rs3.close%>
									</tr>
									<tr>
										<th>Hidden</th>
										<th style="text-align: center;vertical-align: top;">Alumno</th>
										<th style="text-align: center;vertical-align: top;">RUT</th>
										<th style="text-align: center;vertical-align: top;">Estado</th>
										<th style="text-align: center;vertical-align: top;">Asist.<br/>(%)</th><%
											for j=0 to TotSes-1%>
												<th style="text-align: center;vertical-align: top;" class="no-sort"><%=response.Write(sesnom(j) & " [" & sesfec(j) & "/" & seshra(j) & "/s-" & sesid(j) & "]")%></th><%
											next%>                                        
									  </tr>
								</thead>
								<tbody>
								</tbody>
							</table>
							<div id="btnAsis" style="display:none"><%
								'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then
								if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and ((USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1))) then%>
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddasistencia" name="btn_frmaddasistencia"><i class="fas fa-plus"></i> Agregar</button><%								
								end if%>
								<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirasistencia" name="btn_salirasistencia"><i class="fas fa-sign-out-alt"></i> Salir</button>								
							</div>
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--frmPlanificacion-->				
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12" id="container-table-asistencia">
							<!--Table-->
							<table id="tbl-asistenciamodal" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="asistencia" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>	
									<tr>										
										<th>RUT</th> 
										<th>Nombres</th>
										<th>Paterno</th>
										<th>Materno</th>
										<th>Sexo</th>
										<th>Email</th>
										<th>Asis.(%)</th>
										<th>Estado</th>
										<th style="display:none">Causa Deserción</th>
										<th style="display:none">Razón Causa Deserción</th>
										<th style="display:none">Observación</th><%
										if LFO_Calif=1 then%>
											<th>Nota (Prom)</th><%
										end if										
										'if((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1)) then%>
											<th>Des/Hab</th><%
										'end if
										columnsDefsAsistencia = "[{""targets"": [ 8 ],""visible"": false,""searchable"": false},{""targets"": [ 9 ],""visible"": false,""searchable"": false},{""targets"": [ 10 ],""visible"": false,""searchable"": false}]"%>										
									</tr>
								</thead>
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer"><%
				'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nueva asistencia" id="btn_agregaasistencia" name="btn_agregaasistencia"><i class="fas fa-angle-up ml-1"></i></button>
					</div><%
				'end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">					
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->
	<!-- Formulario para desertar alumno -->
	<div class="modal fade in" id="modalDesertar" tabindex="-1" role="dialog" aria-labelledby="modalDesertarLabel" aria-hidden="true">
		<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
			<div class="modal-content">		
				<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
					<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-user-alt-slash"></i> Ingresa motivo de la deserción</div>				
				</div>
				<form role="form" action="" method="POST" name="frmDesertar" id="frmDesertar" class="needs-validation">
					<div class="modal-body">
						<div class="row">
							<div class="col-sm-12 col-md-6 col-lg-6">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-id-card input-prefix"></i>
										<input type="text" id="RutAlumno" name="RutAlumno" class="form-control rut" readonly required>
										<span class="select-bar"></span>
										<label for="RutAlumno" class="active">Rut</label>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form input-with-post-icon">
									<div class="error-message">
										<div class="select">
											<select name="CDE_InfoCausaId" id="CDE_InfoCausaId" class="validate select-text form-control" required>
												<option value="" disabled selected></option><%													
												set rs = cnn.Execute("exec spCausaDesercion_Listar -1")
												on error resume next					
												do While Not rs.eof%>
													<option value="<%=rs("CDE_InfoCausaId")%>"><%=rs("CDE_InfoCausaDesercion")%></option><%
													rs.movenext
												loop
												rs.Close%>
											</select>											
											<i class="fas fa-list-ol input-prefix"></i>
											<span class="select-highlight"></span>
											<span class="select-bar"></span>
											<label class="select-label <%=lblSelect%>">Causa de deserción</label>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form input-with-post-icon">
									<div class="error-message">
										<div class="select">
											<select name="RDE_InfoRazonId" id="RDE_InfoRazonId" class="validate select-text form-control" required>
												<option value="" disabled selected></option>
											</select>
											<i class="fas fa-list-ol input-prefix"></i>
											<span class="select-highlight"></span>
											<span class="select-bar"></span>
											<label class="select-label <%=lblSelect%>">Razón de la causa</label>
										</div>
									</div>
								</div>
							</div>							
						</div>
						<div class="row" id="obsdes">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="EST_InfoObservaciones" name="EST_InfoObservaciones" class="md-textarea form-control" rows="10"></textarea>
										<span class="select-bar"></span>
										<label for="EST_InfoObservaciones" class="active">Espedificar</label>									
									</div>
								</div>
							</div>
						</div>
					</div>				
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary btn-md waves-effect" id="btn_modalDesertarCerrar"><i class="fas fa-sign-out-alt"></i> Salir</button>
						<button type="button" class="btn btn-danger btn-md waves-effect" id="btn_modalDesertarCrear" name="btn_modalDesertarCrear"><i class="fas fa-times"></i> Desertar</button>
					</div>					
				</form>
			</div>
		</div>
	</div>
	<!-- Formulario para desertar alumno -->		
<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
				
		var asistenciaTable;
		var chkTotal=100;
		var asisobj;
		var alumno;
		var chkCount;	
				
		jQuery.fn.DataTable.Api.register( 'buttons.exportData()', function ( options ) {
            if ( this.context.length ) {
				var row = [];
                var jsonResult = $.ajax({
                    url:"/asistencia",
                    data: {search: $("#search").val(),start:0},
                    success: function (result) {
                        //Do nothing
                    },
                    async: false,
					type:"POST"
                });				
				$("#tbl-asistenciamodal").DataTable().columns().header().each(function(e,i){			
					row.push(e.innerText.replace(/(\r\n|\n|\r)/gm, ""))
				});								
				return {body: JSON.parse(jsonResult.responseText).data, header: row};
            }
        } );
		var buttonCommon = {
			exportOptions: {
				format: {
					body: function ( data, row, column, node ) {
						// Strip $ from salary column to make it numeric
						//nothing
					}
				}
			}
		};
		
		$("#asistenciaModal").on('show.bs.modal', function(e){					
			chkCount=0			
			asisobj={};
			alumno=[];
		})		
		$(".calendario").datepicker({
			beforeShow: function(input, inst) {
				$(document).off('focusin.bs.modal');
			},
			onClose:function(){
				$(document).on('focusin.bs.modal');
			},
		});
					
		function loadTableAsistencia(){			
			$(".loader_wrapper").remove()
			if($.fn.DataTable.isDataTable( "#tbl-asistenciamodal")){				
				if(asistenciaTable!=undefined){
					asistenciaTable.destroy();
				}else{
					$('#tbl-asistenciamodal').dataTable().fnClearTable();
    				$('#tbl-asistenciamodal').dataTable().fnDestroy();
				}								
			}
			asistenciaTable = $('#tbl-asistenciamodal').DataTable({
				lengthMenu: [ 10,15,20 ],
				processing: true,
        		serverSide: true,
				ajax:{
					url:"/asistencia",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				"columnDefs": <%=columnsDefsAsistencia%>,
				dom: 'lBfrtip',
            	buttons: [					
					$.extend( true, {}, buttonCommon, {
						extend: 'excelHtml5'
					} ),
					/*$.extend( true, {}, buttonCommon, {
						extend: 'pdfHtml5'
					} )*/
				],
			});	
		}				
		
		$("#modalDesertar").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
		})
		
		$("#modalDesertar").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
		})
		
		$("#asistenciaModal").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			
			$("body").addClass("modal-open");
			loadTableAsistencia();			
			exportTable();
		});				
		
		$("#asistenciaModal").on("click","#btn_frmaddasistencia",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var alumnos = Object.keys(asisobj);
			var sesiones = Object.values(asisobj)
			var event = e;
			var si = false;
			
			chkCount=0			
			asisobj={};
			alumno=[];
			
			$("#btn_frmaddasistencia").attr("disabled","disabled");
			$("#btn_frmaddasistencia").css("color","green");
			$("#btn_frmaddasistencia").css("cursor","not-allowed");
			$("#btn_frmaddasistencia i").removeClass("fa-plus");
			$("#btn_frmaddasistencia i").addClass("fa-sync-alt fa-spin");
			$(sesiones).each(function(i,e){
				si = true;
				var ALU_Rut = alumnos[i];				
				$(this).each(function(){
					var Asistio = Object.values($(this)[0])[0];
					var PLN_Sesion = Object.keys($(this)[0])[0].replace("id-","");					
					$.ajax({
						url: "/agregar-asistencia",
						method: 'POST',
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',ALU_Rut:ALU_Rut,Asistio:Asistio,PLN_Sesion:PLN_Sesion},
						dataType: "json",
						success: function (json) {							
							if(json.state==200){
								asistenciamodTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Asistencia agregada/Modificada exitosamente.'
								});
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Ingreso/Modificación Fallida',
									text:param[1]
								});
							}
						},
						complete: function(){
							$("#btn_frmaddasistencia").removeAttr("disabled");
							$("#btn_frmaddasistencia").css("color","white");
							$("#btn_frmaddasistencia").css("cursor","pointer");
							$("#btn_frmaddasistencia i").addClass("fa-plus");
							$("#btn_frmaddasistencia i").removeClass("fa-sync-alt fa-spin");
						}
					});
				})						
			});
			if(!si){
				$("#btn_frmaddasistencia").removeAttr("disabled");
				$("#btn_frmaddasistencia").css("color","white");
				$("#btn_frmaddasistencia").css("cursor","pointer");
				$("#btn_frmaddasistencia i").addClass("fa-plus");
				$("#btn_frmaddasistencia i").removeClass("fa-sync-alt fa-spin");				
			}
		})
		
		$("#asistenciaModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmAsistencia").css("height","0");			
			$("#btn_agregaasistencia").find('i').toggleClass('openmenu');			
			$('#container-table-asistencia').animate({
				height: $('#container-table-asistencia').get(0).scrollHeight
			}, 600, function(){
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
		
		$("#asistenciaModal").on("click","#btn_agregaasistencia",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			chkCount=0			
			asisobj={};
			alumno=[];
			
			$("#btn_frmaddasistencia").show();
			if($("#frmAsistencia").css("height")=="600px"){				
				$("#frmAsistencia").css("height","0");				
				$("#btn_agregaasistencia").find('i').toggleClass('openmenu');				
				$('#container-table-asistencia').animate({
					height: $('#container-table-asistencia').get(0).scrollHeight
				}, 600, function(){
					$(this).height('auto');
				});				
				asistenciamodTable.ajax.reload();
				asistenciaTable.ajax.reload();
			}else{								
				$("#frmAsistencia").css("height","600px");								
				$("#btn_agregaasistencia").find('i').toggleClass('openmenu');
				$("#container-table-asistencia").css("height","0");
				asistencia_grid(e);
			}						
		})
		
		$("#asistenciaModal").on("click","#btn_salirasistencia",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			asistenciaTable.ajax.reload();
			if($("#frmAsistencia").css("height")=="600px"){				
				$("#frmAsistencia").css("height","0");				
				$("#btn_agregaasistencia").find('i').toggleClass('openmenu');				
				$('#container-table-asistencia').animate({
					height: $('#container-table-asistencia').get(0).scrollHeight
				}, 600, function(){
					$(this).height('auto');					
				});				
			}			
		})		
		
		$("#asistenciaModal").on("change","[type=checkbox]",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();						
						
			var ALU_Rut = $(this).data("rut");
			var PLN_Sesion = $(this).data("sesion");
			
			var Asistio = 0;			
												
			if($(this).is(":checked")){
				Asistio = 1;
			}else{
				Asistio = 0;
			}

			var txtobj = '{"id-' + PLN_Sesion + '":' + Asistio + '}';				
			var existe = false;
			var eliminar = false;

			if(asisobj[ALU_Rut]==undefined){
				alumno = asisobj[ALU_Rut]=[];	
			}else{
				alumno = asisobj[ALU_Rut];
				var txtobj2 = "id-" + PLN_Sesion;
				$(alumno).each(function(e,i){
					if(i[txtobj2]!=undefined){
						/*existe = true;
						i[txtobj2] = Asistio;*/


						eliminar = true
						alumno.splice($.inArray(txtobj2,alumno),1);
						if(alumno.length==0){
							delete asisobj[ALU_Rut];							
						}
						chkCount=chkCount-1
						return false;
					}						
				})

			}
			if(!existe && !eliminar){				
				if(chkCount>=chkTotal){					
					if($(this).is(":checked")){
						$(this).prop('checked', false);
					}else{
						$(this).prop('checked', true);
					}			

					Toast.fire({
					  icon: 'error',
					  title: 'No es posible grabar mas de ' + chkTotal + ' asistencias!'
					});
				}else{
					chkCount=chkCount+1
					alumno.push(JSON.parse(txtobj));
				}
			}
						
		})
			
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
		var asistenciamodTable;
		function asistencia_grid(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			
			$("#frmAsistencia").append("<div class='loader_wrapper'><div class='loader'></div></div>");
			if($.fn.DataTable.isDataTable( "#tbl-asistenciamodal")){				
			
				if(asistenciamodTable!=undefined){
					asistenciamodTable.destroy();
				}else{
					$('#tbl-modasis').dataTable().fnClearTable();
    				$('#tbl-modasis').dataTable().fnDestroy();
				}								
			}
			asistenciamodTable = $('#tbl-modasis').DataTable({				
				processing: true,
        		serverSide: true,
				ajax:{
					url:"/asistencia-modal-grid",
					type:"POST",
					data:data,					
					complete: function(){
						$(".loader_wrapper").remove();
						$("#btnAsis").show("slow");
					}
				},				
				lengthMenu: [ 5,10,15 ],
				"scrollY": "300px",
				"scrollX": "600px",				
				"scrollCollapse": true,
				scrollXInner: '100%',
			    fixedColumns: {
					leftColumns: 5,
				 	//rightColumns: 1,
			   	},
				columnDefs: [
				{
					targets: 0,
					visible: false,
					render: function (data, type, row) {
						if (row[1].includes('Evidencia')) {
							return 0;
						}else {
							return 1;
						}
					},					
				},
				{
					targets: 'no-sort', 
					orderable: false
				}],
				orderFixed: [[0, 'asc']],
				order:[[1,'asc']],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					var estado = $(aData)[3];
					if(estado=="Desertado"){
						$(nRow).find("td").eq(2).css("background", "rgba(217, 83, 79, .3)");
					}
				}
			});													
		}
		
		$("#asistenciaModal").on("click",".aludes",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			$("#modalDesertar").modal("show");
			$("#RutAlumno").val($(this).data("rut").toString()+"-"+$(this).data("dv").toString());			
		});
		
		$("#modalDesertar").on('shown.bs.modal', function(){
			
		});
		
		$("#modalDesertar").on('hidden.bs.modal', function(){
			$("#RutAlumno").val();
		});
		
		$("#asistenciaModal").on("click",".aluhab",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var ALU_Rut = $(this).data("rut");
			var data = {PRY_Id:<%=PRY_Id%>,ALU_Rut:ALU_Rut,PRY_Identificador:'<%=PRY_Identificador%>'};			
			
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
				text: "Esta acción hará que el alumno rut: " + $(this).data("rut") + "-" + $(this).data("dv") + " deje de estar desertado",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, proceder!',
				 cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {						  	
					$.ajax({
						type: 'POST',			
						url: '/elimina-desercion',
						data: data,
						dataType: "json",
						success: function(data) {					
							if(data.state==200){								
								asistenciaTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Deserción eliminada exitosamente'
								});
							}else{
								swalWithBootstrapButtons.fire({
								  title: 'Error, no fué posible eliminar el estado de deserción para este alumno.',
								  text: data.message + "-" + data.data,
								  icon: 'error',							 
								})
							}
						}
					});	
				}
			});
		})
		
		$("#btn_modalDesertarCerrar").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();

			$("#modalDesertar").modal("hide")
			$("#frmDesertar")[0].reset();
		});
		
		$("#btn_modalDesertarCrear").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var rut=$("#RutAlumno").val().split("-")
			formValidate("#frmDesertar");
			if($("#frmDesertar").valid()){
				$.ajax({
					type: 'POST',			
					url: '/graba-desercion',
					data: {PRY_Id:<%=PRY_Id%>,ALU_Rut:rut[0],RDE_InfoRazonId:$("#RDE_InfoRazonId").val(),EST_InfoObservaciones:$("#EST_InfoObservaciones").val()},
					dataType: "json",
					success: function(data) {					
						if(data.state==200){
							if(asistenciaTable==undefined){
								loadTableAsistencia()
							}else{
								asistenciaTable.ajax.reload();
							}							
							Toast.fire({
							  icon: 'success',
							  title: 'Deserción grabada exitosamente'
							});
						}else{
							swalWithBootstrapButtons.fire({
							  title: 'Error, no fué posible crear el estado de deserción para este alumno.',
							  text: data.message + "-" + data.data,
							  icon: 'error',							 
							})
						}
					}
				});				
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los errores antes de grabar la deserción.'
				});
			}

		});						
		
		$("#CDE_InfoCausaId").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("#obsdes").removeClass("show");
			$("#EST_InfoObservaciones").removeAttr("required");
				
			var CDE_InfoCausaId = $(this).val();    	
			$.ajax({
				type: 'POST',			
				url: '/seleccionar-razones',
				data: {CDE_InfoCausaId:CDE_InfoCausaId},
				success: function(data) {					
					$('#RDE_InfoRazonId').html(data);
					setInterval(blink('#RDE_InfoRazonId'), 2200);								
				}
			});
		})
		
		$("#RDE_InfoRazonId").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if($("#RDE_InfoRazonId option:selected").text()=="Especificar"){
				$("#obsdes").addClass("show");
				$("#EST_InfoObservaciones").attr("required","required");
			}else{
				$("#obsdes").removeClass("show");
				$("#EST_InfoObservaciones").removeAttr("required");
			}			
		})
		
		$("#frmaddasistencia").on("click",".delete",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var INF_Arc=$(this).data("arc");
			var PLN_Sesion=$(this).data("sesion")
			var PRY_Hito=95;	
			var id= $(this).parent()[0].id;
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "¿Deseas eliminar el archivo adjunto para este curso?",
			  icon: 'warning',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					data={PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PLN_Sesion:PLN_Sesion};
					$.ajax({
						type: 'POST',		
						url: '/eliminar-evidencia-asistencia',
						data: data,
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
							
								$.ajax({
									url: "/consultar-evidencia-asistencia",
									method: 'POST',					
									data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PLN_Sesion:PLN_Sesion,mode:'<%=mode%>'},
									dataType: "json",
									success: function (data) {											
										$("#" + id).html(data.data[0])											
									}
								})
							
								Toast.fire({								
								  icon: 'success',
								  title: 'Evidencia eliminada correctamente.'
								});
								asistencia_grid(e);
								$("#dwn_evi-" + PLN_Sesion).css("cursor","not-allowed");
								$("#dwn_evi-" + PLN_Sesion).css("color","#aaa");

								$("#del_evi-" + PLN_Sesion).css("cursor","not-allowed");
								$("#del_evi-" + PLN_Sesion).css("color","#aaa");

								$("#upd_evi-" + PLN_Sesion).css("cursor","pointer");
								$("#upd_evi-" + PLN_Sesion).css("color","blue");																

								$("#downloadevi-" + PLN_Sesion).attr("href","");																
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Elimiancion Fallida',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Subida Fallido',
								text:data.message
							});
						}																											
					})
				
			  	}
			})
		})
		
		$("#frmaddasistencia").on("click",".download",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var INF_Arc=$(this).data("arc");
			var PLN_Sesion=$(this).data("sesion")
			var PRY_Hito=95;			
			
			var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, PLN_Sesion:PLN_Sesion};			
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
		
		$("#frmaddasistencia").on("click",".upload",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();						
			
			var MOD_Id 		= $(this).data("modulo") 
			var PLN_Sesion 	= $(this).data("sesion")
			var id			= $(this).parent()[0].id;
			var progressBar = $($(this).parent()).find(".progress-bar")
			var progress = $($(this).parent()).find(".progress")
			var element = $(this)
			
			swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Selecciona un archivo',
				showCancelButton: true,
				confirmButtonText: 'Subir',
				cancelButtonText: 'Cancelar',
				input: 'file',
				onBeforeOpen: () => {
					$(".swal2-file").attr("accept",'image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.wordprocessingml.document,,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint')
					$(".swal2-file").change(function () {
						var reader = new FileReader();
						reader.readAsDataURL(this.files[0]);
					});
				}
			}).then((file) => {
				if (file.value) {																
					var formData = new FormData();
					var file = $('.swal2-file')[0].files[0];
					var fileName = file.name;
					var extFile = fileName.split('.').pop();
					var sizerror=false;										
					
					if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){										
					
						formData.append("fileToUpload", file);
						formData.append("PLN_Sesion", PLN_Sesion);
						formData.append("PRY_Id", <%=PRY_Id%>);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');						
						if(parseInt(file.size)>parseInt(maxupload[maxsize].size)){
							sizerror=true;							
						}						
						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								xhr: function() {
									var xhr = new window.XMLHttpRequest();								
									xhr.upload.addEventListener("progress", ({loaded, total}) =>{
										let fileLoaded = Math.floor((loaded / total) * 100);
										let fileTotal = Math.floor(total / 1000);
										let fileSize;
										(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upload");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-evidencia-asistencia",
								method: 'POST',					
								data:formData,
								enctype: 'multipart/form-data',
								cache: false,
								contentType: false,
								processData: false,
								dataType: "json",
								success: function (data) {							
									if(data.state==200){								
										$.ajax({
											url: "/consultar-evidencia-asistencia",
											method: 'POST',					
											data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PLN_Sesion:PLN_Sesion,mode:'<%=mode%>'},
											dataType: "json",
											success: function (data) {											
												$("#" + id).html(data.data[0])											
											}
										})
									
										Toast.fire({
										icon: 'success',
										title: 'Evidencia subida correctamente.'
										});									
										asistencia_grid(e);
									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Subida Fallido',
											text:data.message
										});
									}
								},
								error: function(){
									swalWithBootstrapButtons.fire({
										icon:'error',
										title:'Subida Fallido',
										text:data.message
									});
								}
							});							
						}
					}else{
						Toast.fire({
						  icon: 'error',
						  title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})
		
		
		$("body").append("<button id='btn_modalasistencia' name='btn_modalasistencia' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalasistencia").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#asistenciaModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalasistencia").click();		
		$("#btn_modalasistencia").remove();				
	})
</script>