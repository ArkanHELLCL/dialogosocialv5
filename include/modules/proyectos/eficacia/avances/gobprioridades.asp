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
		
	set rs = cnn.Execute("exec spPrioridadGobierno_Listar 1," & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spPrioridadGobierno_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	dim fs,f
	set fs=Server.CreateObject("Scripting.FileSystemObject")	
	dataPriGob = "{""data"":["
	do While Not rs.EOF
		PRG_Id=rs("PRG_Id")
		if len(PRG_Id)>1 then
			yPRG_Id=""
			for i=0 to len(PRG_Id)
				if(isnumeric(mid(PRG_Id,i,1))) then
					yPRG_Id=yPRG_Id & mid(PRG_Id,i,1)
				end if
			next
		else
			yPRG_Id=cint(PRG_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorgobiernogrp\g-" & yPRG_Id								
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
			clasedown="doverpgb"
			disableddown="pointer"
			data = "data-id='" & rs("PRG_Id") & "' data-pry='" & PRY_Id & "' data-tip='GOB' data-hito='118'"
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"
			data = ""
		end if
		
		verificador = "<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"

		acciones = "<i class='fas fa-trash text-danger delprigob' data-toggle='tooltip' title='Elimina Prioridad' data-pry='" & PRY_Id & "' data-prg='" & rs("PRG_Id") & "'></i> "
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			dataPriGob = dataPriGob & "[""" & rs("PRG_Id") & """,""" & rs("PRG_Prioridad") & """,""" & rs("PRG_Problematica") & """,""" & rs("PRG_ExpectativaSolucion") & """,""" & rs("PRG_Compromiso") & """,""" & verificador & """,""" & acciones & """]" 	
		else
			dataPriGob = dataPriGob & "[""" & rs("PRG_Id") & """,""" & rs("PRG_Prioridad") & """,""" & rs("PRG_Problematica") & """,""" & rs("PRG_ExpectativaSolucion") & """,""" & rs("PRG_Compromiso") & """,""" & verificador & """,""" & """]" 
		end if
											
		rs.movenext
		if not rs.eof then
			dataPriGob = dataPriGob & ","
		end if
		
	loop
	dataPriGob=dataPriGob & "]}"	
	response.write(dataPriGob)
%>