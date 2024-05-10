<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")<>1) then	'Todos menos el administrador
		response.write("503/@/Error Perfil no autorizado")
		response.End() 			   
	end if		
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if							
	
	response.write("200/@/")%>
	<table id="tbl-listproyectos" class="table table-striped table-bordered table-sm" data-id="listproyectos" style="margin-top:20px;" width="100%"> 
		<thead> 
			<tr> 
				<th></th> 
				<th>id</th> 
				<th>Empresa Ejecutora</th>				
				<th>Fecha de creación</th>
				<th>Linea</th>			
			</tr> 
		</thead> 	
		<tbody><%
			sql="exec spLineaFormativa_Listar 1 "
			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then		   
				rs.close
				cnn.close
				response.end()
			End If
			do while not rs.eof
				sql="exec spProyecto_Listar 9, " & rs("LFO_Id") & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				set rx = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then			   
					rx.close
					cnn.close
					response.end()
				End If
				do while not rx.eof%>
					<tr>
						<td></td>
						<td><%=rx("PRY_Id")%></td>
						<td><%=rx("PRY_EmpresaEjecutora")%></td>						
						<td><%=rx("PRY_FechaEdit")%></td>
						<td><%=rx("LIN_Nombre")%></td>
					</tr><%
					rx.movenext
				loop					
				rs.movenext
			loop%>						
		</tbody>
	</table>
	<button type="button" class="btn btn-primary btn-md waves-effect waves-dark" id="btn_desarchivapry" name="btn_archivapry"><i class="fas fa-box-open"></i> Desarchivar</button>
	<button type="button" class="btn btn-secondary btn-md waves-effect waves-dark" id="btn_cancelapry" name="btn_cancelapry"><i class="fas fa-thumbs-down"></i> Cancelar</button>