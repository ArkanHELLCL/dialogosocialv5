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
	
	EMP_Id = request("EMP_Id")
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then		
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
	end if
	
	set rs = cnn.Execute("exec spEmpresa_Consultar " & EMP_Id)
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if
	if not rs.eof then
		EMP_Nombre		     = rs("EMP_Nombre")
		EMP_Direccion	     = rs("EMP_Direccion")
		EMP_Telefono	     = rs("EMP_Telefono")								
		EMP_Mail		     = rs("EMP_Mail")
		Estado			     = rs("EMP_Estado")
		RUB_Id               = setNULL(rs("RUB_Id"))
		RUB_Nombre           = rs("RUB_Nombre")																
		EMP_NumTrabajadores   = rs("EMP_NumTrabajadores")
		EMP_NumMujeres       = rs("EMP_NumMujeres")
		EMP_NumHombres       = rs("EMP_NumHombres")
		TOR_Id               = rs("TOR_Id")
		TOR_Nombre			 = rs("TOR_Nombre")
		EMP_Rol				 = rs("EMP_Rol")
	end if
	rs.Close
	if Estado=1 then
		EMP_Estado="Activado"
	else
		EMP_Estado="Desactivado"
	end if							
							
	response.write("200//")%>
				
	<form role="form" action="" method="POST" name="frmrepresentantesForm" id="frmrepresentantesForm" class="form-signin needs-validation px-4">
		<h5>Empresa : <%=EMP_Nombre%></h5>
		<h6>Datos del Representante de la Empresa</h6>																	
		<div class="row">						
			<div class="col-sm-12 col-md-3 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPE_Nombre" name="RPE_Nombre" class="form-control" required value="<%=RPE_Nombre%>">
						<span class="select-bar"></span>
						<label for="RPE_Nombre" class="<%=lblClass%>">Nombre</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPE_ApellidoPaterno" name="RPE_ApellidoPaterno" class="form-control" required value="<%=RPE_ApellidoPaterno%>">
						<span class="select-bar"></span>
						<label for="RPE_ApellidoPaterno" class="<%=lblClass%>">Apellido Paterno</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user input-prefix"></i>													
						<input type="text" id="RPE_ApellidoMaterno" name="RPE_ApellidoMaterno" class="form-control" required value="<%=RPE_ApellidoMaterno%>">
						<span class="select-bar"></span>
						<label for="RPE_ApellidoMaterno" class="<%=lblClass%>">Apellido Materno</label>
					</div>
				</div>
			</div>	
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-id-badge input-prefix"></i>													
						<input type="text" id="RPE_Rut" name="RPE_Rut" class="form-control" required value="<%=RPE_Rut%>">
						<span class="select-bar"></span>
						<label for="RPE_Rut" class="<%=lblClass%>">RUT</label>
					</div>
				</div>
			</div>	

			<div class="col-sm-12 col-md-3 col-lg-3">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-user-tie input-prefix"></i>													
						<input type="text" id="RPE_Cargo" name="RPE_Cargo" class="form-control" required value="<%=RPE_Cargo%>">
						<span class="select-bar"></span>
						<label for="RPE_Cargo" class="<%=lblClass%>">Cargo</label>
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
						<input type="email" id="RPE_Mail" name="RPE_Mail" class="form-control" required value="<%=RPE_Mail%>">
						<span class="select-bar"></span>
						<label for="RPE_Mail" class="<%=lblClass%>">Mail</label>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">	
						<i class="fas fa-phone input-prefix"></i>													
						<input type="number" id="RPE_Telefono" name="RPE_Telefono" class="form-control" required value="<%=RPE_Telefono%>">
						<span class="select-bar"></span>
						<label for="RPE_Telefono" class="<%=lblClass%>">Teléfono</label>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-4 col-lg-3">
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2"><%	
				if (PRY_InformeFinalEstado=0 and PRY_Estado=1) then%>
					<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddrepresentantesemp" name="btn_frmaddrepresentantesemp" style="float:right;"><i class="fas fa-plus"></i> Agregar</button><%
				end if%>
				<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirrepresentantes" name="btn_salirrepresentantes" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>
			</div>
		</div>		
	
		<h6 style="margin-bottom:10px;">Lista de representantes ingresados</h6>		
		<div class="row">
			<div class="col-12">				
					<table id="tbl-representantesEMP" class="ts table table-striped table-bordered dataTable table-sm" data-id="representantesEMP" data-page="true" data-selected="true" data-keys="1"> 
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
		<input type="hidden" id="EMP_Id" name="EMP_Id" value="<%=EMP_Id%>">
		<input type="hidden" id="Rut_RPE" name="Rut_RPE" value="">
	</form>
	<!--form-->	