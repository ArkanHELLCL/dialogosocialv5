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
		
	set rs = cnn.Execute("exec spSindicato_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spSindicato_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataSindicatos = "{""data"":["
	do While Not rs.EOF
		if rs("SIN_Estado")=1 then
			estado = "Activado"
		else
			estado = "Desactivado"
		end if
		dataSindicatos = dataSindicatos & "[""" & rs("SIN_Id") & """,""" & rs("SIN_Rut") & rs("SIN_Dv") & """,""" & rs("ACE_Nombre") & """,""" & rs("SIN_Nombre") & """,""" & rs("RUB_Nombre") & """,""" & estado & """,""" & rs("SIN_Direccion") & """,""" & rs("SIN_Telefono") & """,""" & rs("SIN_Mail") & """,""" & rs("SIN_DirPaginaWeb") & """]"
		
		rs.movenext
		if not rs.eof then
			dataSindicatos = dataSindicatos & ","
		end if
	loop
	dataSindicatos=dataSindicatos & "]}"
	
	response.write(dataSindicatos)
%>