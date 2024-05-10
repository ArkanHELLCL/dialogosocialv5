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
		
	set rs = cnn.Execute("exec [spIncumplimientos_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec spIncumplimientos_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataIncumplimiento = "{""data"":["
	do While Not rs.EOF
		if rs("INC_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataIncumplimiento = dataIncumplimiento & "[""" & rs("INC_Id") & """,""" & rs("INC_Incumplimiento") & """,""" & rs("INC_Monto") & """,""" & rs("MON_Descripcion") & """,""" & rs("GRA_Descripcion") & """,""" & rs("UME_Descripcion") & """,""" & rs("BAS_NombreBases") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataIncumplimiento = dataIncumplimiento & ","
		end if
	loop
	dataIncumplimiento=dataIncumplimiento & "]}"
	
	response.write(dataIncumplimiento)
%>