<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
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
		LFO_CAlif=rs("LFO_Calif")
	end if
		
	set rs = cnn.Execute("exec spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAlumnoProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataAsistencia = "{""data"":["
	do While Not rs.EOF		
		sql="exec spEstadoAcademicoxRut_Modificar " & rs("ALU_Rut") & "," & PRY_Id & ",'" & PRY_Identificador & "'"
		set rs2 = cnn.Execute(sql)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error spEstadoAcademicoxRut_Modificar")
			cnn.close 		
			response.end
		End If		
		TotAsis=0								
		if not rs2.eof then
			TotAsis=round(rs2("TotalHorasAsistidas"),1)
		end if
		rs2.close
		if TotAsis>=1 then											
			xTotAsis = TotAsis & "%"
		else
			xTotAsis = "0%"
		end if		
		
		'if(mode="mod") and ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then		
			dataAsistencia = dataAsistencia & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & xTotAsis
			set ry = cnn.Execute("exec spEstadosAlumnoProyecto_Listar " & rs("ALU_Rut") & "," & PRY_Id)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				response.write("Error spEstadosAlumnoProyecto_Listar")
				cnn.close 		
				response.end
			End If	
			if not ry.eof then
				EstadoAcademico = ry("TES_Descripcion")		'Primer registro, utimo en ingresar
				EstadoAcademicoId = ry("EST_Estado") 
				RDE_InfoRazonDesercion = LimpiarURL(ry("RDE_InfoRazonDesercion"))
				CDE_InfoCausaDesercion = LimpiarURL(ry("CDE_InfoCausaDesercion"))
				EST_InfoObservaciones = LimpiarURL(ry("EST_InfoObservaciones"))
				RDE_InfoRazonId = ry("RDE_InfoRazonId")
			end if
			dataAsistencia = dataAsistencia & """,""" & EstadoAcademico & """,""" & CDE_InfoCausaDesercion & """,""" & RDE_InfoRazonDesercion & """,""" & EST_InfoObservaciones
			
			if LFO_Calif=1 then
				sql="exec spNota_PromedioConsultar " & rs("ALU_Rut") & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" &  session("ds5_usrtoken") & "'"
				set rs3 = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					response.write("Error spNota_PromedioConsultar")
					cnn.close 		
					response.end
				End If
				if not rs3.eof then
					iPronot = round(rs3("NOT_Promedio"),1)
				else
					iPronot=0
				end if				
				dataAsistencia = dataAsistencia & """,""" & iPronot
			end if
									
			if(EstadoAcademicoId<>6) then
				if(mode="mod") then
					desertar = "<i class='fas fa-user-alt-slash aludes text-danger' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Desertar alumno'></i></i><span style='display:none'>-</span>"
				else
					desertar = "<i class='fas fa-user-alt-slash aludes text-white-50' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' style='cursor:not-allowed' title='Desertar alumno'></i></i><span style='display:none'>-</span>"
				end if
			else
				if(not isnull(RDE_InfoRazonId)) then
					if(mode="mod") then
						desertar = "<i class='fas fa-user-check aluhab text-success' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Habilitar Alumno'></i></i><span style='display:none'>Desertado manual</span>"
					else
						desertar = "<i class='fas fa-user-check aluhab text-white-50' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Habilitar Alumno'></i></i><span style='display:none'>Desertado manual</span>"
					end if
				else
					if(mode="mod") then
						desertar = "<i class='fas fa-ban text-danger' title='Desertado por sistema'></i><span style='display:none'>Desertado por sistema</span>"
					else
						desertar = "<i class='fas fa-ban text-white-50' title='Desertado por sistema'></i><span style='display:none'>Desertado por sistema</span>"
					end if
				end if
			end if
			
			'if((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1)) then
				dataAsistencia = dataAsistencia & """,""" & desertar  & """]"
			'else
			''	dataAsistencia = dataAsistencia & """]"
			'end if
		'else
		
		''	dataAsistencia = dataAsistencia & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("SEX_Descripcion") & """]"
		'end if		
		rs.movenext
		if not rs.eof then
			dataAsistencia = dataAsistencia & ","
		end if
		
	loop
	dataAsistencia=dataAsistencia & "]}"
	
	response.write(dataAsistencia)
%>