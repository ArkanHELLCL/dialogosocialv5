<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
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
	
	SIN_Id = request("SIN_Id")
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then		
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
	end if
	
	set rs = cnn.Execute("exec spSindicato_Consultar " & SIN_Id)
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if
	if not rs.eof then
		Rut				     = rs("SIN_Rut")
		SIN_Dv			     = rs("SIN_Dv")
		SIN_Nombre		     = rs("SIN_Nombre")
		SIN_Direccion	     = rs("SIN_Direccion")
		SIN_Telefono	     = rs("SIN_Telefono")
		ACE_Id			     = setNULL(rs("ACE_Id"))
		SIN_Mail		     = rs("SIN_Mail")
		Estado			     = rs("SIN_Estado")
		RUB_Id               = setNULL(rs("RUB_Id"))
		RUB_Nombre           = rs("RUB_Nombre")
		SIN_DirPaginaWeb     = rs("SIN_DirPaginaWeb")
		SIN_NombrePresidente = rs("SIN_NombrePresidente")
		SIN_NumAsociados     = rs("SIN_NumAsociados")
		SIN_NumMujeres       = rs("SIN_NumMujeres")
		SIN_NumHombres       = rs("SIN_NumHombres")
		TOR_Id               = rs("TOR_Id")
		TOR_Nombre			 = rs("TOR_Nombre")
	end if
	rs.Close
	if Estado=1 then
		SIN_Estado="Activado"
	else
		SIN_Estado="Desactivado"
	end if
	SIN_Rut=Rut & SIN_Dv
							
							
	response.write("200//")%>
				
	<form role="form" action="" method="POST" name="frmrepresentantesForm" id="frmrepresentantesForm" class="form-signin needs-validation px-4">
		<h5>Sindicato : <%=SIN_Nombre%></h5>
		<h6>Datos del Representante del Sindicato</h6>																	
		<div class="row">						
			<div class="col-sm-12 col-md-3 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPS_Nombre" name="RPS_Nombre" class="form-control" required value="<%=RPS_Nombre%>">
						<span class="select-bar"></span>
						<label for="RPS_Nombre" class="<%=lblClass%>">Nombre</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPS_ApellidoPaterno" name="RPS_ApellidoPaterno" class="form-control" required value="<%=RPS_ApellidoPaterno%>">
						<span class="select-bar"></span>
						<label for="RPS_ApellidoPaterno" class="<%=lblClass%>">Apellido Paterno</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPS_ApellidoMaterno" name="RPS_ApellidoMaterno" class="form-control" required value="<%=RPS_ApellidoMaterno%>">
						<span class="select-bar"></span>
						<label for="RPS_ApellidoMaterno" class="<%=lblClass%>">Apellido Materno</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-id-badge input-prefix"></i>													
						<input type="text" id="RPS_Rut" name="RPS_Rut" class="form-control" required value="<%=RPS_Rut%>">
						<span class="select-bar"></span>
						<label for="RPS_Rut" class="<%=lblClass%>">RUT</label>
					</div>
				</div>
			</div>	

			<div class="col-sm-12 col-md-3 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user-tie input-prefix"></i>													
						<input type="text" id="RPS_Cargo" name="RPS_Cargo" class="form-control" required value="<%=RPS_Cargo%>">
						<span class="select-bar"></span>
						<label for="RPS_Cargo" class="<%=lblClass%>">Cargo</label>
					</div>
				</div>
			</div>
		</div>
		<div class="row"><%	
			if (LIN_Hombre and LIN_Mujer) then%>						
				<div class="col-sm-2 col-md-2 col-lg-2">
					<div class="md-form input-with-post-icon">
						<div class="error-message">
							<div class="select">
								<select name="SEX_Id" id="SEX_Id" class="validate select-text form-control" required>
									<option value="" disabled selected></option><%													
									set rs = cnn.Execute("exec spSexo_Listar")
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
					<div class="col-sm-2 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-mars input-prefix"></i>													
								<input type="text" id="" name="" class="form-control" value="Masculino">
								<span class="select-bar"></span>
								<label for="Masculino" class="<%=lblClass%>">Sexo</label>
							</div>
						</div>
					</div>
					<input type="hidden" id="SEX_Id" name="SEX_Id" value="2" required><%
				else
					if (not LIN_Hombre and LIN_Mujer) then%>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-venus input-prefix"></i>													
									<input type="text" id="" name="" class="form-control" value="Femenino">
									<span class="select-bar"></span>
									<label for="Masculino" class="<%=lblClass%>">Sexo</label>
								</div>
							</div>
						</div>
						<input type="hidden" id="SEX_Id" name="SEX_Id" value="1" required><%
					else%>
						<div class="col-sm-2 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-genderless input-prefix"></i>													
									<input type="text" id="" name="" class="form-control" value="Error de Definición">
									<span class="select-bar"></span>
									<label for="Masculino" class="active">Sexo</label>
								</div>
							</div>
						</div>
						<input type="hidden" id="SEX_Id" name="SEX_Id" value="" required><<%
					end if
				end if
			end if%>
			<div class="col-sm-12 col-md-3 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-envelope input-prefix"></i>													
						<input type="email" id="RPS_Mail" name="RPS_Mail" class="form-control" required value="<%=RPS_Mail%>">
						<span class="select-bar"></span>
						<label for="RPS_Mail" class="<%=lblClass%>">Mail</label>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-phone input-prefix"></i>													
						<input type="number" id="RPS_Telefono" name="RPS_Telefono" class="form-control" required value="<%=RPS_Telefono%>">
						<span class="select-bar"></span>
						<label for="RPS_Telefono" class="<%=lblClass%>">Teléfono</label>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-4 col-lg-3">
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2"><%	
				if (PRY_InformeFinalEstado=0 and PRY_Estado=1) then%>
					<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddrepresentantessin" name="btn_frmaddrepresentantessin" style="float:right;"><i class="fas fa-plus"></i> Agregar</button><%
				end if%>
				<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirrepresentantes" name="btn_salirrepresentantes" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>
			</div>
		</div>		
	
		<h6 style="margin-bottom:10px;">Lista de representantes ingresados</h6>		
		<div class="row">
			<div class="col-12">				
					<table id="tbl-representantesSIN" class="ts table table-striped table-bordered dataTable table-sm" data-id="representantesSIN" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">Id</th>
								<th>Nombre</th>
								<th>Apellido Paterno</th>
								<th>Apellido Materno</th>
								<th>RUT</th>
								<th>Sexo</th>									
								<%
								if(session("ds5_usrperfil")<>2 and session("ds5_usrperfil")<>4 and session("ds5_usrperfil"))<>5 then%>
									<th>Acciones</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody> 

						</tbody>
					</table>				
			</div>
		</div>
		<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
		<input type="hidden" id="SIN_Id" name="SIN_Id" value="<%=SIN_Id%>">
		<input type="hidden" id="Rut_RPS" name="Rut_RPS" value="">
	</form>
	<!--form-->	