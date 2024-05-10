<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") then
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
		PRY_InformeSistematizacionAceptado=rs("PRY_InformeSistematizacionAceptado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		LFO_Id=rs("LFO_Id")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=false
		end if
		if(PRY_InformeSistematizacionAceptado="" or IsNULL(PRY_InformeSistematizacionAceptado)) then
			PRY_InformeSistematizacionAceptado=false
		end if
		if(LFO_Id=10 or LFO_Id=12) then
			PRY_InfFinal = PRY_InformeFinalAceptado
		end if
		if(LFO_Id=11) then
			PRY_InfFinal = PRY_InformeSistematizacionAceptado
		end if
	end if
		
	set rs = cnn.Execute("exec spAdecuaciones_Listar " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAdecuaciones_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	
	cont=0
	dataAdecuaciones = "{""data"":["
	do While Not rs.EOF		
		if cont=1 then
			dataAdecuaciones = dataAdecuaciones & ","				
		end if
		cont = 1
		ADE_Id=rs("ADE_Id")
		if len(ADE_Id)>1 then
			yADE_Id=""
			for i=0 to len(ADE_Id)
				if(isnumeric(mid(ADE_Id,i,1))) then
					yADE_Id=yADE_Id & mid(ADE_Id,i,1)
				end if
			next
		else
			yADE_Id=cint(ADE_Id)
		end if		
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\adecuaciones\ade-" & yADE_Id & "\"
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
			colordown="text-primary"
			colordel="text-danger"			
			disableddown="pointer"
			disableddel="pointer"
			data="data-id='" & rs("ADE_Id") & "' data-pry='" & PRY_Id & "'"
			clasedown="dowade"
			clasedel="delade"
		else			
			colordown="text-white-50"
			colordel="text-white-50"			
			disableddown="not-allowed"
			disableddel="not-allowed"
			data=""
			clasedown=""
			clasedel=""
		end if
		if(rs("TAD_Id")<>7) then
			vermod = "<i class='fas fa-chevron-down text-secondary vermod' data-toggle='tooltip' title='Ver modificaciones'></i>"
		else
			vermod=""
		end if
		'if((session("ds5_usrperfil")=2) and (rs("ADE_EstadoRespuesta")=0 and rs("TAD_Id")<>1)) or (session("ds5_usrperfil")=1 and rs("ADE_EstadoRespuesta")=0) and not PRY_InfFinal then		'Administrador y revisor puden aceptar o rechazar
		if((session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) and (rs("ADE_EstadoRespuesta")=0)) and not PRY_InfFinal then		'Administrador y revisor puden aceptar o rechazar
			Acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar adjunto' " & data & " data-toggle='tooltip'></i> <i class='fas fa-thumbs-up text-success acemod' title='Aceptar adecuación' data-id='" & ADE_Id & "' data-toggle='tooltip'></i> <i class='fas fa-thumbs-down text-danger recmod' title='Rechazar adecuación' data-id='" & ADE_Id & "' data-toggle='tooltip'></i> " & vermod & "<span style='display:none'></span>"
		else
			Acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar adjunto' " & data & " data-toggle='tooltip'></i> " & vermod & "<span style='display:none'>" & "</span>"
		end if

		if(rs("ADE_EstadoRespuesta")=0) then
			estado="Pendiente"
		else
			if(rs("ADE_EstadoRespuesta")=2) then
				estado="Aceptado"
			else
				if(rs("ADE_EstadoRespuesta")=3) then
					estado="Rechazado"
				else
					estado="No definido"
				end if
			end if
		end if
		
		ADE_DescripcionAdecuacion = replace(rs("ADE_DescripcionAdecuacion"),"""","\""")
		ADE_JustificacionAdecuacion = replace(rs("ADE_JustificacionAdecuacion"),"""","\""")
		ADE_Observaciones = replace(rs("ADE_Observaciones"),"""","\""")
		
		dataAdecuaciones = dataAdecuaciones & "[""" & rs("PRY_Id") & """,""" & rs("ADE_Id") & """,""" & rs("ADE_UsuarioSolicitaDescripcion") & """,""" & rs("ADE_FechaSolicitud") & """,""" & rs("TAD_Id") & """,""" & rs("TAD_Descripcion") & """,""" & ADE_DescripcionAdecuacion & """,""" & rs("ADE_UsuarioRespondeDescripcion") & """,""" & rs("ADE_FechaRespuesta") & """,""" & estado & """,""" & Acciones & """,""" & ADE_JustificacionAdecuacion & """,""" & ADE_Observaciones & """,""" & rs("ADE_EstadoRespuesta") & """]"								

		rs.movenext
	loop
	dataAdecuaciones=dataAdecuaciones & "]}"
	
	response.write(dataAdecuaciones)
%>