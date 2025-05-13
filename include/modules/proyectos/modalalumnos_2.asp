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
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
		modo=4
		mode="vis"
	end if		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
	end if
	response.write("200//")%>
	<!--container-nav-->
	<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;">
		<div class="header">				
			<div class="content-nav">
				<a id="alumno1-tab" href="#alumnotab1" class="active tab"><i class="fas fa-user"></i> Datos personales
				</a>
				<a id="alumno2-tab" href="#alumnotab2" class="tab"><i class="fas fa-map-marker-alt"></i> Datos de ubicación
				</a>
				<a id="alumno3-tab" href="#alumnotab3" class="tab"><i class="fas fa-building"></i> Datos sindicales
				</a>
				<span class="yellow-bar"></span>
				<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
					<div class="animated-icon1"><span></span><span></span><span></span></div>
				</button>
			</div>
		</div>
		<!--tab-content-->
		<div class="tab-content tab-validate">
			<!--alumnotab1-->
			<div id="alumnotab1" class="tabs-pane">
				<form role="form" action="" method="POST" name="frmalumnotab1" id="frmalumnotab1" class="form-signin needs-validation" style="padding-left: 30px;">
					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-id-card input-prefix"></i>
									<input type="text" id="ALU_Rut" name="ALU_Rut" class="form-control rut" required value="<%=ALU_Rut%>">
									<span class="select-bar"></span>
									<label for="ALU_Rut" class="<%=lblClass%>">Rut</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-4 col-lg-3">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-user input-prefix"></i>
									<input type="text" id="ALU_Nombre" name="ALU_Nombre" class="form-control" required value="<%=ALU_Nombre%>">
									<span class="select-bar"></span>
									<label for="ALU_Nombre" class="<%=lblClass%>">Nombres</label>
								</div>
							</div>
						</div>

						<div class="col-sm-12 col-md-3 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-user input-prefix"></i>
									<input type="text" id="ALU_ApellidoPaterno" name="ALU_ApellidoPaterno" class="form-control" required value="<%=ALU_ApellidoPaterno%>">
									<span class="select-bar"></span>
									<label for="ALU_ApellidoPaterno" class="<%=lblClass%>">Apellido Paterno</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-3 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-user input-prefix"></i>
									<input type="text" id="ALU_ApellidoMaterno" name="ALU_ApellidoMaterno" class="form-control" required value="<%=ALU_ApellidoMaterno%>">
									<span class="select-bar"></span>
									<label for="ALU_ApellidoMaterno" class="<%=lblClass%>">Apellido Materno</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-3 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-calendar input-prefix"></i>
									<input type="text" id="ALU_FechaNacimiento" name="ALU_FechaNacimiento" class="form-control calendario" readonly required value="<%=ALU_FechaNacimiento%>">
									<span class="select-bar"></span>
									<label for="ALU_FechaNacimiento" class="<%=lblClass%>">Fecha Nacimiento</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-3 col-lg-1">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-birthday-cake input-prefix"></i>													
									<input type="number" id="ALU_Edad" name="ALU_Edad" class="form-control" readonly value="">
									<span class="select-bar"></span>
									<label for="ALU_Edad" class="<%=lblClass%>">Edad</label>
								</div>
							</div>
						</div>																				
					</div>

					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
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
						</div><%
						if (LIN_Hombre and LIN_Mujer) then%>
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
							</div><%
						else
							if (LIN_Hombre and not LIN_Mujer) then%>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-mars input-prefix"></i>
											<input type="text" id="SEX_Descripcion" name="SEX_Descripcion" class="form-control" readonly value="Masculino">
											<input type="hidden" id="SEX_Id" name="SEX_Id" value="2">
											<span class="select-bar"></span>
											<label for="SEX_Descripcion" class="active">Sexo</label>
										</div>
									</div>
								</div><%
							else
								if (not LIN_Hombre and LIN_Mujer) then%>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">								
												<i class="fas fa-venus input-prefix"></i>
												<input type="text" id="SEX_Descripcion" name="SEX_Descripcion" class="form-control" readonly value="Femenino">
												<input type="hidden" id="SEX_Id" name="SEX_Id" value="1">
												<span class="select-bar"></span>
												<label for="SEX_Descripcion" class="active">Sexo</label>
											</div>
										</div>
									</div><%
								else%>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">
												<i class="fas fa-genderless input-prefix"></i>													
												<input type="text" id="SEX_Descripcion" name="SEX_Descripcion" class="form-control" required value="No definido">
												<input type="hidden" id="SEX_Id" name="SEX_Id" value="0">
												<span class="select-bar"></span>
												<label for="SEX_Descripcion" class="active">Sexo</label>
											</div>
										</div>
									</div><%
								end if
							end if
						end if%>

						<div class="col-sm-12 col-md-2 col-lg-2">
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
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_Discapacidad" name="ALU_Discapacidad" class="switch__input">
										<label for="ALU_Discapacidad" class="switch__label">Discapacidad?</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-2 col-lg-2 discapacidad">
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
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-calendar input-prefix"></i><%
									'set rs = cnn.Execute("SELECT CONVERT(VARCHAR(10), getdate(),111) AS DATE;")
									'on error resume next					
									'if Not rs.eof then
									'	ALU_FechaCreacionRegistro=replace(rs("date"),"/","-")
									'end if%>
									<input type="text" id="ALU_FechaCreacionRegistro" name="ALU_FechaCreacionRegistro" class="form-control" readonly value="">
									<span class="select-bar"></span>
									<label for="ALU_FechaCreacionRegistro" class="">Fecha de Creación</label>
								</div>
							</div>
						</div>
					</div>								
					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_AccesoInternet" name="ALU_AccesoInternet" class="switch__input">
										<label for="ALU_AccesoInternet" class="switch__label">Acceso a Internet?</label>
									</div>
								</div>
							</div>
						</div>	
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_DispositivoElectronico" name="ALU_DispositivoElectronico" class="switch__input">
										<label for="ALU_DispositivoElectronico" class="switch__label">Dispositivo para acceder a internet?</label>
									</div>
								</div>
							</div>
						</div>	

						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_ReconocePuebloOriginario" name="ALU_ReconocePuebloOriginario" class="switch__input">
										<label for="ALU_ReconocePuebloOriginario" class="switch__label">Pueblo Originario?</label>
									</div>
								</div>
							</div>
						</div>	
						<div class="col-sm-12 col-md-3 col-lg-3" id="PuebloOriginario">
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<i class="fas fa-campground input-prefix"></i>														
									<span class="select-bar"></span>
									<label for="ALU_PuebloOriginario" class="<%=lblClass%>">Pueblo Originario</label>
								</div>
							</div>
						</div>

						<div class="col-sm-12 col-md-3 col-lg-3" id="">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<i class="fas fa-cloud-upload-alt input-prefix"></i>
									<input type="text" id="ALU_FichaX" name="ALU_FichaX" class="form-control" required readonly>
									<input type="file" id="ALU_Ficha" name="ALU_Ficha" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
									<span class="select-bar"></span>
									<label for="ALU_FichaX" class="<%=lblClass%>">Adjunto</label>
								</div>
							</div>
							<div class='progress-bar'><div class='progress'></div></div>
						</div>

					</div>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">									
				</form>
			</div>
			<!--alumnotab1-->

			<!--alumnotab2-->
			<div id="alumnotab2" class="tabs-pane">
				<form role="form" action="" method="POST" name="frmalumnotab2" id="frmalumnotab2" class="form-signin needs-validation" style="padding-left: 30px;">
					<div class="row">																						
						<div class="col-sm-12 col-md-3 col-lg-3">
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
						<div class="col-sm-12 col-md-3 col-lg-3">
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
						<div class="col-sm-12 col-md-6 col-lg-6">
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
						<div class="col-sm-12 col-md-4 col-lg-4">
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
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
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
						<div class="col-sm-12 col-md-4 col-lg-4">
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
			<!--alumnotab2-->

			<!--alumnotab3-->
			<div id="alumnotab3" class="tabs-pane">
				<form role="form" action="" method="POST" name="frmalumnotab3" id="frmalumnotab3" class="form-signin needs-validation" style="padding-left: 30px;">
					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
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
						<div class="col-sm-12 col-md-4 col-lg-4 sindicato" id="sin2">
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
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_PermisoCapacitacionEnOrganizacion" name="ALU_PermisoCapacitacionEnOrganizacion" class="switch__input">
										<label for="ALU_PermisoCapacitacionEnOrganizacion" class="switch__label">Permiso Sindical?</label>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">
										<input type="checkbox" id="ALU_DirigenteSindical" name="ALU_DirigenteSindical" class="switch__input">
										<label for="ALU_DirigenteSindical" class="switch__label">Dirigente Sindical?</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-2 col-lg-2 dirigente">
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<i class="fas fa-calendar input-prefix"></i>														
									<span class="select-bar"></span>
									<label for="ALU_TiempoDirigenteSindical" class="<%=lblClass%>">Fecha incio dirigente</label>
								</div>
							</div>
						</div>								

						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<div class="switch">

										<input type="checkbox" id="ALU_CursosFormacionSindicalAnteriormente" name="ALU_CursosFormacionSindicalAnteriormente" class="switch__input">
										<label for="ALU_CursosFormacionSindicalAnteriormente" class="switch__label">Curso Sindical?</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-4 col-lg-4 curso" id="cur1">
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<i class="fas fa-building input-prefix"></i>														
									<span class="select-bar"></span>
									<label for="ALU_InstitucionCursoFormacionSindical" class="<%=lblClass%>">Institución Curso</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-2 col-lg-2 curso" id="cur2">
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
						<div class="col-sm-12 col-md-2 col-lg-2">
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
									<label for="ALU_FechaInicioCargoDirectivo" class="<%=lblClass%>">Fecha desde Cuándo</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-4 col-lg-4 cargo" id="car2">
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
			</div>
			<!--alumnotab3-->
		</div>
		<!--tab-content-->
	</div>
	<!--container-nav-->

	<form role="form" action="" method="POST" name="frmaddalumnos" id="frmaddalumnos" class="form-signin needs-validation" style="padding-left: 30px;"><%
		if (PRY_InformeFinalEstado=0 and PRY_Estado=1) and (mode="mod") then%>
			<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddalumnos" name="btn_frmaddalumnos" style="float:right;"><i class="fas fa-plus"></i> Agregar</button><%
		else%>
			<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="" name="" style="float:right;" disabled><i class="fas fa-plus"></i> Agregar</button><%
		end if%>
		<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_saliralumnos" name="btn_saliralumnos" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>											
	</form>
	<!--form-->

	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">