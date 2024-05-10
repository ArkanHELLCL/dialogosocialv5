<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if			
	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador				 = request("PRY_Identificador")
		
	ALU_Rut							 = request("ALU_Rut")
				
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
	
	sql="exec spAlumnoProyectos_Eliminar " & ALU_Rut & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
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
		if(result=3) then
			response.write("3\\Alumno tiene asistencia creada. Imposible eliminar")	
		else
			if(result=2) then
				response.write("3\\Alumno tiene calificaciones. Imposible eliminar")	
			else
				if(result=1) then
					response.write("3\\Alumno ya fue procesado y cuenta con mas de un estado. Imposible eliminar")	
				else
					response.write("200\\Alumno eliminado de este proyecto exitosamente.")
				end if
			end if		
		end if
	end if
	
%>