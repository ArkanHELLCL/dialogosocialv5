<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%	
	key=request("key1")	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_AudInte")

	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   	     
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	if session("ds5_usrperfil")<>1 and session("ds5_usrperfil")<>2 then
		response.Write("403/@/Error Perfil no autoizado")
		response.end()
	end if			
	
	set rs = cnn.Execute("exec spPerfil_Consultar " & key)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error SQL: " & ErrMsg & "-" & sql)
		cnn.close 			   
		response.end()	
	End If
	if not rs.eof then
		PER_Id			= rs("PER_Id")
		PER_Nombre		= rs("PER_Nombre")
		PER_Estado		= rs("PER_Estado")
	end if
	rs.Close
	if TDO_Estado=1 then
		Estado="Activado"
	else
		Estado="Desactivado"
	end if		
		
	response.write("200/@/")
	%>			
	<div class="row container-header">
	</div>
	<div class="row container-body">
		<div class="card visualizar">
			<div class="card-header"><i class="fas fa-edit"></i> Modificar Perfil
				<button type="button" class="close text-primary" aria-label="Close" data-url="/mantenedores/perfiles">
				  <span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form class="form"> 
				<div class="card-body">								
                	<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-user-cog input-prefix"></i>
									<label for="PER_Nombre" class="active">Nombre</label>
									<input type="text" id="PER_Nombre" name="PER_Nombre" class="form-control" value="<%=PER_Nombre%>" required disabled>
								</div>						
							</div>		
						</div>							
					</div>	
					
					<div class="row justify-content-end">						
						<div class="col-md-auto">
							<div class="custom-control custom-switch sw-estado" data-field="PER_Estado"><%
								if PER_Estado=1 then%>
									<input type="checkbox" class="custom-control-input" id="PER_Estado" name="PER_Estado" checked disabled>
									<label class="custom-control-label" for="PER_Estado">Activo</label><%
								else%>
									<input type="checkbox" class="custom-control-input" id="PER_Estado" name="PER_Estado" disabled>
									<label class="custom-control-label" for="PER_Estado">Bloqueado</label><%
								end if%>
							</div>
						</div>
					</div>															
				</div>						
			</form>
		</div>		
	</div>
	<%
	rs.Close
	cnn.Close
%>