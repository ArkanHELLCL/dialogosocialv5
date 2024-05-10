<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRY_Id	= request("PRY_Id")
			
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
		response.Write("503/@/Error Conexión:" & ErrMsg)
		cnn.close
		response.End() 	
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
			
	set rs2 = cnn.Execute("exec [spIncumplimientosProyecto_Listar]  " & PRY_Id & ",-1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description		
		cnn.close 		
		response.end
	End If
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	cont=0
	dataIncumplimientos = "{""data"":["
	do while not rs2.eof
		if cont>=1 then
			dataIncumplimientos = dataIncumplimientos & ","				
		end if
		cont = cont + 1					
		IPR_Id=rs2("IPR_Id")
		if len(IPR_Id)>1 then
			yIPR_Id=""
			for i=0 to len(IPR_Id)
				if(isnumeric(mid(IPR_Id,i,1))) then
					yIPR_Id=yIPR_Id & mid(IPR_Id,i,1)
				end if
			next
		else
			yIPR_Id=cint(IPR_Id)
		end if		
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\incumplimientos\inc-" & yIPR_Id & "\"
		archivos=contararchivos(path)
		if(archivos>0) then			
			colordown="text-primary"
			'colordel="text-danger"			
			disableddown="pointer"
			'disableddel="pointer"
			data="data-id='" & rs2("IPR_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="dowinc"
			'clasedel="delade"
		else			
			colordown="text-white-50"
			colordel="text-white-50"			
			disableddown="not-allowed"
			disableddel="not-allowed"
			data=""
			clasedown=""
			clasedel=""
		end if
		Acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Ver adjunto(s)' " & data & " data-toggle='tooltip'></i> "
		set rs3 = cnn.Execute("exec [spRespuestaMultaIncumplimiento_Listar]  " & rs2("IPR_Id"))
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description		
			cnn.close 		
			response.end
		End If
		reg="new"
		RIN_RespuestaIncumplimiento=""
		id=id+1
		if not rs3.eof then
			RIN_Id=rs3("RIN_Id")
			id=rs3("RIN_Id")
			RIN_RespuestaIncumplimiento=rs3("RIN_RespuestaIncumplimiento")
			reg="old"					
		end if
		
		RIN_Id=rs2("RIN_Id")
		if len(RIN_Id)>1 then
			yRIN_Id=""
			for i=0 to len(RIN_Id)
				if(isnumeric(mid(RIN_Id,i,1))) then
					yRIN_Id=yRIN_Id & mid(RIN_Id,i,1)
				end if
			next
		else
			yRIN_Id=cint(RIN_Id)
		end if		
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\incumplimientos\res-" & yIPR_Id & "\"
		archivos=contararchivos(path)
		if(archivos>0) then			
			colordown="text-primary"
			colordel="text-danger"			
			disableddown="pointer"
			disableddel="pointer"
			data="data-ipr='" & rs2("IPR_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="dowres"
			'clasedel="delade"
		else			
			colordown="text-white-50"
			colordel="text-white-50"			
			disableddown="not-allowed"
			disableddel="not-allowed"
			data=""
			clasedown=""
			clasedel=""
		end if		
		
		if (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1) then
			respuesta="<textarea class='md-textarea form-control' name='RIN_RespuestaIncumplimiento' id='RIN_RespuestaIncumplimiento-" & id & "' row='15' style='height: 150px;'>" & RIN_RespuestaIncumplimiento & "</textarea>"
			
			Acciones2="<i class='fas fa-cloud-upload-alt uplres text-success' data-rin='" & RIN_Id & "' data-ipr='" & IPR_Id & "' title='Subir Adjunto(s)' data-toggle='tooltip'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Ver adjunto(s)' " & data & " data-toggle='tooltip' " & data & "></i> <i class='fas fa-trash delres " & colordel & "' style='cursor:" & disableddel & "' title='Eliminar Adjunto(s)' data-toggle='tooltip' " & data & "></i> "
								
			dataIncumplimientos = dataIncumplimientos & "[""" & rs2("INC_Id") & """,""" & rs2("INC_Incumplimiento") & """,""" & rs2("IPR_Id") & """,""" & rs2("IPR_HechosFundantes") & """,""" & Acciones & """,""" & RIN_Id & """,""" & respuesta & """,""" & Acciones2 & """,""" & "<input type='hidden' id='Id-" & id & "' name='Id' value='" & id & "'>" & """,""" & "<input type='hidden' id='Type-" & id & "' name='Type' value='" & reg & "'>" & """,""" & "<input type='hidden' id='IPR_Id-" & id & "' name='IPR_Id' value='" & IPR_Id & "'>"	& """]"
		else
			respuesta=RIN_RespuestaIncumplimiento
			Acciones2="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Ver adjunto(s)' " & data & " data-toggle='tooltip'></i> "
			
			dataIncumplimientos = dataIncumplimientos & "[""" & rs2("INC_Id") & """,""" & rs2("INC_Incumplimiento") & """,""" & rs2("IPR_Id") & """,""" & rs2("IPR_HechosFundantes") & """,""" & Acciones & """,""" & RIN_Id & """,""" & respuesta & """,""" & Acciones2 & """]"
		end if				
		
		rs2.movenext
	loop
	rs2.Close
	cnn.Close
	dataIncumplimientos=dataIncumplimientos & "]}"
	
	function contararchivos(path)		
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
		
		return archivos
	end function
	
	response.write(dataIncumplimientos)%>		