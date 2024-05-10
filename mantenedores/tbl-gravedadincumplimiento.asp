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
		
	set rs = cnn.Execute("exec [spGravedadIncumplimiento_Listar] -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("exec [spGravedadIncumplimiento_Listar]")
		cnn.close 		
		response.end
	End If	
	
	dataGravedadincumplimiento = "{""data"":["
	do While Not rs.EOF
		if rs("GRA_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if						
		
		dataGravedadincumplimiento = dataGravedadincumplimiento & "[""" & rs("GRA_Id") & """,""" & rs("GRA_Descripcion") & """,""" & estado & """]"		
		rs.movenext
		if not rs.eof then
			dataGravedadincumplimiento = dataGravedadincumplimiento & ","
		end if
	loop
	dataGravedadincumplimiento=dataGravedadincumplimiento & "]}"
	
	response.write(dataGravedadincumplimiento)
%>