<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	'response.write("200/@/" & LIN_Id & "-" & mode & "-" & PRY_Id)
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="mod"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		calendario="calendario"
		action="/mod-10-h0-s4"
		columns="{data: ""ENP_Id""},{data: ""ENP_Accion""},{data: ""ENP_DescripcionAccion""},{data: ""ENP_Justificacion""},{data: ""ENP_Verificador""},{className: 'delaccenfoque',orderable: false,data: ""Del""}"
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
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
		columns="{data: ""ENP_Id""},{data: ""ENP_Accion""},{data: ""ENP_DescripcionAccion""},{data: ""ENP_Justificacion""},{data: ""ENP_Verificador""}"
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
			LIN_Id=rs("LIN_Id")
			PRY_Carpeta=rs("PRY_Carpeta")
			PRY_Carpeta=Replace(PRY_Carpeta, "{", "") 
			PRY_Carpeta=Replace(PRY_Carpeta, "}", "") 
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		
	end if
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end%>
	<h5>Enfoques Pedagógicos</h5><%
	if(mode="mod") then%>
		<h6>Acción y descripción</h6>
		<form role="form" action="/agregar-enfoque-pedagogico" method="POST" name="frm10s4_1" id="frm10s4_1" class="needs-validation">			
			<div class="row"> 
				<div class="col-sm-3 col-md-3 col-lg-3">
					<div class="md-form input-with-post-icon">
						<div class="error-message">					
							<i class="fas fa-tasks prefix"></i>
							<textarea id="ENP_Accion" name="ENP_Accion" class="md-textarea form-control" rows="5" required=""></textarea>
							<span class="select-bar"></span>
							<label for="ENP_Accion">Acción</label>							
						</div>
					</div>							
				</div>
				<div class="col-sm-4 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">					
							<i class="fas fa-tasks prefix"></i>
							<textarea id="ENP_DescripcionAccion" name="ENP_DescripcionAccion" class="md-textarea form-control" rows="5" required=""></textarea>
							<span class="select-bar"></span>
							<label for="ENP_DescripcionAccion">Descripción</label>							
						</div>
					</div>
				</div>	
				<div class="col-sm-4 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">					
							<i class="fas fa-tasks prefix"></i>
							<textarea id="ENP_Justificacion" name="ENP_Justificacion" class="md-textarea form-control" rows="5" required=""></textarea>
							<span class="select-bar"></span>
							<label for="ENP_Justificacion">Justificación</label>							
						</div>
					</div>
				</div>
				<div class="col align-self-end">
					<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm10s4_1" name="btn_frm10s4_1" style="float: right;"><i class="fas fa-plus"></i></button>
				</div>
			</div>
			<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
			<input type="hidden" id="PRY_Identificador" value="<%=PRY_Identificador%>" name="PRY_Identificador">
		</form><%
	end if%>
	
	<div class="row" style="padding-top:20px">		
		<div class="col-12">
			<span class="text-muted" style="float:left;Padding-bottom:10px">Acciones incorporadas</span>
			<table id="tbl-estraconv" class="ts table table-striped table-bordered dataTable table-sm" data-id="estraconv" data-page="true" data-selected="true" data-keys="1"> 
				<thead> 
					<tr> 
						<th style="width:10px;">Id</th>
						<th>Acción</th>
						<th>Descripción</th>
						<th>Justificación</th>
						<th>Verificador</th><%
						if(mode="mod") then%>
							<th>Eliminar</th><%
						end if%>
					</tr> 
				</thead>					
				<tbody> 
				<%
					set rs=cnn.execute("exec [spEnfoquesPedagogicos_Listar] " & PRY_Id )
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   
						Response.end()
					End If
					dataAccionesEnfoque = "["
					do While Not rs.EOF
						ENP_Id=rs("ENP_Id")
						if len(ENP_Id)>1 then
							yENP_Id=""
							for i=0 to len(ENP_Id)
								if(isnumeric(mid(ENP_Id,i,1))) then
									yENP_Id=yENP_Id & mid(ENP_Id,i,1)
								end if
							next
						else
							yENP_Id=cint(ENP_Id)
						end if
						path="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\verificadorenfoques\e-" & yENP_Id
						archivos=0
						If fs.FolderExists(path) = true Then
							Set carpeta = fs.getfolder(path)
							Set ficheros = carpeta.Files
							For Each archivo In ficheros
								archivos = archivos + 1
							Next
						else
							archivos = 0
						end if
						if(archivos>0) then															
							colordown="text-success"
							clasedown="doverenfoque"
							disableddown="pointer"															
						else						
							colordown="text-white-50"
							clasedown=""
							disableddown="not-allowed"
						end if
						data = "data-id='" & rs("ENP_Id") & "' data-pry='" & PRY_Id & "' data-hito='116'"
						if(mode="mod") then
							dataAccionesEnfoque = dataAccionesEnfoque & "{""ENP_Id"":""" & rs("ENP_Id") & """,""ENP_Accion"":""" & rs("ENP_Accion") & """,""ENP_DescripcionAccion"":""" & rs("ENP_DescripcionAccion") & """,""ENP_Justificacion"":""" & rs("ENP_Justificacion") & """,""ENP_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-enp='" & rs("ENP_Id") & "' data-pry='" & PRY_Id & "'></i>"""
						else
							dataAccionesEnfoque = dataAccionesEnfoque & "{""ENP_Id"":""" & rs("ENP_Id") & """,""ENP_Accion"":""" & rs("ENP_Accion") & """,""ENP_DescripcionAccion"":""" & rs("ENP_DescripcionAccion") & """,""ENP_Justificacion"":""" & rs("ENP_Justificacion") & """,""ENP_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
						end if
						dataAccionesEnfoque = dataAccionesEnfoque & "}"											
						rs.movenext
						if not rs.eof then
							dataAccionesEnfoque = dataAccionesEnfoque & ","
						end if
					loop
					dataAccionesEnfoque=dataAccionesEnfoque & "]"								
					rs.close											
				%>                	
				</tbody>
			</table>
		</div>
	</div>		
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm10s4" id="frm10s4" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s4" name="btn_frm10s4"><%=txtBoton%></button>
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
					<input type="hidden" id="Step" name="Step" value="4" />		
					<input type="hidden" id="PRY_Hito" value="0" name="PRY_Hito">
				</form><%	
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	
<script>
	$(document).ready(function() {	
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		

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
					
		var estraconvTable;
		var dataAccionesEnfoque = <%=dataAccionesEnfoque%>
		loadTableModulosAdd(dataAccionesEnfoque);
        $('#tbl-estraconv').css('width','100%')
		
		function loadTableModulosAdd(data) {
			estraconvTable = $('#tbl-estraconv').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columns%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		$("#btn_frm10s4_1").click(function(){
			formValidate("#frm10s4_1")
			if($("#frm10s4_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm10s4_1").attr("action"),
					data: $("#frm10s4_1").serialize(),
					success: function(data) {					
						param=data.split(bb);
						estraconvTable.clear().draw();
						estraconvTable.rows.add(jQuery.parseJSON(param[1])).draw();
						if(param[0]=="200"){
							$("#frm10s4_1")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Acción agregada correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos de la acción adicional',					
								text:param[1]
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
		})
		
		$("#pry-content").on("click",".doverenfoque",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ENP_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-enfoques-pedagogicos',			
				data:{ENP_Id:ENP_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:116, ALU_Rut:ALU_Rut,ENP_Id:ENP_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})

		$("#pry-content").on("click",".delaccenfoque",function(e){
			e.preventDefault();
			e.stopPropagation();
			var ENP_Id = $(this).find("i").data("enp");			
			var PRY_Id = $(this).find("i").data("pry");
			var PRY_Identificador = $("#PRY_Identificador").val();
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará la enfoque pedagógico seleccionado",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
			}).then((result) => {
			  if (result.value) {			
					$.ajax({
						type: 'POST',			
						url: '/elimina-enfoque-pedagogico',
						data: {PRY_Id:PRY_Id, ENP_Id:ENP_Id, PRY_Identificador:PRY_Identificador},
						success: function(data) {					
							param=data.split(bb);							
							if(param[0]=="200"){
								estraconvTable.clear().draw();
								estraconvTable.rows.add(jQuery.parseJSON(param[1])).draw();
								Toast.fire({
								  icon: 'success',
								  title: 'Acción enfoque pedagógico eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'ERROR!',
									text:'No se pudo eliminar la acción seleccionada.'
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
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Estrategia de convocatoria grabada correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
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
								title: 'Ups!, no pude grabar los datos del proyecto',					
								text:param[1]
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
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
	});
</script>