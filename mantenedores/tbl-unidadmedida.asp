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
		
	set rs = cnn.Execute("exec [spUnidadMedida_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec [spUnidadMedida_Listar]")
		cnn.close 		
		response.end
	End If	
	
	dataUnidadmedida = "{""data"":["
	do While Not rs.EOF
		if rs("UME_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataUnidadmedida = dataUnidadmedida & "[""" & rs("UME_Id") & """,""" & rs("UME_Descripcion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataUnidadmedida = dataUnidadmedida & ","
		end if
	loop
	dataUnidadmedida=dataUnidadmedida & "]}"
	
	response.write(dataUnidadmedida)
%>