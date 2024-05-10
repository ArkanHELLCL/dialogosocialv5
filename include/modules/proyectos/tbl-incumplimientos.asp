<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	INC_Id 	= request("INC_Id")
	table 	= request("table")	
	PRY_Id	= request("PRY_Id")
			
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
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		response.End() 	
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
			
	set rs2 = cnn.Execute("exec [spIncumplimientosProyecto_Listar]  " & PRY_Id & "," & INC_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description		
		cnn.close 		
		response.end
	End If%>		
	
	<table class="table table-striped" id="<%=table%>">
		<thead>
			<tr>
				<th>Id</th>
				<th>Hechos Fundantes</th>
				<th>Monto</th>
				<th>Aplicado</th>
				<th>Moneda</th>
				<th>Estado</th>
				<th>Creador</th>
				<th>Creado</th>
				<th>Acciones</th>
		</thead>
		<tbody><%
		dim fs,f	
		set fs=Server.CreateObject("Scripting.FileSystemObject")
		do while not rs2.eof
			if(rs2("IPR_Estado")=1) then
				estado="Creado"
			else
				if(rs2("IPR_Estado")=2) then
					estado="Respondio"
				else
					estado="No definido"				
				end if
			end if
			IPR_Id=rs2("IPR_Id")
			if len(IPR_Id)>1 then
				yIPR_Id=""
				for i=0 to len(IPR_Id)
					if(isnumeric(mid(IPR_Id,i,1))) then
						yIPR_Id=yIPR_Id & mid(IPR_Id,i,1)
					end if
				next
			else
				yIPR_Id=cint(IPR_Id)
			end if				
			path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\incumplimientos\inc-" & yIPR_Id & "\"
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
				colordown="text-primary"
				'colordel="text-danger"			
				disableddown="pointer"
				'disableddel="pointer"
				data="data-id='" & rs2("IPR_Id") & "' data-pry='" & PRY_Id & "'"
				clasedown="dowinc"
				'clasedel="delade"
			else			
				colordown="text-white-50"
				colordel="text-white-50"			
				disableddown="not-allowed"
				disableddel="not-allowed"
				data=""
				clasedown=""
				clasedel=""
			end if
			Acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar adjunto(s)' " & data & " data-toggle='tooltip'></i> "
			%>
			<tr>
				<td><%=rs2("IPR_Id")%></td>
				<td><%=replace(rs2("IPR_HechosFundantes"),"\""","""")%></td>
				<td><%=rs2("INC_Monto")%></td>
				<td><%=rs2("IPR_MontoAplicado")%></td>
				<td><%=rs2("MON_Descripcion")%></td>
				<td><%=estado%></td>
				<td><%=rs2("IPR_UsuarioEdit")%></td>
				<td><%=rs2("IPR_FechaEdit")%></td>	
				<td><%=Acciones%></td>
			</tr><%
			rs2.movenext
		loop
		rs2.Close
		cnn.Close%>

		</tbody>
	</table>