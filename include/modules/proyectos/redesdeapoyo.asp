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
		
	set rs = cnn.Execute("exec [spPatrocinios_Listar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spPatrocinios_Listar] " & ErrMsg)
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
	dataPatrocinios = "{""data"":["
	do While Not rs.EOF	
		VER_Total=VER_Total+1
		PAT_Id=rs("PAT_Id")
		if len(PAT_Id)>1 then
			yPAT_Id=""
			for i=0 to len(PAT_Id)
				if(isnumeric(mid(PAT_Id,i,1))) then
					yPAT_Id=yPAT_Id & mid(PAT_Id,i,1)
				end if
			next
		else
			yPAT_Id=cint(PAT_Id)
		end if

        tipo=""
        subcarpeta=""
        if(rs("PAT_Tipo")="SIN") then
            tipo="Sindicato"
            subcarpeta="\verificadorsindicato\s-"
			PRY_Hito = 112
        else
            if(rs("PAT_Tipo")="EMP") then
                tipo="Empresa"
                subcarpeta="\verificadorempresa\e-"
				PRY_Hito = 113
            else
                if(rs("PAT_Tipo")="CIV") then
                    tipo="Civil"
                    subcarpeta="\verificadorcivil\c-"
					PRY_Hito = 114
                end if
            end if
        end if

		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & subcarpeta & yPAT_Id
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
			clasedown="doverpat"
			disableddown="pointer"

			colorup="text-white-50"
			claseup=""
			disabledup="not-allowed"
			
			if (PRY_InformeFinalAceptado=0 and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2)) or (PRY_InformeFinalEstado=0 and (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1)) then
				if((rs("PAT_EstadoAprobado")=0) and (rs("PAT_EstadoRevisado")=0)) or (rs("PAT_EstadoRechazado")=1) then
					colordel="text-danger"
					clasedel="delverpat"
					disableddel="pointer"
				end if
				colorcheck="text-warning"
				clasecheck="checkverpat"
				disabledcheck="pointer"

				coloraccept="text-info"
				claseaccept="acceptverpat"
				disabledaccept="pointer"

				colorreject="text-danger"
				clasereject="rejectverpat"
				disabledreject="pointer"						
			end if
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colorup="text-primary"
			claseup="upverpat"
			disabledup="pointer"									
		end if
		data="data-id='" & rs("PAT_Id") & "' data-pry='" & PRY_Id & "' data-tip='" & rs("PAT_Tipo") & "' data-hito='" & PRY_Hito & "'"
		acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"		
		if(session("ds5_usrperfil")=1) then		'Adm - todo		
			acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"			
		else			
			if(session("ds5_usrperfil")=2) then		'Revisor
				acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-pry='" & PRY_Id & "' " & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-pry='" & PRY_Id & "' " & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-pry='" & PRY_Id & "' " & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt text-white-50' style='cursor:not-allowed' title='Eliminar documento'></i>"			
			else				
				if(session("ds5_usrperfil")=3) then			'Ejecutor
					acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-pry='" & PRY_Id & "' " & data & " title='Eliminar documento'></i>"
				else
					acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & ">"
				end if
			end if
		end if		
		
		if(rs("PAT_EstadoAprobado")=1) then
			aprobado="<i class='fas fa-thumbs-up aprobado text-success'></i>"
			VER_EstadoAprobado = VER_EstadoAprobado + 1
		else
			aprobado="-"
		end if			
		if(rs("PAT_EstadoSubido")=1) then
			subido="<i class='fas fa-thumbs-up subido text-primary'></i>"
			VER_EstadoSubido = VER_EstadoSubido + 1
		else
			subido="-"
		end if
		if(rs("PAT_EstadoRechazado")=1) then
			rechazado="<i class='fas fa-thumbs-down rechazado text-danger'></i>"
			VER_EstadoRechazado = VER_EstadoRechazado + 1
		else
			rechazado="-"
		end if
		if(rs("PAT_EstadoRevisado")=1) then
			revisado="<i class='fas fa-thumbs-up revisado text-warning'></i>"
			VER_EstadoRevisado = VER_EstadoRevisado + 1
		else
			revisado="-"
		end if

		barradeprogreso="<div class='progress-bar'><div class='progress'></div></div>"
		acciones=acciones & barradeprogreso
		
		dataPatrocinios = dataPatrocinios & "[""" & rs("PAT_Id") & """,""" & rs("PAT_Nombre") & """,""" & rs("RUB_Nombre") & """,""" & rs("PAT_Compromiso") & """,""" & tipo & """,""" & subido & """,""" & revisado & """,""" & aprobado & """,""" & rechazado	& """,""" & acciones & """]"
									
		rs.movenext
		if not rs.eof then
			dataPatrocinios = dataPatrocinios & ","
		end if
		
	loop
	dataPatrocinios=dataPatrocinios & "],""VER_Total"":""" & VER_Total & """,""VER_EstadoAprobado"":""" & VER_EstadoAprobado & """,""VER_EstadoSubido"":""" & VER_EstadoSubido & """,""VER_EstadoRechazado"":""" & VER_EstadoRechazado & """,""VER_EstadoRevisado"":""" & VER_EstadoRevisado & """}"
	set f=nothing
	set fs=nothing
	response.write(dataPatrocinios)
%>