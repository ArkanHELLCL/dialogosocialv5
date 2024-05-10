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
		
	set rs = cnn.Execute("exec spServicio_Listar -1, -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spServicio_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataServicios = "{""data"":["
	do While Not rs.EOF								
		dataServicios = dataServicios & "[""" & rs("GOB_Id") & """,""" & rs("GOB_NombreInstitucion") & """,""" & rs("SER_Id") & """,""" & rs("SER_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataServicios = dataServicios & ","
		end if
	loop
	dataServicios=dataServicios & "]}"
	
	response.write(dataServicios)
%>