<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	
	Dim ruta
	Dim streamFile, fileItem, filePath, up
	Dim sFileName

	Set up = New FreeASPUpload
	up.Upload()

	Response.Flush	
	
	PRY_Id							 = up.form("PRY_Id")
	PRY_Identificador				 = up.form("PRY_Identificador")
	
	'Rut								 = up.form("ALU_Rut")
	Rut								 = up.form("Rut")
	ALU_Rut							 = mid(Rut,1,Len(Rut)-1)
	ALU_Dv							 = mid(Rut,Len(Rut),1)
	ALU_Nombre						 = LimpiarUrl(up.form("ALU_Nombre"))
	ALU_ApellidoPaterno				 = LimpiarUrl(up.form("ALU_ApellidoPaterno"))
	ALU_ApellidoMaterno				 = LimpiarUrl(up.form("ALU_ApellidoMaterno"))
	NAC_Id							 = up.form("NAC_Id")
	SEX_Id							 = up.form("SEX_Id")
	EDU_Id							 = up.form("EDU_Id")
	ALU_Discapacidad				 = up.form("ALU_Discapacidad")
	if(ALU_Discapacidad="") then
		ALU_Discapacidad=0
		TDI_Id							 = "NULL"
	else
		ALU_Discapacidad=1	'on
		TDI_Id							 = up.form("TDI_Id")
	end if
	
	ALU_FechaCreacionRegistro		 = up.form("ALU_FechaCreacionRegistro")	
	ALU_AccesoInternet				 = up.form("ALU_AccesoInternet")
	if(ALU_AccesoInternet="") then
		ALU_AccesoInternet=0
	else
		ALU_AccesoInternet=1
	end if
	ALU_DispositivoElectronico		 = up.form("ALU_DispositivoElectronico")
	if(ALU_DispositivoElectronico="") then
		ALU_DispositivoElectronico=0
	else
		ALU_DispositivoElectronico=1
	end if
	ALU_ReconocePuebloOriginario	 = up.form("ALU_ReconocePuebloOriginario")
	if(ALU_ReconocePuebloOriginario="") then
		ALU_ReconocePuebloOriginario=0
	else
		ALU_ReconocePuebloOriginario=1
	end if
	ALU_PuebloOriginario			 = LimpiarUrl(up.form("ALU_PuebloOriginario"))
	'ALU_Ficha						 = up.form("ALU_FichaX")
	
	'REG_Id							 = up.form("")
	COM_Id							 = up.form("COM_Id")
	ALU_Direccion					 = LimpiarUrl(up.form("ALU_Direccion"))
	ALU_Mail						 = up.form("ALU_Mail")
	ALU_Telefono					 = up.form("ALU_Telefono")
	TTR_Id							 = up.form("TTR_Id")
	ALU_NombreEmpresa				 = LimpiarUrl(up.form("ALU_NombreEmpresa"))
	RUB_Id							 = up.form("RUB_Id")

	ALU_PerteneceSindicato			 = up.form("ALU_PerteneceSindicato")
	if(ALU_PerteneceSindicato="") then
		ALU_PerteneceSindicato=0
	else
		ALU_PerteneceSindicato=1
	end if
	ALU_FechaIngreso				 = up.form("ALU_FechaIngreso")
	ALU_NombreOrganizacion			 = LimpiarUrl(up.form("ALU_NombreOrganizacion"))
	ALU_RSU							 = LimpiarUrl(up.form("ALU_RSU"))
	ALU_PermisoCapacitacionEnOrganizacion	= up.form("ALU_PermisoCapacitacionEnOrganizacion")
	if(ALU_PermisoCapacitacionEnOrganizacion="") then
		ALU_PermisoCapacitacionEnOrganizacion=0
	else
		ALU_PermisoCapacitacionEnOrganizacion=1
	end if
	ALU_DirigenteSindical					= up.form("ALU_DirigenteSindical")
	if(ALU_DirigenteSindical="") then
		ALU_DirigenteSindical=0
	else
		ALU_DirigenteSindical=1
	end if
	ALU_TiempoDirigenteSindical				= up.form("ALU_TiempoDirigenteSindical")
	ALU_CursosFormacionSindicalAnteriormente= up.form("ALU_CursosFormacionSindicalAnteriormente")
	if(ALU_CursosFormacionSindicalAnteriormente="") then
		ALU_CursosFormacionSindicalAnteriormente= 0
		ALU_AnioCursoFormacionSindical			= "NULL"
	else
		ALU_CursosFormacionSindicalAnteriormente= 1
		ALU_AnioCursoFormacionSindical			= up.form("ALU_AnioCursoFormacionSindical")
	end if
	ALU_InstitucionCursoFormacionSindical	= LimpiarUrl(up.form("ALU_InstitucionCursoFormacionSindical"))
	
	ALU_CargoDirectivoEnOrganizacion		= up.form("ALU_CargoDirectivoEnOrganizacion")
	if(ALU_CargoDirectivoEnOrganizacion="") then
		ALU_CargoDirectivoEnOrganizacion=0
	else
		ALU_CargoDirectivoEnOrganizacion=1
	end if
	ALU_FechaInicioCargoDirectivo			= up.form("ALU_FechaInicioCargoDirectivo")
	ALU_NombreCargoDirectivo				= LimpiarUrl(up.form("ALU_NombreCargoDirectivo"))
	ALU_FechaNacimiento						= up.form("ALU_FechaNacimiento")
	
	'Obteniendo el nombre del archivo a subir
	fileItems = up.UploadedFiles.Items
	set fileItem = fileItems(0)
	outFileName = fileItem.FileName

	ALU_Ficha		  						  = outFileName
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
	
	xsql = "exec spProyecto_Consultar " & PRY_Id	
	set rs = cnn.Execute(xsql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503\\Error Conexión 2:" & ErrMsg & "-" & xsql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then						
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then
	else
		response.Write("403\\Acción no autorizada")
		response.End() 	
	end if
	
	datos =   ALU_Rut & ",'" & ALU_DV & "'," & PRY_Id & "," & SEX_Id & ",'" & ALU_Nombre & "','" & ALU_ApellidoPaterno & "','" & ALU_ApellidoMaterno & "','" & ALU_Direccion & "'," & COM_Id & ",'" & ALU_Telefono & "','" & ALU_Mail & "','" & ALU_NombreEmpresa & "'," & RUB_Id & "," & EDU_Id & "," & ALU_PerteneceSindicato & ",'" & ALU_NombreOrganizacion & "','" & ALU_RSU & "','" & ALU_FechaCreacionRegistro & "'," & ALU_PermisoCapacitacionEnOrganizacion & "," & ALU_CargoDirectivoEnOrganizacion & ",'" & ALU_NombreCargoDirectivo & "','" & ALU_FechaInicioCargoDirectivo & "'," & ALU_CursosFormacionSindicalAnteriormente & ",'" & ALU_AnioCursoFormacionSindical & "','" & ALU_InstitucionCursoFormacionSindical & "'," & NAC_Id & ",'" & ALU_Ficha & "'," & ALU_Discapacidad & "," & TDI_Id & "," & ALU_ReconocePuebloOriginario & ",'" & ALU_PuebloOriginario & "'," & TTR_Id & "," & ALU_DirigenteSindical & ",'" & ALU_TiempoDirigenteSindical & "'," & ALU_AccesoInternet & "," & ALU_DispositivoElectronico & ",'" & ALU_FechaNacimiento & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


	'Adjunto
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description
	    response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		path="D:\DocumentosSistema\dialogosocial\fichasalumnos\" & ALU_Rut & "\"
	else
		response.Write("1\\No fue posible obtener la carpeta del proyecto:")	   
		cnn.close 		
		response.End()
	end if
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f

	folders = Split(path, "\")
	currentFolder = ""
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(folders)
		currentFolder = currentFolder & folders(i)
		'response.write("</br>" & currentFolder & "</br>")
		If fs.FolderExists(currentFolder) <> true Then
			Set f=fs.CreateFolder(currentFolder)
			Set f=nothing       
		End If      
		currentFolder = currentFolder & "\"
	Next

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()	

	ruta=path		
	up.Save(ruta)	'Subiendo archivo		
	
	sql="exec spAlumno_Agregar " & datos 	
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then
		result=rs("Result")
		if(result=4) then
			response.write("4\\Alumno ya ejecutó éste programa en el 2023")	
		else
			if(result=3) then
				response.write("3\\Usuario no autorizado")	
			else
				if(result=1) then
					response.write("3\\Alumno ya se encuentra matriculado en otro proyecto")	
				else
					response.write("200\\")
				end if
			end if
		end if
	end if
	
%>