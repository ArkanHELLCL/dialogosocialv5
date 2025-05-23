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
	if(xm="visualizar") or (session("ds5_usrperfil")=4) then
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
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
	end if
	columnsDefsAlumnos="[]"
	response.write("200\\#alumnosModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-address-card"></i> Alumnos</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">																				
				<div id="frmAlumno" class="px-4">

					
				</div>
				<!--div frmAlumno-->
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-alumnos">
							<!--Table-->
							<table id="tbl-alumnos" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="alumnos" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>	
									<tr>
										<th>RUT</th>
										<th>RUT-DV</th>
										<th>DV</th>
										<th>Nombres</th>
										<th>Paterno</th>
										<th>Materno</th>
										<th>Nacionalidad</th>
										<th>Sexo</th>
										<th>Email</th>
										<th>Empresa</th>
										<th>Ingreso</th>
										<th>Estado</th>										
										<th>Acciones</th>
										
										<th>Fecha Nacimeinto</th>
										<th>Edad</th>
										<th>Cargo Directivo</th>
										<th>Tiene Discapacidad?</th>
										<th>Tipo de Discapcidad</th>
										<th>Reconoce Pueblo Originario?</th>
										<th>Pueblo Originario</th>
										<th>Tipo de Trabajador</th>
										<th>Dirigente Sindical?</th>
										<th>Fecha Dirigente</th>
										<th>Acceso a Internet?</th>
										<th>Dispositivo Electrónico?</th>
										
										<th>Región</th>
										<th>Comuna</th>
										<th>Dirección</th>
										<th>Teléfono</th>
										<th>Rubro</th>
										<th>Nivel Educacional</th>
										<th>Pertenece a Sindicato</th>
										<th>Nombre de Organización</th>
										<th>RSU</th>
										<th>Fecha de Ingreso</th>
										<th>Permiso de Capacitacion</th>
										<th>Nombre Cargo Directivo</th>
										<th>Fecha de Inicio Cargo Directivo</th>
										<th>Cursos Sindicales Anteriores</th>
										<th>Año del curso anterior</th>
										<th>Institución del curso</th>
									</tr>
								</thead>									
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer"><%
				'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then
				if (PRY_InformeFinalEstado=0 and PRY_Estado=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nuevo alumno" id="btn_agregaalumno" name="btn_agregaalumno"><i class="fas fa-angle-up ml-1"></i></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="alumnos"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->

<script>	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
				
		var alumnosTable;
		var tablaAlumnosAlto;
		var disabled={}
		$("#alumnosModal").on('show.bs.modal', function(e){					
			
		})		
		$(".calendario").datepicker({
			beforeShow: function(input, inst) {
				$(document).off('focusin.bs.modal');
			},
			onClose:function(){
				$(document).on('focusin.bs.modal');
			},
		});
					
		function loadTableAlumnos(){			
			if($.fn.DataTable.isDataTable( "#tbl-alumnos")){				
				if(alumnosTable!=undefined){
					alumnosTable.destroy();
				}else{
					$('#tbl-alumnos').dataTable().fnClearTable();
    				$('#tbl-alumnos').dataTable().fnDestroy();
				}
			}
			alumnosTable = $('#tbl-alumnos').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/alumnos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				columnDefs: [{"targets": [ 1,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40 ],"visible": false,"searchable": false}],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					$("td:not(:last)",nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();
						
						$("td:first",nRow).find("div").remove();						
						var ALU_Rut = $("td:first",nRow).html().replace("-","");
						muestramodalalumno(e);
						$("#frmAlumno").one("webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend",function(e) {						
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
						
							if($(e.target).attr("id")=="frmAlumno"){
								$("#ALU_Rut").val(ALU_Rut);
								$("#ALU_Rut").siblings("label").addClass("active");
								$("#ALU_Rut").Rut();
								cargadatosalumno(ALU_Rut,<%=modo%>);
							}
						})    						
					})
				},
				order:[1,"desc"],
				stateSave: true
			});	
		}				
		
		$("#alumnosModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").addClass("modal-open");
			loadTableAlumnos();			
			
			exportTable();
		});				
		var target="/agregar-alumno"
		$("#alumnosModal").on("click","#btn_frmaddalumnos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frmalumnotab1");
			formValidate("#frmalumnotab2");
			formValidate("#frmalumnotab3");
			var frm1=false;
			var frm2=false;
			var frm3=false;
			if($("#frmalumnotab1").valid()){
				frm1=true;
			}
			if($("#frmalumnotab2").valid()){
				frm2=true;
			}
			if($("#frmalumnotab3").valid()){
				frm3=true;
			}
			if(frm1 && frm2 && frm3){				
				var ALU_Rut = $("#ALU_Rut").val().replace(/[($)\s\._\-]+/g, '');
				
				var data1 = $("#frmalumnotab1").serializeArray();
				var data2 = $("#frmalumnotab2").serializeArray();
				var data3 = $("#frmalumnotab3").serializeArray();
				var sizerror=false;

				var formdata = new FormData();							
				var file_data = $('#ALU_Ficha').prop('files');				
				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i]);
					if(file_data[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					};
				}
								
				$.each(data1, function(i, field) { 
                   formdata.append(field.name,field.value);
                }); 
				$.each(data2, function(i, field) { 
                    formdata.append(field.name,field.value);
                }); 
				$.each(data3, function(i, field) { 
                   formdata.append(field.name,field.value);
                }); 				
				formdata.append("Rut",ALU_Rut);
				if(sizerror){					
					$("#ALU_FichaX").removeClass("is-valid");
					$("#ALU_FichaX").addClass("is-invalid");
					$("#ALU_FichaX").siblings('.select-bar').removeClass("is-valid");
					$("#ALU_FichaX").siblings('.select-bar').addClass("is-invalid");
					$("#ALU_FichaX").parent().after('<div id="ALU_FichaX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
					Toast.fire({
						icon: 'error',
						title: maxupload[maxsize]['msg-toast']
					});
				}else{
					$.ajax({
						url: target,
						method: 'POST',					
						data:formdata,
						enctype: 'multipart/form-data',
						cache: false,
						contentType: false,
						processData: false,
						success: function (data) {
							param=data.split(bb);
							if(param[0]==200){																					
								if(param[1]==""){
									$("#frmalumnotab1")[0].reset();
									$("#frmalumnotab2")[0].reset();
									$("#frmalumnotab3")[0].reset();
																
									$("#ALU_AccesoInternet").removeAttr("checked");
									$("#ALU_DispositivoElectronico").removeAttr("checked");							
													
									$("#ALU_Discapacidad").removeAttr("checked");
									$(".discapacidad").find("select").remove();
									$("#TDI_id-error").remove();
									$(".discapacidad").slideUp("slow");
														
									$("#ALU_ReconocePuebloOriginario").removeAttr("checked");
									$("#PuebloOriginario").find("input").remove();
									$("#ALU_PuebloOriginario-error").remove();
									$("#PuebloOriginario").slideUp("slow");
									
									
									$("#ALU_PerteneceSindicato").removeAttr("checked");
									$("#sin1").find("input").remove();
									$("#sin2").find("input").remove();
									$("#sin3").find("input").remove();
									$("#ALU_FechaIngreso-error").remove();
									$("#ALU_NombreOrganizacion-error").remove();
									$("#ALU_RSU-error").remove();
									$(".sindicato").slideUp("slow")
																
									$("#ALU_PermisoCapacitacionEnOrganizacion").removeAttr("checked");
									
									$("#ALU_DirigenteSindical").removeAttr("checked");
									$(".dirigente").find("input").remove();
									$("#ALU_TiempoDirigenteSindical-error").remove();
									$(".dirigente").slideUp("slow");

									$("#ALU_CursosFormacionSindicalAnteriormente").removeAttr("checked");
									$("#cur1").find("input").remove();
									$("#cur2").find("input").remove();
									$("#ALU_InstitucionCursoFormacionSindical-error").remove();
									$("#ALU_AnioCursoFormacionSindical-error").remove();
									$(".curso").slideUp("slow");

									$("#ALU_CargoDirectivoEnOrganizacion").removeAttr("checked");
									$("#car1").find("input").remove();
									$("#car2").find("input").remove();
									$("#ALU_FechaInicioCargoDirectivo-error").remove();
									$("#ALU_NombreCargoDirectivo-error").remove();
									$(".cargo").slideUp("slow");

									Toast.fire({
									icon: 'success',
									title: 'Alumno agregado exitosamente.'
									});
								}else{
									swalWithBootstrapButtons.fire({
										icon:'info',
										title:'Actualización',
										text:param[1]
									});
								}
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Ingreso Fallido',
									text:param[1]
								});
							}
						}
					});			
				}
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los campos con error antes de guardar'
				});
			}
		})
		
		$("#alumnosModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmAlumno").css("height","0");			
			$("#btn_agregaalumno").find('i').toggleClass('openmenu');			
			$('#container-table-alumnos').animate({
				height: $('#container-table-alumnos').get(0).scrollHeight
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
		
		function muestramodalalumno(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			alumnos_tabs(e);
			alumnosTable.ajax.reload(null, false);
			$("#btn_frmaddalumnos").show();
			if($("#frmAlumno").css("height")=="500px"){				
				$("#frmAlumno").css("height","0");				
				$("#btn_agregaalumno").find('i').toggleClass('openmenu');				
				$('#container-table-alumnos').animate({
					height: $('#container-table-alumnos').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmAlumno").css("height","500px");								
				$("#btn_agregaalumno").find('i').toggleClass('openmenu');
				$("#container-table-alumnos").css("height","0");				
			}
		}
		
		$("#alumnosModal").on("click","#btn_agregaalumno",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			
			muestramodalalumno(e);
			alumnosTable.ajax.reload(null, false);
		})
		
		$("#alumnosModal").on("click","#btn_saliralumnos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			alumnosTable.ajax.reload(null, false);
			
			$("#frmalumnotab1, #frmalumnotab2, #frmalumnotab3").find(":input").each(function(){
				/*if(disabled[$(this).attr("id")]=="disabled"){				
					$(this).attr(disabled,"disabled");
				}else{
					$(this).removeAttr(disabled);
				}
				disabled={}				*/
			});
			if($("#frmAlumno").css("height")=="500px"){				
				$("#frmAlumno").css("height","0");				
				$("#btn_agregaalumno").find('i').toggleClass('openmenu');				
				$('#container-table-alumnos').animate({
					height: $('#container-table-alumnos').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})	
						
		$("#alumnosModal").on("click",".arcalm",function(e){
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
		});
		
		function cargadatosalumno(ALU_Rut, modo){
			var readonly
			var disabled
			if(modo=="vis"){
				readonly="readonly"
				disabled="disabled"				
			}else{
				$("input").removeAttr("disabled, readonly")
				$("#btn_frmaddalumnos").removeAttr("disabled")
			}
			$.ajax({
				type: 'POST',
				url: '/consultar-alumno',
				data: {PRY_Id:<%=PRY_Id%>,ALU_Rut:ALU_Rut},
				dataType: "json",										
				success: function(json) {
					if($(json.data).length>0){
						if($(json.data)[0][41]==1 || ($(json.data)[0][42]==1)) {
							readonly="readonly"
							disabled="disabled"
							modo="vis"
						}
						if($(json.data)[0][41]!=1 && $(json.data)[0][42]!=1){
							$('[data-toggle="tooltip"]').tooltip({
								trigger : 'hover'
							})
							$('[data-toggle="tooltip"]').on('click', function () {
								$(this).tooltip('hide')
							});

							$("#frmalumnotab1")[0].reset();
							$("#frmalumnotab2")[0].reset();
							$("#frmalumnotab3")[0].reset();											

							$("#btn_frmaddalumnos").removeClass("btn-success");
							$("#btn_frmaddalumnos").addClass("btn-warning");
							$("#btn_frmaddalumnos").html("<i class='fas fa-edit'></i> Modificar");
							target="/modificar-alumno"

							$("#ALU_FichaX").removeAttr("required");

							$("#ALU_Rut").val($(json.data)[0][0]);
							$("#ALU_Rut").siblings("label").addClass("active");
							$("#ALU_Rut").Rut();
							$("#ALU_Rut").attr("readonly","readonly");
							
							$("#ALU_Nombre").val($(json.data)[0][1]);
							$("#ALU_Nombre").siblings("label").addClass("active");
							$("#ALU_Nombre").attr(readonly,readonly);
							
							$("#ALU_ApellidoPaterno").val($(json.data)[0][2]);
							$("#ALU_ApellidoPaterno").siblings("label").addClass("active");
							$("#ALU_ApellidoPaterno").attr(readonly,readonly);
							
							$("#ALU_ApellidoMaterno").val($(json.data)[0][3]);
							$("#ALU_ApellidoMaterno").siblings("label").addClass("active");
							$("#ALU_ApellidoMaterno").attr(readonly,readonly);
							
							$("#ALU_FechaNacimiento").val($(json.data)[0][4]);
							$("#ALU_FechaNacimiento").siblings("label").addClass("active");
							$("#ALU_FechaNacimiento").attr(disabled,disabled);

							dob = new Date($("#ALU_FechaNacimiento").val());
							var today = new Date();
							var age = Math.floor((today-dob) / (365.25 * 24 * 60 * 60 * 1000));

							$("#ALU_Edad").val(age);
							$("#ALU_Edad").siblings("label").addClass("active");
							$('#NAC_Id option[value="' + $(json.data)[0][6] + '"]').prop("selected", true);	
							$("#NAC_Id").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#NAC_Id").siblings("label").addClass("active");
							}
							$('#SEX_Id option[value="' + $(json.data)[0][8] + '"]').prop("selected", true);
							$("#SEX_Id").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#SEX_Id").siblings("label").addClass("active");
							}
							$('#EDU_Id option[value="' + $(json.data)[0][9] + '"]').prop("selected", true);
							$("#EDU_Id").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#EDU_Id").siblings("label").addClass("active");
							}
							if($(json.data)[0][10]==1){
								$("#ALU_Discapacidad").attr("checked","checked");
								$(".discapacidad").find("select").remove();
								$.ajax({
									url: "/listar-tipo-discapacidad",
									method: 'POST',						
									success: function (data) {
										param=data.split(bb);
										if(param[0]==200){
											$(".discapacidad").find("i").after(param[1]);
											$('#TDI_Id option[value="' + $(json.data)[0][11] + '"]').prop("selected", true);
											$(".discapacidad").slideDown("slow");
										}
									}
								});
							}else{
								$("#ALU_Discapacidad").removeAttr("checked");
								$(".discapacidad").find("select").remove();
								$("#TDI_id-error").remove();
								$(".discapacidad").slideUp("slow");
							}
							$("#ALU_Discapacidad").attr(disabled,disabled);
							
							$("#ALU_FechaCreacionRegistro").val($(json.data)[0][12]);
							$("#ALU_FechaCreacionRegistro").siblings("label").addClass("active");							
							if($(json.data)[0][13]==1){
								$("#ALU_AccesoInternet").attr("checked","checked");
							}else{
								$("#ALU_AccesoInternet").removeAttr("checked");
							}
							$("#ALU_AccesoInternet").attr(disabled,disabled);
							
							if($(json.data)[0][14]==1){
								$("#ALU_DispositivoElectronico").attr("checked","checked");
							}else{
								$("#ALU_DispositivoElectronico").removeAttr("checked");
							}
							$("#ALU_DispositivoElectronico").attr(disabled,disabled);
							
							if($(json.data)[0][15]==1){
								$("#ALU_ReconocePuebloOriginario").attr("checked","checked");
								$("#PuebloOriginario").find("i").after('<input type="text" id="ALU_PuebloOriginario" name="ALU_PuebloOriginario" class="form-control" required>')
								$("#ALU_PuebloOriginario").val($(json.data)[0][16]);
								$("#ALU_PuebloOriginario").siblings("label").addClass("active");												
								$("#PuebloOriginario").slideDown("slow");	
							}else{
								$("#ALU_ReconocePuebloOriginario").removeAttr("checked");
								$("#PuebloOriginario").find("input").remove();
								$("#ALU_PuebloOriginario-error").remove();
								$("#PuebloOriginario").slideUp("slow");
							}																				
							$("#ALU_ReconocePuebloOriginario").attr(disabled,disabled);
							$("#ALU_PuebloOriginario").attr(disabled,disabled);
							$("#ALU_FichaX").attr(disabled,disabled);
							
							
							/*tab ubicacion*/
							$('#REG_IdAlu option[value="' + $(json.data)[0][20] + '"]').prop("selected", true);
							$("#REG_IdAlu").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#REG_IdAlu").siblings("label").addClass("active");
							}
							
							var region = $(json.data)[0][20];    	
							$.ajax({
								type: 'POST',			
								url: '/seleccionar-comunas',
								data: {REG_Id:region},
								success: function(data) {					
									$('#COM_IdAlu').html(data);
									setInterval(blink('#COM_IdAlu'), 2200);
									$('#COM_IdAlu option[value="' + $(json.data)[0][21] + '"]').prop("selected", true);
									$("#COM_IdAlu").attr(disabled,disabled);
									if(disabled=="disabled"){								
										$("#COM_IdAlu").siblings("label").addClass("active");
									}
								}
							});	
							
							$("#ALU_Direccion").val($(json.data)[0][22]);
							$("#ALU_Direccion").siblings("label").addClass("active");
							$("#ALU_Direccion").attr(readonly,readonly);
							
							$("#ALU_Mail").val($(json.data)[0][23]);
							$("#ALU_Mail").siblings("label").addClass("active");
							$("#ALU_Mail").attr(readonly,readonly);
							
							$("#ALU_Telefono").val($(json.data)[0][24]);
							$("#ALU_Telefono").siblings("label").addClass("active");
							$("#ALU_Telefono").attr(readonly,readonly);
							
							$('#TTR_Id option[value="' + $(json.data)[0][25] + '"]').prop("selected", true);
							$("#TTR_Id").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#TTR_Id").siblings("label").addClass("active");
							}
							
							$("#ALU_NombreEmpresa").val($(json.data)[0][26]);
							$("#ALU_NombreEmpresa").siblings("label").addClass("active");
							$("#ALU_NombreEmpresa").attr(readonly,readonly);
														
							$('#RUB_Id option[value="' + $(json.data)[0][27] + '"]').prop("selected", true);
							$("#RUB_Id").attr(disabled,disabled);							
							if(disabled=="disabled"){								
								$("#RUB_Id").siblings("label").addClass("active");
							}
							
							/*tab sindicales*/										
							if($(json.data)[0][28]==1){
								$("#ALU_PerteneceSindicato").attr("checked","checked");								
								$("#sin1").find("i").after('<input type="text" id="ALU_FechaIngreso" name="ALU_FechaIngreso" class="form-control calendario" required readonly>')
								$("#sin2").find("i").after('<input type="text" id="ALU_NombreOrganizacion" name="ALU_NombreOrganizacion" class="form-control" required>')
								$("#sin3").find("i").after('<input type="text" id="ALU_RSU" name="ALU_RSU" class="form-control" required>')								
								
								$(".sindicato").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
								$("#ALU_FechaIngreso").val($(json.data)[0][29]);
								$("#ALU_FechaIngreso").siblings("label").addClass("active");								
								
								$("#ALU_NombreOrganizacion").val($(json.data)[0][30]);
								$("#ALU_NombreOrganizacion").siblings("label").addClass("active");								
								
								$("#ALU_RSU").val($(json.data)[0][31]);
								$("#ALU_RSU").siblings("label").addClass("active");								
							}else{
								$("#ALU_PerteneceSindicato").removeAttr("checked");
								$("#sin1").find("input").remove();
								$("#sin2").find("input").remove();
								$("#sin3").find("input").remove();
								$("#ALU_FechaIngreso-error").remove();
								$("#ALU_NombreOrganizacion-error").remove();
								$("#ALU_RSU-error").remove();
								$(".sindicato").slideUp("slow");
							}	
							$("#ALU_PerteneceSindicato").attr(disabled,disabled);
							$("#ALU_FechaIngreso").attr(disabled,disabled);
							$("#ALU_NombreOrganizacion").attr(readonly,readonly);
							$("#ALU_RSU").attr(readonly,readonly);
							
							if($(json.data)[0][32]==1){
								$("#ALU_PermisoCapacitacionEnOrganizacion").attr("checked","checked");
							}else{
								$("#ALU_PermisoCapacitacionEnOrganizacion").removeAttr("checked");
							}				
							$("#ALU_PermisoCapacitacionEnOrganizacion").attr(disabled,disabled);
							
							if($(json.data)[0][33]==1){
								$("#ALU_DirigenteSindical").attr("checked","checked");
								$(".dirigente").find("i").after('<input type="text" id="ALU_TiempoDirigenteSindical" name="ALU_TiempoDirigenteSindical" class="form-control calendario" required readonly>')
								$(".dirigente").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
								$("#ALU_TiempoDirigenteSindical").val($(json.data)[0][34]);
								$("#ALU_TiempoDirigenteSindical").siblings("label").addClass("active");
							}else{
								$("#ALU_DirigenteSindical").removeAttr("checked");
								$(".dirigente").find("input").remove();
								$("#ALU_TiempoDirigenteSindical-error").remove();
								$(".dirigente").slideUp("slow");
							}
							$("#ALU_DirigenteSindical").attr(disabled,disabled);
							$("#ALU_TiempoDirigenteSindical").attr(disabled,disabled);
							
							if($(json.data)[0][35]==1){
								$("#ALU_CursosFormacionSindicalAnteriormente").attr("checked","checked");
								$("#cur1").find("i").after('<input type="text" id="ALU_InstitucionCursoFormacionSindical" name="ALU_InstitucionCursoFormacionSindical" class="form-control" required>')
								$("#cur2").find("i").after('<input type="number" id="ALU_AnioCursoFormacionSindical" name="ALU_AnioCursoFormacionSindical" class="form-control" required>')
								$(".curso").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});

								$("#ALU_InstitucionCursoFormacionSindical").val($(json.data)[0][36]);
								$("#ALU_InstitucionCursoFormacionSindical").siblings("label").addClass("active");
								$("#ALU_AnioCursoFormacionSindical").val($(json.data)[0][37]);
								$("#ALU_AnioCursoFormacionSindical").siblings("label").addClass("active");
							}else{
								$("#ALU_CursosFormacionSindicalAnteriormente").removeAttr("checked");
								$("#cur1").find("input").remove();
								$("#cur2").find("input").remove();
								$("#ALU_InstitucionCursoFormacionSindical-error").remove();
								$("#ALU_AnioCursoFormacionSindical-error").remove();
								$(".curso").slideUp("slow");
							}	
							$("#ALU_CursosFormacionSindicalAnteriormente").attr(disabled,disabled);
							$("#ALU_InstitucionCursoFormacionSindical").attr(readonly,readonly);
							$("#ALU_AnioCursoFormacionSindical").attr(readonly,readonly);
							
							
							if($(json.data)[0][38]==1){
								$("#ALU_CargoDirectivoEnOrganizacion").attr("checked","checked");
								$("#car1").find("i").after('<input type="text" id="ALU_FechaInicioCargoDirectivo" name="ALU_FechaInicioCargoDirectivo" class="form-control calendario" required readonly>')
								$("#car2").find("i").after('<input type="text" id="ALU_NombreCargoDirectivo" name="ALU_NombreCargoDirectivo" class="form-control" required>')
								$(".cargo").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});

								$("#ALU_FechaInicioCargoDirectivo").val($(json.data)[0][39]);
								$("#ALU_FechaInicioCargoDirectivo").siblings("label").addClass("active");
								$("#ALU_NombreCargoDirectivo").val($(json.data)[0][40]);
								$("#ALU_NombreCargoDirectivo").siblings("label").addClass("active");

							}else{
								$("#ALU_CargoDirectivoEnOrganizacion").removeAttr("checked");
								$("#car1").find("input").remove();
								$("#car2").find("input").remove();
								$("#ALU_FechaInicioCargoDirectivo-error").remove();
								$("#ALU_NombreCargoDirectivo-error").remove();
								$(".cargo").slideUp("slow");											
							}
							$("#ALU_CargoDirectivoEnOrganizacion").attr(disabled,disabled);
							$("#ALU_FechaInicioCargoDirectivo").attr(disabled,disabled);
							$("#ALU_NombreCargoDirectivo").attr(readonly,readonly);
														
						}else{
							if($(json.data)[0][41]==1){
								$("#ALU_Rut").val("");
								$("#frmalumnotab1")[0].reset();								
								$("#frmalumnotab2")[0].reset();
								$("#frmalumnotab3")[0].reset();
								
								swalWithBootstrapButtons.fire({
								icon: 'error',
								title: 'Oops...',
								text: 'El alumno que estas tratando de agregar ya pertenece a otro proyecto de la misma línea',								  
								}).then((result) => {									
								});		
							}else{
								if($(json.data)[0][42]==1){
									$("#ALU_Rut").val("");
									$("#frmalumnotab1")[0].reset();								
									$("#frmalumnotab2")[0].reset();
									$("#frmalumnotab3")[0].reset();
									
									swalWithBootstrapButtons.fire({
									icon: 'error',
									title: 'Oops...',
									text: 'El alumno que estas tratando de agregar ya particpó en un proyecto similar el 2023',								  
									}).then((result) => {									
									});		
								}else{
									if($(json.data)[0][41]==4){
										$("#ALU_Rut").val("");
										$("#frmalumnotab1")[0].reset();								
										$("#frmalumnotab2")[0].reset();
										$("#frmalumnotab3")[0].reset();
										
										swalWithBootstrapButtons.fire({
										icon: 'error',
										title: 'Oops...',
										text: 'El alumno ya cursó este proyecto en años anteriores',								  
										}).then((result) => {									
										});		
									}
								}
							}							
						}
					}else{
						$("#btn_frmaddalumnos").addClass("btn-success");
						$("#btn_frmaddalumnos").removeClass("btn-warning");
						$("#btn_frmaddalumnos").html("<i class='fas fa-plus'></i> Agregar");
						target="/agregar-alumno"
						$("#ALU_FichaX").attr("required","required");						

						var ALU_Rut = $("#ALU_Rut").val();

						$("#frmalumnotab1")[0].reset();
						$("#frmalumnotab2")[0].reset();
						$("#frmalumnotab3")[0].reset();										

						$("#ALU_Rut").val(ALU_Rut);
						$("#ALU_Discapacidad").removeAttr("checked");
						$(".discapacidad").find("select").remove();										
						$(".discapacidad").slideUp("slow");

						$("#ALU_AccesoInternet").removeAttr("checked");
						$("#ALU_DispositivoElectronico").removeAttr("checked");

						$("#ALU_ReconocePuebloOriginario").removeAttr("checked");
						$("#PuebloOriginario").find("input").remove();										
						$("#PuebloOriginario").slideUp("slow");

						$("#ALU_PerteneceSindicato").removeAttr("checked");
						$("#sin1").find("input").remove();
						$("#sin2").find("input").remove();
						$("#sin3").find("input").remove();																				
						$(".sindicato").slideUp("slow");

						$("#ALU_PermisoCapacitacionEnOrganizacion").removeAttr("checked");

						$("#ALU_DirigenteSindical").removeAttr("checked");
						$(".dirigente").find("input").remove();										
						$(".dirigente").slideUp("slow");

						$("#ALU_CursosFormacionSindicalAnteriormente").removeAttr("checked");
						$("#cur1").find("input").remove();
						$("#cur2").find("input").remove();										
						$(".curso").slideUp("slow");

						$("#ALU_CargoDirectivoEnOrganizacion").removeAttr("checked");
						$("#car1").find("input").remove();
						$("#car2").find("input").remove();

						$(".cargo").slideUp("slow");																											
					}
				},
				error: function(){
					console.log("error")
				}
			});
		}
		
		function alumnos_tabs(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$.ajax( {
				type:'POST',					
				url: '/alumnos-modal-tabs',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmAlumno").html(param[1]);
						$("#frmAlumno").tabsmaterialize({menumovil:false},function(){});
						$(".calendario").datepicker({
							beforeShow: function(input, inst) {
								$(document).off('focusin.bs.modal');
							},
							onClose:function(){
								$(document).on('focusin.bs.modal');
							},
						});						
						$("#ALU_Rut").Rut();	
						$("#ALU_Rut").unbind();
						$("#ALU_Rut").on("change",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
														
							var ALU_Rut = $(this).val().replace(/[($)\s\._\-]+/g, '');
							cargadatosalumno(ALU_Rut,"mod");							
						});						
						$("#ALU_FechaNacimiento").on("change",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							$(this).siblings("label").addClass("active");
							//dob = new Date($(this).val());
							//var today = new Date();
							//var age = Math.floor((today-dob) / (365.25 * 24 * 60 * 60 * 1000));
							const today = new Date();
							const fechaNac = new Date($(this).val());
							let age = today.getFullYear() - fechaNac.getFullYear();
							const m = today.getMonth() - fechaNac.getMonth();
							if (m < 0 || (m === 0 && today.getDate() < fechaNac.getDate())) {
								age--;
							}

							$('#ALU_Edad').val(age);
							$('#ALU_Edad').siblings("label").addClass("active");
						})
						$('select#REG_IdAlu').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							var region = $(this).val();    	
							$.ajax({
								type: 'POST',			
								url: '/seleccionar-comunas',
								data: {REG_Id:region},
								success: function(data) {					
									$('#COM_IdAlu').html(data);
									setInterval(blink('#COM_IdAlu'), 2200);								
								}
							});
						});												
						$('#ALU_ReconocePuebloOriginario').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
			
							if($('#ALU_ReconocePuebloOriginario').is(":checked")){
								$("#PuebloOriginario").find("i").after('<input type="text" id="ALU_PuebloOriginario" name="ALU_PuebloOriginario" class="form-control" required>')
								$("#PuebloOriginario").slideDown("slow");										
							}else{
								$("#PuebloOriginario").find("input").remove();
								$("#ALU_PuebloOriginario-error").remove();
								$("#PuebloOriginario").slideUp("slow");
							}
						})
						$('#ALU_PerteneceSindicato').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							if($('#ALU_PerteneceSindicato').is(":checked")){
								$("#sin1").find("i").after('<input type="text" id="ALU_FechaIngreso" name="ALU_FechaIngreso" class="form-control calendario" required readonly>')
								$("#sin2").find("i").after('<input type="text" id="ALU_NombreOrganizacion" name="ALU_NombreOrganizacion" class="form-control" required>')
								$("#sin3").find("i").after('<input type="text" id="ALU_RSU" name="ALU_RSU" class="form-control" required>')
								$(".sindicato").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
							}else{
								$("#sin1").find("input").remove();
								$("#sin2").find("input").remove();
								$("#sin3").find("input").remove();
								$("#ALU_FechaIngreso-error").remove();
								$("#ALU_NombreOrganizacion-error").remove();
								$("#ALU_RSU-error").remove();
								$(".sindicato").slideUp("slow");
							}
						})
						$('#ALU_DirigenteSindical').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							if($('#ALU_DirigenteSindical').is(":checked")){					
								$(".dirigente").find("i").after('<input type="text" id="ALU_TiempoDirigenteSindical" name="ALU_TiempoDirigenteSindical" class="form-control calendario" required readonly>')
								$(".dirigente").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
							}else{
								$(".dirigente").find("input").remove();
								$("#ALU_TiempoDirigenteSindical-error").remove();
								$(".dirigente").slideUp("slow");
							}
						})
						$('#ALU_CargoDirectivoEnOrganizacion').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							if($('#ALU_CargoDirectivoEnOrganizacion').is(":checked")){
								$("#car1").find("i").after('<input type="text" id="ALU_FechaInicioCargoDirectivo" name="ALU_FechaInicioCargoDirectivo" class="form-control calendario" required readonly>')
								$("#car2").find("i").after('<input type="text" id="ALU_NombreCargoDirectivo" name="ALU_NombreCargoDirectivo" class="form-control" required>')
								$(".cargo").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
							}else{
								$("#car1").find("input").remove();

								$("#car2").find("input").remove();
								$("#ALU_FechaInicioCargoDirectivo-error").remove();
								$("#ALU_NombreCargoDirectivo-error").remove();
								$(".cargo").slideUp("slow");
							}
						})
						$('#ALU_CursosFormacionSindicalAnteriormente').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							if($('#ALU_CursosFormacionSindicalAnteriormente').is(":checked")){	
								$("#cur1").find("i").after('<input type="text" id="ALU_InstitucionCursoFormacionSindical" name="ALU_InstitucionCursoFormacionSindical" class="form-control" required>')
								$("#cur2").find("i").after('<input type="number" id="ALU_AnioCursoFormacionSindical" name="ALU_AnioCursoFormacionSindical" class="form-control" required>')
								$(".curso").slideDown("slow");
								$(".calendario").datepicker({
									beforeShow: function(input, inst) {
										$(document).off('focusin.bs.modal');
									},
									onClose:function(){
										$(document).on('focusin.bs.modal');
									},
								});
							}else{
								$("#cur1").find("input").remove();
								$("#cur2").find("input").remove();
								$("#ALU_InstitucionCursoFormacionSindical-error").remove();
								$("#ALU_AnioCursoFormacionSindical-error").remove();
								$(".curso").slideUp("slow");
							}
						})
						$('#ALU_Discapacidad').on('change',function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							if($('#ALU_Discapacidad').is(":checked")){					
								$.ajax({
									url: "/listar-tipo-discapacidad",
									method: 'POST',						
									success: function (data) {
										param=data.split(bb);
										if(param[0]==200){
											$(".discapacidad").find("i").after(param[1]);
											$(".discapacidad").slideDown("slow");
										}
									}
								});					
							}else{
								$(".discapacidad").find("select").remove();
								$("#TDI_id-error").remove();
								$(".discapacidad").slideUp("slow");
							}
						})
						$("#ALU_FichaX").click(function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#ALU_Ficha").click();
						})
						$("#ALU_Ficha").change(function(click){								
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
							$('#ALU_FichaX').val($("#ALU_Ficha").val().replace(fakepath_4,""));								
						})
					}				
				}
			})
		}
		
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
		
		
		$("body").append("<button id='btn_modalalumnos' name='btn_modalalumnos' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalalumnos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#alumnosModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalalumnos").click();		
		$("#btn_modalalumnos").remove();
	})
</script>