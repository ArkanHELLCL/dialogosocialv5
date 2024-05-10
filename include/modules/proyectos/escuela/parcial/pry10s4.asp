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
		action="/mod-10-h2-s4"
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
			PRY_Carpeta=rs("PRY_Carpeta")
			carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotaxlEstado] " & PRY_Id & ",0," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_TotalEstado=0
	if not rs.eof then
		ALU_TotalEstado=rs("ALU_TotalEstado")
	end if
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotalSinAsistencia] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_CeroAsistencia=0
	if not rs.eof then
		ALU_CeroAsistencia=rs("ALU_CeroAsistencia")
	end if
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_Total50oMasAsistencia] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_50maspor=0
	Do While not rs.eof
		if(CInt(rs("PLN_PorTotalHorasAsistidas"))>=50) then
			ALU_50maspor=ALU_50maspor+1
		end if
		rs.movenext
	loop
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotalDesertadosManual] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_DesetadosManual=0
	if not rs.eof then
		ALU_DesetadosManual=rs("ALU_DesetadosManual")
	end if			
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotalesPorSesion] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
		
	response.write("200/@/")%>

	<h5>Informe de asistencia</h5>	
	<h6>Estadísticas generales</h6>
	<div class="row px-4" style="padding-top:30px;">		
		<table id="tbl-resumenasistencia" class="ts table table-striped table-bordered dataTable table-sm" data-id="resumenasistencia" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>				
				<tr> 
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Matriculados/as</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Beneficiarios/as con 0% asistencia</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Beneficiarios/as con 50% o más de asistencia</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Benefeciarios/as desertados/as manualmente</th>					
				</tr> 
			</thead>
			<tbody>
				<tr>
					<td><%=ALU_TotalEstado%></td>
					<td><%=ALU_CeroAsistencia%></td>
					<td><%=ALU_50maspor%></td>
					<td><%=ALU_DesetadosManual%></td>
				</tr>
			</tbody>
			
		</table>	
	</div>
	
	<h6 style="margin-top:50px;">Estadísticas por sesión</h6>
	<div class="row px-4" style="padding-top:30px;">
		<table id="tbl-asistencia" class="ts table table-striped table-bordered dataTable table-sm" data-id="asistencia" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>				
				<tr> 
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Sesión</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos/as Presentes</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos/as Ausentes</th>
					<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos/as justificados/as</th>		
					<th scope="col" style="text-align: center;vertical-align: middle;">Detalle</th>		
				</tr> 
			</thead>
			<tbody><%				
				do while not rs.eof%>
					<tr>
						<td><%=rs("PLN_Sesion")%></td>
						<td><%=rs("ALU_Asistieron")%></td>
						<td><%=rs("ALU_Ausentes")%></td>
						<td><%=rs("ALU_Justificados")%></td><%
						if(rs("ALU_Ausentes")>0 or rs("ALU_Justificados")>0) then%>
							<td><i class="fas fa-chevron-down text-secondary verdetalle" style="cursor:pointer;" data-toggle="tooltip" title="Ver detalles"></i></td><%
						else%>
							<td><i class="fas fa-chevron-down text-white-50" style="cursor:not-allowed" data-toggle="tooltip" title="Ver detalles"></i></td><%
						end if%>
					</tr><%
					rs.movenext
				loop%>				
			</tbody>
			
		</table>
	</div>	
				
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm10s4" id="frm10s4" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s4" name="btn_frm10s4"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="4">
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
	var iTermGPACounter = 1;	
	
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
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		$(tables).each(function () {
			$(this).dataTable().fnDestroy();				
		});	
		asistenciaTable = $('#tbl-asistencia').DataTable({
			lengthMenu: [ 10,15,30 ],
		});
		$('#tbl-asistencia').css("width","100%")
				
		$("#tbl-asistencia").on("click",".dowade",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ADE_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando adjuntos','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-adjuntos-adecuaciones',			
				data:{ADE_Id:ADE_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de adjuntos creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:96, ALU_Rut:ALU_Rut,ADE_Id:ADE_Id};
							$.ajax({
								url: "/bajar-archivo",
								method: 'POST',
								data:data,
								xhrFields: {
									responseType: 'blob'
								},
								success: function (data) {

									var a = document.createElement('a');
									var url = window.URL.createObjectURL(data);
									a.href = url;
									a.download = INF_Arc;
									document.body.append(a);
									a.click();
									a.remove();
									window.URL.revokeObjectURL(url);
								}
							});			
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de adjuntos.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#btn_frm10s4").click(function(){
			formValidate("#frm10s4")
			if($("#frm10s4").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s4").attr("action"),
					data: $("#frm10s4").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Informe de Asistencia grabada correctamente'
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
		
		$("#tbl-asistencia").on("click", ".verdetalle", function() {
			var tr = $(this).closest('tr');
			var row = asistenciaTable.row(tr);			
			var id=$(this).data("id");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".verdetalle").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-inaDET_" + iTermGPACounter)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".verdetalle").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}
			$(".shown").next("tr").attr("style","background-color: transparent !important;");
	  	});
		
		function formatRespuesta(rowData,table_id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/ver-detalle-inasistencias',
				data: {PLN_Sesion: rowData[0], table: table_id, PRY_Id:<%=PRY_Id%>},        
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 3 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}
		
	});
</script>