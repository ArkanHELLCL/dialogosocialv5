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
		
	set rs = cnn.Execute("exec spLineaFormativa_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spLineaFormativa_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataLineaformativa = "{""data"":["
	do While Not rs.EOF
		if rs("LFO_Estado")=1 then
			estado = "Activado"
		else
			estado = "Desactivado"
		end if
		if rs("LFO_CAlif")=1 then
			calif = "Si"
		else
			calif = "No"
		end if
		if(rs("LFO_PorcentajeMinEjecutado")="" or ISNULL(rs("LFO_PorcentajeMinEjecutado"))) then
			LFO_PorcentajeMinEjecutado=0
		else
			LFO_PorcentajeMinEjecutado = rs("LFO_PorcentajeMinEjecutado")
		end if
		dataLineaformativa = dataLineaformativa & "[""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & calif & """,""" & rs("FON_Nombre") & """,""" & LFO_PorcentajeMinEjecutado & """,""" & estado & """]"
		
		rs.movenext
		if not rs.eof then
			dataLineaformativa = dataLineaformativa & ","
		end if
	loop
	dataLineaformativa=dataLineaformativa & "]}"
	
	response.write(dataLineaformativa)
%>