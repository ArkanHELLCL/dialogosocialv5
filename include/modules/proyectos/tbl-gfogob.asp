<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	SER_Id 	= request("SER_Id")
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
			
	set rs = cnn.Execute("exec spGrupoFocalGobierno_Listar -1," & PRY_Id & "," & SER_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spGrupoFocalGobierno_Listar")
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
					<td><%=rs("GFG_Id")%></td>
					<td><%=rs("GFG_Nombre")%></td>
					<td><%=rs("GFG_Cargo")%></td>										
					<td><%=rs("SEX_Descripcion")%></td>
				</tr><%
				rs.movenext
			loop%>
		</tbody>
	</table>
	