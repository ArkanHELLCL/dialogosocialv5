<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Ejecutor, Auditor, administrativo
		response.write("503/@/Error de conexion")
		response.End() 			   
	end if		
	
	PRY_Id					 = request("PRY_Id")	
	PRY_Identificador		 = Request("PRY_Identificador")
	INF_NumeroInformeTecnico = request("PRY_Hito")
	MEN_Observaciones		 = LimpiarUrl(request("MEN_Texto"))
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error 1 de conexion: " & ErrMsg)
	   response.End() 			   
	end if		
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
	   response.write("503/@/Error de conexion")
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		LFO_Id 				= rs("LFO_Id")		
		PRY_Identificador	= rs("PRY_Identificador")										
	else
		response.write("1/@/Tabla proyectos sin datos")
		rs.close
		cnn.close
		response.end()
	end if
	
	sql="exec spProyectoInforme_Apertura 1, " & LFO_Id & "," & PRY_Id & ",'" & PRY_Identificador & "'," & INF_NumeroInformeTecnico & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description
	   	response.write("503/@/Error 2 de conexion: " & ErrMsg)
		rs.close
		cnn.close
		response.end()
	End If
	MEN_Archivo						 = ""	'Sin adjuntos
	if session("ds5_usrperfil")=1 then
		tipo="Administrador"
	end if
	if session("ds5_usrperfil")=2 then
		tipo="Revisor"
	end if
	if LFO_Id=10 then
		if INF_NumeroInformeTecnico=0 then
			TIP_Id							 = 	71
			MEN_Texto						 = "Apertura manual del informe CREACIÓN por el " & tipo & " : " & session("ds5_usrnom") & " (Escuela) - OBS: " & trim(MEN_Observaciones)
		else			
			if INF_NumeroInformeTecnico=1 then
				TIP_Id							 = 5		
				MEN_Texto						 = "Apertura manual del informe INICIO por el " & tipo & " : " & session("ds5_usrnom") & " (Escuela) - OBS: " & trim(MEN_Observaciones)
			else			
				if INF_NumeroInformeTecnico=2 then
					TIP_Id							 = 7
					MEN_Texto						 = "Apertura manual del informe DESARROLLO por el " & tipo & " : " & session("ds5_usrnom") & " (Escuela) - OBS: " & trim(MEN_Observaciones)
				else
					if INF_NumeroInformeTecnico=3 then
						TIP_Id							 = 8
						MEN_Texto						 = "Apertura manual del informe FINAL por el " & tipo & " : " & session("ds5_usrnom") & " (Escuela) - OBS: " & trim(MEN_Observaciones)
					end if
				end if			
			end if
		end if
	end if
	
	if LFO_Id=11 then
		if INF_NumeroInformeTecnico=0 then
			TIP_Id							 = 	71	
			MEN_Texto						 = "Apertura manual del informe CREACIÓN por el " & tipo & " : " & session("ds5_usrnom") & " (Mesa) - OBS: " & trim(MEN_Observaciones)
		else
			if INF_NumeroInformeTecnico=1 then
				TIP_Id							 = 9		
				MEN_Texto						 = "Apertura manual del informe INICIAL por el " & tipo & " : " & session("ds5_usrnom") & " (Mesa) - OBS: " & trim(MEN_Observaciones)
			else
				if INF_NumeroInformeTecnico=2 then
					TIP_Id							 = 10
					MEN_Texto						 = "Apertura manual del informe AVANCES por el " & tipo & " : " & session("ds5_usrnom") & " (Mesa) - OBS: " & trim(MEN_Observaciones)
				else
					if INF_NumeroInformeTecnico=3 then
						TIP_Id							 = 11
						MEN_Texto						 = "Apertura manual del informe FINAL por el " & tipo & " : " & session("ds5_usrnom") & " (Mesa) - OBS: " & trim(MEN_Observaciones)
					end if
				end if
			end if
		end if
	end if
	
	if LFO_Id=12 then
		if INF_NumeroInformeTecnico=0 then
			TIP_Id							 = 71	
			MEN_Texto						 = "Apertura manual del informe CREACIÓN por el " & tipo & " : " & session("ds5_usrnom") & " (Curso) - OBS: " & trim(MEN_Observaciones)
		else						
			if INF_NumeroInformeTecnico=1 then
				TIP_Id							 = 5		
				MEN_Texto						 = "Apertura manual del informe INICIO por el " & tipo & " : " & session("ds5_usrnom") & " (Curso) - OBS: " & trim(MEN_Observaciones)
			else						
				if INF_NumeroInformeTecnico=2 then
					TIP_Id							 = 8
					MEN_Texto						 = "Apertura manual del informe FINAL por el " & tipo & " : " & session("ds5_usrnom") & " (Curso) - OBS: " & trim(MEN_Observaciones)
				end if						
			end if
		end if
	end if

	if LFO_Id=13 then
		if INF_NumeroInformeTecnico=0 then
			TIP_Id							 = 	71	
			MEN_Texto						 = "Apertura manual del informe CREACIÓN por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
		else
			if INF_NumeroInformeTecnico=1 then
				TIP_Id							 = 9		
				MEN_Texto						 = "Apertura manual del informe INICIAL por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
			else
				if INF_NumeroInformeTecnico=2 then
					TIP_Id							 = 10
					MEN_Texto						 = "Apertura manual del informe AVANCES por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
				else
					if INF_NumeroInformeTecnico=3 then
						TIP_Id							 = 11
						MEN_Texto						 = "Apertura manual del informe FINAL por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
					end if
				end if
			end if
		end if
	end if

	if LFO_Id=14 then
		if INF_NumeroInformeTecnico=0 then
			TIP_Id							 = 	71	
			MEN_Texto						 = "Apertura manual del informe CREACIÓN por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
		else
			if INF_NumeroInformeTecnico=1 then
				TIP_Id							 = 9		
				MEN_Texto						 = "Apertura manual del informe INICIAL por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
			else
				if INF_NumeroInformeTecnico=2 then
					TIP_Id							 = 10
					MEN_Texto						 = "Apertura manual del informe AVANCES por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
				else
					if INF_NumeroInformeTecnico=3 then
						TIP_Id							 = 6
						MEN_Texto						 = "Apertura manual del informe DESARROLLO por el " & tipo & " : " & session("ds5_usrnom") & " (Eficacia) - OBS: " & trim(MEN_Observaciones)
					else
						if INF_NumeroInformeTecnico=4 then
							TIP_Id							 = 11
							MEN_Texto						 = "Apertura manual del informe FINAL por el " & tipo & " : " & session("ds5_usrnom") & " (Recuperación) - OBS: " & trim(MEN_Observaciones)
						end if
					end if
				end if
			end if
		end if
	end if

	sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	on error resume next	
	cnn.execute sql	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error 3 de conexion: " & ErrMsg)
	   	rs.close
		cnn.close
		response.end()
	End If
	
	
	cnn.close
	set cnn = nothing		
	
	response.write("200/@/")%>