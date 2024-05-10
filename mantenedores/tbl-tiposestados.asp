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
		
	set rs = cnn.Execute("exec spTipoEstado_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spTipoEstado_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataTipoEstado = "{""data"":["
	do While Not rs.EOF									
		dataTipoEstado = dataTipoEstado & "[""" & rs("EST_Estado") & """,""" & rs("TES_Descripcion") & """]"		
		rs.movenext
		if not rs.eof then
			dataTipoEstado = dataTipoEstado & ","
		end if
	loop
	dataTipoEstado=dataTipoEstado & "]}"
	
	response.write(dataTipoEstado)
%>