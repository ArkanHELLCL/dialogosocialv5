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
		LFO_Calif=rs("LFO_Calif")
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
	
	dataCalificacion = "{""data"":["
	do While Not rs.EOF				
		TotAsis=round(rs("TotalHorasAsistidas"),1)				
		if TotAsis>=1 then											
			xTotAsis = TotAsis & "%"
		else
			xTotAsis = "0%"
		end if		
		
		if(mode="mod") and ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then
		
			dataCalificacion = dataCalificacion & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & xTotAsis
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
					iProNot=0
				end if				
				dataCalificacion = dataCalificacion & """,""" & iPronot
			end if			
			estado="Activo"
			causa=""
			obs=""
			dataCalificacion = dataCalificacion & """,""" & estado & """,""" & causa & """,""" & obs & """]"
		else
			dataCalificacion = dataCalificacion & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("SEX_Descripcion") & """]"
		end if		
		rs.movenext
		if not rs.eof then
			dataCalificacion = dataCalificacion & ","
		end if
		
	loop
	dataCalificacion=dataCalificacion & "]}"
	
	response.write(dataCalificacion)
%>