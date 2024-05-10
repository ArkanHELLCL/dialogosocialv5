<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		modo=1
		txtBoton="<i class='fas fa-plus'></i> Crear"
		btnColor="btn-success"
		action="/sav-11-h0-s1"
		id="btn_frm11s1"
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		action="/mod-11-h0-s1"
		id="btn_frm11s2"
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		mode="vis"
		modo=4
		disabled="readonly disabled"
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBoton="<i class='fas fa-forward'></i>"
		btnColor="btn-secondary"
	end if
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	sql="exec spLinea_Consultar " & LIN_Id
	set rs = cnn.Execute(sql)
	if not rs.eof then
		LFO_Id = rs("LFO_Id")		
		FON_Nombre = rs("FON_Nombre")
	end if		
	lblClass=""
	if(mode="mod" or mode="vis") then
		if(mode="vis") then
			lblSelect = "active"
		end if
		lblClass="active"
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if
		if not rs.eof then
			PRY_Identificador=rs("PRY_Identificador")
			PRY_Nombre=rs("PRY_Nombre")
			PRY_AnioProyecto=rs("PRY_AnioProyecto")
			REG_Id=rs("REG_Id")
			REG_Nombre=rs("REG_Nombre")
			COM_Id=rs("COM_Id")
			COM_Nombre=rs("COM_Nombre")
			PRY_DireccionEjecucion=rs("PRY_DireccionEjecucion")
			PRY_EmpresaEjecutora=rs("PRY_EmpresaEjecutora")
			USR_IdEjecutor=rs("USR_IdEjecutor")
			USR_IdRevisor=rs("USR_IdRevisor")
			'PRY_HorasPedagogicasMin=rs("PRY_HorasPedagogicasMin")
			PRY_MontoAdjudicado=rs("PRY_MontoAdjudicado")
			PRY_IdLicitacion=rs("PRY_IdLicitacion")
			FON_Nombre=rs("FON_Nombre")			
			PRY_NombreLicitacion=rs("PRY_NombreLicitacion")
			LIN_Mixta=rs("LIN_Mixta")
			PRY_CodigoAsociado=rs("PRY_CodigoAsociado")
			MET_Id=rs("MET_Id")
			EME_Id=rs("EME_Id")
			PRY_UrlClase=rs("PRY_UrlClase")
			PRY_TipoMesa=rs("PRY_TipoMesa")
			RUB_Id=rs("RUB_Id")
			TEM_Descripcion=rs("TEM_Descripcion")			

			MCZ_Descripcion=rs("DescripcionMacrozona")
			PRY_DimensionDialogoSocial=rs("PRY_DimensionDialogoSocial")
			PRY_NivelDialogoSocial=rs("PRY_NivelDialogoSocial")

		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if
	if(PRY_TipoMesa="") then
		PRY_TipoMesa=99
	end if			
	rs.close
	set rs = nothing
		
	response.write("200/@/")	
	if(mode="add") then
		PRY_Anio = anio	
		PRY_CodigoAsociado = "null"
		USR_IdEjecutor = "null"
	else
		PRY_Anio = PRY_AnioProyecto		
	end if
	

	cancelada=false
	sql="exec spPresupuesto_Listar " & PRY_Id
	set rw = cnn.Execute(sql)
	do while not rw.eof		
		if(rw("PRE_EstadoCuota")=1) then
			cancelada=true
		end if
		rw.movenext
	loop
%>
<form role="form" action="<%=action%>" method="POST" name="frm11s1" id="frm11s1" class="needs-validation">
	<h5>Personalización</h5>
	<h6>Datos del Proyecto</h6>
	<div class="row"> 
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-tag input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_Nombre" name="PRY_Nombre" class="form-control" <%=disabled%> value="<%=PRY_Nombre%>"><%
					else%>
						<input type="text" id="PRY_Nombre" name="PRY_Nombre" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_Nombre" class="<%=lblClass%>">Nombre Proyecto</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="EME_Id" id="EME_Id" class="validate select-text form-control" <%=disabled%>><%
							if(mode="add") or (EME_Id="" or IsNULL(EME_Id)) then%>
								<option value="" disabled selected></option><%
							end if
							set rs = cnn.Execute("exec spEmpresaEjecutora_Listar -1")
							on error resume next					
							do While Not rs.eof
								if rs("EME_Id")=EME_Id then%>
									<option value="<%=rs("EME_Id")%>" selected ><%=rs("EME_Nombre")%></option><%
								else%>
									<option value="<%=rs("EME_Id")%>"><%=rs("EME_Nombre")%></option><%
								end if
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-map-marker-alt input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Empresa Ejecutora/Ejecutor</label>
					</div>
				</div>
			</div>					
		</div>
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-id-card input-prefix"></i>
					<input type="text" id="EME_Rol" name="EME_Rol" class="form-control" readonly>
					<span class="select-bar"></span>
					<label for="EME_Rol" class="<%=lblClass%>">ROL/RUT</label>									
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="USR_IdEjecutor" id="USR_IdEjecutor" class="validate select-text form-control" <%=disabled%>>
						</select>
						<i class="fas fa-user input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Coordinador/a</label>
					</div>
				</div>
			</div>
		</div>					
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="USR_IdRevisor" id="USR_IdRevisor" class="validate select-text form-control" <%=disabled%>><%
							if(mode="add" or USR_IdRevisor="" or IsNULL(USR_IdRevisor)) then%>
								<option value="" disabled selected></option><%
							end if
							if session("ds_usrperfil")=2 then
								set rs = cnn.Execute("exec spUsuario_Consultar " & session("ds5_usrid"))
							else
								set rs = cnn.Execute("exec spUsuarioPerfil_Listar  2, -1")
							end if
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description			
								cnn.close 			   
								Response.end()
							End If
							do While Not rs.EOF
								if(rs("USR_Id")=USR_IdRevisor) then%>
									<option value="<%=rs("USR_Id")%>" selected><%response.Write(rs("USR_Nombre") & " " & rs("USR_Apellido"))%></option><%
								else%>
									<option value="<%=rs("USR_Id")%>"><%response.Write(rs("USR_Nombre") & " " & rs("USR_Apellido"))%></option><%
								end if
								rs.MoveNext
							loop
							rs.Close

							if session("ds5_usrperfil")<>2 then
								set rs = cnn.Execute("exec spUsuario_Consultar " & session("ds5_usrid"))

								set rs = cnn.Execute("exec spUsuarioPerfil_Listar  1, -1")
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description			
									cnn.close 			   
									Response.end()
								End If
								do While Not rs.EOF 
									if(rs("USR_Id")=USR_IdRevisor) then%>
										<option value="<%=rs("USR_Id")%>" selected><%response.Write(rs("USR_Nombre") & " " & rs("USR_Apellido"))%></option><%
									else%>
										<option value="<%=rs("USR_Id")%>"><%response.Write(rs("USR_Nombre") & " " & rs("USR_Apellido"))%></option><%
									end if
									rs.MoveNext
								loop
								rs.Close
							end if%>
						</select>
						<i class="fas fa-user input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Revisor</label>
					</div>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="MET_Id" id="MET_Id" class="validate select-text form-control" <%=disabled%>><%
							if(mode="add") or (MET_Id="" or IsNULL(MET_Id)) then%>
								<option value="" disabled selected></option><%
							end if
							set rs = cnn.Execute("exec spMetodologia_Listar 1")
							on error resume next					
							do While Not rs.eof
								if rs("MET_Id")=MET_Id then%>
									<option value="<%=rs("MET_Id")%>" selected ><%=rs("MET_Descripcion")%></option><%
								else%>
									<option value="<%=rs("MET_Id")%>"><%=rs("MET_Descripcion")%></option><%
								end if
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-graduation-cap input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Metodología</label>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<div id="direccion">
		<div class="row">	
			<div class="" id="region">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="REG_Id" id="REG_Id" class="validate select-text form-control" <%=disabled%>><%
								if(mode="add" or REG_Id="" or IsNULL(REG_Id)) then%>
									<option value="" disabled selected></option><%
								end if
								set rs = cnn.Execute("exec spRegion_Listar")
								on error resume next					
								do While Not rs.eof
									if rs("REG_Id")=REG_Id then%>
										<option value="<%=rs("REG_Id")%>" selected ><%=rs("REG_Nombre")%></option><%
									else%>
										<option value="<%=rs("REG_Id")%>"><%=rs("REG_Nombre")%></option><%
									end if
									rs.movenext						
								loop
								rs.Close%>
							</select>
							<i class="fas fa-map-marker-alt input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Región Ejecución</label>
						</div>
					</div>
				</div>
			</div>		

			<div class="" id="comuna">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="COM_Id" id="COM_Id" class="validate select-text form-control" <%=disabled%>><%
								if(mode="mod" or mode="vis") then
									set rs = cnn.Execute("exec spComuna_Listar " & REG_Id)
									on error resume next					
									do While Not rs.eof
										if rs("COM_Id")=COM_Id then%>
											<option value="<%=rs("COM_Id")%>" selected><%=rs("COM_Nombre")%></option><%
										else%>
											<option value="<%=rs("COM_Id")%>"><%=rs("COM_Nombre")%></option><%
										end if
										rs.movenext						
									loop
									rs.Close
								else%>
									<option value="" disabled selected></option><%
								end if%>							
							</select>
							<i class="fas fa-map-marker-alt input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Comuna</label>
						</div>
					</div>
				</div>
			</div>
			<div class="" id="fisica">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_DireccionEjecucion" name="PRY_DireccionEjecucion" class="form-control" <%=disabled%> value="<%=PRY_DireccionEjecucion%>"><%
						else%>
							<input type="text" id="PRY_DireccionEjecucion" name="PRY_DireccionEjecucion" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span>
						<label for="PRY_DireccionEjecucion" class="<%=lblClass%>">Dirección</label>									
					</div>
				</div>
			</div>
			<div class="" id="virtual">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="url" id="PRY_UrlClase" name="PRY_UrlClase" class="form-control" <%=disabled%> value="<%=PRY_UrlClase%>"><%
						else%>
							<input type="url" id="PRY_UrlClase" name="PRY_UrlClase" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span>
						<label for="PRY_UrlClase" class="<%=lblClass%>">Url</label>									
					</div>
				</div>
			</div>			
		</div>
	</div>
	
	<div class="row">		
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-dollar-sign input-prefix"></i><%
					if(not cancelada) then
						if(mode="mod" or mode="vis") then%>
							<input type="number" id="PRY_MontoAdjudicado" name="PRY_MontoAdjudicado" class="form-control" <%=disabled%> value="<%=PRY_MontoAdjudicado%>" max="2000000000"><%
						else%>
							<input type="number" id="PRY_MontoAdjudicado" name="PRY_MontoAdjudicado" class="form-control" <%=disabled%> max="2000000000"><%
						end if
					else%>
						<input type="number" id="PRY_MontoAdjudicado" name="PRY_MontoAdjudicado" class="form-control" readonly value="<%=PRY_MontoAdjudicado%>" max="2000000000"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_MontoAdjudicado" class="<%=lblClass%>">Monto</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-6 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="PRY_TipoMesa" id="PRY_TipoMesa" class="validate select-text form-control" <%=disabled%>><%
							if PRY_TipoMesa>2 then%>
								<option selected readonly value=""></option>
								<option value="1">Mesa Bipartita</option>
								<option value="2">Mesa Tripartita</option><%
							else
								if PRY_TipoMesa=1 then%>
									<option value="1" selected>Mesa Bipartita</option>
									<option value="2">Mesa Tripartita</option><%
								else
									if PRY_TipoMesa=2 then%>
										<option value="1">Mesa Bipartita</option>
										<option value="2" selected>Mesa Tripartita</option><%
									end if
								end if
							end if%>
						</select>						
						<i class="fas fa-handshake input-prefix"></i>
						<span class="select-highlight"></span><%
						if(mode="vis") then%>
							<label class="select-label active">Tipo de Mesa</label><%
						else%>
							<label class="select-label">Tipo de Mesa</label><%
						end if%>
					</div>
				</div>
			</div>							
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-tag input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_IdLicitacion" name="PRY_IdLicitacion" class="form-control" <%=disabled%> value="<%=PRY_IdLicitacion%>"><%
					else%>
						<input type="text" id="PRY_IdLicitacion" name="PRY_IdLicitacion" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_IdLicitacion" class="<%=lblClass%>">Id. Licitaciòn</label>									
				</div>
			</div>
		</div>		
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-tag input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_NombreLicitacion" name="PRY_NombreLicitacion" class="form-control" <%=disabled%> value="<%=PRY_NombreLicitacion%>"><%
					else%>
						<input type="text" id="PRY_NombreLicitacion" name="PRY_NombreLicitacion" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_NombreLicitacion" class="<%=lblClass%>">Nombre Licitaciòn</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-funnel-dollar input-prefix"></i>											
					<input type="text" id="FON_Nombre" name="FON_Nombre" class="form-control" value="<%=FON_Nombre%>" readonly disabled>
					<span class="select-bar"></span>
					<label for="FON_Nombre" class="active">Ítem Presupuestario</label>									
				</div>
			</div>
		</div>		
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="RUB_Id" id="RUB_Id" class="validate select-text form-control" <%=disabled%>><%
							if(mode="add" or RUB_Id="" or IsNULL(RUB_Id)) then%>
								<option value="" disabled selected></option><%
							end if
							if(mode="mod" or mode="vis" or mode="add") then
								sw=0
								set rs = cnn.Execute("exec spRubro_Listar 1")
								on error resume next													
								do While Not rs.eof
									if rs("RUB_Id")=RUB_Id then
										sw=1%>
										<option value="<%=rs("RUB_Id")%>" selected><%=rs("RUB_Nombre")%></option><%
									else%>
										<option value="<%=rs("RUB_Id")%>"><%=rs("RUB_Nombre")%></option><%
									end if
									rs.movenext						
								loop
								rs.Close
								
							else%>
								<option value="" disabled selected></option><%
							end if%>							
						</select>
						<i class="fas fa-industry input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Actividad Económica</label>
					</div>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-globe-americas input-prefix"></i>											
					<input type="text" id="MCZ_Descripcion" name="MCZ_Descripcion" class="form-control" value="<%=MCZ_Descripcion%>" readonly disabled>
					<span class="select-bar"></span><%
					if(mode="add") then%>
						<label for="MCZ_Descripcion" class="">Macrozona</label><%
					else%>
						<label for="MCZ_Descripcion" class="active">Macrozona</label><%
					end if%>					
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form">
				<div class="error-message">								
					<i class="fas fa-comment prefix"></i>
						<textarea id="TEM_Descripcion" name="TEM_Descripcion" class="md-textarea form-control" required="" rows="5" data-msg-required="Debes ingresar la temática"><%=TEM_Descripcion%></textarea>
					<span class="select-bar"></span><%
					if(TEM_Descripcion<>"") then%>
						<label for="TEM_Descripcion" class="active">Temática</label><%
					else%>
						<label for="TEM_Descripcion" class="">Temática</label><%
					end if%>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form">
				<div class="error-message">								
					<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_DimensionDialogoSocial" name="PRY_DimensionDialogoSocial" class="md-textarea form-control" required="" rows="5" data-msg-required="Debes ingresar la dimensión del diálogo social"><%=PRY_DimensionDialogoSocial%></textarea>
					<span class="select-bar"></span><%
					if(PRY_DimensionDialogoSocial<>"") then%>
						<label for="PRY_DimensionDialogoSocial" class="active">Dimensión del Diálogo Social</label><%
					else%>
						<label for="PRY_DimensionDialogoSocial" class="">Dimensión del Diálogo Social</label><%
					end if%>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form">
				<div class="error-message">								
					<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_NivelDialogoSocial" name="PRY_NivelDialogoSocial" class="md-textarea form-control" required="" rows="5" data-msg-required="Debes ingresar el nivel de diálogo social"><%=PRY_NivelDialogoSocial%></textarea>
					<span class="select-bar"></span><%
					if(PRY_NivelDialogoSocial<>"") then%>
						<label for="PRY_NivelDialogoSocial" class="active">Nivel del Diálogo Social</label><%
					else%>
						<label for="PRY_NivelDialogoSocial" class="">Nivel del Diálogo Social</label><%
					end if%>
				</div>
			</div>
		</div>
	</div>


	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="<%=id%>" name="btn_frm11s1"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="Step" name="Step" value="1" />	
</form>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	$(document).ready(function() {			
		
		function datosempresa(){
			$.ajax({
				type: 'POST',			
				url: '/datos-empresa-ejecutora',
				data: {EME_Id:$("#EME_Id").val()},
				dataType: "json",
				success: function(data) {
					if(data.state=="200"){
						$('#EME_Rol').val(data.EME_Rol);
						$('#EME_Rol').Rut();
						$("#EME_Rol").siblings("label").addClass("active");
					}
				}
			});
		}		
		$('select#REG_Id').on('change',function(){
			var region = $(this).val();    	
			$.ajax({
				type: 'POST',			
				url: '/seleccionar-comunas',
				data: {REG_Id:region},
				success: function(data) {					
					$('#COM_Id').html(data);
					setInterval(blink('#COM_Id'), 2200);								
				}
			});
		});	
		$('select#REG_Id').on('change',function(){
			var REG_Id = $(this).val();    	
			$.ajax({
				type: 'POST',			
				url: '/macrozona-consultar',
				data: {REG_Id:REG_Id},
				success: function(data) {			
					$("#MCZ_Descripcion").siblings("label").addClass("active");		
					$('#MCZ_Descripcion').val(data);
					setInterval(blink('#MCZ_Descripcion'), 2200);								
				}
			});
		});
		mostrarDir();
		listarEje();		
		datosempresa();		
		function listarEje(){
			var bb = String.fromCharCode(92) + String.fromCharCode(92);
			var data = {EME_Id:$("#EME_Id").val(),USR_IdEjecutor:<%=USR_IdEjecutor%>,mode:"<%=mode%>"}			
			$.ajax({
				type: 'POST',			
				url: '/listar-usuarios-empresa-ejecutora',
				data: data,
				success: function(data) {						
					param=data.split(bb);						
					if(param[0]=="200"){
						$("#USR_IdEjecutor").html(param[1]);						
						$("#USR_IdEjecutor").focus();						
					}
				}
			})
		}		
		function mostrarDir(){
			var MET_Id = $("#MET_Id").val();			
			$("#region, #comuna, #fisica, #virtual").attr("class","");		
			if(MET_Id==1) {				
				$("#region").addClass("col-sm-12 col-md-6 col-lg-6");				
				$("#virtual").addClass("col-sm-12 col-md-6 col-lg-6");
				$("#comuna").hide("slow");
				$("#fisica").hide("slow");				
				$("#virtual").show("slow");
				$("#direccion").show("slow");
			}
			if(MET_Id==2) {
				$("#region").addClass("col-sm-12 col-md-4 col-lg-4");
				$("#comuna").addClass("col-sm-12 col-md-4 col-lg-4");
				$("#fisica").addClass("col-sm-12 col-md-4 col-lg-4");				
				$("#virtual").hide("slow");
				$("#comuna").show("slow");
				$("#fisica").show("slow");	
				$("#direccion").show("slow");
			}
			if(MET_Id==3) {
				$("#region").addClass("col-sm-12 col-md-3 col-lg-3");
				$("#comuna").addClass("col-sm-12 col-md-3 col-lg-3");
				$("#fisica").addClass("col-sm-12 col-md-3 col-lg-3");
				$("#virtual").addClass("col-sm-12 col-md-3 col-lg-3");
				$("#comuna").show("slow");
				$("#fisica").show("slow");
				$("#virtual").show("slow");
				$("#direccion").show("slow");
			}						
		}
		$("#MET_Id").on("change", function(){
			mostrarDir();
		})
		$("#EME_Id").on("change", function(){
			listarEje();
			datosempresa();
		})
		
		$("#btn_frm11s1, #btn_frm11s2").click(function(){
			formValidate("#frm11s1")
			if($("#frm11s1").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm11s1").attr("action"),
					data: $("#frm11s1").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Personalización grabada correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}							
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
							$.ajax( {
								type:'POST',					
								url: '/mnu-11',
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
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del proyecto'								
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto'							
						});
					}
				});
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		});		
	});
</script>