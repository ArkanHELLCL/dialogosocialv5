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
		action="/mod-12-h0-s4"
		columns="{data: ""OES_Id""},{data: ""OES_ObjetivoEspecifico""},{data: ""OES_ResultadoEsperado""},{data: ""OES_Indicador""},{data: ""OES_VerificadorCumplimiento""},{className: '',orderable: false,data: ""Del""}"
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
		columns="{data: ""OES_Id""},{data: ""OES_ObjetivoEspecifico""},{data: ""OES_ResultadoEsperado""},{data: ""OES_Indicador""},{data: ""OES_VerificadorCumplimiento""}"
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
			PRY_ObjetivoGeneral=rs("PRY_ObjetivoGeneral")
			PRY_Carpeta=rs("PRY_Carpeta")
			carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
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
	<h5>Objetivos del Proyecto</h5>
	<h6>Obejtivo General</h6><%
	if(mode="mod") then%>
		<form role="form" action="<%=action%>" method="POST" name="frm12s4" id="frm12s4" class="needs-validation">
			<div class="row"> 
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="md-form">
						<div class="error-message">					
							<i class="fas fa-tasks prefix"></i>
							<textarea id="PRY_ObjetivoGeneral" name="PRY_ObjetivoGeneral" class="md-textarea form-control" rows="3" required><%=PRY_ObjetivoGeneral%></textarea>
							<span class="select-bar"></span><%
							if(PRY_ObjetivoGeneral<>"") then%>
								<label for="PRY_ObjetivoGeneral" class="active">Objetivo general</label><%
							else%>
								<label for="PRY_ObjetivoGeneral" class="">Objetivo general</label><%
							end if%>							
						</div>
					</div>
				</div>	
			</div>			
			<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
			<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
			<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
			<input type="hidden" id="Step" name="Step" value="4" />		
		</form>
		<form role="form" action="/agregar-objetivo-especifico" method="POST" name="frm12s4_1" id="frm12s4_1" class="needs-validation">
			<h6>Obejtivo Específico</h6>
			<div class="row" style="position:relative;padding-top:20px">				
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-4">
					<div class="md-form">
						<div class="error-message">					
							<i class="fas fa-tasks prefix"></i>
							<textarea id="OES_ObjetivoEspecifico" name="OES_ObjetivoEspecifico" class="md-textarea form-control" rows="3" required></textarea>
							<span class="select-bar"></span>
							<label for="OES_ObjetivoEspecifico" class="">Objetivo específico</label>									
						</div>
					</div>
				</div>			
				<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4">
					<div class="md-form">
						<div class="error-message">													
							<i class="fas fa-thumbs-up prefix"></i>
							<textarea id="OES_ResultadoEsperado" name="OES_ResultadoEsperado" class="md-textarea form-control" rows="3" required></textarea>
							<span class="select-bar"></span>
							<label for="OES_ResultadoEsperado" class="">Resultado esperado</label>									
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4">
					<div class="md-form">
						<div class="error-message">					
							<i class="fas fa-square-root-alt prefix"></i>
							<textarea id="OES_Indicador" name="OES_Indicador" class="md-textarea form-control" rows="3" required></textarea>
							<span class="select-bar"></span>
							<label for="OES_Indicador" class="">Indicador</label>									
						</div>
					</div>
				</div>		
			</div>
			<div class="row">
				<div class="col align-self-end">
					<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm12s4_1" name="btn_frm12s4_1" style="float: right;"><i class="fas fa-plus"></i></button>
				</div>
			</div>
			<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
		</form><%
	end if
	if(mode="vis") then%>		
		<div class="row"> 
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-tasks prefix"></i>
						<textarea id="PRY_ObjetivoGeneral" name="PRY_ObjetivoGeneral" class="md-textarea form-control" rows="3" disabled readonly><%=PRY_ObjetivoGeneral%></textarea>
						<span class="select-bar"></span><%
						if(PRY_ObjetivoGeneral<>"") then%>
							<label for="PRY_ObjetivoGeneral" class="active">Objetivo general</label><%
						else%>
							<label for="PRY_ObjetivoGeneral" class="">Objetivo general</label><%
						end if%>									
					</div>
				</div>
			</div>	
		</div><%
	end if%>
	
	<h6>Objetivos y resultados ingresados</h6>
	<div class="row"> 		
		<div class="col-12" style="overflow: auto;">
			<table id="tbl-objesp" class="ts table table-striped table-bordered dataTable table-sm" data-id="objesp" data-page="true" data-selected="true" data-keys="1"> 
				<thead> 
					<tr> 
						<th style="width:10px;">Id</th>
						<th>Objetivo Específico</th>								 
						<th>Resultado Esperado</th>
						<th>Indicador</th>
						<th>Verificador de Cumplimiento</th><%
						if(mode="mod") then%>
							<th>Eliminar</th><%
						end if%>
					</tr> 
				</thead>					
				<tbody> 
				<%
					set rs=cnn.execute("spObjetivoEspecifico_Listar " & PRY_Id)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   
						Response.end()
					End If
					dataObjetivosEsp = "["
					do While Not rs.EOF
						OES_Id=rs("OES_Id")
						if len(OES_Id)>1 then
							yOES_Id=""
							for i=0 to len(OES_Id)
								if(isnumeric(mid(OES_Id,i,1))) then
									yOES_Id=yOES_Id & mid(OES_Id,i,1)
								end if
							next
						else
							yOES_Id=cint(OES_Id)
						end if
						path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresproyecto\p-" & yOES_Id
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
							colordel="text-white-50"			
							disableddown="pointer"							
							disableddel="not-allowed"
							data="data-id='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'"
							clasedown="doverobj"
							clasedel=""
						else			
							colordown="text-white-50"							
							colordel="text-danger"
							disableddown="not-allowed"
							disableddel="pointer"
							data="data-id='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'"
							clasedown=""
							clasedel="delobjesp"
						end if
						if(mode="mod") then
							dataObjetivosEsp = dataObjetivosEsp & "{""OES_Id"":""" & rs("OES_Id") & """,""OES_ObjetivoEspecifico"":""" & rs("OES_ObjetivoEspecifico") & """,""OES_ResultadoEsperado"":""" & rs("OES_ResultadoEsperado") & """,""OES_Indicador"":""" & rs("OES_Indicador") & """,""OES_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & colordel & " " & clasedel & "' style='cursor:" & disableddel & "' data-obj='" & rs("OES_Id") & "' data-pry='" & PRY_Id & "'></i>"""
						else
							dataObjetivosEsp = dataObjetivosEsp & "{""OES_Id"":""" & rs("OES_Id") & """,""OES_ObjetivoEspecifico"":""" & rs("OES_ObjetivoEspecifico") & """,""OES_ResultadoEsperado"":""" & rs("OES_ResultadoEsperado") & """,""OES_Indicador"":""" & rs("OES_Indicador") & """,""OES_VerificadorCumplimiento"":""" & rs("OES_VerificadorCumplimiento") & """"
						end if
						dataObjetivosEsp = dataObjetivosEsp & "}"											
						rs.movenext
						if not rs.eof then
							dataObjetivosEsp = dataObjetivosEsp & ","
						end if
					loop
					dataObjetivosEsp=dataObjetivosEsp & "]"								
					rs.close										
				%>                	
				</tbody>
			</table>
		</div>
	</div>		
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>				
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s4" name="btn_frm12s4"><%=txtBoton%></button><%	
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
					
		var objespTable;
		var dataObjetivosEsp = <%=dataObjetivosEsp%>
		loadTableObjetivosEsp(dataObjetivosEsp);
        $('#tbl-objesp').css('width','100%')
		
		function loadTableObjetivosEsp(data) {			
			objespTable = $('#tbl-objesp').DataTable({				
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
		
		$("#btn_frm12s4_1").click(function(){
			formValidate("#frm12s4_1")
			if($("#frm12s4_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm12s4_1").attr("action"),
					data: $("#frm12s4_1").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						objespTable.clear().draw();
						objespTable.rows.add(jQuery.parseJSON(param[1])).draw();						
						if(param[0]=="200"){
							$("#frm12s4_1")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Objetivo y Resultados agregados correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del Objetivo',					
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
		
		$("#pry-content").on("click",".delobjesp",function(e){
			e.preventDefault();
			e.stopPropagation();
			/*var OES_Id = $(this).children().data("obj"); 
			var PRY_Id = $(this).children().data("pry");*/
			var OES_Id = $(this).data("obj"); 
			var PRY_Id = $(this).data("pry");
			console.log($(this))
			console.log($(this).data("pry"))
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el objetivo seleccionado",
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
						url: '/elimina-objetivo-especifico',
						data: {PRY_Id:PRY_Id, OES_Id:OES_Id},
						success: function(data) {					
							param=data.split(bb);
							objespTable.clear().draw();
							objespTable.rows.add(jQuery.parseJSON(param[1])).draw();							
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'objetivo Específico eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos del Objetivo',					
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
			
		})
		
		
		
		$("#btn_frm12s4").click(function(){
							
			formValidate("#frm12s4")
			if($("#frm12s4").valid()){
				if(objespTable.data().count()<3){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Debes ingresar al menos 3 objetivos específicos antes de avanzar'							
					});
				}else{
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm12s4").attr("action"),
						data: $("#frm12s4").serialize(),
						success: function(data) {					
							param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Objetivos del Proyecto grabados correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
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
				}
			}
		})
		
		$("#pry-content").on("click",".doverobj",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var OES_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-proyecto',			
				data:{OES_Id:OES_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:105, ALU_Rut:ALU_Rut,OES_Id:OES_Id};
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
		
	});
</script>