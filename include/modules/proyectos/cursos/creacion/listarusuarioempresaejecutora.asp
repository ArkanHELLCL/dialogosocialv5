<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	EME_Id=request("EME_Id")
	USR_IdEjecutor=request("USR_IdEjecutor")
	mode=request("mode")
		
	sql="exec [spUsuarioEmpresaEjecutora_Listar] " & EME_Id & ",1"

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
	response.write("200\\")
	
	if(mode="add") then%>
		<option value="" disabled selected></option><%
	end if	
	do While Not rs.eof
		if(rs("USR_Id")=CInt(USR_IdEjecutor)) then%>
			<option value="<%=rs("USR_Id")%>" selected><%=rs("USR_Nombre") & " " & rs("USR_Apellido")%> </option><%
		else%>
			<option value="<%=rs("USR_Id")%>"><%=rs("USR_Nombre") & " " & rs("USR_Apellido")%> </option><%
		end if
		rs.movenext						
	loop
	rs.Close							
%>