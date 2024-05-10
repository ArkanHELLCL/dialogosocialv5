<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	ESC_Id=request("ESC_Id")
		
	sql = "exec spEstrategiaConvocatoria_Eliminar " & PRY_Id & "," & ESC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)

	if not rs.eof then
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
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
	set rs=cnn.execute("spEstrategiaConvocatoria_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataEstrategiaConvpcatoria = "["
	do While Not rs.EOF
		ESC_Id=rs("ESC_Id")
		if len(ESC_Id)>1 then
			yESC_Id=""
			for i=0 to len(ESC_Id)
				if(isnumeric(mid(ESC_Id,i,1))) then
					yESC_Id=yESC_Id & mid(ESC_Id,i,1)
				end if
			next
		else
			yESC_Id=cint(ESC_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorconvocatoria\c-" & yESC_Id
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
			clasedown="doverest"
			disableddown="pointer"															
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"														
		end if
		dataEstrategiaConvpcatoria = dataEstrategiaConvpcatoria & "{""ESC_Id"":""" & rs("ESC_Id") & """,""ESC_Accion"":""" & rs("ESC_Accion") & """,""ESC_DescripcionAccion"":""" & rs("ESC_DescripcionAccion") & """,""ESC_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-esc='" & rs("ESC_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataEstrategiaConvpcatoria = dataEstrategiaConvpcatoria & "}"		
		rs.movenext
		if not rs.eof then
			dataEstrategiaConvpcatoria = dataEstrategiaConvpcatoria & ","
		end if
	loop
	dataEstrategiaConvpcatoria=dataEstrategiaConvpcatoria & "]"								
	rs.close							
	
	response.write("200\\" & dataEstrategiaConvpcatoria)
%>