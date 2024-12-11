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
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spProyecto_Consultar")
		cnn.close 		
		response.end
	End If			
	
	if not rs.eof then	
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_Estado=rs("PRY_Estado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
	
	set rs=cnn.execute("[spCoordinacionTrabajadores_Listar] " & PRY_Id)	
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spCoordinacionTrabajadores_Listar]")
		cnn.close 		
		response.end
	End If				
	dim fs,f
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataMesasCoordTrab = "{""data"":["
	do While Not rs.EOF
		CTR_Id=rs("CTR_Id")
		if len(CTR_Id)>1 then
			yCTR_Id=""
			for i=0 to len(CTR_Id)
				if(isnumeric(mid(CTR_Id,i,1))) then
					yCTR_Id=yCTR_Id & mid(CTR_Id,i,1)
				end if
			next
		else
			yCTR_Id=cint(CTR_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorcoordactorestra\t-" & yCTR_Id								
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
			clasedown="doverctr"
			disableddown="pointer"
			data = "data-id='" & rs("CTR_Id") & "' data-pry='" & PRY_Id & "' data-tip='TRA' data-hito='119'"
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"
			data = ""
		end if
		
		verificador = "<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"

		acciones = "<i class='fas fa-trash text-danger delcoordtrab' data-toggle='tooltip' title='Elimina sesion' data-pry='" & PRY_Id & "' data-ctr='" & rs("CTR_Id") & "'></i> "
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			dataMesasCoordTrab = dataMesasCoordTrab & "[""" & rs("CTR_Id") & """,""" & rs("CTR_NumSesion") & """,""" & rs("CTR_DiaActividad") & """,""" & rs("CTR_TematicaAbordada") & """,""" & rs("CTR_ContenidosTrabajados") & """,""" & rs("CTR_Conclusion") & """,""" & rs("CTR_Compromiso") & """,""" & verificador & """,""" & acciones & """]" 	
		else
			dataMesasCoordTrab = dataMesasCoordTrab & "[""" & rs("CTR_Id") & """,""" & rs("CTR_NumSesion") & """,""" & rs("CTR_DiaActividad") & """,""" & rs("CTR_TematicaAbordada") & """,""" & rs("CTR_ContenidosTrabajados") & """,""" & rs("CTR_Conclusion") & """,""" & rs("CTR_Compromiso") & """,""" & verificador & """,""" & """]" 
		end if
											
		rs.movenext
		if not rs.eof then
			dataMesasCoordTrab = dataMesasCoordTrab & ","
		end if
		
	loop
	dataMesasCoordTrab=dataMesasCoordTrab & "]}"	
	response.write(dataMesasCoordTrab)
%>