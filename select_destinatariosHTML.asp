<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="session.min.inc" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")
	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	if isEmpty(session("ds5_usrid")) or isNull(session("ds5_usrid")) then
		response.Write("500//Error Parámetros no válidos")
		response.end()
	end if	
	response.write("200//")%>
	<form role="form" action="/" method="POST" name="frmcreamensaje" id="frmcreamensaje" class="needs-validation">
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form input-with-post-icon">
					<div class="error-message">									
						<div class="select">
							<select name="destinatarios" id="destinatarios" class="validate select-text form-control" required>
								<option value="" disabled selected></option><%
								set rx = cnn.Execute("exec spPerfil_Listar 1")
								on error resume next	
								do while not rx.eof%>
									<optgroup label="<%=rx("PER_Nombre")%>"><%
									set rs = cnn.Execute("exec spMensajeDestinatario_Listar " & session("ds5_usrid") & "," & rx("PER_Id") )
									on error resume next					
									do While Not rs.eof 
										if rs("USR_Id")<>session("ds5_usrid") then%>							
											<option value="<%=rs("USR_Id")%>"><%=rs("USR_Nombre") & " " & rs("USR_Apellido")%></option><%
										end if
										rs.movenext						
									loop%>
									</optgroup><%
									rx.movenext
								loop
								rx.close
								rs.Close	
								cnn.Close%>
							</select>
							<i class="fas fa-user input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label">Destinatario</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">								
						<i class="fas fa-comment prefix"></i>										
						<textarea id="MEN_Texto" name="MEN_Texto" class="md-textarea form-control" rows="3" required></textarea>
						<label for="MEN_Texto" class="">Mensaje</label>
					</div>						
				</div>	
			</div>	
		</div>		
	</form>