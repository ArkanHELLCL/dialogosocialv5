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
		
	set rs = cnn.Execute("exec spTipoMesa_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spTipoMesa_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataHitos = "{""data"":["
	do While Not rs.EOF
		if rs("TIM_Estado")=1 then
			Estado="Activado"
		else
			Estado="Descativado"
		end if
		if(rs("TIM_RelatorObligatorio")=1) then
			RelatorObligatorio = "Si"
		else
			RelatorObligatorio = "No"
		end if
		dataHitos = dataHitos & "[""" & rs("TIM_Id") & """,""" & rs("TIM_NombreMesa") & """,""" & RelatorObligatorio & """,""" & Estado & """]"
		rs.movenext
		if not rs.eof then
			dataHitos = dataHitos & ","
		end if
	loop
	dataHitos=dataHitos & "]}"
	
	response.write(dataHitos)
%>