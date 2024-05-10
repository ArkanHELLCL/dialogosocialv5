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
		
	set rs = cnn.Execute("exec spRubro_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRubro_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataRubros = "{""data"":["
	do While Not rs.EOF
		if rs("RUB_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataRubros = dataRubros & "[""" & rs("RUB_Id") & """,""" & rs("RUB_Nombre") & """,""" & estado & """]"
		
		rs.movenext
		if not rs.eof then
			dataRubros = dataRubros & ","
		end if
	loop
	dataRubros=dataRubros & "]}"
	
	response.write(dataRubros)
%>