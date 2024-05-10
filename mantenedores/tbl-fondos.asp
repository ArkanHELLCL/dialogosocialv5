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
		
	set rs = cnn.Execute("exec spFondos_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spBases_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataFondos = "{""data"":["
	do While Not rs.EOF
		if rs("FON_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataFondos = dataFondos & "[""" & rs("FON_Id") & """,""" & rs("FON_Nombre") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataFondos = dataFondos & ","
		end if
	loop
	dataFondos=dataFondos & "]}"
	
	response.write(dataFondos)
%>