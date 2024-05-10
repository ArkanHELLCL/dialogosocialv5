<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec spLinea_Listar -1, -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spLinea_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataLineas = "{""data"":["
	do While Not rs.EOF
		if rs("LIN_Estado")=1 then
			estado = "Activado"
		else
			estado = "Desactivado"
		end if
		if (rs("LIN_AgregaTematica")) then
			LIN_AgregaTematica="Si"
		else
			LIN_AgregaTematica="No"
		end if
		if (rs("LIN_Hombre") and rs("LIN_Mujer")) then
			genero = "Ambos"
		else
			if (rs("LIN_Hombre") and not rs("LIN_Mujer")) then
				genero = "Hombres"
			else
				if (not rs("LIN_Hombre") and rs("LIN_Mujer")) then
					genero = "Mujeres"
				else
					genero = "Ninguno"
				end if
			end if
		end if
		if rs("LIN_Mixta") then
			mixta = "Si"
		else
			mixta = "No"
		end if
									
		dataLineas = dataLineas & "[""" & rs("LIN_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LIN_Nombre") & """,""" & rs("FON_Nombre") & """,""" & LIN_AgregaTematica & """,""" & genero & """,""" & estado & """,""" & rs("LIN_DiasCierreInformeParcial") & """,""" & rs("LIN_DiasCierreInformeFinal") & """,""" & rs("LIN_DiasCierreInformeParcial50Ejecucion") & """,""" & rs("LIN_DiasCierreInformeFinal100Ejecucion") & """,""" & rs("LIN_PorcentajeMaxAsistenciaDesercion") & """,""" & rs("LIN_PorcentajeMaxAsistenciaReprobacion") & """,""" & rs("LIN_PorcentajeMaxAsistenciaInscrito") & """,""" & rs("LIN_DiasIngresoAsistencia") & """,""" & mixta & """]"
		
		rs.movenext
		if not rs.eof then
			dataLineas = dataLineas & ","
		end if
	loop
	dataLineas=dataLineas & "]}"
	
	response.write(dataLineas)
%>