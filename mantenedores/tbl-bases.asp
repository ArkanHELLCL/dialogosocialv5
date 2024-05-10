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
		
	set rs = cnn.Execute("exec spBases_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spBases_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataBases = "{""data"":["
	do While Not rs.EOF
		if rs("BAS_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataBases = dataBases & "[""" & rs("BAS_Id") & """,""" & rs("BAS_NombreBases") & """,""" & rs("BAS_NumResolucion") & """,""" & rs("BAS_FechaTramitacion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataBases = dataBases & ","
		end if
	loop
	dataBases=dataBases & "]}"
	
	response.write(dataBases)
%>