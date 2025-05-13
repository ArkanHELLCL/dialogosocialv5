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
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
	end if
		
	set rs = cnn.Execute("exec spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error AlumnoProyecto")
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataAlumnos = "{""data"":["
	do While Not rs.EOF
		if trim(rs("ALU_Ficha"))<>"" then			
			ALU_Ficha="<i class='fas fa-cloud-download-alt text-primary arcalm' data-arc='" & rs("ALU_Ficha") & "' data-pry='" & PRY_Id & "' data-token='" & PRY_Identificador & "' data-hito='98' data-rut='" & rs("ALU_Rut") &"'></i><span style='display:none'>" & rs("ALU_Ficha") & "</span>"
		else
			'ALU_Ficha = "<i class='fas fa-ban text-danger'></i><span style='display:none'>No</span>"
			ALU_Ficha = "-"
		end if
		if (rs("ALU_PerteneceSindicato")=1) then
			PerteneceSindicato="Si"
		else
			PerteneceSindicato="No"
		end if
		if (rs("ALU_PermisoCapacitacionEnOrganizacion")=1) then
			PermisoCapacitacionEnOrganizacion="Si"
		else
			PermisoCapacitacionEnOrganizacion="No"
		end if
		if (rs("ALU_CursosFormacionSindicalAnteriormente")=1) then
			CursosFormacionSindicalAnteriormente="Si"
		else
			CursosFormacionSindicalAnteriormente="NO"
		end if
		if (rs("ALU_CargoDirectivoEnOrganizacion")=1) then
			ALU_CargoDirectivoEnOrganizacion="Si"
		else
			ALU_CargoDirectivoEnOrganizacion="No"
		end if
		if (rs("ALU_Discapacidad")=1) then
			ALU_Discapacidad="Si"
		else
			ALU_Discapacidad="No"
		end if
		if (rs("ALU_ReconocePuebloOriginario")=1) then
			ALU_ReconocePuebloOriginario="Si"
		else
			ALU_ReconocePuebloOriginario="No"
		end if
		if (rs("ALU_DirigenteSindical")=1) then
			ALU_DirigenteSindical="Si"
		else
			ALU_DirigenteSindical="No"
		end if
		if (rs("ALU_AccesoInternet")=1) then
			ALU_AccesoInternet="Si"
		else
			ALU_AccesoInternet="No"
		end if
		if (rs("ALU_DispositivoElectronico")=1) then
			ALU_DispositivoElectronico="Si"
		else
			ALU_DispositivoElectronico="No"
		end if
		Edad = DateDiff("yyyy",rs("ALU_FechaNacimiento"),date)
		
		
		EstadoAcademico = rs("TES_Descripcion")		'Primer registro, utimo en ingresar
		
				
		if (PRY_InformeFinalEstado=0 and PRY_Estado=1) then
			dataAlumnos = dataAlumnos & "[""" & rs("ALU_Rut") & """,""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("NAC_Nombre") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & rs("ALU_NombreEmpresa") & """,""" & rs("ALU_UsuarioEdit") & """,""" & EstadoAcademico & """,""" & ALU_Ficha & """,""" & rs("ALU_FechaNacimiento") & """,""" & Edad & """,""" & ALU_CargoDirectivoEnOrganizacion & """,""" & ALU_Discapacidad & """,""" & rs("TDI_Nombre") & """,""" & ALU_ReconocePuebloOriginario & """,""" & rs("ALU_PuebloOriginario") & """,""" & rs("TTR_Nombre") & """,""" & ALU_DirigenteSindical & """,""" & rs("ALU_TiempoDirigenteSindical") & """,""" & ALU_AccesoInternet & """,""" & ALU_DispositivoElectronico & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("ALU_Direccion") & """,""" & rs("ALU_Telefono") & """,""" & rs("RUB_Nombre") & """,""" & rs("EDU_Nombre") & """,""" & PerteneceSindicato & """,""" & rs("ALU_NombreOrganizacion") & """,""" & rs("ALU_RSU") & """,""" & rs("ALU_FechaIngreso") & """,""" & PermisoCapacitacionEnOrganizacion & """,""" & rs("ALU_NombreCargoDirectivo") & """,""" & rs("ALU_FechaInicioCargoDirectivo") & """,""" & CursosFormacionSindicalAnteriormente & """,""" & rs("ALU_AnioCursoFormacionSindical") & """,""" & rs("ALU_InstitucionCursoFormacionSindical") & """]"						
		else
			dataAlumnos = dataAlumnos & "[""" & rs("ALU_Rut") & """,""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("NAC_Nombre") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & rs("ALU_NombreEmpresa") & """,""" & rs("ALU_UsuarioEdit") & """,""" & EstadoAcademico & """,""" & ALU_Ficha & """,""" & rs("ALU_FechaNacimiento") & """,""" & Edad & """,""" & ALU_CargoDirectivoEnOrganizacion & """,""" & ALU_Discapacidad & """,""" & rs("TDI_Nombre") & """,""" & ALU_ReconocePuebloOriginario & """,""" & rs("ALU_PuebloOriginario") & """,""" & rs("TTR_Nombre") & """,""" & ALU_DirigenteSindical & """,""" & rs("ALU_TiempoDirigenteSindical") & """,""" & ALU_AccesoInternet & """,""" & ALU_DispositivoElectronico & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("ALU_Direccion") & """,""" & rs("ALU_Telefono") & """,""" & rs("RUB_Nombre") & """,""" & rs("EDU_Nombre") & """,""" & PerteneceSindicato & """,""" & rs("ALU_NombreOrganizacion") & """,""" & rs("ALU_RSU") & """,""" & rs("ALU_FechaIngreso") & """,""" & PermisoCapacitacionEnOrganizacion & """,""" & rs("ALU_NombreCargoDirectivo") & """,""" & rs("ALU_FechaInicioCargoDirectivo") & """,""" & CursosFormacionSindicalAnteriormente & """,""" & rs("ALU_AnioCursoFormacionSindical") & """,""" & rs("ALU_InstitucionCursoFormacionSindical") & """]"						
		end if		
		rs.movenext
		if not rs.eof then
			dataAlumnos = dataAlumnos & ","
		end if
	loop
	dataAlumnos=dataAlumnos & "]}"
	
	response.write(dataAlumnos)
%>