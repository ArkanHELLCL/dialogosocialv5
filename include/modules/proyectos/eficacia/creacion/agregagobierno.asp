<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	SER_Id=request("SER_Id")
	PGO_Compromiso=LimpiarUrl(request("PGO_Compromiso"))
		
	sql = "exec spPatrocinioGobierno_Agregar " & SER_Id & "," & PRY_Id & ",'" & PGO_Compromiso & "',''," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("exec spPatrocinioGobierno_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataGobierno = "["
	colordown="text-white-50"
	clasedown=""
	disableddown="not-allowed"
	do While Not rs.EOF
		data = "data-id='" & rs("SER_Id") & "' data-pry='" & PRY_Id & "' data-tip='PGO' data-hito='115'"
		dataGobierno = dataGobierno & "{""SER_Id"":""" & rs("SER_Id") & """,""SER_Nombre"":""" & rs("SER_Nombre") & """,""PGO_Compromiso"":""" & rs("PGO_Compromiso") & """,""PGO_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-ser='" & rs("SER_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataGobierno = dataGobierno & "}"
		rs.movenext
		if not rs.eof then
			dataGobierno = dataGobierno & ","
		end if
	loop
	dataGobierno=dataGobierno & "]"								
	rs.close							
	
	response.write("200\\" & dataGobierno)
%>