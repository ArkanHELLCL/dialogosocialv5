<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	'if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Revisor, Auditor
	''	response.write("503\\Error de conexion")
	''	response.End() 			   
	'end if		
	
	ALU_Rut				= request("ALU_Rut")
	PRY_Id				= request("PRY_Id")
	PRY_Identificador 	= request("PRY_Identificador")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión: 1 " & ErrMsg)
	   response.End() 			   
	end if
	
	set rs = cnn.Execute("exec spEstados_Consultar " & ALU_Rut & "," & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503\\Error Conexión: 2 " & ErrMsg)
		cnn.close 		
		response.end
	End If	
	if not rs.eof then
		rs.moivefirst
		do while not rs.eof 
			if(rs("EST_Estado")=6) then
				response.Write("20\\Error : Alumno se encuentra desertado")
				cnn.close 		
				response.end
			end if
			rs.movenext
		loop
	else
		response.Write("10\\Error : Alumno no pertenece a este proyecto : " & PRY_Id)
		cnn.close 		
		response.end
	end if
	
		
	set rs = cnn.Execute("exec spFecha_Obtener")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503\\Error Conexión: 3 " & ErrMsg)
		cnn.close 		
		response.end
	End If
	if not rs.eof then
		dia=trim(rs("dia"))
		if len(dia)=1 then
			dia="0" & dia
		end if
		mes=trim(rs("mes"))
		if len(mes)=1 then
			mes="0" & mes
		end if		
		ano=trim(rs("año"))
		FechaHoySQL = ano & "-" & mes & "-" & dia				
		hoy=cdate(FechaHoySQL)
	end if

	'set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	'on error resume next
	'if cnn.Errors.Count > 0 then 
	''	ErrMsg = cnn.Errors(0).description
	''	response.write("Error Planificacion_Listar")
	''	cnn.close 		
	''	response.end
	'End If
	
	sql="exec spAlumno_Consultar " & ALU_Rut
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAlumno_Consultar")
		cnn.close 		
		response.end
	End If
	if not rs.eof then
		ALU_Nombre=rs("ALU_Nombre")
		ALU_ApellidoPaterno=rs("ALU_ApellidoPaterno")
		SEX_Descripcion=rs("SEX_Descripcion")
	end if
	
	sql="exec spPlanificacion_ListarporSesion " & PRY_Id & ",'" & PRY_Identificador & "'"			
	set rs3 = cnn.Execute(sql)
	rs3.Sort = "PLN_Sesion ASC"
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spPlanificacion_ListarporSesion")
		cnn.close 		
		response.end
	End If
	dim sesiones(100)
	dim sesnom(100)
	dim sesfec(100)
	dim sesasi(100)
	TotSes=0
	do while not rs3.eof
		if TotSes=0 then
			SesIni=rs3("PLN_Sesion")	'Sesion menor
		end if
		sesiones(rs3("PLN_Sesion"))= rs3("PLN_Sesion")
		sesnom(rs3("PLN_Sesion"))=rs3("TEM_Nombre")
		sesfec(rs3("PLN_Sesion"))=rs3("PLN_Fecha")
		sesasi(rs3("PLN_Sesion"))=false

		TotSes=TotSes+1
		SesFin=rs3("PLN_Sesion")	'Sesion mayor
		rs3.movenext
	loop
	rs3.close
	
	sql="exec spAsistenciaRut_Listar " & PRY_Id & ",'" & PRY_Identificador & "'" & "," & ALU_Rut & ",-1"
	set rs2 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spAsistenciaRut_Listar")
		cnn.close 		
		response.end
	End If
	
	
	response.write("200\\")%>	
	<div class="table-wrapper col-sm-12" id="container-table-inasistencia" style="overflow-y:auto;max-height:500px">
		<h5 style="display:block;padding-bottom:20px;">Alumno : <%=ALU_Nombre%>&nbsp;<%=ALU_ApellidoPaterno%></h5>
		<!--Table-->
		<table id="tbl-listinasistencia" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="listinasistencia" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
			<thead> 
				<tr> 					
					<th>Ses.</th>
					<th>Fecha de Inasistencia</th>	
					<th>Módulo</th>
				</tr> 
			</thead>		
			<tbody><%								
				do while not rs2.eof										
					if (CInt(rs2("ASI_Asistio"))<>1) and (not rs2("ASI_Justifica") or ISNULL(rs2("ASI_Justifica"))) then
						'if datediff("d",cdate(trim(rs2("PLN_Fecha"))),hoy)>7 then
						if datediff("d",cdate(trim(rs2("PLN_Fecha"))),hoy)>=1 then
							response.Write("<tr>")
							response.Write("<td class='key2' style='text-align: center;'>" & rs2("PLN_Sesion") & "</td>")	
							response.Write("<td class='key3' style='text-align: center;'>" & rs2("PLN_Fecha") & "</td>")	
							response.Write("<td class='key4' style='text-align: center;'>" & rs2("TEM_Nombre") & "</td>")
							response.Write("</tr>")							
						end if											
					end if					
					sesasi(rs2("PLN_Sesion"))=true
					rs2.movenext
				loop
				cnn.close
				set cnn = nothing
				for k=SesIni to SesFin					
					if (trim(sesasi(k))<>"") then
						if (not sesasi(k)) then
							if datediff("d",cdate(trim(sesfec(k))),hoy)>=1 then
								response.Write("<tr>")
								response.Write("<td class='key2' style='text-align: center;'>" & sesiones(k) & "</td>")	
								response.Write("<td class='key3' style='text-align: center;'>" & sesfec(k) & "</td>")	
								response.Write("<td class='key4' style='text-align: center;'>" & sesnom(k) & "</td>")								
								response.Write("</tr>")
							end if
						end if
					end if
				next%>
			</tbody>                 
		</table>