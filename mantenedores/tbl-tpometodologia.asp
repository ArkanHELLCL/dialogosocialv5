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
		
	set rs = cnn.Execute("exec [spMetodologia_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec [spMetodologia_Listar]")
		cnn.close 		
		response.end
	End If	
	
	dataTpoMetodologia = "{""data"":["
	do While Not rs.EOF
		if rs("MET_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataTpoMetodologia = dataTpoMetodologia & "[""" & rs("MET_Id") & """,""" & rs("MET_Descripcion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataTpoMetodologia = dataTpoMetodologia & ","
		end if
	loop
	dataTpoMetodologia=dataTpoMetodologia & "]}"
	
	response.write(dataTpoMetodologia)
%>