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
		
	set rs = cnn.Execute("exec spGobierno_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spGobierno_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataMinisterios = "{""data"":["
	do While Not rs.EOF								
		dataMinisterios = dataMinisterios & "[""" & rs("GOB_Id") & """,""" & rs("GOB_NombreInstitucion") & """,""" & rs("GOB_Rut") & """,""" & rs("GOB_NombreInstitucion") & """]"
		
		rs.movenext
		if not rs.eof then
			dataMinisterios = dataMinisterios & ","
		end if
	loop
	dataMinisterios=dataMinisterios & "]}"
	
	response.write(dataMinisterios)
%>