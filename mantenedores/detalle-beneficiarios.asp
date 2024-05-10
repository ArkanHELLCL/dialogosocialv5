<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	ALU_Rut = request("ALU_Rut")
	table 	= request("table")	
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	set rs = cnn.Execute("exec [spProyectosxAlumno_Listar] " & ALU_Rut)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End() 	
	End If%>	
	<table class="table table-striped" id="<%=table%>">
		<thead>
			<tr>
				<th>Id</th>
				<th>Proyecto</th>
				<th>Estado</th>				
				<th>Razon Deserción</th>
				<th>Causa Deserción</th>
				<th>Fecha</th>
				<th>Usuario</th>
			</tr>
		</thead>
		<tbody><%
		do while not rs.eof
			set ry = cnn.Execute("exec spEstadosAlumnoProyecto_Listar " & rs("ALU_Rut") & "," & rs("PRY_Id"))
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				response.Write("503/@/Error Conexión:" & ErrMsg)
				cnn.close 		
				response.end
			End If%>
			<tr>				
				<td><%=rs("PRY_Id")%></td>						
				<td><%=rs("PRY_Nombre")%></td>
				<td><%=ry("TES_Descripcion")%></td>
				<td><%=ry("RDE_InfoRazonDesercion")%></td>
				<td><%=ry("CDE_InfoCausaDesercion")%></td>
				<td><%=ry("EST_FechaCreacionRegistro")%></td>
				<td><%=ry("EST_UsuarioEdit")%></td>
			</tr><%
			rs.movenext
		loop	
		rs2.Close
		cnn.Close%>
		</tbody>
	</table>
	