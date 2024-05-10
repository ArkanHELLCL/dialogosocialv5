<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	SER_Id=request("SER_Id")
		
	sql = "exec spPatrocinioGobierno_Eliminar " & PRY_Id & "," & SER_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataGobierno = "["
	do While Not rs.EOF
		SER_Id=rs("SER_Id")
		if len(SER_Id)>1 then
			ySER_Id=""
			for i=0 to len(SER_Id)
				if(isnumeric(mid(SER_Id,i,1))) then
					ySER_Id=ySER_Id & mid(SER_Id,i,1)
				end if
			next
		else
			ySER_Id=cint(SER_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\verificadorgobierno\c-" & ySER_Id
		archivos=0
		If fs.FolderExists(path) = true Then
			Set carpeta = fs.getfolder(path)
			Set ficheros = carpeta.Files
			For Each archivo In ficheros
				archivos = archivos + 1
			Next
		else
			archivos = 0
		end if
		if(archivos>0) then
			colordown="text-success"
			clasedown="doverpat"
			disableddown="pointer"															
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"														
		end if
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