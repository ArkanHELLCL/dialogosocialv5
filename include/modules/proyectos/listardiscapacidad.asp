<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	'if(session("ds5_usrperfil")=5 and session("ds5_usrperfil")=4) then	'Administrativo y Auditor
	''	response.Write("403\\Perfil no autorizado")
	''	response.End() 			   
	'end if		
		
	sql="exec spTipoDiscapacidad_Listar 1"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	response.write("200\\")%>
	<select name="TDI_Id" id="TDI_Id" class="validate select-text form-control" required>															
		<option value="" disabled selected></option><%
		do While Not rs.eof%>
			<option value="<%=rs("TDI_Id")%>"><%=rs("TDI_Nombre")%></option><%		
			rs.movenext						
		loop					
		rs.close%>
	</select>