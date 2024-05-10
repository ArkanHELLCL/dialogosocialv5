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
		
	set rs = cnn.Execute("exec spTematicaDialogo_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error Planificacion_Listar")
		cnn.close 		
		response.end
	End If				
	
	response.write("200\\")%>	
	<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-plandetrabajo" style="overflow-y:auto;max-height:500px">
		<!--Table-->
		<table id="tbl-listplandetrabajo" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="listplandetrabajo" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
			<thead> 
				<tr> 
					<th>Id</th>					
					<th>Hito</th>
					<th>Relator</th>
					<th>Temática</th>
					<th>Fecha</th>					
					<th>H.Ini</th>
					<th>h.Tér</th>
				</tr> 
			</thead>		
			<tbody><%
				do While Not rs.EOF%> 
					<tr> 
						<td><%=rs("TED_Id")%></td>						
						<td><%=rs("TIM_NombreMesa")%></td> 
						<td><%=rs("REL_Nombres")%>&nbsp;<%=rs("REL_Paterno")%>&nbsp;<%=rs("REL_Materno")%></td> 
						<td><%=rs("TED_Nombre")%></td> 
						<td><%=rs("TED_Fecha")%></td> 						
						<td><%=rs("TED_HoraInicio")%></td>
						<td><%=rs("TED_HoraTermino")%></td>
					</tr><%
					rs.movenext
				loop
				cnn.close
				set cnn = nothing%>
			</tbody>                 
		</table>