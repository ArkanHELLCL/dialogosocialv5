<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	OES_Id=request("OES_Id")			

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	if not rs.eof then	
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Id=rs("LIN_Id")
		PRY_ObjetivoGeneral=rs("PRY_ObjetivoGeneral")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	else
		response.Write("503/@/Error Conexión:")
		response.End() 
	end if
	
	sql = "exec spObjetivoEspecifico_Eliminar " & PRY_Id & "," & OES_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
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
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataObjetivosEsp = "["
	do While Not rs.EOF
		OES_Id=rs("OES_Id")
		if len(OES_Id)>1 then
			yOES_Id=""
			for i=0 to len(OES_Id)
				if(isnumeric(mid(OES_Id,i,1))) then
					yOES_Id=yOES_Id & mid(OES_Id,i,1)
				end if
			next
		else
			yOES_Id=cint(OES_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresproyecto\p-" & yOES_Id
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
			colordel="text-white-50"			
			disableddown="pointer"							
			disableddel="not-allowed"
			data="data-id='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="doverobj"
			clasedel=""
		else			
			colordown="text-white-50"							
			colordel="text-danger"
			disableddown="not-allowed"
			disableddel="pointer"
			data=""
			clasedown=""
			clasedel="delobjesp"
		end if
						
		dataObjetivosEsp = dataObjetivosEsp & "{""OES_Id"":""" & rs("OES_Id") & """,""OES_ObjetivoEspecifico"":""" & rs("OES_ObjetivoEspecifico") & """,""OES_ResultadoEsperado"":""" & rs("OES_ResultadoEsperado") & """,""OES_Indicador"":""" & rs("OES_Indicador") & """,""OES_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-obj='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'></i>"""
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