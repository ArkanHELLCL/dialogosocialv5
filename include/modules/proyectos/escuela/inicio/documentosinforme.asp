<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id		= request("PRY_Id")		
	PRY_Hito	= request("PRY_Hito")
	mode		= request("mode")
	
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
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		LFO_Id=rs("LFO_Id")
		LIN_Id=rs("LIN_Id")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)

		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")		
		PRY_InformeParcialEstado=rs("PRY_InformeParcialEstado")
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")

		PRY_InformeInicioAceptado=rs("PRY_InformeInicioAceptado")
		PRY_InformeParcialAceptado=rs("PRY_InformeParcialAceptado")
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
	end if

	if(PRY_CreacionProyectoEstado="") then
		PRY_CreacionProyectoEstado=0
	end if
	if(PRY_InformeInicioEstado="") then
		PRY_InformeInicioEstado=0
	end if
	if(PRY_InformeParcialEstado="") then
		PRY_InformeParcialEstado=0
	end if
	if(PRY_InformeFinalEstado="") then
		PRY_InformeFinalEstado=0
	end if
	
	if(IsNull(PRY_InformeInicioAceptado)) then
		PRY_InformeInicioAceptado=0
	end if
	if(IsNull(PRY_InformeParcialAceptado)) then
		PRY_InformeParcialAceptado=0
	end if
	if(IsNull(PRY_InformeFinalAceptado)) then
		PRY_InformeFinalAceptado=0
	end if
		
	set rs = cnn.Execute("exec [spVerificadorProyecto_Listar] 1," & PRY_Id & "," & PRY_Hito & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spVerificadorProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
		
	activaacc = true
	carpeta_informe="no_definido"
	if LFO_Id=10 then
		if PRY_Hito=0 then
			carpeta_informe="informecreacion"			
		else
			if PRY_Hito=1 then
				carpeta_informe="informeinicio"				
				if(PRY_InformeInicioAceptado) then
					activaacc=false
				end if			
			else
				if PRY_Hito=2 then
					carpeta_informe="informeparcial"
					if(PRY_InformeParcialAceptado) then
						activaacc=false
					end if
				else
					'if PRY_Hito=3 then
					'	carpeta_informe="informedesarrollo"
					'else
						'if PRY_Hito=4 then
						if PRY_Hito=3 then
							if(PRY_InformeFinalAceptado) then
								activaacc=false
							end if
							carpeta_informe="informefinal"
						else
							activaacc=false
							carpeta_informe="no_definido"
						end if
					'end if
				end if
			end if
		end if
	else
		if LFO_Id=11 then
			if PRY_Hito=0 then
				carpeta_informe="informecreacion"
			else
				if PRY_Hito=1 then
					carpeta_informe="informeinicial"
				else
					if PRY_Hito=2 then
						carpeta_informe="informeavances"
					else
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							if PRY_Hito=999 then
								carpeta_informe="verificadoresmesas"
							else
								carpeta_informe="no_definido"
							end if
						end if
					end if
				end if
			end if
		else
			if LFO_Id=12 then
				if PRY_Hito=0 then
					carpeta_informe="informecreacion"
				else
					if PRY_Hito=1 then
						carpeta_informe="informeinicio"
					else			
						if PRY_Hito=2 then
							carpeta_informe="informefinal"
						else						
							carpeta_informe="no_definido"
						end if 
					end if
				end if
			else
				if LFO_Id=13 then
					if PRY_Hito=0 then
						carpeta_informe="informecreacion"
					else
						if PRY_Hito=1 then
							carpeta_informe="informeinicial"
						else
							if PRY_Hito=2 then
								carpeta_informe="informeavances"
							else
								if PRY_Hito=3 then
									carpeta_informe="informefinal"
								else
									if PRY_Hito=999 then
										carpeta_informe="verificadoresrecuperacion"
									else
										carpeta_informe="no_definido"
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
	
	xpath="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\" & carpeta_informe & "\documentos\tpo-"
	x=0				
	dataDocumentos = "{""data"":["
	do While Not rs.EOF				
		if x=1 then
			dataDocumentos = dataDocumentos & ","
		end if
		x=1
		VER_Corr=rs("VER_Corr")
		if len(VER_Corr)>1 then
			yVER_Corr=""
			for i=0 to len(VER_Corr)
				if(isnumeric(mid(VER_Corr,i,1))) then
					yVER_Corr=yVER_Corr & mid(VER_Corr,i,1)
				end if
			next
		else
			if(VER_Corr="" or IsNull(VER_Corr)) then
				yVER_Corr=-1
			else
				yVER_Corr=cint(VER_Corr)
			end if
		end if
		if(yVER_Corr>=0) then
			path=xpath & yVER_Corr
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
		else
			archivos = 0
		end if	
		
		if(rs("VPR_EstadoSubido")=1) then
			subido="<i class='fas fa-thumbs-up subido text-primary'></i>"
		else
			subido="-"
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
			clasedown="dodocumentos"
			disableddown="pointer"

			colorup="text-white-50"
			claseup=""
			disabledup="not-allowed"

			if(activaacc) then
				colordel="text-danger"
				clasedel="deldocumentos"
				disableddel="pointer"

				colorcheck="text-warning"
				clasecheck="checkdocumentos"
				disabledcheck="pointer"

				coloraccept="text-info"
				claseaccept="acceptdocumentos"
				disabledaccept="pointer"

				colorreject="text-danger"
				clasereject="rejectdocumentos"
				disabledreject="pointer"
			end if

		else			
			colordown="text-white-50"
			clasedown=""
			disableddown="not-allowed"

			colorup="text-primary"
			claseup="updocumentos"
			disabledup="pointer"
			
		end if
		
		if(rs("VPR_EstadoAprobado")=1) then
			aprobado="<i class='fas fa-thumbs-up aprobado text-success'></i>"
		else
			aprobado="-"
		end if			
		
		if(rs("VPR_EstadoRechazado")=1) then
			rechazo="<i class='fas fa-thumbs-down rechazado text-danger'></i>"
		else
			rechazo="-"
		end if
		if(rs("VPR_EstadoRevisado")=1) then
			revisado="<i class='fas fa-thumbs-up revisado text-warning'></i>"
		else
			revisado="-"
		end if
		if(rs("VPR_EstadoEliminado")=1) then
			eliminado="<i class='fas fa-trash-alt eliminado text-danger'></i>"
		else
			eliminado="-"
		end if
		
		data="data-id='" & rs("VER_Corr") & "' data-pry='" & PRY_Id & "'"			
		acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"

		if(mode="mod") and (session("ds5_usrperfil")=1) then	'Adm - todo
			acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Reviasar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Eliminar documento'></i>"
		else
			'if(mode="mod") and (session("ds5_usrperfil")=2) then
			if(session("ds5_usrperfil")=2) then
				acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-check " & colorcheck & " " & clasecheck & "' style='cursor:" & disabledcheck & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Revisar documento'></i> <i class='fas fa-thumbs-up " & coloraccept & " " & claseaccept & "' style='cursor:" & disabledaccept & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Aceptar documento'></i> <i class='fas fa-thumbs-down " & colorreject & " " & clasereject & "' style='cursor:" & disabledreject & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Rechazar documento'></i> <i class='fas fa-trash-alt' style='cursor:not-allowed' title='Eliminar documento'></i>"
			else
				if(mode="mod") and (session("ds5_usrperfil")=3) then
					if(rs("VPR_EstadoAprobado")=1) and (rs("VPR_EstadoRevisado")=1) then
						acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt text-white-50' style='cursor:not-allowed' title='Eliminar documento'></i>"
					else
						if(rs("VPR_EstadoRechazado")=1) then
							acciones="<i class='fas fa-cloud-upload-alt text-white-50' style='cursor:not-allowed' title='Subir documento'></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Eliminar documento'></i>"
						else
							acciones="<i class='fas fa-cloud-upload-alt " & claseup & " " & colorup & "' style='cursor:" & disabledup & "' title='Subir documento' " & data & "></i> <i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i> <i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-obj='" & rs("VPR_Corr") & "' data-pry='" & PRY_Id & "'" & data & " title='Eliminar documento'></i>"
						end if
					end if
				end if
			end if
		end if

		barradeprogreso="<div class='progress-bar'><div class='progress'></div></div>"
		acciones=acciones & barradeprogreso	
		
		dataDocumentos = dataDocumentos & "[""" & rs("VER_Corr") & """,""" & rs("VER_Descripcion") & """,""" & subido & """,""" & rs("VPR_FechaSubido") & """,""" & rs("VPR_UsuarioSubido")	& """,""" & revisado & """,""" & rs("VPR_FechaRevisado") & """,""" & rs("VPR_UsuarioRevisado") & """,""" & aprobado & """,""" & rs("VPR_FechaAprobado") & """,""" & rs("VPR_UsuarioAprobado") & """,""" & rechazo & """,""" & rs("VPR_FechaRechazado") & """,""" & rs("VPR_UsuarioRechazado") & """,""" & eliminado & """,""" & rs("VPR_FechaEliminado") & """,""" & rs("VPR_UsuarioEliminado")	& """,""" & acciones & """]"			
	
		rs.movenext		
	loop	
	dataDocumentos=dataDocumentos & "]}"
	dataDocumentos=replace(replace(replace(dataDocumentos,",,",","),"[,[","[["),"],]","]]")
	set f=nothing
	set fs=nothing
	response.write(dataDocumentos)
%>