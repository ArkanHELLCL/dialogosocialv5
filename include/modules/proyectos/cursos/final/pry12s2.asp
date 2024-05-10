<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Hito=2
	
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
		action="/mod-12-h2-s2"
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
		txtBoton="<i class='fas fa-forward'></i>"
		btnColor="btn-secondary"
		checkbox="disabled"
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
	
	sql="exec  spAlumnoProyecto_DesercionInfo " & PRY_Id  & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	if not rs.eof then
		FechaPrimeraDesercionsplit = split(mid(rs("FechaPrimeraDesercion"),1,10),"-")
		FechaPrimeraDesercion = FechaPrimeraDesercionsplit(2) & "-" & FechaPrimeraDesercionsplit(1) & "-" & FechaPrimeraDesercionsplit(0)	'año mes dia'
	else
		FechaPrimeraDesercion = ""
	end if
	if(isNULL(rs("FechaPrimeraDesercion"))) then
		FechaPrimeraDesercion = ""
	end if
	
	rs.close		
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
%>	
	<h5>Deserciones Manuales</h5>
	<h6>Causas, razones y cantidad de deserciones</h6>	
	<div class="row px-4" style="padding-top:30px;">		
		<table id="tbl-causas" class="ts table table-striped table-bordered dataTable table-sm" data-id="causas" data-page="true" data-selected="true" data-keys="1"> 
			<thead>
				<tr>
				  <th rowspan="2" style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">Causa</th>
				  <td rowspan="2" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Razón</td><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					<td colspan="3" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Cantidad de Alumnos/as</td><%
				  else
					if(LIN_Mujer and not LIN_Hombre) then%>
						<td colspan="3" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Cantidad de Alumnas</td><%
					else
						if(not LIN_Mujer and LIN_Hombre) then%>
							<td colspan="3" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Cantidad de Alumnos</td><%
						else%>
							<td colspan="3" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">No definido</td><%
						end if
					end if
				  end if%>
				</tr>
				<tr><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Hombres</td>
					<td style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Mujeres</td><%
				  end if%>						  
				  <td style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Total</td>
				</tr>
			</thead>
			<tbody><%
				sql = "exec spAlumnoProyecto_DesercionResumen " & PRY_Id  & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
				set rs = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	   
					cnn.close
					response.Write("503/@/Error Conexión:" & ErrMsg)
					response.End()
				End If
				do while not rs.eof%>
					<tr><%
					if(CDE_InfoCausaId<>rs("CDE_InfoCausaId")) then%>
						<th rowspan="<%=rs("RazonesxCausa")%>" scope="row" style="text-align: center;vertical-align: middle;"><%=trim(rs("CDE_InfoCausaDesercion"))%></th><%
					end if%>					
					<td><%=trim(rs("RDE_InfoRazonDesercion"))%></td><%
					if(LIN_Hombre and LIN_Mujer) then%>
						<td style="text-align: center;vertical-align: middle;"><%=rs("Masculino")%></td>
						<td style="text-align: center;vertical-align: middle;"><%=rs("Femenino")%></td><%
					end if%>
					<td style="text-align: center;vertical-align: middle;font-weight: bold;"><%=rs("Masculino")+rs("Femenino")%></td><%
					CDE_InfoCausaId=rs("CDE_InfoCausaId")
					rs.movenext		
				loop
				rs.close%>
			</tbody>
			
		</table>	
	</div>		
	<h6 style="margin-top:50px;">Observaciones sobre las deserciones</h6>	
	<div class="row px-4" style="padding-top:30px;">		
		<table id="tbl-obsevaciones" class="ts table table-striped table-bordered dataTable table-sm" data-id="obsevaciones" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>
				<tr><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					<th style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">Alumno/a</th><%						
				  else
					if(LIN_Hombre and not LIN_Mujer) then%>
						<th style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">Alumno</th><%
					else
						if(not LIN_Hombre and LIN_Mujer) then%>
							<th style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">Alumna</th><%
						else%>
							<th style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">No definido</th><%
						end if
					end if
				  end if%>
				  <th style="text-align: center;vertical-align: middle;" scope="row" data-sorter="false" data-filter="false">Causa</th>
				  <td style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Razón</td>
				  <td style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Observación</td>
			</thead><%					
			sql = "exec spAlumnoProyecto_Listar " & PRY_Id
			set rsx = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close
				response.Write("503/@/Error Conexión:" & ErrMsg)
				response.End()
			End If
			do while not rsx.eof						
				if rsx("EST_Estado")=6 and rsx("EST_InfoEstadoAcademico")<>99 then%>
					<tr>
						<td><% response.write(rsx("ALU_Nombre") & " ")%><% response.write(rsx("ALU_Apellido"))%></td>
						<td><%=rsx("CDE_InfoCausaDesercion")%></td>
						<td><%=rsx("RDE_InfoRazonDesercion")%></td>							
						<td><%=rsx("EST_InfoObservaciones")%></td>
					</tr><%
				end if					
				rsx.movenext
			loop%>					
		</table>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i>
					<input type="text" id="FechaPrimeraDesercion" name="FechaPrimeraDesercion" class="form-control calendario hasDatepicker" disabled readonly="" value="<%=mid(FechaPrimeraDesercion,1,10)%>">
					<span class="select-bar"></span><%
					if(FechaPrimeraDesercion<>"") then%>
						<label for="FechaPrimeraDesercion" class="active">Fecha Primera Deserción</label><%
					else%>
						<label for="FechaPrimeraDesercion" class="">Fecha Primera Deserción</label><%
					end if%>
				</div>
			</div>
		</div>				
	</div>
				
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm12s2" id="frm12s2" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s2" name="btn_frm12s2"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="2">
					<input type="hidden" id="PRY_Hito" value="<%=PRY_Hito%>" name="PRY_Hito">
					
				</form><%
			else%>				
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
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
		obsevacionesTable = $('#tbl-obsevaciones').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		
		$("#btn_frm12s2").click(function(){
			formValidate("#frm12s2")
			if($("#frm12s2").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm12s2").attr("action"),
					data: $("#frm12s2").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Causas de deserción grabadas correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:$("#PRY_Hito").val()};
							$.ajax( {
								type:'POST',					
								url: '/mnu-12',
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