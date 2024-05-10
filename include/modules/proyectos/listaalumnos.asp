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
	
	set rs2 = cnn.Execute("spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503\\Error Conexión:" & ErrMsg)
		cnn.close 		
		response.end
	End If		
	
	response.write("200\\")%>	
	<div class="table-wrapper col-sm-12" id="container-table-alumnosproyecto" style="overflow-y:auto;max-height:500px">		
		<!--Table-->
		<table id="tbl-alumnosproyecto" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="alumnosproyecto" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
			<thead> 
				<tr> 					
					<th>RUT</th>
					<th>Nombres</th>	
					<th>Paterno</th>
					<th>Materno</th>
					<th>Estado</th>
				</tr> 
			</thead>		
			<tbody><%
				do while not rs2.eof%>					
					<tr>
						<td><%=rs2("ALU_Rut")%>-<%=rs2("ALU_DV")%></td>
						<td><%=rs2("ALU_Nombre")%></td>
						<td><%=rs2("ALU_ApellidoPaterno")%></td>
						<td><%=rs2("ALU_ApellidoMaterno")%></td>
						<td><%=rs2("TES_Descripcion")%></td>
					</tr><%
					rs2.movenext
				loop
				cnn.close%>
			</tbody>                 
		</table>
	</div>