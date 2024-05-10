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
		
	set rs = cnn.Execute("exec spNivel_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spNivel_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataNiveldialogo = "{""data"":["
	do While Not rs.EOF								
		dataNiveldialogo = dataNiveldialogo & "[""" & rs("NIV_Id") & """,""" & rs("NIV_Nombre") & """]"
		
		rs.movenext
		if not rs.eof then
			dataNiveldialogo = dataNiveldialogo & ","
		end if
	loop
	dataNiveldialogo=dataNiveldialogo & "]}"
	
	response.write(dataNiveldialogo)
%>