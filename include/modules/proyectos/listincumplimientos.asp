<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	'if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Revisor, Auditor
	''	response.write("503\\Error de conexion")
	''	response.End() 			   
	'end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador 	= request("PRY_Identificador")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
		
	set rs = cnn.Execute("exec [spIncumplimientosLineaFormativa_Listar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spIncumplimientosLineaFormativa_Listar")
		cnn.close 		
		response.end
	End If				
	
	response.write("200\\")%>	
	<div class="table-wrapper col-sm-12" id="container-table-incumplimientos" style="overflow-y:scroll;overflow-x:scroll;max-height:500px">
		<!--Table-->
		<table id="tbl-listincumplimientos" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="listincumplimientos">
			<thead> 
				<tr> 
					<th style="width:10px;">Id</th> 					
					<th>Incumplimiento</th>					
					<th>Monto</th>
					<th>Moneda</th>
					<th>Gravedad</th>
					<th>U.Medida</th>
					<th>Bases</th>					
				</tr> 
			</thead>		
			<tbody><%
				do While Not rs.EOF%> 
					<tr> 
						<td><%=rs("INC_Id")%></td> 						
						<td><%=replace(rs("INC_Incumplimiento"),"\""","""")%></td>
						<td><%=rs("INC_Monto")%></td>
						<td><%=rs("MON_Descripcion")%></td> 
						<td><%=rs("GRA_Descripcion")%></td> 
						<td><%=rs("UME_Descripcion")%></td> 
						<td><%=rs("BAS_NombreBases")%></td>						
					</tr><%
					rs.movenext
				loop
				cnn.close
				set cnn = nothing%>
			</tbody>                 
		</table>