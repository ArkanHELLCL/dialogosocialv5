<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	ALU_Rut = request("ALU_Rut")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmbeneficiarios="frmbeneficiarios"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-beneficiarios"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect="active"
				action="/modificar-beneficiarios"
			else
				typeFrm=""
				button=""
				action=""
			end if
		end if
	else
		frmbeneficiarios=""
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
	
	Rut = replace(ALU_Rut,"-","")
	if(Rut<>"" and not IsNull(Rut)) then
		Ruty = mid(Rut,1,len(Rut)-1)
	else
		Ruty = 0
	end if
	sql="spProyectosxAlumno_Listar " & Ruty
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
								
	if(mode="mod") then
			
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Beneficiario</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmbeneficiarios" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="">						
						<!--container-nav-->
						<div class="container-nav">
							<div class="header">				
								<div class="content-nav">
									<a id="beneficiarios1-tab" href="#beneficiariostab1" class="active tab"><i class="fas fa-user"></i> Datos personales
									</a>
									<a id="beneficiarios2-tab" href="#beneficiariostab2" class="tab"><i class="fas fa-map-marker-alt"></i> Datos de ubicación
									</a>
									<a id="beneficiarios3-tab" href="#beneficiariostab3" class="tab"><i class="fas fa-building"></i> Datos sindicales
									</a><%
									if(mode="mod") then%>
										<a id="beneficiarios4-tab" href="#beneficiariostab4" class="tab"><i class="fas fa-book"></i> Proyectos <span class="badge blue" style="font-size:9px;" title="Número de Proyectos Asociados" data-toggle="tooltip"><%=contPry%></span><%
									end if%>
									</a>
									<span class="yellow-bar"></span>									
								</div>
							</div>
							<!--tab-content-->
							<div class="tab-content tab-validate">
								<!--beneficiariostab1-->
								<div id="beneficiariostab1" class="tabs-pane">
									<form role="form" action="" method="POST" name="frmbeneficiariostab1" id="frmbeneficiariostab1" class="form-signin needs-validation">
										<div class="row">
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-id-card input-prefix"></i><%
														if(mode="add") then%>
															<input type="text" id="ALU_Rut" name="ALU_Rut" class="form-control rut" required value=""> <%
														else%>
															<input type="text" id="ALU_Rut" name="ALU_Rut" class="form-control rut" readonly value="<%=ALU_Rut%>"> <%
														end if%>																												
														<span class="select-bar"></span>
														<label for="ALU_Rut" class="<%=lblClass%>">Rut</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="ALU_Nombre" name="ALU_Nombre" class="form-control" required value="<%=ALU_Nombre%>">
														<span class="select-bar"></span>
														<label for="ALU_Nombre" class="<%=lblClass%>">Nombres</label>
													</div>
												</div>
											</div>

											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="ALU_ApellidoPaterno" name="ALU_ApellidoPaterno" class="form-control" required value="<%=ALU_ApellidoPaterno%>">
														<span class="select-bar"></span>
														<label for="ALU_ApellidoPaterno" class="<%=lblClass%>">Apellido Paterno</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-user input-prefix"></i>
														<input type="text" id="ALU_ApellidoMaterno" name="ALU_ApellidoMaterno" class="form-control" required value="<%=ALU_ApellidoMaterno%>">
														<span class="select-bar"></span>
														<label for="ALU_ApellidoMaterno" class="<%=lblClass%>">Apellido Materno</label>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-calendar input-prefix"></i>
														<input type="text" id="ALU_FechaNacimiento" name="ALU_FechaNacimiento" class="form-control calendario" readonly required value="<%=ALU_FechaNacimiento%>">
														<span class="select-bar"></span>
														<label for="ALU_FechaNacimiento" class="<%=lblClass%>">Fecha Nacimiento</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-1 col-lg-1">
												<div class="md-form input-with-post-icon">
													<div class="error-message">	
														<i class="fas fa-birthday-cake input-prefix"></i>													
														<input type="number" id="ALU_Edad" name="ALU_Edad" class="form-control" readonly value="">
														<span class="select-bar"></span>
														<label for="ALU_Edad" class="<%=lblClass%>">Edad</label>
													</div>
												</div>
											</div>																														
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="NAC_Id" id="NAC_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rs = cnn.Execute("exec spNacionalidad_Listar")
																on error resume next					
																do While Not rs.eof%>
																	<option value="<%=rs("NAC_Id")%>"><%=rs("NAC_Nombre")%></option><%
																	rs.movenext						
																loop
																rs.Close%>
															</select>
															<i class="fas fa-globe-americas input-prefix"></i>											
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Nacionalidad</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="SEX_Id" id="SEX_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%																	
																set rs = cnn.Execute("exec spSexo_listar")
																on error resume next					
																do While Not rs.eof%>																			
																	<option value="<%=rs("SEX_Id")%>"><%=rs("SEX_Descripcion")%></option><%
																	rs.movenext						
																loop
																rs.Close%>
															</select>									
															<i class="fas fa-venus-mars input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Sexo</label>
														</div>
													</div>	
												</div>
											</div>										
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="EDU_Id" id="EDU_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rs = cnn.Execute("exec spEducacion_Listar")
																on error resume next					
																do While Not rs.eof%>
																	<option value="<%=rs("EDU_Id")%>"><%=rs("EDU_Nombre")%></option><%
																	rs.movenext						
																loop
																rs.Close%>
															</select>														
															<i class="fas fa-user-graduate input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Nivel Educacional</label>
														</div>
													</div>	
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-calendar input-prefix"></i><%
														set rs = cnn.Execute("SELECT CONVERT(VARCHAR(10), getdate(),111) AS DATE;")
														on error resume next					
														if Not rs.eof then
															ALU_FechaCreacionRegistro=replace(rs("date"),"/","-")
														end if%>
														<input type="text" id="ALU_FechaCreacionRegistro" name="ALU_FechaCreacionRegistro" class="form-control" required readonly value="<%=ALU_FechaCreacionRegistro%>">
														<span class="select-bar"></span>
														<label for="ALU_FechaCreacionRegistro" class="active">Fecha de Ingreso</label>
													</div>
												</div>
											</div>											
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_Discapacidad" name="ALU_Discapacidad" class="switch__input">
															<label for="ALU_Discapacidad" class="switch__label">Discapacidad?</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4 discapacidad">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">															
															<i class="fas fa-wheelchair input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Tipo Discapacidad</label>
														</div>
													</div>	
												</div>
											</div>	
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_AccesoInternet" name="ALU_AccesoInternet" class="switch__input">
															<label for="ALU_AccesoInternet" class="switch__label">Acceso a Internet?</label>
														</div>
													</div>
												</div>
											</div>
										</div>								
										<div class="row">												
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_DispositivoElectronico" name="ALU_DispositivoElectronico" class="switch__input">
															<label for="ALU_DispositivoElectronico" class="switch__label">Dispositivo para acceder a internet?</label>
														</div>
													</div>
												</div>
											</div>	

											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_ReconocePuebloOriginario" name="ALU_ReconocePuebloOriginario" class="switch__input">
															<label for="ALU_ReconocePuebloOriginario" class="switch__label">Pueblo Originario?</label>
														</div>
													</div>
												</div>
											</div>	
											<div class="col-sm-12 col-md-6 col-lg-6" id="PuebloOriginario">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-campground input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_PuebloOriginario" class="<%=lblClass%>">Pueblo Originario</label>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-10 col-lg-10" id="">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<i class="fas fa-cloud-upload-alt input-prefix"></i>
														<input type="text" id="ALU_FichaX" name="ALU_FichaX" class="form-control" required readonly>
														<input type="file" id="ALU_Ficha" name="ALU_Ficha" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
														<span class="select-bar"></span>
														<label for="ALU_FichaX" class="<%=lblClass%>">Adjunto</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_Estado" name="ALU_Estado" class="switch__input">
															<label for="ALU_Estado" class="switch__label">Habilitado</label>
														</div>
													</div>
												</div>
											</div>
										</div>
										<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
										<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">									
									</form>
								</div>
								<!--beneficiariostab1-->

								<!--beneficiariostab2-->
								<div id="beneficiariostab2" class="tabs-pane">
									<form role="form" action="" method="POST" name="frmbeneficiariostab2" id="frmbeneficiariostab2" class="form-signin needs-validation">
										<div class="row">																						
											<div class="col-sm-12 col-md-6 col-lg-6">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="REG_Id" id="REG_IdAlu" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rs = cnn.Execute("exec spRegion_Listar")
																on error resume next					
																do While Not rs.eof%>
																	<option value="<%=rs("REG_Id")%>"><%=rs("REG_Nombre")%></option><%
																	rs.movenext
																loop
																rs.Close%>
															</select>
															<i class="fas fa-map-marker-alt input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Región</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-6 col-lg-6">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="COM_Id" id="COM_IdAlu" class="validate select-text form-control" required>
																<option value="" disabled selected></option>
															</select>
															<i class="fas fa-map-marker-alt input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Comuna</label>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-12 col-lg-12">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-home input-prefix"></i>
														<input type="text" id="ALU_Direccion" name="ALU_Direccion" class="form-control" required value="<%=ALU_Direccion%>">
														<span class="select-bar"></span>
														<label for="ALU_Direccion" class="<%=lblClass%>">Dirección</label>
													</div>
												</div>
											</div>											
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-6 col-lg-6">
												<div class="md-form input-with-post-icon">
													<div class="error-message">								
														<i class="fas fa-envelope input-prefix"></i>
														<input type="email" id="ALU_Mail" name="ALU_Mail" class="form-control" required value="<%=ALU_Mail%>">
														<span class="select-bar"></span>
														<label for="ALU_Mail" class="<%=lblClass%>">Email</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-mobile-alt input-prefix"></i>
														<input type="number" id="ALU_Telefono" name="ALU_Telefono" class="form-control" required value="<%=ALU_Telefono%>">
														<span class="select-bar"></span>
														<label for="ALU_Telefono" class="<%=lblClass%>">Teléfono</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="TTR_Id" id="TTR_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rs = cnn.Execute("spTipoTrabajador_Listar 1")
																on error resume next					
																do While Not rs.eof%>
																	<option value="<%=rs("TTR_Id")%>"><%=rs("TTR_Nombre")%></option><%
																	rs.movenext						
																loop
																rs.Close%>
															</select>															
															<i class="fas fa-briefcase input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Tipo de Trabajador</label>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="row">											
											<div class="col-sm-12 col-md-6 col-lg-6">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-building input-prefix"></i>
														<input type="text" id="ALU_NombreEmpresa" name="ALU_NombreEmpresa" class="form-control" required value="<%=ALU_NombreEmpresa%>">
														<span class="select-bar"></span>
														<label for="ALU_NombreEmpresa" class="<%=lblClass%>">Nombre Empresa</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-6 col-lg-6">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<div class="select">
															<select name="RUB_Id" id="RUB_Id" class="validate select-text form-control" required>
																<option value="" disabled selected></option><%													
																set rs = cnn.Execute("spRubro_Listar 1")
																on error resume next
																do While Not rs.eof%>
																	<option value="<%=rs("RUB_Id")%>"><%=rs("RUB_Nombre")%></option><%
																	rs.movenext						
																loop
																rs.Close%>
															</select>															
															<i class="fas fa-shapes input-prefix"></i>
															<span class="select-highlight"></span>
															<span class="select-bar"></span>
															<label class="select-label <%=lblSelect%>">Rubro</label>
														</div>
													</div>
												</div>
											</div>
										</div>										
									</form>
								</div>
								<!--beneficiariostab2-->

								<!--beneficiariostab3-->
								<div id="beneficiariostab3" class="tabs-pane">
									<form role="form" action="" method="POST" name="frmbeneficiariostab3" id="frmbeneficiariostab3" class="form-signin needs-validation">
										<div class="row">
											<div class="col-sm-12 col-md-3 col-lg-3s">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_PerteneceSindicato" name="ALU_PerteneceSindicato" class="switch__input">
															<label for="ALU_PerteneceSindicato" class="switch__label">Pertenece a Sindicato?</label>
														</div>
													</div>
												</div>
											</div>								
											<div class="col-sm-12 col-md-2 col-lg-2 sindicato" id="sin1">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-calendar input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_FechaIngreso" class="<%=lblClass%>">Fecha Ingreso</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-5 col-lg-5 sindicato" id="sin2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-building input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_NombreOrganizacion" class="<%=lblClass%>">Nombre Organización</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2 sindicato" id="sin3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-tag input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_RSU" class="<%=lblClass%>">RSU</label>
													</div>
												</div>
											</div>											
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_PermisoCapacitacionEnOrganizacion" name="ALU_PermisoCapacitacionEnOrganizacion" class="switch__input">
															<label for="ALU_PermisoCapacitacionEnOrganizacion" class="switch__label">Permiso Sindical?</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_DirigenteSindical" name="ALU_DirigenteSindical" class="switch__input">
															<label for="ALU_DirigenteSindical" class="switch__label">Dirigente Sindical?</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-4 col-lg-4 dirigente">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-calendar input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_TiempoDirigenteSindical" class="<%=lblClass%>">Fecha incio dirigente</label>
													</div>
												</div>
											</div>								
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-3 col-lg-3">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_CursosFormacionSindicalAnteriormente" name="ALU_CursosFormacionSindicalAnteriormente" class="switch__input">
															<label for="ALU_CursosFormacionSindicalAnteriormente" class="switch__label">Curso Sindical?</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-6 col-lg-6 curso" id="cur1">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-building input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_InstitucionCursoFormacionSindical" class="<%=lblClass%>">Institución Curso</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-3 col-lg-3 curso" id="cur2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-calendar input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_AnioCursoFormacionSindical" class="<%=lblClass%>">Año curso</label>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 col-md-4 col-lg-4">
												<div class="md-form input-with-post-icon">
													<div class="error-message">														
														<div class="switch">
															<input type="checkbox" id="ALU_CargoDirectivoEnOrganizacion" name="ALU_CargoDirectivoEnOrganizacion" class="switch__input">
															<label for="ALU_CargoDirectivoEnOrganizacion" class="switch__label">Desempeña Cargo Directivo en su lugar de trabajo?</label>
														</div>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-2 col-lg-2 cargo" id="car1">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-building input-prefix"></i>
														<span class="select-bar"></span>
														<label for="ALU_FechaInicioCargoDirectivo" class="<%=lblClass%>">Desde Cuándo</label>
													</div>
												</div>
											</div>
											<div class="col-sm-12 col-md-6 col-lg-6 cargo" id="car2">
												<div class="md-form input-with-post-icon">
													<div class="error-message">
														<i class="fas fa-user-tie input-prefix"></i>														
														<span class="select-bar"></span>
														<label for="ALU_NombreCargoDirectivo" class="<%=lblClass%>">Nombre de cargo</label>
													</div>
												</div>
											</div>
										</div>										
									</form>
								</div><%
								if(mode="mod") then%>
									<!--beneficiariostab3-->
									<div id="beneficiariostab4" class="tabs-pane">									
										<form role="form" action="" method="POST" name="frmbeneficiariostab4" id="frmbeneficiariostab4" class="form-signin needs-validation">
											<div class="row">
												<div class="col-sm-12 col-md-2 col-lg-2">
													<div class="md-form input-with-post-icon">
														<div class="error-message">								
															<i class="fas fa-tag input-prefix"></i>
															<input type="number" id="PRY_IdBen" name="PRY_IdBen" class="form-control" value="<%=PRY_IdBen%>" required>
															<span class="select-bar"></span>
															<label for="PRY_IdBen" class="<%=lblClass%>">Proyecto</label>
														</div>
													</div>
												</div>											
												<div class="col-sm-12 col-md-9 col-lg-9">
													<div class="md-form input-with-post-icon">
														<div class="error-message">								
															<i class="fas fa-tag input-prefix"></i>
															<input type="text" id="PRY_NombreBen" name="PRY_NombreBen" class="form-control" readonly value="<%=PRY_NombreBen%>">
															<span class="select-bar"></span>
															<label for="PRY_NombreBen" class="<%=lblClass%>">Nombre</label>
														</div>
													</div>
												</div>
												<div class="col-sm-12 col-md-1 col-lg-1" style="padding-top: 23px;text-align:left;">
													<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmbeneficiariostab4_1" name="btn_frmbeneficiariostab4_1"><i class="fas fa-plus"></i></button>	
												</div>
											</div>
										</form>
										<table id="tbl-benproyectos" class="ts table table-striped table-bordered dataTable table-sm" data-id="benproyectos" data-page="true" data-selected="true" data-keys="1"> 
											<thead> 
												<tr> 
													<th>Id</th>
													<th>Nombre</th>
													<th>Acciones</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div><%
								end if%>
								<!--Proyectos-->
							</div>
							<!--tab-content-->
						</div>
						<!--container-nav-->
					</div>
				</div>
			</div>
			<div class="modal-footer" style="margin-top:15px;">
				<form role="form" action="" method="POST" name="frmaddbeneficiarios" id="frmaddbeneficiarios" class="form-signin needs-validation" style="padding-left: 30px;"><%
					if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
						<div style="float:left;" class="btn-group" role="group" aria-label="">
							<button class="<%=button%>" type="button" data-url="" title="Modificar Beneficiario" id="btn_frmaddbeneficiarios" name="btn_frmaddbeneficiarios"><%=typeFrm%></button>
						</div><%
					end if%>
					<div style="float:right;" class="btn-group" role="group" aria-label="">					
						<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i> Salir</button>
					</div>				
				</form>				
			</div>
		</div>
	</div>		

	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">

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
		$("#beneficiariosModal").on('show.bs.modal', function(e){					
			
		})		
		$(".calendario").datepicker({
			beforeShow: function(input, inst) {
				$(document).off('focusin.bs.modal');
			},
			onClose:function(){
				$(document).on('focusin.bs.modal');
			},
		});
		$("#ALU_Rut").on("change",function(){
			beneficiarios_tabs();
		})
		$("#ALU_FechaNacimiento").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();

			$(this).siblings("label").addClass("active");
			dob = new Date($(this).val());
			var today = new Date();
			var age = Math.floor((today-dob) / (365.25 * 24 * 60 * 60 * 1000));

			$('#ALU_Edad').val(age);
			$('#ALU_Edad').siblings("label").addClass("active");
		})
		$('select#REG_IdAlu').on('change',function(){
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

		var benproyectosTable;		
		loadTablebenproyectos();
        $('#tbl-benproyectos').css('width','100%')
		
		function loadTablebenproyectos() {
			if($.fn.DataTable.isDataTable( "#tbl-benproyectos")){				
				$('#tbl-benproyectos').dataTable().fnClearTable();
    			$('#tbl-benproyectos').dataTable().fnDestroy();
			}			
			benproyectosTable = $('#tbl-benproyectos').DataTable({				
				lengthMenu: [ 3,5,10 ],
				ajax:{
					url:"/beneficiarios-proyectos",
					type:"POST",					
					data: function (d) {
							d.ALU_Rut = $('#ALU_Rut').val().replace(/\./g, '');
						},
					complete: function(data){
						if(data.responseJSON!=undefined){
							$("#beneficiarios4-tab").find("span.badge").html(data.responseJSON.data.length);
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
				autoWidth: false,
				stateSave: true
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
						Toast.fire({
							icon: 'error',
						  	title: data.message
						});
					}
				}
			});			
		})
		$('#ALU_ReconocePuebloOriginario').on('change',function(){
			if($('#ALU_ReconocePuebloOriginario').is(":checked")){
				$("#PuebloOriginario").find("i").after('<input type="text" id="ALU_PuebloOriginario" name="ALU_PuebloOriginario" class="form-control" required>')
				$("#PuebloOriginario").slideDown("slow");										
			}else{
				$("#PuebloOriginario").find("input").remove();
				$("#ALU_PuebloOriginario-error").remove();
				$("#PuebloOriginario").slideUp("slow");
			}
		})
		$('#ALU_PerteneceSindicato').on('change',function(){
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
		$('#ALU_DirigenteSindical').on('change',function(){
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
		$('#ALU_CargoDirectivoEnOrganizacion').on('change',function(){
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
		$('#ALU_CursosFormacionSindicalAnteriormente').on('change',function(){
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
		$('#ALU_Discapacidad').on('change',function(){
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
		
		beneficiarios_tabs();
		function beneficiarios_tabs(){									
			$(".container-nav").tabsmaterialize({menumovil:false},function(){});
			$(".calendario").datepicker({
				beforeShow: function(input, inst) {
					$(document).off('focusin.bs.modal');
				},
				onClose:function(){
					$(document).on('focusin.bs.modal');
				},
			});			
			$("#ALU_Rut").Rut();
			$.ajax({
				type: 'POST',
				url: '/consultar-beneficiario',
				data: {ALU_Rut:$("#ALU_Rut").val().replace("-","")},
				dataType: "json",
				success: function(json) {					
					benproyectosTable.ajax.reload(null, false);
					if((json.data!=undefined) && ($(json.data).length>0)){
						$('[data-toggle="tooltip"]').tooltip({
							trigger : 'hover'
						})
						$('[data-toggle="tooltip"]').on('click', function () {
							$(this).tooltip('hide')
						});

						/*$("#frmbeneficiariostab1")[0].reset();
						$("#frmbeneficiariostab2")[0].reset();
						$("#frmbeneficiariostab3")[0].reset();*/											

						$("#btn_frmaddbeneficiarios").removeClass("btn-success");
						$("#btn_frmaddbeneficiarios").addClass("btn-warning");
						$("#btn_frmaddbeneficiarios").html("<i class='fas fa-edit'></i> Modificar");
						target="/modificar-beneficiario"
						$("#frmaddbeneficiarios").attr("action",target);
						$("#ALU_FichaX").removeAttr("required");

						$("#ALU_Rut").val($(json.data)[0][0]);
						$("#ALU_Rut").siblings("label").addClass("active");
						$("#ALU_Rut").Rut();

						$("#ALU_Nombre").val($(json.data)[0][1]);
						$("#ALU_Nombre").siblings("label").addClass("active");
						$("#ALU_ApellidoPaterno").val($(json.data)[0][2]);
						$("#ALU_ApellidoPaterno").siblings("label").addClass("active");
						$("#ALU_ApellidoMaterno").val($(json.data)[0][3]);
						$("#ALU_ApellidoMaterno").siblings("label").addClass("active");
						$("#ALU_FechaNacimiento").val($(json.data)[0][4]);
						$("#ALU_FechaNacimiento").siblings("label").addClass("active");

						dob = new Date($("#ALU_FechaNacimiento").val());
						var today = new Date();
						var age = Math.floor((today-dob) / (365.25 * 24 * 60 * 60 * 1000));

						$("#ALU_Edad").val(age);
						$("#ALU_Edad").siblings("label").addClass("active");
						$('#NAC_Id option[value="' + $(json.data)[0][6] + '"]').prop("selected", true);										
						$('#SEX_Id option[value="' + $(json.data)[0][8] + '"]').prop("selected", true);
						$('#EDU_Id option[value="' + $(json.data)[0][9] + '"]').prop("selected", true);
						if($(json.data)[0][10]==1){
							$("#ALU_Discapacidad").attr("checked","checked");
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
						if($(json.data)[0][41]==1){
							$("#ALU_Estado").attr("checked","checked");
						}else{
							$("#ALU_Estado").removeAttr("checked");
						}							
						$("#ALU_FechaCreacionRegistro").val($(json.data)[0][12]);						
						if($(json.data)[0][13]==1){
							$("#ALU_AccesoInternet").attr("checked","checked");
						}else{
							$("#ALU_AccesoInternet").removeAttr("checked");
						}										
						if($(json.data)[0][14]==1){
							$("#ALU_DispositivoElectronico").attr("checked","checked");
						}else{
							$("#ALU_DispositivoElectronico").removeAttr("checked");
						}
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

						/*tab ubicacion*/
						$('#REG_IdAlu option[value="' + $(json.data)[0][20] + '"]').prop("selected", true);
						var region = $(json.data)[0][20];    	
						$.ajax({
							type: 'POST',			
							url: '/seleccionar-comunas',
							data: {REG_Id:region},
							success: function(data) {					
								$('#COM_IdAlu').html(data);
								setInterval(blink('#COM_IdAlu'), 2200);
								$('#COM_IdAlu option[value="' + $(json.data)[0][21] + '"]').prop("selected", true);
							}
						});	
						$("#ALU_Direccion").val($(json.data)[0][22]);
						$("#ALU_Direccion").siblings("label").addClass("active");
						$("#ALU_Mail").val($(json.data)[0][23]);
						$("#ALU_Mail").siblings("label").addClass("active");
						$("#ALU_Telefono").val($(json.data)[0][24]);
						$("#ALU_Telefono").siblings("label").addClass("active");
						$('#TTR_Id option[value="' + $(json.data)[0][25] + '"]').prop("selected", true);
						$("#ALU_NombreEmpresa").val($(json.data)[0][26]);
						$("#ALU_NombreEmpresa").siblings("label").addClass("active");
						$('#RUB_Id option[value="' + $(json.data)[0][27] + '"]').prop("selected", true);

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
						if($(json.data)[0][32]==1){
							$("#ALU_PermisoCapacitacionEnOrganizacion").attr("checked","checked");
						}else{
							$("#ALU_PermisoCapacitacionEnOrganizacion").removeAttr("checked");
						}										
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
					}else{
						$("#btn_frmaddbeneficiarios").addClass("btn-success");
						$("#btn_frmaddbeneficiarios").removeClass("btn-warning");
						$("#btn_frmaddbeneficiarios").html("<i class='fas fa-plus'></i> Agregar");
						target="/agregar-beneficiario"
						$("#frmaddbeneficiarios").attr("action",target);
						$("#ALU_FichaX").attr("required","required");

						var ALU_Rut = $("#ALU_Rut").val();

						$("#frmbeneficiariostab1")[0].reset();
						$("#frmbeneficiariostab2")[0].reset();
						$("#frmbeneficiariostab3")[0].reset();										

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
				}
			})
		}	//function
		
		$("#btn_frmaddbeneficiarios").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frmbeneficiariostab1");
			formValidate("#frmbeneficiariostab2");
			formValidate("#frmbeneficiariostab3");
			var frm1=false;
			var frm2=false;
			var frm3=false;
			if($("#frmbeneficiariostab1").valid()){
				frm1=true;
			}
			if($("#frmbeneficiariostab2").valid()){
				frm2=true;
			}
			if($("#frmbeneficiariostab3").valid()){
				frm3=true;
			}
			if(frm1 && frm2 && frm3){				
				var ALU_Rut = $("#ALU_Rut").val().replace(/[($)\s\._\-]+/g, '');
				
				var data1 = $("#frmbeneficiariostab1").serializeArray();
				var data2 = $("#frmbeneficiariostab2").serializeArray();
				var data3 = $("#frmbeneficiariostab3").serializeArray();
				
				var formdata = new FormData();							
				var file_data = $('#ALU_Ficha').prop('files');				
				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i])
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
				$.ajax({
					url: $("#frmaddbeneficiarios").attr("action"),
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
								$("#frmbeneficiariostab1")[0].reset();
								$("#frmbeneficiariostab2")[0].reset();
								$("#frmbeneficiariostab3")[0].reset();

								$("#ALU_Rut").val("");						
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
								  title: 'Beneficiario agregado exitosamente.'
								});
								
								var data={ALU_Rut:ALU_Rut,mode:'mod'}								
								$.ajax( {
									type:'POST',
									url: '/modal-beneficiarios',
									data: data,
									success: function ( data ) {
										param = data.split(bb)
										if(param[0]==200){							
											$("#beneficiariosModal").html(param[1]);
											$("#beneficiariosModal").modal("show");
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
		
		$("#btn_frmbeneficiariostab4_1").on("click",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$.ajax({
				type: 'POST',
				url: '/consultar-beneficiario',
				data: {ALU_Rut:$("#ALU_Rut").val().replace(/\./g, '').replace("-","")},
				dataType: "json",
				success: function(json) {					
					benproyectosTable.ajax.reload(null, false);					
					if((json.data.length==0)){
						//No existe
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'ERROR!',
							text:'Debes grabar los datos del beneficiario antes de asignarle uno o mas proyectos'
						});
					}else{
						formValidate("#frmbeneficiariostab4");
						if($("#frmbeneficiariostab4").valid()){
							$.ajax({
								type: "POST",
								url: "/asociar-proyecto-beneficiario",
								data: {PRY_Id:$("#PRY_IdBen").val(),ALU_Rut:$("#ALU_Rut").val()},
								dataType: "json",
								success: function(data) {
									if(data.state=='200'){
										benproyectosTable.ajax.reload(null, false);
										Toast.fire({
											icon: 'success',
											title: 'Proyecto agregado exitosamente.'
										});
										$("#PRY_NombreBen").val("");
										$("#PRY_IdBen").val("");							
										$("#beneficiarios4-tab").find("span.badge").html(data.contPRY);
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
					}
				}
			})			
		})

		$("#beneficiariostab4").on("click",".delpryben",function(){
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
				text: "Al eliminar esta asociación se eliminarán todos los estados que tenga creados el beneficiario.",
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
						url: "/desasociar-proyecto-beneficiario",
						data: {PRY_Id:$(this).data("pry"),ALU_Rut:$("#ALU_Rut").val()},
						dataType: "json",
						success: function(data) {
							if(data.state=='200'){
								benproyectosTable.ajax.reload(null, false);
								Toast.fire({
									icon: 'success',
									title: 'Proyecto eliminado exitosamente.'
								});
								$("#PRY_NombreBen").val("");
								$("#PRY_IdBen").val("");							
								$("#beneficiarios4-tab").find("span.badge").html(data.contPRY);
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