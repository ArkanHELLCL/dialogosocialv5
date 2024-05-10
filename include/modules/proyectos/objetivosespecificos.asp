<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") or session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 then
		modo=2
		mode="mod"
	end if
	if session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
		modo=4
		mode="vis"
	end if		
	
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
		
	set rs = cnn.Execute("exec spObjetivoEspecifico_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spObjetivoEspecifico_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
		
	dataObjEsp = "{""data"":["
	do While Not rs.EOF	
		OES_Id=rs("OES_Id")
		if len(OES_Id)>1 then
			yOES_Id=""
			for i=0 to len(OES_Id)
				if(isnumeric(mid(OES_Id,i,1))) then
					yOES_Id=yOES_Id & mid(OES_Id,i,1)
				end if
			next
		else
			yOES_Id=cint(OES_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresproyecto\p-" & yOES_Id
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
			clasedown="doverobj"
			disableddown="pointer"

			colorup="text-white-50"
			claseup=""
			disabledup="not-allowed"

			colordel="text-danger"
			clasedel="delverobj"
			disableddel="pointer"

			colorcheck="text-warning"
			clasecheck="checkverobj"
			disabledcheck="pointer"

			coloraccept="text-info"
			claseaccept="acceptverobj"
			disabledaccept="pointer"

			colorreject="text-danger"
			clasereject="rejectverobj"
			disabledreject="pointer"						
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colorup="text-primary"
			claseup="upverobj"
			disabledup="pointer"

			colordel="text-white-50"			
			clasedel=""
			disableddel="not-allowed"

			colorcheck="text-white-50"
			clasecheck=""
			disabledcheck="not-allowed"

			coloraccept="text-white-50"
			claseaccept=""
			disabledaccept="not-allowed"

			colorreject="text-white-50"
			clasereject=""
			disabledreject="not-allowed"						
		end if
		data="data-id='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'"
		acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"
		if(mode="mod") and (session("ds5_usrperfil")=1) then	'Adm - todo
			acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"			
		else
			if(mode="mod") and (session("ds5_usrperfil")=2) then
				acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt text-white-50' style='cursor:not-allowed' title='Eliminar documento'></i>"			
			else
				if(mode="mod") and (session("ds5_usrperfil")=3) then
					acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"		
				else
				end if
			end if
		end if

		'if(mode="mod") and (session("ds5_usrperfil")=3) then	'eje
		''	if(rs("OES_EstadoAprobado")="" or IsNULL(rs("OES_EstadoAprobado")) or rs("OES_EstadoAprobado")=0) then	'solo subir, bajar y eliminar
		''		acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "><i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & "></i>"
		''	else	'solo subir y bajar
		''		acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "> </i>"
		''	end if
		'end if

		'if(mode="mod" and session("ds5_usrperfil")=2) then 'rev solo bajar, revisar
		''	acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & "></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & "></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & "></i>"
		'end if
		
		if(rs("OES_EstadoAprobado")=1) then
			aprobado="<i class='fas fa-thumbs-up aprobado text-success'></i>"
		else
			aprobado="-"
		end if			
		if(rs("OES_EstadoSubido")=1) then
			subido="<i class='fas fa-thumbs-up subido text-primary'></i>"
		else
			subido="-"
		end if
		if(rs("OES_EstadoRechazado")=1) then
			rechazado="<i class='fas fa-thumbs-down rechazado text-danger'></i>"
		else
			rechazado="-"
		end if
		if(rs("OES_EstadoRevisado")=1) then
			revisado="<i class='fas fa-thumbs-up revisado text-warning'></i>"
		else
			revisado="-"
		end if
		if(rs("OES_EstadoEliminado")=1) then
			eliminado="<i class='fas fa-trash-alt eliminado text-danger'></i>"
		else
			eliminado="-"
		end if
		
		dataObjEsp = dataObjEsp & "[""" & rs("OES_Id") & """,""" & rs("OES_ObjetivoEspecifico") & """,""" & rs("OES_ResultadoEsperado") & """,""" & rs("OES_Indicador") & """,""" & subido & """,""" & revisado & """,""" & aprobado & """,""" & rechazado	& """,""" & acciones & """]"
									
		rs.movenext
		if not rs.eof then
			dataObjEsp = dataObjEsp & ","
		end if
		
	loop
	dataObjEsp=dataObjEsp & "]}"
	set f=nothing
	set fs=nothing
	response.write(dataObjEsp)
%>