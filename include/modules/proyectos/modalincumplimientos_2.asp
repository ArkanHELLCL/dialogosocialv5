<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	'if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	''   response.Write("403\\Error Perfil no autorizado")
	''   response.End() 
	'end if
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=4 then
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
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_InformeInicioEstado		= rs("PRY_InformeInicioEstado")		
		PRY_InformeFinalEstado		= rs("PRY_InformeFinalEstado")
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
		
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if	
		
	response.write("200//")%>
	<!--container-nav-->
	<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;">
		<div class="header">				
			<div class="content-nav"><%
				if(session("ds5_usrperfil")<>3 and session("ds5_usrperfil")<>4) then
					if(session("ds5_usrperfil")<>5) then%>
						<a id="addincumplimiento1-tab" href="#incumplimientostab1" class="active tab"><i class="fas fa-thumbs-down"></i> Agregar Incumplimiento
						</a><%
					end if%>
					<a id="docincumplimiento2-tab" href="#incumplimientostab2" class="tab"><i class="fas fa-file-invoice"></i> Agregar Documentos
					</a><%
				end if%>
				<a id="resincumplimiento3-tab" href="#incumplimientostab3" class="tab"><i class="fas fa-comments"></i> Descargos
				</a>
				<span class="yellow-bar"></span>
				<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
					<div class="animated-icon1"><span></span><span></span><span></span></div>
				</button>
			</div>
		</div>
		<!--tab-content-->
		<div class="tab-content tab-validate"><%
			if(session("ds5_usrperfil")<>3 and session("ds5_usrperfil")<>4) then
				if(session("ds5_usrperfil")<>5) then%>			
					<div id="incumplimientostab1">			
						<form role="form" action="" method="POST" name="frmincumplimientosadd" id="frmincumplimientosadd" class="form-signin needs-validation" style="padding-left: 30px;position:relative;">
							<h5>Incumplimiento</h5>
							<h6>Selección</h6>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-1">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-id-badge input-prefix"></i>													
											<input type="text" id="INC_Id" name="INC_Id" class="form-control" required readonly>
											<span class="select-bar"></span>
											<label for="INC_Id" class="<%=lblClass%>">Id</label>
										</div>
									</div>
								</div>											
								<div class="col-sm-12 col-md-12 col-lg-11">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="INC_Incumplimiento" name="INC_Incumplimiento" class="md-textarea form-control" readonly rows="2"></textarea>
											<span class="select-bar"></span>
											<label for="INC_Incumplimiento" class="active">Incumplimiento</label>									
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-1">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-dollar-sign input-prefix"></i>													
											<input type="text" id="INC_Monto" name="INC_Monto" class="form-control" readonly>
											<span class="select-bar"></span>
											<label for="INC_Monto" class="<%=lblClass%>">Monto</label>
										</div>
									</div>
								</div>					
								<div class="col-sm-12 col-md-12 col-lg-1">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-funnel-dollar input-prefix"></i>													
											<input type="text" id="MON_Descripcion" name="MON_Descripcion" class="form-control" readonly>
											<span class="select-bar"></span>
											<label for="MON_Descripcion" class="<%=lblClass%>">Moneda</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-radiation input-prefix"></i>													
											<input type="text" id="GRA_Descripcion" name="GRA_Descripcion" class="form-control" readonly>
											<span class="select-bar"></span>
											<label for="GRA_Descripcion" class="<%=lblClass%>">Gravedad</label>
										</div>
									</div>
								</div>		
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-ruler-combined input-prefix"></i>													
											<input type="text" id="UME_Descripcion" name="UME_Descripcion" class="form-control" readonly>
											<span class="select-bar"></span>
											<label for="UME_Descripcion" class="<%=lblClass%>">U.Medida</label>
										</div>
									</div>
								</div>		
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-tag input-prefix"></i>													
											<input type="text" id="BAS_NombreBases" name="BAS_NombreBases" class="form-control" readonly>
											<span class="select-bar"></span>
											<label for="BAS_NombreBases" class="<%=lblClass%>">Bases</label>
										</div>
									</div>
								</div>			
							</div>
							<h6>Ingreso</h6>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-8">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="IPR_HechosFundantes" name="IPR_HechosFundantes" class="md-textarea form-control" required="" rows="3"></textarea>
											<span class="select-bar"></span>
											<label for="IPR_HechosFundantes" class="active">Hechos Fundantes</label>									
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-1">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-dollar-sign input-prefix"></i>													
											<input type="number" id="IPR_MontoAplicado" name="IPR_MontoAplicado" class="form-control">
											<span class="select-bar"></span>
											<label for="IPR_MontoAplicado" class="<%=lblClass%>">M.Aplicado</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">														
											<i class="fas fa-cloud-upload-alt input-prefix"></i>
											<input type="text" id="INC_AdjuntoX" name="INC_AdjuntoX" class="form-control" readonly>						
											<input type="file" id="INC_Adjunto" name="INC_Adjunto" readonly multiple accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
											<span class="select-bar"></span>
											<label for="INC_AdjuntoX" class="<%=lblClass%>">Adjuntos</label>
										</div>
									</div>
								</div>		
								<div class="col-sm-12 col-md-12 col-lg-1">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-hashtag input-prefix"></i>													
											<input type="text" id="INC_Veces" name="INC_Veces" class="form-control" required>
											<span class="select-bar"></span>
											<label for="INC_Veces" class="<%=lblClass%>">Veces</label>
										</div>
									</div>
								</div>	
							</div>
							<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
							<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>"><%

							'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>							
								<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddincumplimientos" name="btn_frmaddincumplimientos" style="position: absolute;right: 215px;bottom: 0px;"><i class="fas fa-plus"></i></button><%
							'end if%>
							<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirincumplimientos" name="btn_salirincumplimientos" style="position: absolute;right: 145px;bottom: 0px;"><i class="fas fa-sign-out-alt"></i></button>
						</form>
					</div><%
				end if%>
				<div id="incumplimientostab2">
					<form role="form" action="" method="POST" name="frmincumplimientosdocenv" id="frmincumplimientosdocenv" class="form-signin needs-validation" style="padding-left: 30px;">
						<h5>Envío</h5>
						<h6>Datos del documento</h6>
						<div class="row align-items-center">
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-hashtag input-prefix"></i>													
										<input type="text" id="IPR_IdEnv" name="IPR_IdEnv" class="form-control" required readonly>
										<span class="select-bar"></span>
										<label for="IPR_IdEnv" class="<%=lblClass%>">Incumplimiento(s)</label>
									</div>
								</div>
							</div>													
							<div class="col-sm-12 col-md-12 col-lg-4">
								<div class="md-form input-with-post-icon">
									<div class="error-message">
										<div class="select">
											<select name="TDG_IdEnv" id="TDG_IdEnv" class="validate select-text form-control" required>
												<option value="" disabled selected></option><%										
												set rs = cnn.Execute("exec spTipoDocumentoGobierno_Listar 1")
												on error resume next					
												do While Not rs.eof%>												
													<option value="<%=rs("TDG_Id")%>"><%=rs("TDG_Nombre")%></option><%												
													rs.movenext						
												loop
												rs.Close%>
											</select>
											<i class="fas fa-file-invoice input-prefix"></i>
											<span class="select-highlight"></span>
											<span class="select-bar"></span>
											<label class="select-label">Documento</label>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-id-badge input-prefix"></i>													
										<input type="text" id="DIN_NumDocumentoEnv" name="DIN_NumDocumentoEnv" class="form-control" required>
										<span class="select-bar"></span>
										<label for="DIN_NumDocumentoEnv" class="<%=lblClass%>">Número</label>
									</div>
								</div>
							</div><%
							set rs = cnn.Execute("SELECT CONVERT(VARCHAR(10), getdate(),111) AS DATE;")
							on error resume next
							if Not rs.eof then
								DIN_FechaEnvioEnv=replace(rs("date"),"/","-")
							end if%>
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-calendar input-prefix"></i>													
										<input type="text" id="DIN_FechaEnvioEnv" name="DIN_FechaEnvioEnv" class="form-control calendario" readonly value="<%=DIN_FechaEnvioEnv%>">
										<span class="select-bar"></span>
										<label for="DIN_FechaEnvioEnv" class="active">Fecha</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-1"><%
								'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>							
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmadddocenv" name="btn_frmadddocenv"><i class="fas fa-plus"></i></button><%
								'end if%>							
							</div>
						</div>
						<h6>Documentos enviados</h6>
						<table id="tbl-incdocenv" class="ts table table-striped table-bordered dataTable table-sm" data-id="incdocenv"> 
							<thead>
								<tr>
									<th>Id.Inc</th>								
									<th>Tipo Doc.</th>
									<th>Número</th>
									<th>Fecha Envio</th>
									<th>Usuario</th><%
									if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=5) then%>
										<th>Acciones</th><%
									end if%>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</form>
					<form role="form" action="" method="POST" name="frmincumplimientosdocrec" id="frmincumplimientosdocrec" class="form-signin needs-validation" style="padding-left: 30px;">
						<h5>Recepción</h5>
						<h6>Datos del documento</h6>
						<div class="row align-items-center">
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-hashtag input-prefix"></i>													
										<input type="text" id="IPR_IdRec" name="IPR_IdRec" class="form-control" required readonly>
										<span class="select-bar"></span>
										<label for="IPR_IdRec" class="<%=lblClass%>">Incumplimiento(s)</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-5">
								<div class="md-form input-with-post-icon">
									<div class="error-message">
										<div class="select">
											<select name="TDG_IdRec" id="TDG_IdRec" class="validate select-text form-control" required>
												<option value="" disabled selected></option><%										
												set rs = cnn.Execute("exec spTipoDocumentoGobierno_Listar 1")
												on error resume next					
												do While Not rs.eof%>												
													<option value="<%=rs("TDG_Id")%>"><%=rs("TDG_Nombre")%></option><%												
													rs.movenext						
												loop
												rs.Close%>
											</select>
											<i class="fas fa-file-invoice input-prefix"></i>
											<span class="select-highlight"></span>
											<span class="select-bar"></span>
											<label class="select-label">Documento</label>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-id-badge input-prefix"></i>													
										<input type="text" id="DIN_NumDocumentoRec" name="DIN_NumDocumentoRec" class="form-control" required>
										<span class="select-bar"></span>
										<label for="DIN_NumDocumentoRec" class="<%=lblClass%>">Número</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-2" id="FechaRecDoc">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-calendar input-prefix"></i>													
										<input type="text" id="FechaRec" name="FechaRec" class="form-control calendario" required readonly>
										<span class="select-bar"></span>
										<label for="FechaRec" class="<%=lblClass%>">F.Recepción</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-2 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">														
										<div class="switch">
											<input type="checkbox" id="DIN_AplicaDesestimaMultaRec" name="DIN_AplicaDesestimaMultaRec" class="switch__input">
											<label for="DIN_AplicaDesestimaMultaRec" class="switch__label" style="top: -13px;">Aplica Multa?</label>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">	
										<i class="fas fa-dollar-sign input-prefix"></i>													
										<input type="number" id="IPR_MontoAplicadoRec" name="IPR_MontoAplicadoRec" class="form-control">
										<span class="select-bar"></span>
										<label for="IPR_MontoAplicadoRec" class="<%=lblClass%>">M.Aplicado</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-1"><%
								'if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>							
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmadddocrec" name="btn_frmadddocrec"><i class="fas fa-plus"></i></button><%
								'end if%>							
							</div>
						</div>
						<h6>Documentos recepcionados</h6>
						<table id="tbl-incdocrec" class="ts table table-striped table-bordered dataTable table-sm" data-id="incdocrec"> 
							<thead>
								<tr>
									<th>Id.Inc</th>								
									<th>Tipo Doc.</th>
									<th>Número</th>
									<th>Fecha Recepción</th>
									<th>Fec.Tot.Tramit.</th>
									<th>Usuario</th>
									<th>Aplica Multa?</th>
									<th>M.Aplicado</th><%
									if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=5) then%>
										<th>Acciones</th><%
									end if%>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</form>
					<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_frmcandoc" name="btn_frmcandoc" style="position: absolute;right: 0px;bottom: 10px;right: 30px;"><i class="fas fa-sign-out-alt"></i></button>
				</div><%
			end if%>
			<div id="incumplimientostab3">
				<form role="form" action="" method="POST" name="frmincumplimientosresp" id="frmincumplimientosresp" class="form-signin needs-validation" style="padding-left: 30px;">
					<h5>Descargos</h5>
					<h6>Ingreso de Descargos a los Incumplimientos</h6>	
					<table class="ts table table-striped table-bordered dataTable table-sm" id="tbl-respincum">
						<thead>
							<tr>
								<th>Id</th>
								<th>Incumplimiento</th>
								<th>Id</th>
								<th>Hechos Fundantes</th>
								<th>Adjuntos</th>
								<th>Id</th>
								<th>Descargos</th>
								<th>Adjuntos</th><%
								if (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1) then%>
									<th style="visibility:0;width:0px;"></th>
									<th style="visibility:0;width:0px;"></th>
									<th style="visibility:0;width:0px;"></th><%
								end if%>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>												
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-10">
						</div>
						<div class="col-sm-12 col-md-12 col-lg-2" style="text-align:right"><%
							if (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1) then%>
								<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddresp" name="btn_frmaddresp"><i class="fas fa-plus"></i></button><%
							end if%>
							<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_frmcandoc" name="btn_frmcandoc"><i class="fas fa-sign-out-alt"></i></button>
						</div>
					</div>
					<input type="hidden" value="<%=PRY_Id%>" name="PRY_Id" id="PRY_Id">
					<input type="hidden" value="<%=PRY_Identificador%>" name="PRY_Identificador" id="PRY_Identificador">
				</form>
			</div>
		</div>
	</div>	
	
	
