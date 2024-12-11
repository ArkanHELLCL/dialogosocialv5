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
		
	set rs = cnn.Execute("exec spPrioridadEmpresa_Listar 1," & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spPrioridadEmpresa_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	dim fs,f
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataPriEmp = "{""data"":["
	do While Not rs.EOF
		PRE_Id=rs("PRE_Id")
		if len(PRE_Id)>1 then
			yPRE_Id=""
			for i=0 to len(PRE_Id)
				if(isnumeric(mid(PRE_Id,i,1))) then
					yPRE_Id=yPRE_Id & mid(PRE_Id,i,1)
				end if
			next
		else
			yPRE_Id=cint(PRE_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorempresagrp\e-" & yPRE_Id								
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
			clasedown="doverpre"
			disableddown="pointer"
			data = "data-id='" & rs("PRE_Id") & "' data-pry='" & PRY_Id & "' data-tip='EMP' data-hito='117'"
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"
			data = ""
		end if
		
		verificador = "<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"

		acciones = "<i class='fas fa-trash text-danger delpriemp' data-toggle='tooltip' title='Elimina Prioridad' data-pry='" & PRY_Id & "' data-pre='" & rs("PRE_Id") & "'></i> "
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			dataPriEmp = dataPriEmp & "[""" & rs("PRE_Id") & """,""" & rs("PRE_Prioridad") & """,""" & rs("PRE_Problematica") & """,""" & rs("PRE_ExpectativaSolucion") & """,""" & rs("PRE_Compromiso") & """,""" & verificador & """,""" & acciones & """]" 	
		else
			dataPriEmp = dataPriEmp & "[""" & rs("PRE_Id") & """,""" & rs("PRE_Prioridad") & """,""" & rs("PRE_Problematica") & """,""" & rs("PRE_ExpectativaSolucion") & """,""" & rs("PRE_Compromiso") & """,""" & verificador & """,""" & """]" 
		end if
											
		rs.movenext
		if not rs.eof then
			dataPriEmp = dataPriEmp & ","
		end if
		
	loop
	dataPriEmp=dataPriEmp & "]}"	
	response.write(dataPriEmp)
%>