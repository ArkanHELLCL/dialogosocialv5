<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%					
	if isEmpty(session("ds5_usrid")) or isNull(session("ds5_usrid")) then
		response.Write("500/@/Error Parámetros no válidos")
		response.end
	end if			
		
	LFO_Id 	= request("LFO_Id")
	tpo		= request("tpo")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")
	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End 			   
	end if	
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=4) then	'Super y auditor
		if(tpo=2) then
			sql="exec spProyecto_Listar 9," & LFO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		else
			sql="exec spProyecto_Listar 1," & LFO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		end if
	else
		if (session("ds5_usrperfil")=2) then	'Revisor
			if tpo=1 then
				sql="exec spProyectoNORevisor_Consultar 1," & LFO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			else
				sql="exec spProyectoRevisor_Consultar 1," & LFO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"				
			end if
		else
			if (session("ds5_usrperfil")=3) then	'Usuario estandar
				sql="exec spProyectoUsuarioEjecutor_Consultar " & LFO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			else
				response.Write("403/@/Acceso no permitido")
				response.end
			end if
		end if
	end if
	'response.write(sql)
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error SQL: " & ErrMsg & "-" & sql)
		cnn.close 			   
		response.end
	End If		
	
	dataProyectos = "{""data"":["
	do While (Not rs.EOF)		
		if rs("PRY_CodigoAsociado")>0 then
			PMixto = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"			
		else
			PMixto = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"			
		end if
		if rs("LIN_Mixta") then
			LMixta = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			LMixta = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
		end if


		if rs("PRY_InformeInicioAceptado") then
			PRY_InformeInicioAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeInicioFecha")<>"") then
				PRY_InformeInicioAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeInicioAceptado = ""
			end if
		end if
		if rs("PRY_InformeParcialAceptado") then
			PRY_InformeParcialAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeParcialFecha")<>"") then
				PRY_InformeParcialAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeParcialAceptado = ""
			end if
		end if
		if rs("PRY_InformeFinalAceptado") then
			PRY_InformeFinalAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeFinalFecha")<>"") then
				PRY_InformeFinalAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeFinalAceptado = ""
			end if
		end if
		
		
		if rs("PRY_InformeInicialAceptado") then
			PRY_InformeInicialAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeInicialFecha")<>"") then
				PRY_InformeInicialAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeInicialAceptado = ""
			end if
		end if
		if rs("PRY_InformeConsensosAceptado") then
			PRY_InformeConsensosAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeConsensosFecha")<>"") then
				PRY_InformeConsensosAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeConsensosAceptado = ""
			end if
		end if
		if rs("PRY_InformeSistematizacionAceptado") then
			PRY_InformeSistematizacionAceptado = "<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span></td>"
		else
			if(rs("PRY_InformeSistematizacionFecha")<>"") then
				PRY_InformeSistematizacionAceptado = "<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span></td>"
			else
				PRY_InformeSistematizacionAceptado = ""
			end if
		end if
		
		if rs("PRY_InformeInicioEstado")="" then
			PRY_InformeInicioEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeInicioEstado"))=1 then
				PRY_InformeInicioEstado = "Aceptado"
			else
				PRY_InformeInicioEstado = "No Aceptado"				
			end if
		end if		
		if rs("PRY_InformeParcialEstado")="" then
			PRY_InformeParcialEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeParcialEstado"))=1 then
				PRY_InformeParcialEstado = "Aceptado"
			else
				PRY_InformeParcialEstado = "No Aceptado"				
			end if
		end if
		if rs("PRY_InformeFinalEstado")="" then
			PRY_InformeFinalEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeFinalEstado"))=1 then
				PRY_InformeFinalEstado = "Aceptado"
			else
				PRY_InformeFinalEstado = "No Aceptado"				
			end if
		end if
		
						
		if rs("PRY_InformeInicialEstado")="" then
			PRY_InformeInicialEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeInicialEstado"))=1 then
				PRY_InformeInicialEstado = "Aceptado"
			else
				PRY_InformeInicialEstado = "No Aceptado"				
			end if
		end if		
		if rs("PRY_InformeConsensosEstado")="" then
			PRY_InformeConsensosEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeConsensosEstado"))=1 then
				PRY_InformeConsensosEstado = "Aceptado"
			else
				PRY_InformeConsensosEstado = "No Aceptado"				
			end if
		end if
		if rs("PRY_InformeSistematizacionEstado")="" then
			PRY_InformeSistematizacionEstado = "En Curso"			
		else
			if CInt(rs("PRY_InformeSistematizacionEstado"))=1 then
				PRY_InformeSistematizacionEstado = "Aceptado"
			else
				PRY_InformeSistematizacionEstado = "No Aceptado"				
			end if
		end if
		
		
		if(LFO_Id=10) then
			if rs("PRY_CreacionProyectoEstado")=1 then
				if rs("PRY_InformeInicioAceptado") then
					if rs("PRY_InformeParcialAceptado") then						
						if rs("PRY_InformeFinalAceptado") then
							estado="Finalizado"
						else
							estado="Final"
						end if
					else
						estado="Desarrollo"
					end if
				else
					estado="Inicio"
				end if
			else
				estado="Creación"
			end if
			fechaCreacionInforme=""
			estadoCreacionInforme=PRY_CreacionProyectoEstado
			fechaAceptadoCreacionInforme=""
			diferenciaCreacionInforme=""
			estadoCreacion=""
			
			fechaPrimerInforme=rs("PRY_InformeInicioFecha")
			estadoPrimerInforme=PRY_InformeInicioAceptado
			fechaAceptadoPrimerInforme=rs("PRY_InformeInicioFechaAceptado")
			diferenciaPrimerInforme=rs("PRY_InformeInicioFechaDiferencia")
			estadoPrimer=PRY_InformeInicioEstado
			
			fechaSegundoInforme=rs("PRY_InformeParcialFecha")
			estadoSegundoInforme=PRY_InformeParcialAceptado
			fechaAceptadoSegundoInforme=rs("PRY_InformeParcialFechaAceptado")
			diferenciaSegundoInforme=rs("PRY_InformeParcialFechaDiferencia")
			estadoSegundo=PRY_InformeParcialEstado
			
			fechaTercerInforme=rs("PRY_InformeFinalFecha")
			estadoTercerInforme=PRY_InformeFinalAceptado
			fechaAceptadoTercerInforme=rs("PRY_InformeFinalFechaAceptado")
			diferenciaTercerInforme=rs("PRY_InformeFinalFechaDiferencia")
			estadoTercer=PRY_InformeFinalEstado
			
		else
			if(LFO_Id=12) then
				if rs("PRY_CreacionProyectoEstado") then
					if rs("PRY_InformeInicioAceptado") then						
						if rs("PRY_InformeFinalAceptado") then
							estado="Finalizado"
						else
							estado="Final"
						end if						
					else
						estado="Inicio"
					end if
				else
					estado="Creación"
				end if
				fechaCreacionInforme=""
				estadoCreacionInforme=PRY_CreacionProyectoEstado
				fechaAceptadoCreacionInforme=""
				diferenciaCreacionInforme=""
				estadoCreacion=""

				fechaPrimerInforme=rs("PRY_InformeInicioFecha")
				estadoPrimerInforme=PRY_InformeInicioAceptado
				fechaAceptadoPrimerInforme=rs("PRY_InformeInicioFechaAceptado")
				diferenciaPrimerInforme=rs("PRY_InformeInicioFechaDiferencia")
				estadoPrimer=PRY_InformeInicioEstado

				fechaSegundoInforme=""
				estadoSegundoInforme=""
				fechaAceptadoSegundoInforme=""
				diferenciaSegundoInforme=""
				estadoSegundo=""

				fechaTercerInforme=rs("PRY_InformeFinalFecha")
				estadoTercerInforme=PRY_InformeFinalAceptado
				fechaAceptadoTercerInforme=rs("PRY_InformeFinalFechaAceptado")
				diferenciaTercerInforme=rs("PRY_InformeFinalFechaDiferencia")
				estadoTercer=PRY_InformeFinalEstado
			else
				if(LFO_Id=11 or LFO_Id=13) then
					if rs("PRY_CreacionProyectoEstado") then
						if rs("PRY_InformeInicialAceptado") then
							if rs("PRY_InformeConsensosAceptado") then
								if rs("PRY_InformeSistematizacionAceptado") then								
									estado="Finalizado"
								else
									estado="Final"
								end if							
							else
								estado="Desarrollo"
							end if
						else
							estado="Inicial"
						end if
					else
						estado="Creación"
					end if
				Else
					if(LFO_Id=14) then
						if rs("PRY_CreacionProyectoEstado") then
							if rs("PRY_InformeInicialAceptado") then
								if rs("PRY_InformeConsensosAceptado") then
									if rs("PRY_InformeParcialAceptado") then										
										if rs("PRY_InformeSistematizacionAceptado") then								
											estado="Finalizado"
										else
											estado="Final"
										end if	
									else
										estado="Avances"						
									end if
								else
									estado="Desarrollo"
								end if
							else
								estado="Inicial"
							end if
						else
							estado="Creación"
						end if
					end if
				end if
				fechaCreacionInforme=""
				estadoCreacionInforme=PRY_CreacionProyectoEstado
				fechaAceptadoCreacionInforme=""
				diferenciaCreacionInforme=""				
				estadoCreacion=""

				fechaPrimerInforme=rs("PRY_InformeInicialFecha")
				estadoPrimerInforme=PRY_InformeInicialAceptado
				fechaAceptadoPrimerInforme=rs("PRY_InformeInicialFechaAceptado")
				diferenciaPrimerInforme=rs("PRY_InformeInicialFechaDiferencia")
				estadoPrimer=PRY_InformeInicialEstado

				fechaSegundoInforme=rs("PRY_InformeConsensosFecha")
				estadoSegundoInforme=PRY_InformeConsensosAceptado
				fechaAceptadoSegundoInforme=rs("PRY_InformeConsensosFechaAceptado")
				diferenciaSegundoInforme=rs("PRY_InformeConsensosFechaDiferencia")
				estadoSegundo=PRY_InformeConsensosEstado

				fechaCuartoInforme=rs("PRY_InformeParcialFecha")
				estadoCuartoInforme=PRY_InformeParcialAceptado
				fechaAceptadoCuartoInforme=rs("PRY_InformeParcialFechaAceptado")
				diferenciaCuartoInforme=rs("PRY_InformeParcialFechaDiferencia")
				estadoCuarto=PRY_InformeParcialEstado

				fechaTercerInforme=rs("PRY_InformeSistematizacionFecha")
				estadoTercerInforme=PRY_InformeSistematizacionAceptado
				fechaAceptadoTercerInforme=rs("PRY_InformeSistematizacionFechaAceptado")
				diferenciaTercerInforme=rs("PRY_InformeSistematizacionFechaDiferencia")
				estadoTercer=PRY_InformeSistematizacionEstado
			end if
		end if
		if(rs("PRY_Estado")=1) then
			msg="Activo"			
		end if
		if(PRY_Estado=9) then
			msg="Archivado"			
		end if
		if rs("USR_SexoEjecutor")=1 then
			USR_SexoEjecutor = "Femenino"
		else
			USR_SexoEjecutor = "Masculino"
		end if
		if rs("SEX_IdEncargadoProyecto")=1 then
			SEX_IdEncargadoProyecto = "Femenino"
		else
			SEX_IdEncargadoProyecto = "Masculino"
		end if
		if rs("SEX_IdEncargadoActividades")=1 then
			SEX_IdEncargadoActividades = "Femenino"
		else
			SEX_IdEncargadoActividades = "Masculino"
		end if						
		'estadoPrimer 50
		'diferenciaPrimerInforme 60
		if(LFO_Id = 14) then
			dataProyectos = dataProyectos & "[""" & rs("PRY_Id") & """,""" & rs("PRY_EmpresaEjecutora") & """,""" & PMixto & """,""" & rs("PRY_CodigoAsociado") & """,""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & LMixta & """,""" & rs("REG_Id") & """,""" & rs("PRY_AnioProyecto") & """,""" & fechaPrimerInforme & """,""" & estadoPrimerInforme & """,""" & fechaAceptadoPrimerInforme & """,""" & fechaSegundoInforme & """,""" & estadoSegundoInforme & """,""" & fechaAceptadoSegundoInforme & """,""" & fechaCuartoInforme & """,""" & estadoCuartoInforme & """,""" & fechaAceptadoCuartoInforme & """,""" & fechaTercerInforme & """,""" & estadoTercerInforme & """,""" & fechaAceptadoTercerInforme  & """,""" & estado & """,""" & msg & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("USR_NombreRevisor") & """,""" & rs("USR_ApellidoRevisor") & """,""" & rs("USR_MailRevisor") & """,""" & rs("USR_TelefonoRevisor") & """,""" & rs("USR_DireccionRevisor") & """,""" & rs("USR_NombreEjecutor") & """,""" & rs("USR_ApellidoEjecutor") & """,""" & rs("USR_MailEjecutor") & """,""" & rs("USR_TelefonoEjecutor") & """,""" & rs("USR_DireccionEjecutor") & """,""" & rs("USR_NombreInstitucionEjecutor") & """,""" & USR_SexoEjecutor & """,""" & rs("PRY_EncargadoProyecto") & """,""" & rs("PRY_EncargadoProyectoMail") & """,""" & rs("PRY_EncargadoProyectoCelular") & """,""" & SEX_IdEncargadoProyecto & """,""" & rs("PRY_EncargadoActividades") & """,""" & rs("PRY_EncargadoActividadesMail") & """,""" & rs("PRY_EncargadoActividadesCelular") & """,""" & SEX_IdEncargadoActividades & """,""" & rs("PRY_InformeInicioFechaEnvio") & """,""" & rs("PRY_InformeFinalFechaEnvio") & """,""" & rs("PRY_CreacionProyectoFechaEnvio") & """,""" & estadoPrimer & """,""" & estadoSegundo & """,""" & estadoCuarto & """,""" & estadoTercer & """,""" & rs("PRY_LanzamientoDireccion") & """,""" & rs("PRY_LanzamientoFecha") & """,""" & rs("PRY_LanzamientoHora") & """,""" & rs("PRY_CierreDireccion") & """,""" & rs("PRY_CierreFecha") & """,""" & rs("PRY_CierreHora") & """,""" & diferenciaPrimerInforme & """,""" & diferenciaSegundoInforme & """,""" & diferenciaCuartoInforme & """,""" & diferenciaTercerInforme & """]"
		else
			dataProyectos = dataProyectos & "[""" & rs("PRY_Id") & """,""" & rs("PRY_EmpresaEjecutora") & """,""" & PMixto & """,""" & rs("PRY_CodigoAsociado") & """,""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & LMixta & """,""" & rs("REG_Id") & """,""" & rs("PRY_AnioProyecto") & """,""" & fechaPrimerInforme & """,""" & estadoPrimerInforme & """,""" & fechaAceptadoPrimerInforme & """,""" & fechaSegundoInforme & """,""" & estadoSegundoInforme & """,""" & fechaAceptadoSegundoInforme & """,""" & fechaTercerInforme & """,""" & estadoTercerInforme & """,""" & fechaAceptadoTercerInforme & """,""" & estado & """,""" & msg & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("USR_NombreRevisor") & """,""" & rs("USR_ApellidoRevisor") & """,""" & rs("USR_MailRevisor") & """,""" & rs("USR_TelefonoRevisor") & """,""" & rs("USR_DireccionRevisor") & """,""" & rs("USR_NombreEjecutor") & """,""" & rs("USR_ApellidoEjecutor") & """,""" & rs("USR_MailEjecutor") & """,""" & rs("USR_TelefonoEjecutor") & """,""" & rs("USR_DireccionEjecutor") & """,""" & rs("USR_NombreInstitucionEjecutor") & """,""" & USR_SexoEjecutor & """,""" & rs("PRY_EncargadoProyecto") & """,""" & rs("PRY_EncargadoProyectoMail") & """,""" & rs("PRY_EncargadoProyectoCelular") & """,""" & SEX_IdEncargadoProyecto & """,""" & rs("PRY_EncargadoActividades") & """,""" & rs("PRY_EncargadoActividadesMail") & """,""" & rs("PRY_EncargadoActividadesCelular") & """,""" & SEX_IdEncargadoActividades & """,""" & rs("PRY_InformeInicioFechaEnvio") & """,""" & rs("PRY_InformeFinalFechaEnvio") & """,""" & rs("PRY_CreacionProyectoFechaEnvio") & """,""" & estadoPrimer & """,""" & estadoSegundo & """,""" & estadoTercer & """,""" & rs("PRY_LanzamientoDireccion") & """,""" & rs("PRY_LanzamientoFecha") & """,""" & rs("PRY_LanzamientoHora") & """,""" & rs("PRY_CierreDireccion") & """,""" & rs("PRY_CierreFecha") & """,""" & rs("PRY_CierreHora") & """,""" & diferenciaPrimerInforme & """,""" & diferenciaSegundoInforme & """,""" & diferenciaTercerInforme & """]"
		end if			
		rs.MoveNext
		if not rs.eof then
			dataProyectos = dataProyectos & ","
		end if
  Loop   	   				
  rs.Close
  cnn.Close     
  
  dataProyectos=dataProyectos & "]}"	
  response.write(dataProyectos)	  
%>