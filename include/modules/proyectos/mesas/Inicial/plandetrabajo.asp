<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id=request("PRY_Id")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then	
		PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")
		PRY_Estado=rs("PRY_Estado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")		
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
		
	set rs = cnn.Execute("exec spTematicaDialogo_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spTematicaDialogo_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataPlnTra = "{""data"":["
	do While Not rs.EOF
		TED_Id=rs("TED_Id")
		if len(TED_Id)>1 then
			yTED_Id=""
			for i=0 to len(TED_Id)
				if(isnumeric(mid(TED_Id,i,1))) then
					yTED_Id=yTED_Id & mid(TED_Id,i,1)
				end if
			next
		else
			yTED_Id=cint(TED_Id)
		end if		
        path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresplandetrabajo\p-" & yTED_Id
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
			clasedown="doverplntra"
			disableddown="pointer"

			colordel="text-white-50"
			clasedel=""
			disableddel="not-allowed"
		else			
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colordel="text-danger"
			clasedel="delplntra"
			disableddel="pointer"			
		end if
		data="data-id='" & rs("TED_Id") & "' data-pry='" & PRY_Id & "'data-ted='" & rs("TED_Id") & "'"
		download="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"
		delete="<i class='fas fa-trash " & clasedel & " " & colordel & "' style='cursor:" & disableddel & "' title='Elimina Plan de Trabajo' " & data & "></i>"
		
		if (PRY_InformeInicialEstado=0 and PRY_Estado=1) and (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1) then
			acciones = download & " " & delete
		else
			acciones = download
		end if
		dataPlnTra = dataPlnTra & "[""" & rs("TED_Id") & """,""" & rs("TIM_NombreMesa") & """,""" & rs("REL_Nombres") & " " & rs("REL_Paterno") & " " & rs("REL_Materno") & """,""" & rs("TED_ActoresConvocados") & """,""" & rs("TED_Nombre") & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("TED_Direccion") & """,""" & rs("TED_Fecha") & """,""" & rs("TED_HoraInicio") & """,""" & rs("TED_HoraTermino") & """,""" & acciones & """]" 						
		rs.movenext
		if not rs.eof then
			dataPlnTra = dataPlnTra & ","
		end if
		
	loop
	dataPlnTra=dataPlnTra & "]}"	
	response.write(dataPlnTra)
%>