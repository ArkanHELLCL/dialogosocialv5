<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Ejecutor, Auditor y Administrativo
		response.write("503/@/Error de conexion")
		response.End() 
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")
	PRY_Hito			= request("PRY_Hito")		

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if	
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description
	   	response.write("503/@/Error de conexion")
		rs.close
		cnn.close
		response.end()
	End If
	
	if(not rs.eof) then
		LFO_Id=rs("LFO_Id")
	end if
	
	if(LFO_Id=10) then
		if (PRY_Hito=1) then
			sql="exec spProyectoInformeInicioAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1" 	'Solo envio de Mail
		else
			if (PRY_Hito=2) then
				sql="exec spProyectoInformeParcialAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"	'Solo envio de Mail
			else
				if (PRY_Hito=3) then
					sql="exec spProyectoInformeFinalAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"	'Solo envio de Mail
				else
					response.write("11/@/Error Hito no definido para esta linea")
					response.end					
				end if
			end if
		end if
	else
		if(LFO_Id=11) then
			if (PRY_Hito=1) then
				sql="exec spProyectoInformeInicialAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"
			else
				if (PRY_Hito=2) then
					sql="exec spProyectoInformeConsensosAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"
				else
					if (PRY_Hito=3) then
						sql="exec spProyectoInformeSistematizacionAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"
					else
						response.end
						response.write("12/@/Error Hito no definido para esta linea")
					end if
				end if
			end if
		else
			if(LFO_Id=12) then
				if (PRY_Hito=1) then
					sql="exec spProyectoInformeInicioAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1" 	'Solo envio de Mail
				else					
					if (PRY_Hito=2) then
						sql="exec spProyectoInformeFinalAceptado_Cerrar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "',1"	'Solo envio de Mail
					else
						response.write("13/@/Error Hito no definido para esta linea")
						response.end						
					end if					
				end if
			else
				response.write("10/@/Error Linea no definida")
				response.end	   			
			end if
		end if
	end if
	
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description
	   	response.write("503/@/Error de conexion")
		rs.close
		cnn.close
		response.end()
	End If
	   
	response.write("200/@/")
	
	cnn.close
	set cnn = nothing
%>