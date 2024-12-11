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
	
	set rs=cnn.execute("spCoordinacionGobierno_Listar " & PRY_Id)	
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spCoordinacionGobierno_Listar")
		cnn.close 		
		response.end
	End If				
	dim fs,f
	set fs=Server.CreateObject("Scripting.FileSystemObject")	
	dataMesasBiTri = "{""data"":["
	do While Not rs.EOF
		CGO_Id=rs("CGO_Id")
		if len(CGO_Id)>1 then
			yCGO_Id=""
			for i=0 to len(CGO_Id)
				if(isnumeric(mid(CGO_Id,i,1))) then
					yCGO_Id=yCGO_Id & mid(CGO_Id,i,1)
				end if
			next
		else
			yCGO_Id=cint(CGO_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorcoordactoresgob\g-" & yCGO_Id								
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
			clasedown="dovercgo"
			disableddown="pointer"
			data = "data-id='" & rs("CGO_Id") & "' data-pry='" & PRY_Id & "' data-tip='GOB' data-hito='121'"
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"
			data = ""
		end if
		
		verificador = "<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"

		acciones = "<i class='fas fa-trash text-danger delcoordgobl' data-toggle='tooltip' title='Elimina sesion' data-pry='" & PRY_Id & "' data-cgo='" & rs("CGO_Id") & "'></i> "
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			dataMesasBiTri = dataMesasBiTri & "[""" & rs("CGO_Id") & """,""" & rs("CGO_NumSesion") & """,""" & rs("CGO_DiaActividad") & """,""" & rs("CGO_TematicaAbordada") & """,""" & rs("CGO_ContenidosTrabajados") & """,""" & rs("CGO_Conclusion") & """,""" & rs("CGO_Compromiso") & """,""" & verificador & """,""" & acciones & """]" 	
		else
			dataMesasBiTri = dataMesasBiTri & "[""" & rs("CGO_Id") & """,""" & rs("CGO_NumSesion") & """,""" & rs("CGO_DiaActividad") & """,""" & rs("CGO_TematicaAbordada") & """,""" & rs("CGO_ContenidosTrabajados") & """,""" & rs("CGO_Conclusion") & """,""" & rs("CGO_Compromiso") & """,""" & verificador & """,""" & """]" 
		end if
											
		rs.movenext
		if not rs.eof then
			dataMesasBiTri = dataMesasBiTri & ","
		end if
		
	loop
	dataMesasBiTri=dataMesasBiTri & "]}"	
	response.write(dataMesasBiTri)
%>