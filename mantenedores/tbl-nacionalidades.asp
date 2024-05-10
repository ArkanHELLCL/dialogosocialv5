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
		
	set rs = cnn.Execute("exec spNacionalidad_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spNacionalidad_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataNacionalidades = "{""data"":["
	do While Not rs.EOF								
		dataNacionalidades = dataNacionalidades & "[""" & rs("NAC_Id") & """,""" & rs("NAC_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataNacionalidades = dataNacionalidades & ","
		end if
	loop
	dataNacionalidades=dataNacionalidades & "]}"
	
	response.write(dataNacionalidades)
%>