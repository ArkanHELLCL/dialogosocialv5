<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")	
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
	if(Rut<>"" and not IsNull(Rut)) then
		ALU_Rut = mid(Rut,1,len(Rut)-1)
	else
		ALU_Rut = 0
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
	
	sql="spAlumno_Consultar " & ALU_Rut
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAlumno_Consultar : " & sql)
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataAlumnos = "{""data"":["
	do While Not rs.EOF
		ALU_FichaX=""
		ALU_Ficha=""
		PRY_Identificador=""	
		edad=0			
		
		dataAlumnos = dataAlumnos & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("ALU_FechaNacimiento") & """,""" & edad & """,""" & rs("NAC_Id") & """,""" & rs("SEX_Descripcion") & """,""" & rs("SEX_Id") & """,""" & rs("EDU_Id") & """,""" & rs("ALU_Discapacidad") & """,""" & rs("TDI_Id") & """,""" & rs("ALU_FechaEdit") & """,""" & rs("ALU_AccesoInternet") & """,""" & rs("ALU_DispositivoElectronico") & """,""" & rs("ALU_ReconocePuebloOriginario") & """,""" & rs("ALU_PuebloOriginario") & """,""" & ALU_FichaX & """,""" & ALU_Ficha & """,""" & PRY_Identificador & """,""" & rs("REG_Id") & """,""" & rs("COM_Id") & """,""" & rs("ALU_Direccion") & """,""" & rs("ALU_Mail") & """,""" & rs("ALU_Telefono") & """,""" & rs("TTR_Id") & """,""" & rs("ALU_NombreEmpresa") & """,""" & rs("RUB_Id") & """,""" & rs("ALU_PerteneceSindicato") & """,""" & rs("ALU_FechaIngreso") & """,""" & rs("ALU_NombreOrganizacion") & """,""" & rs("ALU_RSU") & """,""" & rs("ALU_PermisoCapacitacionEnOrganizacion") & """,""" & rs("ALU_DirigenteSindical") & """,""" & rs("ALU_TiempoDirigenteSindical") & """,""" & rs("ALU_CursosFormacionSindicalAnteriormente") & """,""" & rs("ALU_InstitucionCursoFormacionSindical") & """,""" & rs("ALU_AnioCursoFormacionSindical") & """,""" & rs("ALU_CargoDirectivoEnOrganizacion") & """,""" & rs("ALU_FechaInicioCargoDirectivo") & """,""" & rs("ALU_NombreCargoDirectivo") & """,""" & rs("ALU_Estado") & """]"

		rs.movenext
		if not rs.eof then
			dataAlumnos = dataAlumnos & ","
		end if
	loop
	dataAlumnos=dataAlumnos & "]}"
	
	response.write(dataAlumnos)
%>