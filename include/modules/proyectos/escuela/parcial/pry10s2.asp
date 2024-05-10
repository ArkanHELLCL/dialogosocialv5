<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="vis"
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		action="/mod-10-h2-s2"
		checkbox="required"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
	end if
			
	anio=year(date())
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	lblClass=""
	if(mode="mod" or mode="vis") then
		if(mode="vis") then
			lblSelect = "active"
		end if		
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End()
		end if
		if not rs.eof then
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if		
	
	rs.close
	response.write("200/@/")%>

	<h5>Nuevas Deserciones e Incorporaciones</h5>
	<h6>Deserciones (Posteriores a la fecha de cierre del informe Inicio)</h6>
	<div class="row px-4" style="padding-top:30px;">		
		<table id="tbl-newdeserciones" class="ts table table-striped table-bordered dataTable table-sm" data-id="newdeserciones" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>				
				<tr> 
					<th style="width:10px;">#</th>
					<th>Nombre</th>
					<th>Sexo</th> 
					<th>Rut</th>
					<th>Fecha</th>
				</tr> 
			</thead>
			<tbody><%
				sql = "exec spAlumnoProyecto_DesercionResumen_PorFechaCierreInforme " & PRY_Id  & ",1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
				set rs = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	   
					cnn.close
					response.Write("503/@/Error Conexión:" & ErrMsg)
					response.End()
				End If
				do while not rs.eof	
					x=x+1%>
					<tr>
						<td><% response.write(x)%></td>
						<td><% response.write(rs("ALU_Nombre") & " " & rs("ALU_ApellidoPaterno")) %></td>                      	                  	
						<td><%=rs("Sex_Descripcion")%></td> 
						<td><% response.write(rs("ALU_Rut") & rs("ALU_Dv"))%></td>
						<td><%=rs("EST_FechaCreacionRegistro")%></td>
					</tr><%
					rs.movenext				
				loop
				rs.close%>
			</tbody>
			
		</table>	
	</div>		
	<h6>Incorporaciones (Posteriores a la fecha de cierre del informe Inicio)</h6>	
	<div class="row px-4" style="padding-top:30px;">		
		<table id="tbl-newincorporaciones" class="ts table table-striped table-bordered dataTable table-sm" data-id="newincorporaciones" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>
				<tr>
					<th style="width:10px;">#</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Rut</th>
					<th>Incorporación</th>
                    <th>Estado</th>
				</tr>
			</thead><%					
			sql = "exec spAlumnoProyecto_IncorporacionResumen_PorFechaCierreInforme " & PRY_Id & ",1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rsx = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close
				response.Write("503/@/Error Conexión:" & ErrMsg)
				response.End()
			End If
			do while not rsx.eof				
				x=x+1%>
				<tr>
					<td><% response.write(x)%></td>
					<td><% response.write(rsx("ALU_Nombre") & " " & rsx("ALU_APellidoPaterno")) %></td>                      	                  	
					<td><%=rsx("Sex_Descripcion")%></td> 
					<td><% response.write(rsx("ALU_Rut") & "-" & rsx("ALU_Dv"))%></td>
					<td><%=rsx("EST_FechaCreacionRegistro")%></td>
					<td><%=rsx("TES_Descripcion")%></td>
				</tr><%
				rsx.movenext
			loop%>		
		</table>
	</div>	
				
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm10s1" id="frm10s2" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s2" name="btn_frm10s2"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="2">
					<input type="hidden" id="PRY_Hito" value="2" name="PRY_Hito">
					
				</form><%
			else%>				
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>			
	</div>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	$(document).ready(function() {
		var tables = $.fn.dataTable.fnTables(true);
		$(tables).each(function () {
			$(this).dataTable().fnDestroy();				
		});	
		newdesercionesTable = $('#tbl-newdeserciones').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		newincorporacionesTable = $('#tbl-newincorporaciones').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		
		$("#btn_frm10s2").click(function(){
			formValidate("#frm10s2")
			if($("#frm10s2").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s2").attr("action"),
					data: $("#frm10s2").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Deserciones/Incorporaciones grabadas correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:2};
							$.ajax( {
								type:'POST',					
								url: '/mnu-10',
								data: data,
								success: function ( data ) {
									param = data.split(sas)
									if(param[0]==200){						
										$("#pry-menucontent").html(param[1]);										
										moveMark(false);
									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',								
											title: 'Ups!, no pude cargar el menú del proyecto',					
											text:param[1]
										});				
									}
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){					
									swalWithBootstrapButtons.fire({
										icon:'error',								
										title: 'Ups!, no pude cargar el menú del proyecto',					
									});				
								}
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del proyecto'								
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto'							
						});
					}
				});
			}
		});		
	});
</script>