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
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_InformeInicioEstado		= rs("PRY_InformeInicioEstado")		
		PRY_InformeFinalEstado		= rs("PRY_InformeFinalEstado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeInicioAceptado 	= rs("PRY_InformeInicioAceptado")
		PRY_InformeInicialAceptado	= rs("PRY_InformeInicialAceptado")
		PRY_Identificador			= rs("PRY_Identificador")
		PRY_Estado					= rs("PRY_Estado")
		LFO_Id						= rs("LFO_Id")
		PRY_EmpresaEjecutora		= rs("PRY_EmpresaEjecutora")
		PRY_Nombre					= rs("PRY_Nombre")
		REG_Nombre					= rs("REG_Nombre")
		PRY_EncargadoProyecto		= rs("PRY_EncargadoProyecto")
		PRY_EncargadoProyectoMail	= rs("PRY_EncargadoProyectoMail")
		PRY_EncargadoProyectoCelular= rs("PRY_EncargadoProyectoCelular")
		SEX_IdEncargadoProyecto		= rs("SEX_IdEncargadoProyecto")
		
		PRY_EncargadoActividades	= rs("PRY_EncargadoActividades")
		PRY_EncargadoActividadesMail= rs("PRY_EncargadoActividadesMail")
		PRY_EncargadoActividadesCelular=rs("PRY_EncargadoActividadesCelular")
		SEX_IdEncargadoActividades	= rs("SEX_IdEncargadoActividades")
		MET_Id = rs("MET_Id")
		MET_Descripcion = rs("MET_Descripcion")
		
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
			
	response.write("200//")%>
	
	<form role="form" action="" method="POST" name="frmAdecuacionadd" id="frmAdecuacionadd" class="form-signin needs-validation" style="padding-left: 30px;">		
		<h5>Adecuación</h5>
		<h6>Ingreso de solicitud</h6>
		<div class="row">
			<div class="col-sm-12 col-md-2 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="TAD_Id" id="TAD_Id" class="validate select-text form-control" required data-msg="Debes seleccionar un tipo de adecuación">
								<option value="" disabled selected></option><%													
								set rs = cnn.Execute("exec spTiposAdecuaciones_Listar 1")
								on error resume next					
								do While Not rs.eof
									if(PRY_InformeInicioAceptado or PRY_InformeInicialAceptado) then
										if(LFO_Id=10 or LFO_Id=12) then										
											if(rs("TAD_Id")<>9 and rs("TAD_Id")<>10 and rs("TAD_Id")<>11) then%>
												<option value="<%=rs("TAD_Id")%>"><%=rs("TAD_Descripcion")%></option><%
											end if
										else
											if(rs("TAD_Id")<>5) and  (rs("TAD_Id")<>6) and (rs("TAD_Id")<>8) and (rs("TAD_Id")<>12) and (rs("TAD_Id")<>13) then%>
												<option value="<%=rs("TAD_Id")%>"><%=rs("TAD_Descripcion")%></option><%
											end if
										end if
									else
										if(rs("TAD_Id")=12 or rs("TAD_Id")=13) then%>
											<option value="<%=rs("TAD_Id")%>"><%=rs("TAD_Descripcion")%></option><%
										end if
									end if
									rs.movenext						
								loop
								rs.Close%>
							</select>														
							<i class="fas fa-list-ol input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Tipo Adecuacion</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-3 col-lg-7">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-comment input-prefix"></i>													
						<input type="text" id="ADE_DescripcionAdecuacion" name="ADE_DescripcionAdecuacion" class="form-control" required value="<%=ADE_DescripcionAdecuacion%>" data-msg="Ingresa una descripción del motivo de la adecuación">
						<span class="select-bar"></span>
						<label for="ADE_DescripcionAdecuacion" class="<%=lblClass%>">Descripción Adecuación</label>
					</div>
				</div>
			</div><%
			set rs = cnn.Execute("SELECT CONVERT(VARCHAR(10), getdate(),111) AS DATE;")
			on error resume next					
			if Not rs.eof then
				ADE_FechaSolicitud=replace(rs("date"),"/","-")
			end if%>
			<div class="col-sm-12 col-md-3 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-calendar input-prefix"></i>													
						<input type="text" id="ADE_FechaSolicitud" name="ADE_FechaSolicitud" class="form-control" readonly value="<%=ADE_FechaSolicitud%>">
						<span class="select-bar"></span>
						<label for="ADE_FechaSolicitud" class="active">Fecha Solicitud</label>
					</div>
				</div>
			</div>
			
		</div>
		<div class="row">
			<div class="col-sm-12 col-md-3 col-lg-8">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-comment input-prefix"></i>													
						<input type="text" id="ADE_JustificacionAdecuacion" name="ADE_JustificacionAdecuacion" class="form-control" required value="<%=ADE_JustificacionAdecuacion%>" data-msg="Ingresa una justificación para la adecuación">
						<span class="select-bar"></span>
						<label for="ADE_JustificacionAdecuacion" class="<%=lblClass%>">Justificación Adecuación</label>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-3 col-lg-4">
				<div class="md-form input-with-post-icon">
					<div class="error-message">														
						<i class="fas fa-cloud-upload-alt input-prefix"></i>
						<input type="text" id="ADE_AdjuntoX" name="ADE_AdjuntoX" class="form-control" required readonly data-msg="Debes anexar un archivo de apoyo para la solicitud">						
						<input type="file" id="ADE_Adjunto" name="ADE_Adjunto" readonly multiple accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
						<span class="select-bar"></span>
						<label for="ADE_AdjuntoX" class="<%=lblClass%>">Adjuntos</label>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
		<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">									
	</form>	

	<div id="ade-1" style="padding-left: 30px;">	<!--Calendarizacion-->
		<h5>Adecuación</h5>
		<h6>Calendarización</h6><%
		if(LFO_Id<>11) then%>
			<form role="form" action="" method="POST" name="frmCalendarizacion" id="frmCalendarizacion" class="form-signin needs-validation">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-1">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-hashtag input-prefix"></i>													
								<input type="text" id="PLN_Sesion" name="PLN_Sesion" class="form-control" readonly value="<%=PLN_Sesion%>" required>
								<span class="select-bar"></span>
								<label for="PLN_Sesion" class="">Sesión</label>
							</div>
						</div>
					</div>					
					<div class="col-sm-12 col-md-3 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-book-reader input-prefix"></i>													
								<input type="text" id="TEM_Nombre" name="TEM_Nombre" class="form-control" readonly value="<%=TEM_Nombre%>" required data-msg="Debes seleccionar un módulo">
								<span class="select-bar"></span>
								<label for="TEM_Nombre" class="">Módulo</label>
							</div>
						</div>
					</div>				
					<div class="col-sm-12 col-md-3 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-calendar input-prefix"></i>													
								<input type="text" id="PLN_Fecha" name="PLN_Fecha" class="form-control calendario" value="<%=PLN_Fecha%>" required readonly data-msg="Debes seleccionar una fecha">
								<span class="select-bar"></span>
								<label for="PLN_Fecha" class="">Fecha</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-3 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="PLN_HoraInicio" name="PLN_HoraInicio" class="form-control hora" value="<%=PLN_HoraInicio%>" required readonly data-msg="Debes seleccionar una hora de inicio">
								<span class="select-bar"></span>
								<label for="PLN_HoraInicio" class="">Inicio</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-3 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="PLN_HoraFin" name="PLN_HoraFin" class="form-control hora" value="<%=PLN_HoraFin%>" required readonly data-msg="Debes seleccionar una hora de término">
								<span class="select-bar"></span>
								<label for="PLN_HoraFin" class="">Fin</label>
							</div>
						</div>
					</div>					
					<div class="col-sm-12 col-md-3 col-lg-2"><%
						if(MET_Id=3) then%>
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<div class="select">
										<select name="MET_Id" id="MET_Id-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" class="validate select-text form-control" required data-msg="Debes seleccionar una metodología">										
											<option value="" selected></option><%											
											set rsw = cnn.Execute("exec spMetodologia_Listar 1")
											on error resume next					
											do While Not rsw.eof
												if(rsw("MET_Id")<MET_Id) then
													if rsw("MET_Id")=MET_Id then%>
														<option value="<%=rsw("MET_Id")%>" selected ><%=rsw("MET_Descripcion")%></option><%
													else%>
														<option value="<%=rsw("MET_Id")%>"><%=rsw("MET_Descripcion")%></option><%
													end if
												end if
												rsw.movenext						
											loop
											rsw.Close%>
										</select>
										<i class="fas fa-graduation-cap input-prefix"></i>
										<span class="select-highlight"></span>
										<span class="select-bar"></span>
										<label class="select-label ">Metodología</label>
									</div>
								</div>
							</div><%
						else%>
							<input type="hidden" name="MET_Id" id="MET_Id-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" value="<%=MET_Id%>" readonly="<%=readonly%>" <%=disabled%>>
							<%=MET_Descripcion%><%
						end if%>
					</div>					
				</div>
			</form><%
		end if		
		if(LFO_Id=11) then%>
			<form role="form" action="" method="POST" name="frmCalendarizacion" id="frmCalendarizacion" class="form-signin needs-validation">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-1">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-hashtag input-prefix"></i>													
								<input type="text" id="TED_Id" name="TED_Id" class="form-control" readonly required>
								<span class="select-bar"></span>
								<label for="TED_Id" class="">Id</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-tag input-prefix"></i>													
								<input type="text" id="TIM_NombreMesa" name="TIM_NombreMesa" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TIM_NombreMesa" class="">Hito</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-user input-prefix"></i>													
								<input type="text" id="TED_Relator" name="TED_Relator" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_Relator" class="">Relator</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-5">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-book input-prefix"></i>													
								<input type="text" id="TED_Nombre" name="TED_Nombre" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_Nombre" class="">Temática</label>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-calendar input-prefix"></i>													
								<input type="text" id="TED_FechaAde" name="TED_FechaAde" class="form-control calendario" required readonly>
								<span class="select-bar"></span>
								<label for="TED_FechaAde" class="">Fecha</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="TED_HoraInicio" name="TED_HoraInicio" class="form-control hora" required>
								<span class="select-bar"></span>
								<label for="TED_HoraInicio" class="">Hora Inicio</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="TED_HoraTermino" name="TED_HoraTermino" class="form-control hora" required>
								<span class="select-bar"></span>
								<label for="TED_HoraTermino" class="">Hora Término</label>
							</div>
						</div>
					</div>					
				</div>
			</form><%
		end if%>
	</div>
	<div id="ade-2" style="padding-left: 30px;">	<!--Lugar-->
		<div class="row">

		</div>
	</div>
	<div id="ade-3" style="padding-left: 30px;">	<!--Coordinador de Proyecto-->
		<h5>Adecuación</h5>
		<h6>Coordinador/a de Proyecto</h6>		
		<form role="form" action="" method="POST" name="frmCoordinadorProyecto" id="frmCoordinadorProyecto" class="form-signin needs-validation">
			<div class="row align-items-center">
				<div class="col-sm-12 col-md-12 col-lg-3">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-user input-prefix"></i>													
							<input type="text" id="PRY_EncargadoProyecto" name="PRY_EncargadoProyecto" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoProyecto" class="">Nombre</label>
						</div>
					</div>
				</div>					
				<div class="col-sm-12 col-md-3 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-envelope input-prefix"></i>													
							<input type="email" id="PRY_EncargadoProyectoMail" name="PRY_EncargadoProyectoMail" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoProyectoMail" class="">Mail</label>
						</div>
					</div>
				</div>				
				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-movile-alt input-prefix"></i>													
							<input type="text" id="PRY_EncargadoProyectoCelular" name="PRY_EncargadoProyectoCelular" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoProyectoCelular" class="">Telefono</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3" style="text-align: left;">			
					<label for="SEX_IdEncargadoProyecto" class="radiolabel">Sexo</label>
					<div class="md-radio radio-lightBlue md-radio-inline">
						<input id="SEX_IdEncargadoProyectofemeninoADE" type="radio" name="SEX_IdEncargadoProyectoADE" checked value="1" required="">						
						<label for="SEX_IdEncargadoProyectofemeninoADE">Femenino</label>
					</div>
					<div class="md-radio radio-lightBlue md-radio-inline">
						<input id="SEX_IdEncargadoProyectomasculinoADE" type="radio" name="SEX_IdEncargadoProyectoADE" value="2" required="">						
						<label for="SEX_IdEncargadoProyectomasculinoADE">Masculino</label>
					</div>					
				</div>
			</div><%
			if(LFO_Id<>11) then%>
				<div class="row">
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">														
								<i class="fas fa-cloud-upload-alt input-prefix"></i>
								<input type="text" id="CAD_AdjuntoX" name="CAD_AdjuntoX" class="form-control" required readonly>						
								<input type="file" id="CAD_Adjunto" name="CAD_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
								<span class="select-bar"></span>
								<label for="CAD_AdjuntoX" class="<%=lblClass%>">Adjunto</label>
							</div>
						</div>
					</div>			
				</div><%
			else%>
				<div class="row">
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<div class="select">
									<select name="EDU_IdEncargadoProyecto" id="EDU_IdEncargadoProyecto" class="validate select-text form-control" required>
										<option value="" disabled selected></option><%													
										set rx = cnn.Execute("exec spEducacion_Listar")
										on error resume next					
										do While Not rx.eof
											if(EDU_IdEncargadoProyecto=rx("EDU_Id")) then%>
												<option value="<%=rx("EDU_Id")%>" selected><%=rx("EDU_Nombre")%></option><%
											else%>
												<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
											end if								
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
								<i class="fas fa-movile-alt input-prefix"></i>													
								<input type="text" id="PRY_EncargadoProyectoCarrera" name="PRY_EncargadoProyectoCarrera" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_EncargadoProyectoCarrera" class="">Nombre Carrera</label>
							</div>
						</div>
					</div>
				</div><%
			end if%>
		</form>
	</div>
	<div id="ade-4" style="padding-left: 30px;">	<!--Encargado de Actividades-->
		<h5>Adecuación</h5>
		<h6>Encargado/a de Activiades</h6>			
		<form role="form" action="" method="POST" name="frmEncargadoActividades" id="frmEncargadoActividades" class="form-signin needs-validation">
			<div class="row align-items-center">
				<div class="col-sm-12 col-md-12 col-lg-3">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-user input-prefix"></i>													
							<input type="text" id="PRY_EncargadoActividades" name="PRY_EncargadoActividades" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoActividades" class="">Nombre</label>
						</div>
					</div>
				</div>					
				<div class="col-sm-12 col-md-3 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-envelope input-prefix"></i>													
							<input type="text" id="PRY_EncargadoActividadesMail" name="PRY_EncargadoActividadesMail" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoActividadesMail" class="">Mail</label>
						</div>
					</div>
				</div>				
				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-movile-alt input-prefix"></i>													
							<input type="text" id="PRY_EncargadoActividadesCelular" name="PRY_EncargadoActividadesCelular" class="form-control" value="" required>
							<span class="select-bar"></span>
							<label for="PRY_EncargadoActividadesCelular" class="">Telefono</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-6 col-lg-3" style="text-align: left;">			
					<label for="SEX_IdEncargadoActividades" class="radiolabel">Sexo</label>
					<div class="md-radio radio-lightBlue md-radio-inline">
						<input id="SEX_IdEncargadoActividadesfemeninoADE" type="radio" name="SEX_IdEncargadoActividadesADE" checked value="1" required="">						
						<label for="SEX_IdEncargadoActividadesfemeninoADE">Femenino</label>
					</div>
					<div class="md-radio radio-lightBlue md-radio-inline">
						<input id="SEX_IdEncargadoActividadesmasculinoADE" type="radio" name="SEX_IdEncargadoActividadesADE" value="2" required="">						
						<label for="SEX_IdEncargadoActividadesmasculinoADE">Masculino</label>
					</div>					
				</div>
			</div><%
			if(LFO_Id<>11) then%>
				<div class="row">
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">														
								<i class="fas fa-cloud-upload-alt input-prefix"></i>
								<input type="text" id="EAD_AdjuntoX" name="EAD_AdjuntoX" class="form-control" required readonly>						
								<input type="file" id="EAD_Adjunto" name="EAD_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
								<span class="select-bar"></span>
								<label for="EAD_AdjuntoX" class="<%=lblClass%>">Adjunto</label>
							</div>
						</div>			
					</div>
				</div><%
			else%>
				<div class="row">
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<div class="select">
									<select name="EDU_IdEncargadoActividades" id="EDU_IdEncargadoActividades" class="validate select-text form-control" required>
										<option value="" disabled selected></option><%													
										set rx = cnn.Execute("exec spEducacion_Listar")
										on error resume next					
										do While Not rx.eof
											if(EDU_IdEncargadoActividades=rx("EDU_Id")) then%>
												<option value="<%=rx("EDU_Id")%>" selected><%=rx("EDU_Nombre")%></option><%
											else%>
												<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
											end if								
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
								<i class="fas fa-movile-alt input-prefix"></i>													
								<input type="text" id="PRY_EncargadoActividadesCarrera" name="PRY_EncargadoActividadesCarrera" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_EncargadoActividadesCarrera">Nombre Carrera</label>
							</div>
						</div>
					</div>
				</div><%
			end if%>
		</form>
	</div><%
	if(LFO_Id=11) then%>
		<div id="ade-9" style="padding-left: 30px;">	<!--Facilitador/a-->
			<h5>Adecuación</h5>
			<h6>Facilitador/a</h6>			
			<form role="form" action="" method="POST" name="frmFacilitador" id="frmFacilitador" class="form-signin needs-validation">
				<div class="row align-items-center">
					<div class="col-sm-12 col-md-12 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-user input-prefix"></i>													
								<input type="text" id="PRY_Facilitador" name="PRY_Facilitador" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_Facilitador">Nombre</label>
							</div>
						</div>
					</div>					
					<div class="col-sm-12 col-md-3 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-envelope input-prefix"></i>													
								<input type="text" id="PRY_FacilitadorMail" name="PRY_FacilitadorMail" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_FacilitadorMail">Mail</label>
							</div>
						</div>
					</div>				
					<div class="col-sm-12 col-md-3 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-movile-alt input-prefix"></i>													
								<input type="text" id="PRY_FacilitadorCelular" name="PRY_FacilitadorCelular" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_FacilitadorCelular">Telefono</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3" style="text-align: left;">			
						<label for="SEX_IdFacilitadorADE" class="radiolabel">Sexo</label>
						<div class="md-radio radio-lightBlue md-radio-inline">
							<input id="SEX_IdFacilitadorfemeninoADE" type="radio" name="SEX_IdFacilitadorADE" checked value="1" required="">						
							<label for="SEX_IdFacilitadorfemeninoADE">Femenino</label>
						</div>
						<div class="md-radio radio-lightBlue md-radio-inline">
							<input id="SEX_IdFacilitadormasculinoADE" type="radio" name="SEX_IdFacilitadorADE" value="2" required="">						
							<label for="SEX_IdFacilitadormasculinoADE">Masculino</label>
						</div>					
					</div>
				</div>
				<div class="row align-items-center">
					<div class="col-sm-12 col-md-3 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<div class="select">
									<select name="EDU_IdFacilitador" id="EDU_IdFacilitador" class="validate select-text form-control" required>
										<option value="" disabled selected></option><%													
										set rx = cnn.Execute("exec spEducacion_Listar")
										on error resume next					
										do While Not rx.eof
											if(EDU_IdFacilitador=rx("EDU_Id")) then%>
												<option value="<%=rx("EDU_Id")%>" selected><%=rx("EDU_Nombre")%></option><%
											else%>
												<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
											end if								
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
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-movile-alt input-prefix"></i>													
								<input type="text" id="PRY_FacilitadorCarrera" name="PRY_FacilitadorCarrera" class="form-control" value="" required>
								<span class="select-bar"></span>
								<label for="PRY_FacilitadorCarrera" class="">Nombre Carrera</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-3 col-lg-3" style="text-align: left;">			
						<label for="PRY_FacilitidorForEspADE" class="radiolabel">Formación Especializada</label>
						<div class="md-radio radio-lightBlue md-radio-inline">
							<input id="PRY_FacilitidorForEspSIADE" type="radio" name="PRY_FacilitidorForEspADE" checked value="1" required>
							<label for="PRY_FacilitidorForEspSIADE">Si</label>
						</div>
						<div class="md-radio radio-lightBlue md-radio-inline">
							<input id="PRY_FacilitidorForEspNOADE" type="radio" name="PRY_FacilitidorForEspADE" value="2" required>
							<label for="PRY_FacilitidorForEspNOADE">No</label>
						</div>			
					</div>
				</div>
			</form>
		</div><%
	end if%>		
	<div id="ade-5" style="padding-left: 30px;">	<!--Relator-->
		<h5>Adecuación</h5>
		<h6>Relator</h6><%
		if(LFO_Id<>11) then%>
			<form role="form" action="" method="POST" name="frmRelator" id="frmRelator" class="form-signin needs-validation">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-hashtag input-prefix"></i>													
								<input type="text" id="PLN_Sesion" name="PLN_Sesion" class="form-control" readonly value="<%=PLN_Sesion%>" required>
								<span class="select-bar"></span>
								<label for="PLN_Sesion" class="">Sesión</label>
							</div>
						</div>
					</div>					
					<div class="col-sm-12 col-md-3 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-book-reader input-prefix"></i>													
								<input type="text" id="TEM_Nombre" name="TEM_Nombre" class="form-control" readonly value="<%=TEM_Nombre%>" required>
								<span class="select-bar"></span>
								<label for="TEM_Nombre" class="">Módulo</label>
							</div>
						</div>
					</div>					
					<div class="col-sm-12 col-md-3 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<div class="select">
									<i class="fas fa-user-graduate input-prefix"></i>
									<select name="REL_Id" id="REL_Id" class="validate select-text form-control" <%=sltdisabled%>>
										<option value="" selected disabled></option><%										
										set rsw = cnn.Execute("exec [spRelatorProyectoxProyecto_Listar] " & PRY_Id & ",1")
										on error resume next					
										do While Not rsw.eof%>												
											<option value="<%=rsw("REL_Id")%>"><%=rsw("REL_Nombres") & " " & rsw("REL_Paterno") & " " & rsw("REL_Materno")%></option><%											
											rsw.movenext
										loop
										rsw.Close%>
									</select>									
									<span class="select-bar"></span>
									<label class="select-label ">Relator</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</form><%
		end if
		if(LFO_Id=11) then%>
			<form role="form" action="" method="POST" name="frmRelator" id="frmRelator" class="form-signin needs-validation">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-1">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-hashtag input-prefix"></i>													
								<input type="text" id="TED_Id" name="TED_Id" class="form-control" readonly required>
								<span class="select-bar"></span>
								<label for="TED_Id" class="">Id</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-tag input-prefix"></i>													
								<input type="text" id="TIM_NombreMesa" name="TIM_NombreMesa" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TIM_NombreMesa" class="">Hito</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-user input-prefix"></i>													
								<input type="text" id="TED_Relator" name="TED_Relator" class="form-control" required>
								<span class="select-bar"></span>
								<label for="TED_Relator" class="">Relator</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-5">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-book input-prefix"></i>													
								<input type="text" id="TED_Nombre" name="TED_Nombre" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_Nombre" class="">Temática</label>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-calendar input-prefix"></i>													
								<input type="text" id="TED_FechaAde" name="TED_FechaAde" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_FechaAde" class="">Fecha</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="TED_HoraInicio" name="TED_HoraInicio" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_HoraInicio" class="">Hora Inicio</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-12 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-clock input-prefix"></i>													
								<input type="text" id="TED_HoraTermino" name="TED_HoraTermino" class="form-control" readonly>
								<span class="select-bar"></span>
								<label for="TED_HoraTermino" class="">Hora Término</label>
							</div>
						</div>
					</div>					
				</div>
			</form><%
		end if%>
	</div>
	<div id="ade-6" style="padding-left: 30px;">	<!--Justificación de inasistencia-->
		<h5>Adecuación</h5>
		<h6>Justificación de Inasistencia</h6>			
		<form role="form" action="" method="POST" name="frmJustificacion" id="frmJustificacion" class="form-signin needs-validation">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-address-card input-prefix"></i>													
							<input type="text" id="ALU_Rut" name="ALU_Rut" class="form-control" value="<%=ALU_Rut%>" required readonly>
							<span class="select-bar"></span>
							<label for="ALU_Rut" class="">RUT</label>
						</div>
					</div>
				</div>	
				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-hashtag input-prefix"></i>													
							<input type="text" id="PLN_Sesion" name="PLN_Sesion" class="form-control" value="<%=PLN_Sesion%>" required readonly>
							<span class="select-bar"></span>
							<label for="PLN_Sesion" class="">Sesión</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-calendar-day input-prefix"></i>													
							<input type="text" id="DIA_Inacistencia" name="DIA_Inacistencia" class="form-control" value="<%=DIA_Inacistencia%>" required readonly>
							<span class="select-bar"></span>
							<label for="DIA_Inacistencia" class="">Dia</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-3 col-lg-6">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-book-reader input-prefix"></i>													
							<input type="text" id="TEM_Inacistencia" name="TEM_Inacistencia" class="form-control" readonly value="<%=TEM_Inacistencia%>" required>
							<span class="select-bar"></span>
							<label for="TEM_Inacistencia" class="">Módulo</label>
						</div>
					</div>
				</div>				
			</div>
		</form>
	</div>
	<div id="ade-8" style="padding-left: 30px;">	<!--Desvinculacion de alumno al proyecto-->
		<h5>Adecuación</h5>
		<h6>Desvinculacion de Alumno al Proyecto</h6>			
		<form role="form" action="" method="POST" name="frmDesvinculacion" id="frmDesvinculacion" class="form-signin needs-validation">
			<div class="row">
				<div class="col-sm-12 col-md-2 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">								
							<i class="fas fa-id-card input-prefix"></i>
							<input type="text" id="ALU_RutDes" name="ALU_RutDes" class="form-control rut" required value="<%=ALU_Rut%>">
							<span class="select-bar"></span>
							<label for="ALU_RutDes" class="<%=lblClass%>">Rut</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-4 col-lg-3">
					<div class="md-form input-with-post-icon">
						<div class="error-message">								
							<i class="fas fa-user input-prefix"></i>
							<input type="text" id="ALU_NombreDes" name="ALU_NombreDes" class="form-control" readonly value="<%=ALU_Nombre%>">
							<span class="select-bar"></span>
							<label for="ALU_NombreDes" class="<%=lblClass%>">Nombres</label>
						</div>
					</div>
				</div>

				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">								
							<i class="fas fa-user input-prefix"></i>
							<input type="text" id="ALU_ApellidoPaternoDes" name="ALU_ApellidoPaternoDes" class="form-control" readonly value="<%=ALU_ApellidoPaterno%>">
							<span class="select-bar"></span>
							<label for="ALU_ApellidoPaternoDes" class="<%=lblClass%>">Apellido Paterno</label>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-3 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">								
							<i class="fas fa-user input-prefix"></i>
							<input type="text" id="ALU_ApellidoMaternoDes" name="ALU_ApellidoMaternoDes" class="form-control" readonly value="<%=ALU_ApellidoMaterno%>">
							<span class="select-bar"></span>
							<label for="ALU_ApellidoMaternoDes" class="<%=lblClass%>">Apellido Materno</label>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="ade-12" style="padding-left: 30px;">	<!--Porcentaje Focalización-->
		<h5>Adecuación</h5>
		<h6>Porcentaje Focalización</h6>		
		<form role="form" action="" method="POST" name="frmPorcentajeFocalizacion" id="frmPorcentajeFocalizacion" class="form-signin needs-validation">
			<div class="row align-items-center">
				<div class="col-sm-12 col-md-12 col-lg-3">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-percentage input-prefix"></i>													
							<input type="number" id="GRF_Porcentaje" name="GRF_Porcentaje" class="form-control" value="" required data-msg="Ingresa un porcentaje válido" min="1" max="100">
							<span class="select-bar"></span>
							<label for="GRF_Porcentaje" class="">Porcentaje</label>
						</div>
					</div>
				</div>						
			</div>
		</form>
	</div><%
	if(LFO_Id<>11) then%>
		<div id="ade-13" style="padding-left: 30px;">	<!--Porcentaje Cumplimiento Metodologías-->
			<h5>Adecuación</h5>
			<h6>Porcentaje Cumplimiento Metodologías</h6>		
			<form role="form" action="" method="POST" name="frmPorcentajeMetodologias" id="frmPorcentajeMetodologias" class="form-signin needs-validation">
				<div class="row align-items-center"><%
					if(MET_Id=1 or MET_Id=3) then%>
						<div class="col-sm-12 col-md-6 col-lg-3">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-percentage input-prefix"></i>													
									<input type="number" id="PRY_PorcentajeMinOnlineADE" name="PRY_PorcentajeMinOnlineADE" class="form-control" value="" required data-msg="Ingresa un porcentaje válido" min="1" max="100">
									<span class="select-bar"></span>
									<label for="PRY_PorcentajeMinOnlineADE" class="">Porcentaje mínimo clases online</label>
								</div>
							</div>
						</div><%
					end if
					if(MET_Id=2 or MET_Id=3) then%>
						<div class="col-sm-12 col-md-6 col-lg-3">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-percentage input-prefix"></i>													
									<input type="number" id="PRY_PorcentajeMinPresencialADE" name="PRY_PorcentajeMinPresencialADE" class="form-control" value="" required data-msg="Ingresa un porcentaje válido" min="1" max="100">
									<span class="select-bar"></span>
									<label for="PRY_PorcentajeMinPresencialADE" class="">Porcentaje mínimo clases presenciales</label>
								</div>
							</div>
						</div>
					<%end if%>
				</div>
			</form>
		</div><%
	end if%>

	<form role="form" action="" method="POST" name="frmaddadecuaciones" id="frmaddadecuaciones" class="form-signin needs-validation" style="padding-left: 30px;"><%
		if ((PRY_InfFinal=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InfFinal=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>							
			<button type="button" class="btn btn-primary btn-md waves-effect waves-dark" id="btn_frmaddadecuaciones" name="btn_frmaddadecuaciones" style="float:right;"><i class="fas fa-plus"></i> Solicitar</button><%
		end if%>
		<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_saliradecuaciones" name="btn_saliradecuaciones" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>											
	</form>
	<!--form-->

	<script>
		$("#frmPorcentajeMetodologias").on("change","#PRY_PorcentajeMinOnlineADE", function(e){			
			e.preventDefault();
			e.stopPropagation();			
			var PRY_PorcentajeMinOnline = parseInt($("#PRY_PorcentajeMinOnlineADE").val());			
			$("#PRY_PorcentajeMinPresencialADE").val(100-PRY_PorcentajeMinOnline);
		})
		$("#frmPorcentajeMetodologias").on("change","#PRY_PorcentajeMinPresencialADE", function(e){		
			e.preventDefault();
			e.stopPropagation();			
			var PRY_PorcentajeMinPresencial = parseInt($("#PRY_PorcentajeMinPresencialADE").val());
			$("#PRY_PorcentajeMinOnlineADE").val(100-PRY_PorcentajeMinPresencial);			
		})
	</script>