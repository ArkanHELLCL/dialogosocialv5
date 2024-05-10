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
		action="/mod-12-h2-s1"
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
			LFO_Calif=rs("LFO_Calif")
			LIN_PorcentajeMaxAsistenciaDesercion=rs("LIN_PorcentajeMaxAsistenciaDesercion")
			LIN_PorcentajeMaxAsistenciaReprobacion=rs("LIN_PorcentajeMaxAsistenciaReprobacion")
			LIN_Id=rs("LIN_Id")
			PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		if(LIN_PorcentajeMaxAsistenciaDesercion="") then
			LIN_PorcentajeMaxAsistenciaDesercion=0
		end if
		if(LIN_PorcentajeMaxAsistenciaReprobacion="") then
			LIN_PorcentajeMaxAsistenciaReprobacion=0
		end if
		if(PRY_InformeFinalAceptado="") then
			PRY_InformeFinalAceptado=0
		end if
	end if
	TotMujeres=0
	TotHombres=0
	TotMDesertores=0
	TotMEgresados=0
	TotMReprobados=0
	TotHDesertores=0
	TotHEgresados=0
	TotHReprobados=0
	TotMInscritos=0
	TotHInscritos=0
	TotHMatriculados=0
	TotMMatriculados=0
	TotMBeneficiarios=0
	TotHBeneficiarios=0
	Total=0
	Promedios=0

	sql="exec spCobertura_Listar " & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" & session("ds5_usrtoken") & "'"
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	'0 Matriculado
	'1 Beneficiario
	'2 Inscritos
	'3 Aprobados
	'4 Reprobado por Asistencia
	'5 Reprobado por notas 5
	'6 Desertado (Manual y Automatico)
	do While Not rs.EOF 
    	if(rs("sex_id")=1) then
      		
			if(rs("EST_Estado")=0) then        
        		TotMMatriculados=TotMMatriculados+rs("Total")        
      		else
				if(rs("EST_Estado")=1) then        
					TotMBeneficiarios=TotMBeneficiarios+rs("Total")        
				else
					if(rs("EST_Estado")=2) then        
						TotMInscritos=TotMInscritos+rs("Total")        
					else
						if(rs("EST_Estado")=3) then        
							TotMEgresados=TotMEgresados+rs("Total")        
						else
							if(rs("EST_Estado")=4 or rs("EST_Estado")=5) then
								TotMReprobados=TotMReprobados+rs("Total")        
							else
								if(rs("EST_Estado")=6) then
									TotMDesertores=TotMDesertores+rs("Total")        
								else
								end if
							end if
						end if
					end if
				end if
			end if
			'TotMujeres=TotMujeres+rs("Total")			
    	else      		
			if(rs("EST_Estado")=0) then        
        		TotHMatriculados=TotHMatriculados+rs("Total")        
      		else
				if(rs("EST_Estado")=1) then        
					TotHBeneficiarios=TotHBeneficiarios+rs("Total")        
				else
					if(rs("EST_Estado")=2) then        
						TotHInscritos=TotHInscritos+rs("Total")        
					else
						if(rs("EST_Estado")=3) then        
							TotHEgresados=TotHEgresados+rs("Total")        
						else
							if(rs("EST_Estado")=4 or rs("EST_Estado")=5) then
								TotHReprobados=TotHReprobados+rs("Total")        
							else
								if(rs("EST_Estado")=6) then
									TotHDesertores=TotHDesertores+rs("Total")        
								else
								end if
							end if
						end if
					end if
				end if
			end if
			'TotHombres=TotHombres+rs("Total")			
		end if
    	rs.MoveNext
  	loop  
  	rs.Close
	TotMujeres=TotMMatriculados
	TotHombres=TotHMatriculados
  	Total=TotMujeres+TotHombres
  
  
		
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
%>	
	<h5>Cobertura del Programa</h5><%
	if(PRY_InformeFinalAceptado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) then
	'if((session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) then%>
		<h6>Actualizar estados de beneficiarios</h6>
		<div class="row px-4" style="padding-top:30px;padding-bottom:30px;">
			<a href="#" type="button" class="btn btn-md waves-effect waves-dark btn-secondary" id="btn_estadosmasivo" name="btn_estadosmasivo"><i class="fas fa-sync-alt"></i> Recalcular Estados</a>
			<a href="#" type="button" class="btn btn-md waves-effect waves-dark btn-deep-orange" id="btn_eliminaestadosmasivo" name="btn_eliminaestadosmasivo"><i class="fas fa-sync-alt"></i> ELimina Estados</a>
		</div><%
	end if%>
	
	<h6>Estadísticas</h6>
	<div class="row px-4" style="padding-top:30px;">
		<table id="tbl-cobertura" class="ts table table-striped table-bordered dataTable table-sm" data-id="cobertura" data-page="true" data-selected="true" data-keys="1"> 
			<thead>
                <tr><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Alumnos/as</th>
					  <th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Hombres</th>
					  <th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Mujeres</th>
					  <th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Total</th><%
			 	  else
				  	  if(LIN_Hombre and not LIN_Mujer) then%>
				  	  	<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Alumnos</th>					  
					  	<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Total</th><%
					  else
					  	if(not LIN_Hombre and LIN_Mujer) then%>
							<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Alumnas</th>					  
					  		<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Total</th><%
						else%>
							<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Sin definir</th>					  
					  		<th scope="col" style="text-align: center;vertical-align: middle;" data-sorter="false" data-filter="false">Total</th><%
						end if
					  end if
				  end if%>
                </tr>
                </thead>
                <tbody>
				<tr>
                  <th scope="row">Matriculados/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHMatriculados)%></td>
					  <td><%=response.write(TotMMatriculados)%></td><%
				  end if%>
                  <td><%=response.write(TotHMatriculados+TotMMatriculados)%></td>
                </tr>
				<tr>
                  <th scope="row">Beneficiarios/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHBeneficiarios)%></td>
					  <td><%=response.write(TotMBeneficiarios)%></td><%
				  end if%>
                  <td><%=response.write(TotHBeneficiarios+TotMBeneficiarios)%></td>
                </tr>
                <tr>
                  <th scope="row">Inscritos/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHInscritos)%></td>
					  <td><%=response.write(TotMInscritos)%></td><%
				  end if%>
                  <td><%=response.write(TotHInscritos+TotMInscritos)%></td>
                </tr>
                <tr>
                  <th scope="row">Desertores/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHDesertores)%></td>
					  <td><%=response.write(TotMDesertores)%></td><%
				  end if%>
                  <td><%=response.write(TotHDesertores+TotMDesertores)%></td>
                </tr>
                <tr>
                  <th scope="row">Egresados/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHEgresados)%></td>
					  <td><%=response.write(TotMEgresados)%></td><%
				  end if%>
                  <td><%=response.write(TotHEgresados+TotMEgresados)%></td>
                </tr>
                <tr>
                  <th scope="row">Reprobados/as</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(TotHReprobados)%></td>
					  <td><%=response.write(TotMReprobados)%></td><%
				  end if%>
                  <td><%=response.write(TotHReprobados+TotMReprobados)%></td>
                </tr>
				
				
                <tr>
                  <th scope="row">Promedios</th><%
				  if(LIN_Hombre and LIN_Mujer) then%>
					  <td><%=response.write(round(((TotHombres*100)/Total),1) & "%")%></td>
					  <td><%=response.write(round(((TotMujeres*100)/Total),1) & "%")%></td><%
				  end if%>
                  <td>100%</td>
                </tr>
               </tbody>			
		</table>	
	</div>		
				
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm12s1" id="frm12s1" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s1" name="btn_frm12s1"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="1">
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
		
		$("#btn_estadosmasivo").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			swalWithBootstrapButtons.fire({
			  title: 'Proceso Masivo de cambio de Estados',
			  text: "¿Deseas ejecutar el proceso de cambio de estados masivo?",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, ejecutar!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, por ahora'
			}).then((result) => {
				if (result.value) {				
					$.ajax({
						type: 'POST',			
						url: "/ejecuta-proceso-estado-masivo",
						data: {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'},
						dataType: "json",
						success: function(data) {							
							if(data.state=="200"){
								cargaMenu();
								Toast.fire({
								  icon: 'success',
								  title: 'Ejecución del proceso masivo ejecutado correctamente.'
								});			
							}else{
								Toast.fire({
								  icon: 'error',
								  title: 'Hubo un error en la ejecución del proceso masivo.'
								});
							}
						}
					})
			  	}else{
					Toast.fire({
					  icon: 'info',
					  title: 'Ejecución del proceso masivo cancelado.'
					});	
				}
			})
		})
		
		$("#btn_eliminaestadosmasivo").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			swalWithBootstrapButtons.fire({
			  title: 'Proceso Masivo de eliminación de Estados',
			  text: "¿Deseas ejecutar el proceso de eliminación de estados masivo?",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, ejecutar!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, por ahora'
			}).then((result) => {
				if (result.value) {				
					$.ajax({
						type: 'POST',			
						url: "/ejecuta-proceso-eliminacion-estado-masivo",
						data: {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'},
						dataType: "json",
						success: function(data) {							
							if(data.state=="200"){
								cargaMenu();
								Toast.fire({
								  icon: 'success',
								  title: 'Ejecución del proceso masivo ejecutado correctamente.'
								});			
							}else{
								Toast.fire({
								  icon: 'error',
								  title: 'Hubo un error en la ejecución del proceso masivo.'
								});
							}
						}
					})
			  	}else{
					Toast.fire({
					  icon: 'info',
					  title: 'Ejecución del proceso masivo cancelado.'
					});	
				}
			})
		})
		
		function cargaMenu(){
			var PAR_Hito = window.location.href.split("/")[8];
			var PAR_Step = window.location.href.split("/")[9];
			var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,PRY_Hito:PAR_Hito,CRT_Step:PAR_Step};
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
		}
		
		$("#btn_frm12s1").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm12s1")
			if($("#frm12s1").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm12s1").attr("action"),
					data: $("#frm12s1").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Coberturas grabadas correctamente'
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