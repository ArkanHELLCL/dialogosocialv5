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
		
	set rs = cnn.Execute("exec spEducacion_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spEducacion_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataEducacion = "{""data"":["
	do While Not rs.EOF
		if rs("ACE_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataEducacion = dataEducacion & "[""" & rs("EDU_Id") & """,""" & rs("EDU_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataEducacion = dataEducacion & ","
		end if
	loop
	dataEducacion=dataEducacion & "]}"
	
	response.write(dataEducacion)
%>