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
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
	end if
		
	set rs = cnn.Execute("exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error Planificacion_Listar")
		cnn.close 		
		response.end
	End If	
	MOD_Id = 0
	dataPlanificacion = "{""data"":["
	do While Not rs.EOF
		if(year(rs("PLN_Fecha"))>=2010) then
			Fecha = rs("PLN_Fecha")
		else
			Fecha = "-"
		end if
		if(isDate(rs("PLN_HoraInicio"))) then
			HoraInicio = rs("PLN_HoraInicio")
		else
			HoraInicio = "-"
		end if
		if(isDate(rs("PLN_HoraFin"))) then
			HoraFin = rs("PLN_HoraFin")
		else
			HoraFin = "-"
		end if

		horaInicioArray = split(rs("PLN_HoraInicio"),":")
		horaFinArray = split(rs("PLN_HoraFin"),":")

		minutosInicio = (horaInicioArray(0)*60) + horaInicioArray(1)
		minutosFin = (horaFinArray(0)*60) + horaFinArray(1)
		horasPlanificadas = ((minutosFin - minutosInicio)/45)
		
		if MOD_Id<>rs("MOD_Id") then 'Cambio de Modulo
			totalPendiente = rs("TEM_Horas")
		end if

		totalPendiente = totalPendiente - horasPlanificadas
		if(totalPendiente<0) then
			totalPendiente = 0
		end if
			
		if (PRY_InformeInicioEstado=0 and PRY_Estado=1) and (mode="mod") then
			dataPlanificacion = dataPlanificacion & "[""" & rs("PLN_Sesion") & """,""" & rs("MOD_Id") & """,""" & rs("MOD_Nombre") & """,""" & rs("PER_Id") & """,""" & rs("PER_Nombre") & """,""" & rs("TEM_Id") & """,""" & rs("TEM_Nombre") & """,""" & Fecha & """,""" & HoraInicio & """,""" & HoraFin & """,""" & round(horasPlanificadas,0) & """,""" & round(totalPendiente,0) & """,""" & rs("TEM_Horas") & """,""" & rs("REL_Nombres") & " " & rs("REL_Paterno") & " " & rs("REL_Materno") & """,""" & rs("MET_Descripcion") & ""","" <i class='fas fa-trash delpla text-danger' data-pry='" & PRY_Id & "' data-token='" & PRY_Identificador & "' data-sesion='" & rs("PLN_Sesion") & "' data-tem='" & rs("TEM_Id") & "'  data-toggle='tooltip' title='Eliminar planificación'></i><span style='display:none'>N/A</span>""]"
		else						
			dataPlanificacion = dataPlanificacion & "[""" & rs("PLN_Sesion") & """,""" & rs("MOD_Id") & """,""" & rs("MOD_Nombre") & """,""" & rs("PER_Id") & """,""" & rs("PER_Nombre") & """,""" & rs("TEM_Id") & """,""" & rs("TEM_Nombre") & """,""" & Fecha & """,""" & HoraInicio & """,""" & HoraFin & """,""" & round(horasPlanificadas,0) & """,""" & round(totalPendiente,0) & """,""" & rs("TEM_Horas") & """,""" & rs("REL_Nombres") & " " & rs("REL_Paterno") & " " & rs("REL_Materno") & """,""" & rs("MET_Descripcion") & ""","" <i class='fas fa-trash text-white-50' style='cursor:not-allowed'></i><span style='display:none'>N/A</span>""]"		
		end if		
		MOD_Id=rs("MOD_Id")
		rs.movenext
		'totalPendiente = 0
		if not rs.eof then
			dataPlanificacion = dataPlanificacion & ","
		end if
	loop
	dataPlanificacion=dataPlanificacion & "]}"
	
	response.write(dataPlanificacion)
%>