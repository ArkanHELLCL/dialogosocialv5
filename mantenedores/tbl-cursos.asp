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
		
	set rs = cnn.Execute("exec spModuloLinea_Consultar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spModuloLinea_Consultar")
		cnn.close 		
		response.end
	End If	
	
	dataCursos = "{""data"":["
	do While Not rs.EOF								
		dataCursos = dataCursos & "[""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & rs("MOD_Id") & """,""" & rs("MOD_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataCursos = dataCursos & ","
		end if
	loop
	dataCursos=dataCursos & "]}"
	
	response.write(dataCursos)
%>