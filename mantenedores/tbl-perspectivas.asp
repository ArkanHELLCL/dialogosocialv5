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
		
	set rs = cnn.Execute("exec spPerspectiva_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spModuloLinea_Consultar")
		cnn.close 		
		response.end
	End If	
	
	dataPerspectiavas = "{""data"":["
	do While Not rs.EOF	
		if rs("PER_Id")<>"" then
			dataPerspectiavas = dataPerspectiavas & "[""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & rs("MOD_Id") & """,""" & rs("MOD_Nombre") & """,""" & rs("PER_Id") & """,""" & rs("PER_Nombre")	& """]"
		end if
		rs.movenext
		if not rs.eof then
			dataPerspectiavas = dataPerspectiavas & ","
		end if
	loop
	dataPerspectiavas=dataPerspectiavas & "]}"
	
	response.write(dataPerspectiavas)
%>