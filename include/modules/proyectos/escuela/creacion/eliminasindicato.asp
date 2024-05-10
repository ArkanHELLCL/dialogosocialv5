<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	SIN_Id=request("SIN_Id")
		
	sql = "exec spPatrocinio_Eliminar " & PRY_Id & "," & SIN_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("spPatrocinio_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataSindicales = "["
	do While Not rs.EOF
		SIN_Id=rs("SIN_Id")
		if len(SIN_Id)>1 then
			ySIN_Id=""
			for i=0 to len(SIN_Id)
				if(isnumeric(mid(SIN_Id,i,1))) then
					ySIN_Id=ySIN_Id & mid(SIN_Id,i,1)
				end if
			next
		else
			ySIN_Id=cint(SIN_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorsindicato\s-" & ySIN_Id
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
			clasedown="doversin"
			disableddown="pointer"															
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"														
		end if
		dataSindicales = dataSindicales & "{""SIN_Id"":""" & rs("SIN_Id") & """,""SIN_Nombre"":""" & rs("SIN_Nombre")  & """,""ACE_Nombre"":""" & rs("ACE_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""PAT_Compromiso"":""" & rs("PAT_Compromiso") & """,""PAT_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-sin='" & rs("SIN_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataSindicales = dataSindicales & "}"											
		rs.movenext
		if not rs.eof then
			dataSindicales = dataSindicales & ","
		end if
	loop
	dataSindicales=dataSindicales & "]"								
	rs.close							
	
	response.write("200\\" & dataSindicales)
%>