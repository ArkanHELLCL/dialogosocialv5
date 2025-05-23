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
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeSistematizacionAceptado = rs("PRY_InformeSistematizacionAceptado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
	if(PRY_InformeSistematizacionEstado="" or IsNULL(PRY_InformeSistematizacionEstado)) then
		PRY_InformeSistematizacionEstado=0
	end if
	if(PRY_InformeSistematizacionAceptado="" or IsNULL(PRY_InformeSistematizacionAceptado)) then
		PRY_InformeSistematizacionAceptado=0
	end if
		
	set rs = cnn.Execute("exec [spGruposFocalessMesas_Listar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spGruposFocalessMesas_Listar] " & ErrMsg)
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	VER_EstadoAprobadoMesas=0
	VER_EstadoSubidoMesas=0
	VER_EstadoRechazadoMesas=0
	VER_EstadoRevisadoMesas=0
	VER_TotalMesas=0	
	dataGrpFocales = "{""data"":["
	do While Not rs.EOF	
		VER_TotalMesas=VER_TotalMesas+1
		PRS_Id=rs("PRS_Id")
		if len(PRS_Id)>1 then
			yPRS_Id=""
			for i=0 to len(PRS_Id)
				if(isnumeric(mid(PRS_Id,i,1))) then
					yPRS_Id=yPRS_Id & mid(PRS_Id,i,1)
				end if
			next
		else
			yPRS_Id=cint(PRS_Id)
		end if

        tipo=""
        subcarpeta=""
        if(rs("PRS_Tipo")="SIN") then
            tipo="Sindicatos"
            subcarpeta="\verificadorsindicatogrp\s-"
			PRY_Hito = 116
        else
            if(rs("PRS_Tipo")="EMP") then
                tipo="Empresas"
                subcarpeta="\verificadorempresagrp\e-"
				PRY_Hito = 117
            else                
                if(rs("PRS_Tipo")="GOB") then
                    tipo="Gobierno"
                    subcarpeta="\verificadorgobiernogrp\g-"
                    PRY_Hito = 118
                end if                
            end if
        end if

		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & subcarpeta & yPRS_Id
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
			clasedown="dovergrp"
			disableddown="pointer"

			colorup="text-white-50"
			claseup=""
			disabledup="not-allowed"

			if (PRY_InformeSistematizacionEstado=0 and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3)) or (PRY_InformeSistematizacionAceptado=0 and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2)) then
				if((rs("PRS_EstadoAprobado")=0) and (rs("PRS_EstadoRevisado")=0)) or (rs("PRS_EstadoRechazado")=1) then
					colordel="text-danger"
					clasedel="delvergrp"
					disableddel="pointer"
				end if
				colorcheck="text-warning"
				clasecheck="chkvergrp"
				disabledcheck="pointer"

				coloraccept="text-info"
				claseaccept="acceptvergrp"
				disabledaccept="pointer"

				colorreject="text-danger"
				clasereject="rejectvergrp"
				disabledreject="pointer"						
			end if						
		else						
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colorup="text-primary"
			claseup="upvergrp"
			disabledup="pointer"									
		end if
		data="data-id='" & rs("PRS_Id") & "' data-pry='" & PRY_Id & "' data-tip='" & rs("PRS_Tipo") & "' data-hito='" & PRY_Hito & "'"
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
		
		if(rs("PRS_EstadoAprobado")=1) then
			aprobado="<i class='fas fa-thumbs-up aprobado text-success'></i>"
			VER_EstadoAprobadoMesas = VER_EstadoAprobadoMesas + 1
		else
			aprobado="-"
		end if			
		if(rs("PRS_EstadoSubido")=1) then
			subido="<i class='fas fa-thumbs-up subido text-primary'></i>"
			VER_EstadoSubidoMesas = VER_EstadoSubidoMesas + 1
		else
			subido="-"
		end if
		if(rs("PRS_EstadoRechazado")=1) then
			rechazado="<i class='fas fa-thumbs-down rechazado text-danger'></i>"
			VER_EstadoRechazadoMesas = VER_EstadoRechazadoMesas + 1
		else
			rechazado="-"
		end if
		if(rs("PRS_EstadoRevisado")=1) then
			revisado="<i class='fas fa-thumbs-up revisado text-warning'></i>"
			VER_EstadoRevisadoMesas = VER_EstadoRevisadoMesas + 1
		else
			revisado="-"
		end if		

		barradeprogreso="<div class='progress-bar'><div class='progress'></div></div>"
		acciones=acciones & barradeprogreso
		
		dataGrpFocales = dataGrpFocales & "[""" & rs("PRS_Id") & """,""" & rs("PRS_Prioridad") & """,""" & rs("PRS_Problematica") & """,""" & rs("PRS_ExpectativaSolucion") & """,""" & tipo & """,""" & subido & """,""" & revisado & """,""" & aprobado & """,""" & rechazado	& """,""" & acciones & """]"
									
		rs.movenext
		if not rs.eof then
			dataGrpFocales = dataGrpFocales & ","
		end if
		
	loop
	dataGrpFocales=dataGrpFocales & "],""VER_TotalMesas"":""" & VER_TotalMesas & """,""VER_EstadoAprobadoMesas"":""" & VER_EstadoAprobadoMesas & """,""VER_EstadoSubidoMesas"":""" & VER_EstadoSubidoMesas & """,""VER_EstadoRechazadoMesas"":""" & VER_EstadoRechazadoMesas & """,""VER_EstadoRevisadoMesas"":""" & VER_EstadoRevisadoMesas & """}"
	set f=nothing
	set fs=nothing
	response.write(dataGrpFocales)
%>