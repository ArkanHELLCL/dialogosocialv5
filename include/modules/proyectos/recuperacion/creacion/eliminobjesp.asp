<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	OES_Id=request("OES_Id")
		
	sql = "exec spObjetivoEspecifico_Eliminar " & PRY_Id & "," & OES_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
		
	'Leyendo tabla para retornar todos los registros de ella	
	set rs=cnn.execute("spObjetivoEspecifico_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataObjetivosEsp = "["
	do While Not rs.EOF
		dataObjetivosEsp = dataObjetivosEsp & "{""OES_Id"":""" & rs("OES_Id") & """,""OES_ObjetivoEspecifico"":""" & rs("OES_ObjetivoEspecifico") & """,""OES_ResultadoEsperado"":""" & rs("OES_ResultadoEsperado") & """,""OES_Indicador"":""" & rs("OES_Indicador") & """,""OES_VerificadorCumplimiento"":""" & rs("OES_VerificadorCumplimiento") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-obj='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'></i>"""					
		dataObjetivosEsp = dataObjetivosEsp & "}"											
		rs.movenext
		if not rs.eof then
			dataObjetivosEsp = dataObjetivosEsp & ","
		end if
	loop
	dataObjetivosEsp=dataObjetivosEsp & "]"								
	rs.close							
	
	response.write("200\\" & dataObjetivosEsp)
%>