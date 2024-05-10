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
	
	Rut = request("ALU_Rut")
	ALU_Rut = mid(Rut,1,len(Rut)-1)
	
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
	sql="spAlumnoProyectos_Consultar " & ALU_Rut & "," & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAlumnoProyectos_Consultar : " & sql)
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataAlumnos = "{""data"":["
	do While Not rs.EOF
		ALU_FichaX=""
		ALU_Ficha=""		
		edad=0				
		
		dataAlumnos = dataAlumnos & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("ALU_FechaNacimiento") & """,""" & edad & """,""" & rs("NAC_Id") & """,""" & rs("SEX_Descripcion") & """,""" & rs("SEX_Id") & """,""" & rs("EDU_Id") & """,""" & rs("ALU_Discapacidad") & """,""" & rs("TDI_Id") & """,""" & rs("ALU_FechaEdit") & """,""" & rs("ALU_AccesoInternet") & """,""" & rs("ALU_DispositivoElectronico") & """,""" & rs("ALU_ReconocePuebloOriginario") & """,""" & rs("ALU_PuebloOriginario") & """,""" & ALU_FichaX & """,""" & ALU_Ficha & """,""" & PRY_Identificador & """,""" & rs("REG_Id") & """,""" & rs("COM_Id") & """,""" & rs("ALU_Direccion") & """,""" & rs("ALU_Mail") & """,""" & rs("ALU_Telefono") & """,""" & rs("TTR_Id") & """,""" & rs("ALU_NombreEmpresa") & """,""" & rs("RUB_Id") & """,""" & rs("ALU_PerteneceSindicato") & """,""" & rs("ALU_FechaIngreso") & """,""" & rs("ALU_NombreOrganizacion") & """,""" & rs("ALU_RSU") & """,""" & rs("ALU_PermisoCapacitacionEnOrganizacion") & """,""" & rs("ALU_DirigenteSindical") & """,""" & rs("ALU_TiempoDirigenteSindical") & """,""" & rs("ALU_CursosFormacionSindicalAnteriormente") & """,""" & rs("ALU_InstitucionCursoFormacionSindical") & """,""" & rs("ALU_AnioCursoFormacionSindical") & """,""" & rs("ALU_CargoDirectivoEnOrganizacion") & """,""" & rs("ALU_FechaInicioCargoDirectivo") & """,""" & rs("ALU_NombreCargoDirectivo") & """,""" & rs("Asignado" ) & """,""" & rs("Historico") & """]"

		rs.movenext
		if not rs.eof then
			dataAlumnos = dataAlumnos & ","
		end if
	loop
	dataAlumnos=dataAlumnos & "]}"
	
	response.write(dataAlumnos)
%>