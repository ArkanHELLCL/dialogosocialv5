<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmlineas="frmlineas"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-lineas"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect="active"
				action="/modificar-lineas"
			else
				typeFrm=""
				button=""
				action=""
			end if
		end if
	else
		frmlineas=""
		disabled="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")<>1) then
		ds = "disabled"
		lblSelect = "active"		
	else
		if(mode="add") then
			ds="required"
		else
			ds = ""		
			lblSelect = ""
		end if
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
	
	if(mode="mod") then
		set rs = cnn.Execute("exec spLinea_Consultar " & LIN_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			LIN_Nombre 								= rs("LIN_Nombre")
			LFO_Id      				 			= rs("LFO_Id")
			LFO_Nombre  				 			= rs("LFO_Nombre") 
			LIN_AgregaTematica 			 			= rs("LIN_AgregaTematica")
			LIN_Mujer					 			= rs("LIN_Mujer")
			LIN_Hombre					 			= rs("LIN_Hombre")
			LIN_DiasCierreInformeParcial 			= rs("LIN_DiasCierreInformeParcial")
			LIN_DiasCierreInformeFinal	 			= rs("LIN_DiasCierreInformeFinal")
			LIN_DiasCierreInformeParcial50Ejecucion = rs("LIN_DiasCierreInformeParcial50Ejecucion")
			LIN_DiasCierreInformeFinal100Ejecucion 	= rs("LIN_DiasCierreInformeFinal100Ejecucion")
			LIN_PorcentajeMaxAsistenciaDesercion 	= rs("LIN_PorcentajeMaxAsistenciaDesercion")
			LIN_PorcentajeMaxAsistenciaReprobacion 	= rs("LIN_PorcentajeMaxAsistenciaReprobacion")
			LIN_DiasIngresoAsistencia				= rs("LIN_DiasIngresoAsistencia")
			LIN_PorcentajeMaxAsistenciaInscrito		= rs("LIN_PorcentajeMaxAsistenciaInscrito")
			FON_Nombre								= rs("FON_Nombres")
			FON_Id									= rs("FON_Id")
			LIN_Mixta								= rs("LIN_Mixta")
			LIN_AgregaSindicato						= rs("LIN_AgregaSindicato")
			LIN_AgregaEmpresa						= rs("LIN_AgregaEmpresa")
			LIN_AgregaCivil							= rs("LIN_AgregaCivil")
			LIN_AgregaGobierno						= rs("LIN_AgregaGobierno")
			LIN_AgregaSindicatoVerificador			= rs("LIN_AgregaSindicatoVerificador")
			LIN_AgregaEmpresaVerificador			= rs("LIN_AgregaEmpresaVerificador")
			LIN_AgregaCivilVerificador				= rs("LIN_AgregaCivilVerificador")
			LIN_AgregaGobiernoVerificador			= rs("LIN_AgregaGobiernoVerificador")
		end if
		if LIN_AgregaTematica then
			checked = "checked"
		else
			checked = ""
		end if
		if LIN_Hombre then
			hombres = "checked"
		else
			hombres = ""
		end if
		if LIN_Mujer then
			mujeres = "checked"
		else
			mujeres = ""
		end if
		if LIN_Mixta then
			mixta = "checked"
		else
			mixta = ""
		end if
		if LIN_AgregaSindicato then
			Sindicato = "checked"
		else
			Sindicato = ""
		end if
		if LIN_AgregaEmpresa then
			Empresa = "checked"
		else
			Empresa = ""
		end if
		if LIN_AgregaCivil then
			Civil = "checked"
		else
			Civil = ""
		end if
		if LIN_AgregaGobierno then
			Gobierno = "checked"
		else
			Gobierno = ""
		end if
		if LIN_AgregaSindicatoVerificador then
			SindicatoVerificador = "checked"
		else
			SindicatoVerificador = ""
		end if
		if LIN_AgregaEmpresaVerificador then
			EmpresaVerificador = "checked"
		else
			EmpresaVerificador = ""
		end if
		if LIN_AgregaCivilVerificador then
			CivilVerificador = "checked"
		else
			CivilVerificador = ""
		end if
		if LIN_AgregaGobiernoVerificador then
			GobiernoVerificador = "checked"
		else
			GobiernoVerificador = ""
		end if

		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Lineas</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmlineas" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmlineas%>" id="<%=frmlineas%>" class="needs-validation">
							<div class="row">															
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="LFO_Id" id="LFO_Id" class="select-text form-control" <%=ds%>><%
													if((LFO_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spLineaFormativa_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(LFO_Id = rs("LFO_Id")) then%>
															<option value="<%=rs("LFO_Id")%>" selected><%=rs("LFO_Nombre")%></option><%
														else%>
															<option value="<%=rs("LFO_Id")%>"><%=rs("LFO_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Línea Formativa</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(LIN_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="LIN_Nombre" name="LIN_Nombre" class="form-control" <%=disabled%> value="<%=LIN_Nombre%>">
											<span class="select-bar"></span>
											<label for="LIN_Nombre" class="<%=lblClass%>">Línea</label>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row" style="text-align: left;padding-bottom:20px;">
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaTematica" name="LIN_AgregaTematica" class="toggle" <%=checked%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaTematica" class="label">¿Módulos Adicionales?</label>
									</div>
								</div>								
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_Hombres" name="LIN_Hombres" class="toggle" <%=hombres%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_Hombres" class="label">¿Incluir Hombres?</label>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_Mujer" name="LIN_Mujer" class="toggle" <%=mujeres%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_Mujer" class="label">¿Incluir Mujeres?</label>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_Mixta" name="LIN_Mixta" class="toggle" <%=mixta%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_Mixta" class="label">¿Línea Mixta?</label>
									</div>
								</div>
							</div>
							<div class="row" style="padding-bottom:10px">
								<div class="col-sm-12 col-md-12 col-lg-12">
									<h6>Incluir Redes de Apoyo y sus verificadores</h6>
								</div>
							</div>
							<div class="row" style="text-align: left;padding-bottom:20px;">
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaSindicato" name="LIN_AgregaSindicato" class="toggle" <%=Sindicato%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaSindicato" class="label">Sindicatos</label>
									</div>

									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaSindicatoVerificador" name="LIN_AgregaSindicatoVerificador" class="toggle" <%=SindicatoVerificador%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaSindicatoVerificador" class="label">¿Ver.?</label>
									</div>
								</div>								
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaEmpresa" name="LIN_AgregaEmpresa" class="toggle" <%=Empresa%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaEmpresa" class="label">Empresas</label>
									</div>

									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaEmpresaVerificador" name="LIN_AgregaEmpresaVerificador" class="toggle" <%=EmpresaVerificador%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaEmpresaVerificador" class="label">¿Ver.?</label>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaCivil" name="LIN_AgregaCivil" class="toggle" <%=Civil%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaCivil" class="label">Civiles</label>
									</div>

									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaCivilVerificador" name="LIN_AgregaCivilVerificador" class="toggle" <%=CivilVerificador%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaCivilVerificador" class="label">¿Ver.?</label>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaGobierno" name="LIN_AgregaGobierno" class="toggle" <%=Gobierno%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaGobierno" class="label">Gobierno</label>
									</div>

									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LIN_AgregaGobiernoVerificador" name="LIN_AgregaGobiernoVerificador" class="toggle" <%=GobiernoVerificador%><%=" "%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LIN_AgregaGobiernoVerificador" class="label">¿Ver.?</label>
									</div>
								</div>
							</div>
							<%
							'if LFO_Id=10 or LFO_Id=12 then%>							
								<div class="row"><%
									'if LFO_Id=10 then%>
										<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput">
											<div class="md-form input-with-post-icon">
												<div class="error-message">								
													<i class="fas fa-calendar-day input-prefix"></i><%
													if(LIN_DiasCierreInformeParcial<>"") then
														lblClass="active"
													else
														lblClass=""
													end if%>
													<input type="number" id="LIN_DiasCierreInformeParcial" name="LIN_DiasCierreInformeParcial" class="form-control" <%=disabled%> value="<%=LIN_DiasCierreInformeParcial%>">
													<span class="select-bar"></span>
													<label for="LIN_DiasCierreInformeParcial" class="<%=lblClass%>">Días Cierre Inf.Parcial</label>
												</div>
											</div>
										</div><%									
									'end if%>
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-calendar-day input-prefix"></i><%
												if(LIN_DiasCierreInformeFinal<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_DiasCierreInformeFinal" name="LIN_DiasCierreInformeFinal" class="form-control" <%=disabled%> value="<%=LIN_DiasCierreInformeFinal%>">
												<span class="select-bar"></span>
												<label for="LIN_DiasCierreInformeFinal" class="<%=lblClass%>">Días Cierre Inf.Final</label>
											</div>
										</div>
									</div><%
									'if LFO_Id=10 then%>
										<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput">
											<div class="md-form input-with-post-icon">
												<div class="error-message">								
													<i class="fas fa-calendar-day input-prefix"></i><%
													if(LIN_DiasCierreInformeParcial50Ejecucion<>"") then
														lblClass="active"
													else
														lblClass=""
													end if%>
													<input type="number" id="LIN_DiasCierreInformeParcial50Ejecucion" name="LIN_DiasCierreInformeParcial50Ejecucion" class="form-control" <%=disabled%> value="<%=LIN_DiasCierreInformeParcial50Ejecucion%>">
													<span class="select-bar"></span>
													<label for="LIN_DiasCierreInformeParcial50Ejecucion" class="<%=lblClass%>">Días Cierre Inf.Parcial(50% Pln.)</label>
												</div>
											</div>
										</div><%									
									'end if%>
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-calendar-day input-prefix"></i><%
												if(LIN_DiasCierreInformeFinal100Ejecucion<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_DiasCierreInformeFinal100Ejecucion" name="LIN_DiasCierreInformeFinal100Ejecucion" class="form-control" <%=disabled%> value="<%=LIN_DiasCierreInformeFinal100Ejecucion%>">
												<span class="select-bar"></span>
												<label for="LIN_DiasCierreInformeFinal100Ejecucion" class="<%=lblClass%>">Días Cierre Inf.Final(100% Pln.)</label>
											</div>
										</div>
									</div>											
								</div>
								<div class="row">
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput FechasCierreInput2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-percent input-prefix"></i><%
												if(LIN_PorcentajeMaxAsistenciaDesercion<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_PorcentajeMaxAsistenciaDesercion" name="LIN_PorcentajeMaxAsistenciaDesercion" class="form-control" <%=disabled%> value="<%=LIN_PorcentajeMaxAsistenciaDesercion%>">
												<span class="select-bar"></span>
												<label for="LIN_PorcentajeMaxAsistenciaDesercion" class="<%=lblClass%>">Desercion menor a:</label>
											</div>
										</div>
									</div>										
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput FechasCierreInput2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-percent input-prefix"></i><%
												if(LIN_PorcentajeMaxAsistenciaReprobacion<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_PorcentajeMaxAsistenciaReprobacion" name="LIN_PorcentajeMaxAsistenciaReprobacion" class="form-control" <%=disabled%> value="<%=LIN_PorcentajeMaxAsistenciaReprobacion%>">
												<span class="select-bar"></span>
												<label for="LIN_PorcentajeMaxAsistenciaReprobacion" class="<%=lblClass%>">Reprobado >= a % ant. y < a: </label>
											</div>
										</div>
									</div>										
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput FechasCierreInput2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-percent input-prefix"></i><%
												if(LIN_PorcentajeMaxAsistenciaInscrito<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_PorcentajeMaxAsistenciaInscrito" name="LIN_PorcentajeMaxAsistenciaInscrito" class="form-control" <%=disabled%> value="<%=LIN_PorcentajeMaxAsistenciaInscrito%>">
												<span class="select-bar"></span>
												<label for="LIN_PorcentajeMaxAsistenciaInscrito" class="<%=lblClass%>">Inscrito >= a </label>
											</div>
										</div>
									</div>								
									<div class="col-sm-12 col-md-12 col-lg-3 FechasCierreInput FechasCierreInput2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-calendar-day input-prefix"></i><%
												if(LIN_DiasIngresoAsistencia<>"") then
													lblClass="active"
												else
													lblClass=""
												end if%>
												<input type="number" id="LIN_DiasIngresoAsistencia" name="LIN_DiasIngresoAsistencia" class="form-control" <%=disabled%> value="<%=LIN_DiasIngresoAsistencia%>">
												<span class="select-bar"></span>
												<label for="LIN_DiasIngresoAsistencia" class="<%=lblClass%>">Dás para bloq. Asist. > a</label>
											</div>
										</div>
									</div>
								</div><%							
							'end if
							if(mode="mod") then%>
								<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmlineas-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmlineas" name="btn_frmlineas"><%=typeFrm%></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">					
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i> Salir</button>
				</div>					
			</div>		  
			<!--footer-->	
		</div>
	</div>

<script>    
	$(function () {
		var titani = setInterval(function(){		
				$("h6").slideDown("slow",function(){
					clearInterval(titani)
				});
		},2300);

		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		$("#btn_frmlineas").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';
			
			if(mode=="add"){
				var msg="Linea agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Linea modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmlineas");			
			if($("#frmlineas").valid()){
				$.ajax({
					type: 'POST',
					url: $("#frmlineas").attr("action"),
					data: $("#frmlineas").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmlineas")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de linea Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){						
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
						});				
					}
				})
			}
		})
		selectLinea();
		function selectLinea(){
			var LFO_Id = $("#LFO_Id").val();			
			if(LFO_Id!=undefined) {
				if (LFO_Id.trim()==10){
					$(".FechasCierreInput").slideDown("slow");
					$(".FechasCierreInput2").slideDown("slow");
				}
				else{
					$(".FechasCierreInput").slideUp("slow");
					$(".FechasCierreInput2").slideUp("slow");
					if (LFO_Id.trim()==12){						
						$(".FechasCierreInput2").slideDown("slow");
					}else{					
						$(".FechasCierreInput2").slideUp("slow");
					}					
				}
			}
		}
		$('select#LFO_Id').change(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			selectLinea();
		});
		
		$("#LIN_Mixta").on("click", function(){
			if($("#LIN_Mixta:checked" ).length){
				Toast.fire({
				  icon: 'info',
				  title: 'Recuerda que deben existir al menos dos líneas mixtas para acceder a esta funcionalidad.'
				});
			}
		})
	})
</script>