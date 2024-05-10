<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3) then	'Ejecutor no puede ejecutar reportes		
	   response.Write("403/@/Perfil no autorizado")
	   response.End() 			   	
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
	
	set rs = cnn.Execute("exec spEstadosAlumnoSistema_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spEstadosAlumnoSistema_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataAlumnoEstados = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataAlumnoEstados = dataAlumnoEstados & ","
		end if

		dataAlumnoEstados = dataAlumnoEstados & "[""" & rs("EME_Nombre") & """,""" & rs("EME_Rol") & """,""" & rs("Region") & """,""" & rs("Linea") & """,""" & rs("LineaFormativa") & """,""" & rs("RutBeneficiario") & """,""" & rs("DV") & """,""" & rs("NombreBeneficiario") & """,""" & rs("PaternoBeneficiario") & """,""" & rs("MaternoBeneficiario") & """,""" & rs("Edad") & """,""" & rs("Nacionalidad") & """,""" & rs("Sexo") & """,""" & rs("Discpacidad") & """,""" & rs("PerteneceASindicato") & """,""" & rs("NombreSindicato") & """,""" & rs("DirigenteSindical") & """,""" & rs("CargoDirectivo") & """,""" & rs("NombreCargo") & """,""" & rs("Matriculado") & """,""" & rs("Beneficiario") & """,""" & rs("Inscrito") & """,""" & rs("Aprobado") & """,""" & rs("Desertado") & """,""" & rs("PorAsistencia") & """,""" & rs("TotalHorasProyecto") & """,""" & rs("HorasAsitidas") & """,""" & rs("Direccion") & """,""" & rs("Telefono") & """,""" & rs("Mail") & """,""" & rs("RegionAlumno") & """,""" & rs("ComunaAlumno") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataAlumnoEstados=dataAlumnoEstados & "]}"
	
	response.write(dataAlumnoEstados)
%>