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
		
	set rs = cnn.Execute("exec [spBasesLineaFormativa_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec [spBasesLineaFormativa_Listar]")
		cnn.close 		
		response.end
	End If	
	
	dataBasesLinea = "{""data"":["
	do While Not rs.EOF
		if rs("BLF_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataBasesLinea = dataBasesLinea & "[""" & rs("BLF_Id") & """,""" & rs("BAS_NombreBases") & """,""" & rs("LFO_Nombre") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataBasesLinea = dataBasesLinea & ","
		end if
	loop
	dataBasesLinea=dataBasesLinea & "]}"
	
	response.write(dataBasesLinea)
%>