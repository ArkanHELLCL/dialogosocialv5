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
		
	set rs = cnn.Execute("exec spMoneda_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spMoneda_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataMoneda = "{""data"":["
	do While Not rs.EOF
		if rs("MON_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataMoneda = dataMoneda & "[""" & rs("MON_Id") & """,""" & rs("MON_Descripcion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataMoneda = dataMoneda & ","
		end if
	loop
	dataMoneda=dataMoneda & "]}"
	
	response.write(dataMoneda)
%>