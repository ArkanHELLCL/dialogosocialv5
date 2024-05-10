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
						<form role="form" action="" method="POST" name="frmaddasistencia" id="frmaddasistencia" class="needs-validation">

						
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
							<table id="tbl-asistencia" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="asistencia" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
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
				if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nueva asistencia" id="btn_agregaasistencia" name="btn_agregaasistencia"><i class="fas fa-angle-up ml-1"></i></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="asistencia"><i class="fas fa-download ml-1"></i></button>
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
		$("#asistenciaModal").on('show.bs.modal', function(e){					
			
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
			if($.fn.DataTable.isDataTable( "#tbl-asistencia")){				
				if(asistenciaTable!=undefined){
					asistenciaTable.destroy();
				}else{
					$('#tbl-asistencia').dataTable().fnClearTable();
    				$('#tbl-asistencia').dataTable().fnDestroy();
				}								
			}
			asistenciaTable = $('#tbl-asistencia').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/asistencia",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				"columnDefs": <%=columnsDefsAsistencia%>
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
			
			$(sesiones).each(function(i,e){				
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
								asistencia_grid(event);
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
						}
					});
				})						
			})
				
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
			$("#btn_frmaddasistencia").show();
			if($("#frmAsistencia").css("height")=="600px"){				
				$("#frmAsistencia").css("height","0");				
				$("#btn_agregaasistencia").find('i').toggleClass('openmenu');				
				$('#container-table-asistencia').animate({
					height: $('#container-table-asistencia').get(0).scrollHeight
				}, 600, function(){
					$(this).height('auto');
				});				
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
		var asisobj={};
		var alumno=[];
		$("#asistenciaModal").on("change","[type=checkbox]",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var ALU_Rut = $(this).parent().parent().parent().data("rut");
			var PLN_Sesion = $(this).parent().parent().parent().data("sesion");			
			var Asistio = 0;
			
			if($(this).is(":checked")){
				Asistio = 1;
			}else{
				Asistio = 0;
			}
			$(this).parent().parent().siblings("span").html("Si")				
			var txtobj = '{"id-' + PLN_Sesion + '":' + Asistio + '}';				
			var existe = false;

			if(asisobj[ALU_Rut]==undefined){
				alumno = asisobj[ALU_Rut]=[];	
			}else{
				alumno = asisobj[ALU_Rut];
				var txtobj2 = "id-" + PLN_Sesion;
				$(alumno).each(function(e,i){
					if(i[txtobj2]!=undefined){
						existe = true;
						i[txtobj2] = Asistio;							
						return false;
					}
				})												
			}
			if(!existe){
				alumno.push(JSON.parse(txtobj));																																
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
		
		function asistencia_grid(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#frmAsistencia").append("<div class='loader_wrapper'><div class='loader'></div></div>");
			$.ajax( {
				type:'POST',					
				url: '/asistencia-modal-grid',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmaddasistencia").html(param[1]);																		
						if($.fn.DataTable.isDataTable( "#tbl-modasis")){							
							$('#tbl-modasis').dataTable().fnClearTable();
    						$('#tbl-modasis').dataTable().fnDestroy();
						}					
						modasisTable = $('#tbl-modasis').DataTable({
							lengthMenu: [ 5,10,15 ],
							"scrollY": "300px",
							"scrollX": "600px",
							"scrollCollapse": true,
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
								}
							}],
							orderFixed: [[0, 'asc']],
							order:[[1,'asc']]
						});						
					}
				},
				complete: function(){
					$(".loader_wrapper").remove();
				}
			})
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
								
								/*$("#ArcTot").html((parseInt($("#TotArc").val(),10)-1).toString() + "/" + $("#TotSes").val().toString());*/

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
			
			var MOD_Id = $(this).data("modulo") 
			var PLN_Sesion = $(this).data("sesion")									
			
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
					
					if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){										
					
						formData.append("fileToUpload", file);
						formData.append("PLN_Sesion", PLN_Sesion);
						formData.append("PRY_Id", <%=PRY_Id%>);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

						$.ajax({
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
									Toast.fire({
									  icon: 'success',
									  title: 'Evidencia subida correctamente.'
									});
									asistencia_grid(e)
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