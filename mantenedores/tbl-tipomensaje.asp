<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec [spTipoMensaje_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec [spTipoMensaje_Listar]")
		cnn.close 		
		response.end
	End If	
	
	dataTipoMensaje = "{""data"":["
	do While Not rs.EOF
		if rs("TIP_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataTipoMensaje = dataTipoMensaje & "[""" & rs("TIP_Id") & """,""" & rs("TIP_Mensaje") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataTipoMensaje = dataTipoMensaje & ","
		end if
	loop
	dataTipoMensaje=dataTipoMensaje & "]}"
	
	response.write(dataTipoMensaje)
%>