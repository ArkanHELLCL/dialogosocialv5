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
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
			PRY_InformeFinalEstado=0
		end if
		if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=0
		end if
	end if
		
	set rs = cnn.Execute("exec spEstrategiaConvocatoria_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spEstrategiaConvocatoria_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	VER_EstadoAprobado=0
	VER_EstadoSubido=0
	VER_EstadoRechazado=0
	VER_EstadoRevisado=0
	VER_Total=0	
	dataEstrategiaConv = "{""data"":["
	do While Not rs.EOF
		VER_Total=VER_Total+1
		ESC_Id=rs("ESC_Id")
		if len(ESC_Id)>1 then
			yESC_Id=""
			for i=0 to len(ESC_Id)
				if(isnumeric(mid(ESC_Id,i,1))) then
					yESC_Id=yESC_Id & mid(ESC_Id,i,1)
				end if
			next
		else
			yESC_Id=cint(ESC_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadorconvocatoria\c-" & yESC_Id
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

		if(archivos>0) then												
			colordown="text-success"
			clasedown="doverestconv"
			disableddown="pointer"

			colorup="text-white-50"
			claseup=""
			disabledup="not-allowed"

			if (PRY_InformeFinalAceptado=0 and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2)) or (PRY_InformeFinalEstado=0 and (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1)) then
				if((rs("ESC_EstadoAprobado")=0) and (rs("ESC_EstadoRevisado")=0)) or (rs("ESC_EstadoRechazado")=1) then
					colordel="text-danger"
					clasedel="delverestconv"
					disableddel="pointer"
				end if

				colorcheck="text-warning"
				clasecheck="chkverestconv"
				disabledcheck="pointer"

				coloraccept="text-info"
				claseaccept="acceptverestconv"
				disabledaccept="pointer"

				colorreject="text-danger"
				clasereject="rejectverestconv"
				disabledreject="pointer"
			end if
		else			
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colorup="text-primary"
			claseup="upverestconv"
			disabledup="pointer"			
		end if
		data="data-id='" & rs("ESC_Id") & "' data-pry='" & PRY_Id & "'"
		acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"
		if(session("ds5_usrperfil")=1) then	'Adm - todo
			acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"			
		else
			if(session("ds5_usrperfil")=2) then
				acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt text-white-50' style='cursor:not-allowed' title='Eliminar documento'></i>"			
			else
				if(session("ds5_usrperfil")=3) then
					acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"		
				else
					acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & ">"
				end if
			end if
		end if				
		
		if(rs("ESC_EstadoAprobado")=1) then
			aprobado="<i class='fas fa-thumbs-up aprobado text-success'></i>"
			VER_EstadoAprobado = VER_EstadoAprobado + 1
		else
			aprobado="-"
		end if			
		if(rs("ESC_EstadoSubido")=1) then
			subido="<i class='fas fa-thumbs-up subido text-primary'></i>"
			VER_EstadoSubido = VER_EstadoSubido + 1
		else
			subido="-"
		end if
		if(rs("ESC_EstadoRechazado")=1) then
			rechazado="<i class='fas fa-thumbs-down rechazado text-danger'></i>"
			VER_EstadoRechazado = VER_EstadoRechazado + 1
		else
			rechazado="-"
		end if
		if(rs("ESC_EstadoRevisado")=1) then
			revisado="<i class='fas fa-thumbs-up revisado text-warning'></i>"
			VER_EstadoRevisado = VER_EstadoRevisado + 1
		else
			revisado="-"
		end if		

		barradeprogreso="<div class='progress-bar'><div class='progress'></div></div>"
		acciones=acciones & barradeprogreso
	
		dataEstrategiaConv = dataEstrategiaConv & "[""" & rs("ESC_Id") & """,""" & rs("ESC_Accion") & """,""" & rs("ESC_DescripcionAccion") & """,""" & subido & """,""" & revisado & """,""" & aprobado & """,""" & rechazado	& """,""" & acciones & """]"		
		
		rs.movenext
		if not rs.eof then
			dataEstrategiaConv = dataEstrategiaConv & ","
		end if
		
	loop
	dataEstrategiaConv=dataEstrategiaConv & "],""VER_Total"":""" & VER_Total & """,""VER_EstadoAprobado"":""" & VER_EstadoAprobado & """,""VER_EstadoSubido"":""" & VER_EstadoSubido & """,""VER_EstadoRechazado"":""" & VER_EstadoRechazado & """,""VER_EstadoRevisado"":""" & VER_EstadoRevisado & """}"
	
	response.write(dataEstrategiaConv)	
%>