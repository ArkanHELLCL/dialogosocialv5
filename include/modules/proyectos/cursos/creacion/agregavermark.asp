<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id					= request("PRY_Id")	
	VPM_AccionComprometida	= LimpiarUrl(request("VPM_AccionComprometida"))
	VPM_Etapa				= LimpiarUrl(request("VPM_Etapa"))
	switch					= request("VPM_Comprometida")
	'if(switch="on") then
		VPM_Comprometida = 1
	'else
		'VPM_Comprometida = 0
	'end if			

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
	
	sql = "exec [spVerificadorPlanMarketing_Agregar] '" & VPM_AccionComprometida & "','','" & VPM_Etapa & "'," & PRY_Id & "," & VPM_Comprometida & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
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
	set rs=cnn.execute("spVerificadorPlanMarketing_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataVerificadoresMark = "["
	do While Not rs.EOF
		VPM_Id=rs("VPM_Id")
		if len(VPM_Id)>1 then
			yVPM_Id=""
			for i=0 to len(VPM_Id)
				if(isnumeric(mid(VPM_Id,i,1))) then
					yVPM_Id=yVPM_Id & mid(VPM_Id,i,1)
				end if
			next
		else
			yVPM_Id=cint(VPM_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresmarketing\m-" & yVPM_Id
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
			data="data-id='" & rs("VPM_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="dovermrk"
			clasedel=""
		else			
			colordown="text-white-50"
			colordel="text-danger"
			disableddown="not-allowed"
			disableddel="pointer"
			data=""
			clasedown=""
			clasedel="delvermark"
		end if
		if(rs("VPM_Comprometida")=1) then
			switch="<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span>"
		else
			switch="<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span>"
		end if
		dataVerificadoresMark = dataVerificadoresMark & "{""VPM_Id"":""" & rs("VPM_Id") & """,""VPM_AccionComprometida"":""" & rs("VPM_AccionComprometida") & """,""VPM_Etapa"":""" & rs("VPM_Etapa") & """,""VPM_Comprometida"":""" & switch & """,""VPM_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-vpm='" & rs("VPM_Id") & "' data-pry='" & PRY_Id & "'></i>"""	
		dataVerificadoresMark = dataVerificadoresMark & "}"		
		rs.movenext
		if not rs.eof then
			dataVerificadoresMark = dataVerificadoresMark & ","
		end if
	loop
	dataVerificadoresMark=dataVerificadoresMark & "]"								
	rs.close							
	
	response.write("200\\" & dataVerificadoresMark)
%>