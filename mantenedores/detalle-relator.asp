<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	REL_Id = request("REL_Id")
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
	set rs = cnn.Execute("exec [spRelatorProyecto_Listar] " & REL_Id)
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
				<th>#</th>
				<th>Id</th>
				<th>Proyecto</th>
				<th>Usuario</th>				
				<th>Fecha</th>
			</tr>
		</thead>
		<tbody><%
		do while not rs.eof%>
			<tr>				
				<td><%=rs("RLP_Id")%></td>						
				<td><%=rs("PRY_Id")%></td>
				<td><%=rs("PRY_Nombre")%></td>
				<td><%=rs("RLP_UsuarioEdit")%></td>
				<td><%=rs("RLP_FechaEdit")%></td>
			</tr><%
			rs.movenext
		loop	
		rs2.Close
		cnn.Close%>
		</tbody>
	</table>
	