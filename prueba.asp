<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%response.write("200/@/")%>
<html>
<head>
	<!--head-->
	
	<!-- #INCLUDE FILE="include\template\meta.inc" -->
	<!-- #INCLUDE FILE="include\template\escritorio.inc" -->
	<!-- #INCLUDE FILE="include\template\functions.inc" -->
	<!--head-->	
	<title>Escritorio <%=ds5_usuario%> - Sistema Dialogo Social v5</title>
</head>
<body>
<div class="row container-header">

</div>
<div class="row container-body">
	<form class="form" method="post" action="/agrega-usuario" name="frm_usr_agregar" id="frm_usr_agregar" novalidate="novalidate"> 
				<div class="card-body">								
                	<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-4">
							<div class="md-form input-with-post-icon ">
								<div class="error-message">						
									<i class="fas fa-user input-prefix"></i>
									<label for="USR_Usuario" class="disabled">Usuario</label>
									<input type="text" id="USR_Usuario" name="USR_Usuario" class="form-control" value="" required="">									
								</div>								
							</div>
							<i class="fas fa-search search usrSearch"></i>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-6 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<i class="fas fa-address-book input-prefix"></i>
									<label for="USR_Nombre" class=" ">Nombres</label>
									<input type="text" id="USR_Nombre" name="USR_Nombre" class="form-control" value="" readonly="" required="">
								</div>						
							</div>		
						</div>		
						<div class="col-xs-12 col-sm-6 col-md-6 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<i class="far fa-address-book input-prefix"></i>
									<label for="USR_Apellido" class=" ">Apellidos</label>
									<input type="text" id="USR_Apellido" name="USR_Apellido" class="form-control" value="" readonly="" required="">
								</div>						
							</div>		
						</div>								
					</div>		
					
					<div class="row">
						<div class="col-xs-12 col-sm-6 col-md-6 col-lg-3">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-fingerprint input-prefix"></i>
									<label for="USR_Rut" class=" ">RUT</label>
									<input type="text" id="USR_Rut" name="USR_Rut" class="form-control" value="" readonly="" required="">
								</div>						
							</div>		
						</div>	
						<div class="col-xs-12 col-sm-6 col-md-6 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">				
									<div class="select">
										<select class="select-text form-control" id="SEX_Id" name="SEX_Id" required="">
												<option selected="" value="" disabled=""></option>
													<option value="1">Femenino</option>
												
													<option value="2">Masculino</option>
												
										</select>
												<i class="fas fa-genderless input-prefix"></i>					
										<span class="select-highlight"></span>
										<span class="select-bar"></span>
										<label class="select-label">Sexo</label>
									</div>									
								</div>						
							</div>		
						</div>
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-5">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-envelope input-prefix"></i>
									<label for="USR_Mail" class="">Correo</label>
									<input type="text" id="USR_Mail" name="USR_Mail" class="form-control" value="" readonly="" required="">
								</div>						
							</div>		
						</div>	
					</div>
					
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-building input-prefix"></i>
									<label for="DEP_id" class="">Departamento</label>
									<input type="text" id="DEP_Idx" name="DEP_Idx" class="form-control" value="" readonly="" required="">								
								</div>						
							</div>		
						</div>	
						<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select">
										<select class="select-text form-control" id="PER_Id" name="PER_Id" required="">
												<option selected="" value="" disabled=""></option>
												<optgroup label="Usuarios">
													<option value="1">Administrador</option>
												
													<option value="2">Jefe Servicio/Fiscalizador</option>
												</optgroup>
													<option value="3">Auditor Interno</option>
												
													<option value="4">Responsable de Accioner</option>
												
													<option value="5">Jefe de Area Seguimiento</option>
												
										</select>
										<i class="fas fa-user-lock input-prefix"></i>
										<span class="select-highlight"></span>
										<span class="select-bar"></span>
										<label class="select-label">Perfil</label>
									</div>									
								</div>						
							</div>		
						</div>
						<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select">
										<select class="select-text form-control" id="CAR_Id" name="CAR_Id" required="">
												<option selected="" value="" disabled=""></option>
													<option value="1">Jefe de Servicio</option>
												
										</select>
										<i class="fas fa-address-card input-prefix"></i>
										<span class="select-highlight"></span>
										<span class="select-bar"></span>
										<label class="select-label">Cargo</label>
									</div>
								</div>						
							</div>		
						</div>
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form">
								<div class="error-message">								
									<i class="fas fa-building prefix"></i>										
									<textarea id="OBS_DescripcionHallazgo" name="OBS_DescripcionHallazgo" class="md-textarea form-control" rows="3"></textarea>
									<label for="OBS_DescripcionHallazgo" class="active">Descripcón del Hallazgo</label>
								</div>						
							</div>
						</div>
						
					</div>					
						
					<div class="row justify-content-end">
						<div class="col-md-auto">
							<div class="custom-control custom-switch sw-estado" data-field="USR_Estado">
								<input type="checkbox" class="custom-control-input" id="USR_Estado" name="USR_Estado" checked="" disabled="">
								<label class="custom-control-label" for="USR_Estado">Activo</label>
							</div>
						</div>
					</div>															
				</div>		
				<div class="card-footer"> 			
					<button class="btn agregar btn-rounded btn-sm waves-effect waves-dark btn-success text-white" role="button" id="btn_usr_agregar" type="submit"><i class="fas fa-plus"></i> Agregar</button>			
				</div>
				<input type="hidden" id="USR_Id" name="USR_Id" value="">
			</form>
</div>
<!--container-body-->
</body>
</html>
<%

FUNCTION esc(a)
	esc= Server.HTMLEncode(a)
END FUNCTION

'Response.Write  esc("&*)!(@)#(!@)#SSDx><''""	,/ \	://	'''''	")

response.write(LimpiarUrl("[(?*"",\\<>&#~%{}+.@:\/!;']+///@/\@\  /@/ \@\_ @@ ''					xy" & chr(13) & "hola // \\ mas"))
Set arrResults = RegExResults("Arkanhell12!", "^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$")

'In your pattern the answer is the first group, so all you need is'
ok=false
For each result in arrResults
    'Response.Write(result.Submatches(0))
	if(result.SubMatches.Count=0) then
		ok=true	
	end if
Next
Response.Write(ok)
Set arrResults = Nothing
%>