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
		
	set rs = cnn.Execute("exec spNumeralMultas_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spNumeralMultas_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataNumeralmultas = "{""data"":["
	do While Not rs.EOF
		
		dataNumeralmultas = dataNumeralmultas & "[""" & rs("NUM_Id") & """,""" & rs("NUM_NumeralMultas") & """,""" & rs("BAS_Id") & """,""" & rs("BAS_NombreBases") & """,""" & rs("BAS_NumResolucion") & """,""" & rs("BAS_FechaTramitacion") & """]"		
		rs.movenext
		if not rs.eof then
			dataNumeralmultas = dataNumeralmultas & ","
		end if
	loop
	dataNumeralmultas=dataNumeralmultas & "]}"
	
	response.write(dataNumeralmultas)
%>