<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=5 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=2) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id					= request("PRY_Id")	
	PLC_AccionDifusion		= LimpiarUrl(request("PLC_AccionDifusion"))
	PLC_Descripcion			= LimpiarUrl(request("PLC_Descripcion"))
    PLC_MedioComunicacion	= LimpiarUrl(request("PLC_MedioComunicacion"))
    PLC_FrecuenciaCantidad	= request("PLC_FrecuenciaCantidad")
    PLC_EtapaDesarrollo    	= LimpiarUrl(request("PLC_EtapaDesarrollo"))
    PLC_Verificador         = ""
	PLC_PlanComunicacional	= ""

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
	
	sql = "exec [spPlanComunicacional_Agregar] " & PRY_Id & ",'" & PLC_PlanComunicacional & "','" & PLC_AccionDifusion & "','" & PLC_Descripcion & "','" & PLC_MedioComunicacion & "'," & PLC_FrecuenciaCantidad & ",'" & PLC_EtapaDesarrollo & "','" & PLC_Verificador	& "',NULL," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
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
	set rs=cnn.execute("spPlanComunicacional_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataVerificadoresPLC = "["
	do While Not rs.EOF
		PLC_Id=rs("PLC_Id")
		if len(PLC_Id)>1 then
			yPLC_Id=""
			for i=0 to len(PLC_Id)
				if(isnumeric(mid(PLC_Id,i,1))) then
					yPLC_Id=yPLC_Id_Id & mid(PLC_Id,i,1)
				end if
			next
		else
			yPLC_Id_Id=cint(PLC_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresplancomunicacional\p-" & yPLC_Id
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
			data="data-id='" & rs("PCO_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="doplncom"
			clasedel=""
		else			
			colordown="text-white-50"
			colordel="text-danger"
			disableddown="not-allowed"
			disableddel="pointer"
			data=""
			clasedown=""
			clasedel="delplncom"
		end if										
		
		dataVerificadoresPLC = dataVerificadoresPLC & "{""PLC_Id"":""" & rs("PLC_Id") & """,""PLC_AccionDifusion"":""" & rs("PLC_AccionDifusion") & """,""PLC_Descripcion"":""" & rs("PLC_Descripcion") & """,""PLC_MedioComunicacion"":""" & rs("PLC_MedioComunicacion") & """,""PLC_FrecuenciaCantidad"":""" & rs("PLC_FrecuenciaCantidad") & """,""PLC_EtapaDesarrollo"":""" & rs("PLC_EtapaDesarrollo") & """,""PLC_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-plc='" & rs("PLC_Id") & "' data-pry='" & PRY_Id & "'></i>"""

		dataVerificadoresPLC = dataVerificadoresPLC & "}"											
		rs.movenext
		if not rs.eof then
			dataVerificadoresPLC = dataVerificadoresPLC & ","
		end if
	loop
	dataVerificadoresPLC=dataVerificadoresPLC & "]"	
	rs.close							
	
	response.write("200\\" & dataVerificadoresPLC)
%>