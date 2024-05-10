<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	REL_Id = request("REL_Id")	
	mode=request("mode")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmrelatores="frmrelatores"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-relatores"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect="active"
				action="/modificar-relatores"
				checkbox="required"
			else
				typeFrm=""
				button=""
				action=""
				checkbox="disabled"
			end if
		end if
	else
		frmrelatores=""
		disabled="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")>2) then
		ds = "disabled"
		lblSelect = "active"		
	else
		if(mode="add") then
			ds="required"						
		else
			ds = ""		
			lblSelect = ""
			
			sql="spRelatorProyecto_Listar " & REL_Id
			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 		
				response.end
			End If	

			contPry=0
			do While Not rs.EOF		
				contPry=contPry+1
				rs.movenext
			loop

			sql="spRelator_Consultar " & REL_Id
			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 		
				response.end
			End If	
			if not rs.eof then
				REL_Rut	= rs("REL_Rut")
				REL_Paterno	= rs("REL_Paterno")
				REL_Materno	= rs("REL_Materno")
				REL_Nombres	= rs("REL_Nombres")
				EDU_Id		= rs("EDU_Id")
				REL_NombreCarrera	= rs("REL_NombreCarrera")
				REL_Estado	= rs("REL_Estado")
				SEX_Id	= rs("SEX_Id")
			end if
		end if
	end if				
								
	if(mode="mod") then
			
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Relator</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmrelatores" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="">						
						<!--container-nav-->
						<div class="container-nav">
							<div class="header">				
								<div class="content-nav">
									<a id="relatores1-tab" href="#relatorestab1" class="active tab"><i class="fas fa-user"></i> Datos personales
									</a><%
									if(mode<>"add") then%>
										<a id="relatores2-tab" href="#relatorestab2" class="tab"><i class="fas fa-book"></i> Proyectos <span class="badge blue" style="font-size:9px;" title="Número de Proyectos Asociados" data-toggle="tooltip"><%=contPry%></span>
										</a><%
									end if%>
									<span class="yellow-bar"></span>									
								</div>
							</div>
							<!--tab-content-->
							<div class="tab-content tab-validate">
								<!--relatorestab1-->
								<div id="relatorestab1" class="tabs-pane">
									<form role="form" action="" method="POST" name="frmrelatorestab1" id="frmrelatorestab1" class="form-signin needs-validation">
										<div class="row">
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-id-card input-prefix"></i><%
														if(mode="add") then%>
															<input type="text" id="REL_Rut" name="REL_Rut" class="form-control rut" required value="<%=REL_Rut%>"> <%
														else%>
															<input type="text" id="REL_Rut" name="REL_Rut" class="form-control rut" required readonly value="<%=REL_Rut%>"> <%
														end if%>													
														<span class="select-bar"></span>
														<label for="REL_Rut" class="<%=lblClass%>">Rut</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="REL_Nombres" name="REL_Nombres" class="form-control" required value="<%=REL_Nombres%>">
														<span class="select-bar"></span>
														<label for="REL_Nombres" class="<%=lblClass%>">Nombres</label>
													</div>
												</div>
											</div>

											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="REL_Paterno" name="REL_Paterno" class="form-control" required value="<%=REL_Paterno%>">
														<span class="select-bar"></span>
														<label for="REL_Paterno" class="<%=lblClass%>">Apellido Paterno</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="REL_Materno" name="REL_Materno" class="form-control" required value="<%=REL_Materno%>">
														<span class="select-bar"></span>
														<label for="REL_Materno" class="<%=lblClass%>">Apellido Materno</label>
													</div>
												</div>
											</div>
										</div>
										<div class="row">																			
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="EDU_Id" id="EDU_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rx = cnn.Execute("exec spEducacion_Listar")
																on error resume next					
																do While Not rx.eof%>
																	<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
																	rx.movenext						
																loop
																rx.Close%>
															</select>														
															<i class="fas fa-user-graduate input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Nivel Educacional</label>
														</div>
													</div>	
												</div>
											</div>		
											<div class="col-sm-12 col-md-8 col-lg-8">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="REL_NombreCarrera" name="REL_NombreCarrera" class="form-control" required value="<%=REL_NombreCarrera%>">
														<span class="select-bar"></span>
														<label for="REL_NombreCarrera" class="<%=lblClass%>">Nombre Carrera</label>
													</div>
												</div>
											</div>
										</div>
										<div class="row align-items-center">
											<div class="col-sm-12 col-md-6 col-lg-6 text-right">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<i class="fas fa-cloud-upload-alt input-prefix"></i>
														<input type="text" id="REL_AdjuntoX" name="REL_AdjuntoX" class="form-control" readonly>
														<input type="file" id="REL_Adjunto" name="REL_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
														<span class="select-bar"></span>
														<label for="REL_Adjunto" class="<%=lblClass%>">Adjunto</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-6 col-lg-6" style="text-align: right;">			
												<label for="SEX_Id" class="radiolabel">Sexo</label>
												<div class="md-radio radio-lightBlue md-radio-inline"><%
													if(SEX_Id=1) or (IsNULL(SEX_Id) or SEX_Id="") then%>
														<input id="SEX_Idfemenino" type="radio" name="SEX_Id" checked value="1" <%=checkbox%>><%
													else%>
														<input id="SEX_Idfemenino" type="radio" name="SEX_Id" value="1" <%=checkbox%>><%
													end if%>
													<label for="SEX_Idfemenino">Femenino</label>
												</div>
												<div class="md-radio radio-lightBlue md-radio-inline"><%
													if(SEX_Id=2) then%>
														<input id="SEX_Idmasculino" type="radio" name="SEX_Id" checked value="2" <%=checkbox%>><%
													else%>
														<input id="SEX_Idmasculino" type="radio" name="SEX_Id" value="2" <%=checkbox%>><%
													end if%>
													<label for="SEX_Idmasculino">Masculino</label>
												</div>			
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-10 col-lg-10">
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="REL_Estado" name="REL_Estado" class="switch__input" checked>
															<label for="REL_Estado" class="switch__label">Habilitado</label>
														</div>
													</div>
												</div>
											</div>
										</div>
										<input type="hidden" id="REL_Id" name="REL_Id" value="<%=REL_Id%>">
									</form>
								</div>
								<!--relatorestab1-->
								<%if(mode<>"add") then%>
								<!--relatorestab2-->								
									<div id="relatorestab2" class="tabs-pane">
										<form role="form" action="" method="POST" name="frmrelatorestab4" id="frmrelatorestab4" class="form-signin needs-validation">
											<div class="row">
												<div class="col-sm-12 col-md-2 col-lg-2">
													<div class="md-form input-with-post-icon">
														<div class="error-message">								
															<i class="fas fa-tag input-prefix"></i>
															<input type="number" id="PRY_IdBen" name="PRY_IdBen" class="form-control" value="<%=PRY_IdBen%>" required data-msg="Ingresa un proyecto">
															<span class="select-bar"></span>
															<label for="PRY_IdBen" class="<%=lblClass%>">Proyecto</label>
														</div>
													</div>
												</div>											
												<div class="col-sm-12 col-md-6 col-lg-6">
													<div class="md-form input-with-post-icon">
														<div class="error-message">								
															<i class="fas fa-tag input-prefix"></i>
															<input type="text" id="PRY_NombreBen" name="PRY_NombreBen" class="form-control" readonly value="<%=PRY_NombreBen%>">
															<span class="select-bar"></span>
															<label for="PRY_NombreBen" class="<%=lblClass%>">Nombre</label>
														</div>
													</div>
												</div>
												<div class="col-sm-12 col-md-3 col-lg-3">
													<div class="md-form input-with-post-icon">
														<div class="error-message">
															<div class="select">
																<select name="TRE_Id" id="TRE_Id" class="validate select-text form-control" required data-msg="Selecciona un tipo de relator">
																	<option value="" disabled selected></option><%													
																	set rs = cnn.Execute("exec spTipoRelator_Listar 1")
																	on error resume next					
																	do While Not rs.eof%>
																		<option value="<%=rs("TRE_Id")%>"><%=rs("TRE_Descripcion")%></option><%
																		rs.movenext						
																	loop
																	rs.Close%>
																</select>
																<i class="fas fa-globe-americas input-prefix"></i>											
																<span class="select-highlight"></span>
																<span class="select-bar"></span>
																<label class="select-label <%=lblSelect%>">Tipo</label>
															</div>
														</div>
													</div>
												</div>
												<div class="col-sm-12 col-md-1 col-lg-1" style="padding-top: 23px;text-align:left;">
													<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmrelatorestab4_1" name="btn_frmrelatorestab4_1"><i class="fas fa-plus"></i></button>	
												</div>
											</div>
										</form>
										<table id="tbl-relproyectos" class="ts table table-striped table-bordered dataTable table-sm" data-id="relproyectos" data-page="true" data-selected="true" data-keys="1"> 
											<thead> 
												<tr> 
													<th>Id</th>
													<th>Nombre</th>
													<th>Tipo</th>
													<th>Acciones</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								<%end if%>
								<!--Proyectos-->
							</div>
							<!--tab-content-->
						</div>
						<!--container-nav-->
					</div>
				</div>
			</div>
			<div class="modal-footer" style="margin-top:15px;">
				<form role="form" action="" method="POST" name="frmaddrelatores" id="frmaddrelatores" class="form-signin needs-validation" style="padding-left: 30px;"><%
					if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
						<div style="float:left;" class="btn-group" role="group" aria-label="">
							<button class="<%=button%>" type="button" data-url="" title="Modificar Relator" id="btn_frmaddrelatores" name="btn_frmaddrelatores"><%=typeFrm%></button>
						</div><%
					end if%>
					<div style="float:right;" class="btn-group" role="group" aria-label="">					
						<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i> Salir</button>
					</div>					
				</form>				
			</div>
		</div>
	</div>			

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
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
						
		var disabled={}
		$("#relatoresModal").on('show.bs.modal', function(e){					
			
		})		
		$(".calendario").datepicker({
			beforeShow: function(input, inst) {
				$(document).off('focusin.bs.modal');
			},
			onClose:function(){
				$(document).on('focusin.bs.modal');
			},
		});		

		var relproyectosTable;		
		loadTablerelproyectos();
        $('#tbl-relproyectos').css('width','100%')		
		function loadTablerelproyectos() {
			if($.fn.DataTable.isDataTable( "#tbl-relproyectos")){				
				$('#tbl-relproyectos').dataTable().fnClearTable();
    			$('#tbl-relproyectos').dataTable().fnDestroy();
			}	
			
			relproyectosTable = $('#tbl-relproyectos').DataTable({				
				lengthMenu: [ 3,5,10 ],
				ajax:{
					url:"/relatores-proyectos",
					type:"POST",					
					data:function (d) {
							d.REL_Id = $('#REL_Id').val().replace(/\./g, '');
						},
					complete: function(data){
						if(data.responseJSON!=undefined){
							$("#relatores2-tab").find("span.badge").html(data.responseJSON.data.length);
						}
					}
				},				
				order: [
					[0, 'asc']
				],
				columnDefs:[					
					{"targets": [0],"width":"10px"},
					{"targets": [2],"width":"100px"}
				],
				autoWidth: false
			});							
		}				
		$("#PRY_IdBen").on("change",function(){			
			$.ajax({
				type: "POST",
				url: "/consultar-proyecto",
				data: {PRY_Id:$("#PRY_IdBen").val()},
				dataType: "json",
				success: function(data) {
					if(data.data[0]){
						$("#PRY_NombreBen").val(data.data[0][1]);
					}else{
						$("#PRY_NombreBen").val("");
						$("#PRY_IdBen").val("");
						$("#TRE_Id").val("");
						Toast.fire({
							icon: 'error',
						  	title: data.message
						});
					}
				}
			});			
		})
		
		$("#REL_AdjuntoX").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#REL_Adjunto").click();
		})
		$("#REL_Adjunto").change(function(click){								
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
			$('#REL_AdjuntoX').val($("#REL_Adjunto").val().replace(fakepath_4,""));								
		});
		
		$("#REL_Rut").on("change",function(){
			datosRelator();
		})
		
		function datosRelator(){
			$.ajax({
				type: 'POST',
				url: '/consultar-relator',
				data: {REL_Rut:$("#REL_Rut").val()},
				dataType: "json",
				success: function(json) {					
					if((json.data!=undefined) && ($(json.data).length>0)){
						$('[data-toggle="tooltip"]').tooltip({
							trigger : 'hover'
						})
						$('[data-toggle="tooltip"]').on('click', function () {
							$(this).tooltip('hide')
						});

						$("#frmrelatorestab1")[0].reset();						

						$("#btn_frmaddrelatores").removeClass("btn-success");
						$("#btn_frmaddrelatores").addClass("btn-warning");
						$("#btn_frmaddrelatores").html("<i class='fas fa-edit'></i> Modificar");
						target="/modificar-relatores"
						$("#frmaddrelatores").attr("action",target);						

						$("#REL_Id").val($(json.data)[0][8])
						$("#REL_Rut").val($(json.data)[0][0]);
						$("#REL_Rut").siblings("label").addClass("active");
						$("#REL_Rut").Rut();

						$("#REL_Nombres").val($(json.data)[0][1]);
						$("#REL_Nombres").siblings("label").addClass("active");
						$("#REL_Paterno").val($(json.data)[0][2]);
						$("#REL_Paterno").siblings("label").addClass("active");
						$("#REL_Materno").val($(json.data)[0][3]);
						$("#REL_Materno").siblings("label").addClass("active");
						
						$('#EDU_Id option[value="' + $(json.data)[0][4] + '"]').prop("selected", true);
						
						if($(json.data)[0][6]==1){
							$("#REL_Estado").attr("checked","checked");
						}else{
							$("#REL_Estado").removeAttr("checked");
						}			
						$("#REL_NombreCarrera").val($(json.data)[0][7]);
						$("#REL_NombreCarrera").siblings("label").addClass("active");
						
					}else{										
						$("#btn_frmaddrelatores").addClass("btn-success");
						$("#btn_frmaddrelatores").removeClass("btn-warning");
						$("#btn_frmaddrelatores").html("<i class='fas fa-plus'></i> Agregar");
						target="/agregar-relatores"
						$("#frmaddrelatores").attr("action",target);						

						var REL_Rut = $("#REL_Rut").val();

						$("#frmrelatorestab1")[0].reset();	
						$("#REL_Nombres").val("");
						$("#REL_Paterno").val("");
						$("#REL_Materno").val("");
						$("#REL_NombreCarrera").val("");
						

						$("#REL_Rut").val(REL_Rut);
					}
					relproyectosTable.ajax.reload();
				}
			})
		}
		relatores_tabs();
		function relatores_tabs(){									
			$(".container-nav").tabsmaterialize({menumovil:false},function(){});
			$(".calendario").datepicker({
				beforeShow: function(input, inst) {
					$(document).off('focusin.bs.modal');
				},
				onClose:function(){
					$(document).on('focusin.bs.modal');
				},
			});			
			$("#REL_Rut").Rut();
			datosRelator();
		}	//function
		
		$("#btn_frmaddrelatores").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frmrelatorestab1");
			
			var frm1=false;
			
			if($("#frmrelatorestab1").valid()){
				frm1=true;
			}
			
			if(frm1){
				var REL_Rut = $("#REL_Rut").val().replace(/[($)\s\._\-]+/g, '');
				
				var data1 = $("#frmrelatorestab1").serializeArray();				
				
				var formdata = new FormData();							
				var file_data = $('#REL_Adjunto').prop('files');				
				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i])
				}
								
				$.each(data1, function(i, field) { 
                   formdata.append(field.name,field.value);
                }); 				
				formdata.append("Rut",REL_Rut);
				$.ajax({
					url: $("#frmaddrelatores").attr("action"),
					method: 'POST',					
					data:formdata,
					enctype: 'multipart/form-data',
					cache: false,
					contentType: false,
					processData: false,
					success: function (data) {
						param=data.split(bb);
						if(param[0]==200){		
							relproyectosTable.ajax.reload();
							if(param[1]==""){
								Toast.fire({
								  icon: 'success',
								  title: 'Relator agregado/modificado exitosamente.'
								});

								var data={REL_Id:param[2],mode:'mod'};								
								$.ajax( {
									type:'POST',
									url: '/modal-relatores',
									data: data,
									success: function ( data ) {
										param = data.split(bb)
										if(param[0]==200){							
											$("#relatoresModal").html(param[1]);
											$("#relatoresModal").modal("show");
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude cargar el menú del proyecto1',					
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
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los campos con error antes de guardar'
				});
			}
		})
		
		$("#btn_frmrelatorestab4_1").on("click",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$.ajax({
				type: 'POST',
				url: '/consultar-relator',
				data: {REL_Rut:$("#REL_Rut").val()},
				dataType: "json",
				success: function(json) {
					relproyectosTable.ajax.reload();
					if((json.data.length==0)){
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'ERROR!',
							text:"Debes guardar los datos del relator antes de asignarle uno o mas proyectos"
						});
					}
				}
			})

			formValidate("#frmrelatorestab4");
			if($("#frmrelatorestab4").valid()){
				$.ajax({
					type: "POST",
					url: "/asociar-proyecto-relatores",
					data: {PRY_Id:$("#PRY_IdBen").val(),REL_Id:$("#REL_Id").val(),TRE_Id:$("#TRE_Id").val()},
					dataType: "json",
					success: function(data) {
						if(data.state=='200'){
							relproyectosTable.ajax.reload();
							Toast.fire({
							 	icon: 'success',
							  	title: 'Proyecto agregado exitosamente.'
							});
							$("#PRY_NombreBen").val("");
							$("#PRY_IdBen").val("");
							$("#TRE_Id").val("");
							$("#relatores4-tab").find("span.badge").html(data.contPRY);
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:data.message
							});
						}
					}
				});		
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los campos con error antes de guardar'
				});
			}
		})
		$("#relatorestab2").on("click",".delpryrel",function(){			
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
				text: "Al eliminar esta asociación se eliminarán todos los estados que tenga creados el relator.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar igual!',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {											
					$.ajax({
						type: "POST",
						url: "/desasociar-proyecto-relatores",
						data: {PRY_Id:$(this).data("pry"),REL_Id:$("#REL_Id").val(),RLP_Id:$(this).data("id")},
						dataType: "json",
						success: function(data) {
							if(data.state=='200'){
								relproyectosTable.ajax.reload();
								Toast.fire({
									icon: 'success',
									title: 'Proyecto eliminado exitosamente.'
								});
								$("#PRY_NombreBen").val("");
								$("#PRY_IdBen").val("");							
								$("#relatores4-tab").find("span.badge").html(data.contPRY);
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:data.message
								});
							}
						}
					});				
				}	
			})
		})
	})
</script>