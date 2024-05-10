<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
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
		
	set rs = cnn.Execute("exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error Planificacion_Listar")
		cnn.close 		
		response.end
	End If				
	
	response.write("200\\")%>	
	<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-planificacion" style="overflow-y:auto;max-height:500px">
		<!--Table-->
		<table id="tbl-listplanificacion" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="listplanificacion" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
			<thead> 
				<tr> 
					<th style="width:10px;">Sesión</th>					
					<th>Módulo</th>
					<th>Fecha</th>
					<th>Inicio</th>
					<th>Fin</th>
					<th>Id</th>
					<th>Relator</th>
					<th>Id</th>
					<th>Metodología</th>
				</tr> 
			</thead>		
			<tbody><%
				do While Not rs.EOF
					if(year(rs("PLN_Fecha"))>=2010) then
						Fecha = rs("PLN_Fecha")
					else
						Fecha = "-"
					end if
					if(isDate(rs("PLN_HoraInicio"))) then
						HoraInicio = rs("PLN_HoraInicio")
					else
						HoraInicio = "-"
					end if
					if(isDate(rs("PLN_HoraFin"))) then
						HoraFin = rs("PLN_HoraFin")
					else
						HoraFin = "-"
					end if%> 
					<tr> 
						<td><%=rs("PLN_Sesion")%></td>						
						<td><%=rs("TEM_Nombre")%></td> 
						<td><%=Fecha%></td> 
						<td><%=HoraInicio%></td> 
						<td><%=HoraFin%></td>
						<td><%=rs("REL_Id")%></td>
						<td><%=rs("REL_Nombres") & " " & rs("REL_Paterno")%></td>
						<td><%=rs("MET_Id")%></td>
						<td><%=rs("MET_Descripcion")%></td>
					</tr><%
					rs.movenext
				loop
				cnn.close
				set cnn = nothing%>
			</tbody>                 
		</table>