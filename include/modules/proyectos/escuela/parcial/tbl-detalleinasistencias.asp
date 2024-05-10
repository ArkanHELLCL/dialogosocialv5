<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PLN_Sesion 	= request("PLN_Sesion")
	table 		= request("table")	
	PRY_Id		= request("PRY_Id")	
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
	   response.End()
	end if
	if not rs.eof then
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LIN_Hombre=rs("LIN_Hombre")
		LIN_Mujer=rs("LIN_Mujer")
	else
		response.Write("503/@/Error Conexión:")
		response.End() 
	end if
	
	
	set rs2 = cnn.Execute("exec spAlumnoProyecto_Inasistencias " & PRY_Id & "," & PLN_Sesion & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		response.End() 	
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")%>		
	<table class="table table-striped" id="<%=table%>">
		<thead>
			<tr> 				
				<th scope="col" style="text-align: center;vertical-align: middle;">Alumno</th>
				<th scope="col" style="text-align: center;vertical-align: middle;">Fecha</th>
				<th scope="col" style="text-align: center;vertical-align: middle;">Justificación</th>
				<th scope="col" style="text-align: center;vertical-align: middle;">Medio de Verificación</th>
				<th scope="col" style="text-align: center;vertical-align: middle;">Adecuación</th>
			</tr> 
		</thead>
		<tbody><%
			do while not rs2.eof
				sqlz="exec [spAdecuaciones_BuscarJustificacion] " & PRY_Id & "," & rs2("ALU_Rut") & "," & rs2("PLN_Sesion") & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				set rsx = cnn.Execute(sqlz)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	
					response.Write("503/@/Error Conexión:" & ErrMsg & " - " & sqlz)
					cnn.close 			   
					Response.end()
				End If
				if not rsx.eof then
					ADE_Id = rsx("ADE_Id")
				end if
				path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\adecuaciones\ade-" & ADE_Id & "\"
				archivos=0
				If fs.FolderExists(path) = true Then
					Set carpeta = fs.getfolder(path)
					Set ficheros = carpeta.Files
					For Each archivo In ficheros
						archivos = archivos + 1
					Next
				else
					archivos = 0
				end if
				if(archivos>0) then			
					colordown=" text-primary"
					colordel=" text-danger"			
					disableddown="pointer"
					disableddel="pointer"
					data="data-id='" & ADE_Id & "' data-pry='" & PRY_Id & "'"
					clasedown=" dowade"
					clasedel="delade"
				else			
					colordown=" text-white-50"
					colordel=" text-white-50"			
					disableddown="not-allowed"
					disableddel="not-allowed"
					data=""
					clasedown=""
					clasedel=""
				end if%>
				<tr>
					<td><%=rs2("ALU_Rut")%>-<%=rs2("ALU_Dv")%></td>
					<td><%=rs2("PLN_Fecha")%></td><%
					if rs2("ASI_Justifica") then
						response.Write("<td style='text-align: center;'>SI</td>")%>										
						<td style="text-align: center;">
							<i class="fas fa-cloud-download-alt <%=clasedown%> <%=colordown%>" style="cursor: <%=disableddown%>" title="Bajar adjunto" <%=data%> data-toggle="tooltip"></i>
						</td><%
						response.write("<td><i class='text-primary'>" & ADE_Id & "</id></td>")
					else									
						response.Write("<td class='justificado' style='text-align: center;'>NO</td>")
						response.Write("<td style='text-align: center;'><i class='fas fa-cloud-download-alt' style='color:#aaa;cursor:not-allowed'></i></td>")						
						response.write("<td>-</td>")
					end if%>					
				</tr><%				
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>
		</tbody>
	</table>
	