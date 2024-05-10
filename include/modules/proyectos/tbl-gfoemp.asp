<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	EMP_Id 	= request("EMP_Id")
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
		
	set rs = cnn.Execute("exec spGrupoFocalEmpresa_Listar 1," & PRY_Id & "," & EMP_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRepProyectoEmpresa_Listar")
		cnn.close 		
		response.end
	End If%>			
	<table id="<%=table%>" class="ts table table-striped table-bordered dataTable table-sm"> 
		<thead> 
			<tr> 
				<th style="width:10px;">Id</th>
				<th>Nombre</th>
				<th>Cargo</th>				
				<th>Sexo</th>				
			</tr> 
		</thead>					
		<tbody><%
			do While Not rs.EOF%>
				<tr>
					<td><%=rs("GFE_Id")%></td>
					<td><%=rs("GFE_Nombre")%></td>
					<td><%=rs("GFE_Cargo")%></td>					
					<td><%=rs("SEX_Descripcion")%></td>
				</tr><%
				rs.movenext
			loop%>
		</tbody>
	</table>
	