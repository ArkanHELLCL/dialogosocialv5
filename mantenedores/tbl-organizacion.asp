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
		
	set rs = cnn.Execute("exec spTipoOrganizacion_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spTipoOrganizacion_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataOrganizacion = "{""data"":["
	do While Not rs.EOF								
		dataOrganizacion = dataOrganizacion & "[""" & rs("TOR_Id") & """,""" & rs("TOR_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataOrganizacion = dataOrganizacion & ","
		end if
	loop
	dataOrganizacion=dataOrganizacion & "]}"
	
	response.write(dataOrganizacion)
%>