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
		mode="mod"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		calendario="calendario"
		action="/mod-12-h0-s5"
		columnsOBJ="{data: ""OPM_Id""},{data: ""OPM_ObjetivoEspecifico""},{className: 'delobjmark',orderable: false,data: ""Del""}"		
		columnsVER="{data: ""VPM_Id""},{data: ""VPM_AccionComprometida""},{data: ""VPM_Etapa""},{data: ""VPM_VerificadorCumplimiento""},{data: ""VPM_Comprometida""},{className: '',orderable: false,data: ""Del""}"
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
		columnsOBJ="{data: ""OPM_Id""},{data: ""OPM_ObjetivoEspecifico""}"	
		columnsVER="{data: ""VPM_Id""},{data: ""VPM_AccionComprometida""},{data: ""VPM_Etapa""},{data: ""VPM_VerificadorCumplimiento""},{data: ""VPM_Comprometida""}"
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
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Plan de Marketing</h5>		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">				
				<div class="content-nav">
					<a id="mar1-tab" href="#marobjtab1" class="active tab"><i class="fas fa-tasks"></i> Objetivos Específicos 
						<span class="badge right blue objetivos">0</span>
					</a>
					<a id="mar2-tab" href="#maracctab2" class="tab"><i class="fas fa-people-carry"></i> Acciones 
						<span class="badge right blue verificadores">0</span>
					</a>				
					<span class="yellow-bar"></span>				
					<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
						<div class="animated-icon1"><span></span><span></span><span></span></div>
					</button>
				</div>				
			</div>
			<div class="tab-content">
				<div id="marobjtab1"><%		
					if(mode="mod") then%>
						<form role="form" action="/agregar-objetivo-marketing" method="POST" name="frm12s5_1" id="frm12s5_1" class="needs-validation">			
							<div class="row"> 
								<div class="col-xs-12 col-sm-12 col-md-11 col-lg-11">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-tasks prefix"></i>
											<textarea id="OPM_ObjetivoEspecifico" name="OPM_ObjetivoEspecifico" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="OPM_ObjetivoEspecifico" class="">Objetivo específico</label>									
										</div>
									</div>
								</div>			
								<div class="col align-self-end">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm12s5_1" name="btn_frm12s5_1" style="float: right;"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
						</form><%
					end if%>	
					<div class="row" style="padding-top:20px">						
						<div class="col-12">
							<table id="tbl-objmark" class="ts table table-striped table-bordered dataTable table-sm" data-id="objmark" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">Id</th>
										<th>Objetivo Específico</th><%
										if(mode="mod") then%>
											<th>Eliminar</th><%
										end if%>
									</tr> 
								</thead>					
								<tbody> 
								<%
									set rs=cnn.execute("spObjetivoEspPlanMarketing_Listar " & PRY_Id)
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataObjetivosMark = "["
									do While Not rs.EOF
										if(mode="mod") then
											dataObjetivosMark = dataObjetivosMark & "{""OPM_Id"":""" & rs("OPM_Id") & """,""OPM_ObjetivoEspecifico"":""" & rs("OPM_ObjetivoEspecifico") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-opm='" & rs("OPM_Id") & "' data-pry='" & PRY_Id & "'></i>"""							
										else
											dataObjetivosMark = dataObjetivosMark & "{""OPM_Id"":""" & rs("OPM_Id") & """,""OPM_ObjetivoEspecifico"":""" & rs("OPM_ObjetivoEspecifico") & """"
										end if
										dataObjetivosMark = dataObjetivosMark & "}"											
										rs.movenext
										if not rs.eof then
											dataObjetivosMark = dataObjetivosMark & ","
										end if
									loop
									dataObjetivosMark=dataObjetivosMark & "]"								
									rs.close											
								%>                	
								</tbody>
							</table>
						</div>
					</div>							
				</div>
				<div id="maracctab2"><%
					if(mode="mod") then%>
						<form role="form" action="/agregar-accion-comprometida" method="POST" name="frm12s5_2" id="frm12s5_2" class="needs-validation">			
							<div class="row" style="position:relative;padding-top:20px">								
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-handshake prefix"></i>
											<textarea id="VPM_AccionComprometida" name="VPM_AccionComprometida" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="VPM_AccionComprometida" class="">Acción Comprometida/Propuesta</label>									
										</div>
									</div>
								</div>			
								<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">													
											<i class="fas fa-project-diagram prefix"></i>
											<textarea id="VPM_Etapa" name="VPM_Etapa" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="VPM_Etapa" class="">Etapa en la que se lleva a cabo</label>									
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-9">
								</div>
								<div class="col-2">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple">
										<label class="input-checkbox checkbox-lightBlue">
									  		<input type="checkbox" id="VPM_Comprometida" name="VPM_Comprometida" checked disabled>
									  		<span class="checkbox"></span>
										</label>
										<label for="VPM_Comprometida" class="label">Obligatorio?</label>
								 	</div>
								</div>
								<div class="col-1">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm12s5_2" name="btn_frm12s5_2"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
						</form><%
					end if%>
					<div class="row" style="padding-top:20px">						
						<div class="col-12">
							<table id="tbl-vermark" class="ts table table-striped table-bordered dataTable table-sm" data-id="vermark" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">Id</th>
										<th>Acción Comprometida</th>
										<th>Etapa en la que se lleva a cabo</th>
										<th>Verificador de Cumplimiento</th>
										<th>Comprometida?</th><%
										if(mode="mod") then%>
											<th>Eliminar</th><%
										end if%>
									</tr> 
								</thead>					
								<tbody> 
								<%
									set rs=cnn.execute("spVerificadorPlanMarketing_Listar " & PRY_Id)
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataVerificadoresMark = "["
									do While Not rs.EOF
										VPM_Id=rs("VPM_Id")
										if len(VPM_Id)>1 then
											yVPM_Id=""
											for i=0 to len(VPM_Id)
												if(isnumeric(mid(VPM_Id,i,1))) then
													yVPM_Id=yVPM_Id & mid(VPM_Id,i,1)
												end if
											next
										else
											yVPM_Id=cint(VPM_Id)
										end if
										path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresmarketing\m-" & yVPM_Id
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
											data="data-id='" & rs("VPM_Id") & "' data-pry='" & PRY_Id & "'"
											clasedown="dovermrk"
											clasedel=""
										else			
											colordown="text-white-50"
											colordel="text-danger"
											disableddown="not-allowed"
											disableddel="pointer"
											data=""
											clasedown=""
											clasedel="delvermark"
										end if
										if(rs("VPM_Comprometida")=1) then
											switch="<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>SI</span>"
										else
											switch="<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span>"
										end if
										if(mode="mod") then
											dataVerificadoresMark = dataVerificadoresMark & "{""VPM_Id"":""" & rs("VPM_Id") & """,""VPM_AccionComprometida"":""" & rs("VPM_AccionComprometida") & """,""VPM_Etapa"":""" & rs("VPM_Etapa") & """,""VPM_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""VPM_Comprometida"":""" & switch & """,""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-vpm='" & rs("VPM_Id") & "' data-pry='" & PRY_Id & "'></i>"""							
										else
											dataVerificadoresMark = dataVerificadoresMark & "{""VPM_Id"":""" & rs("VPM_Id") & """,""VPM_AccionComprometida"":""" & rs("VPM_AccionComprometida") & """,""VPM_Etapa"":""" & rs("VPM_Etapa") & """,""VPM_VerificadorCumplimiento"":""" & rs("VPM_VerificadorCumplimiento") & """,""VPM_Comprometida"":""" & switch	& """"
										end if
										dataVerificadoresMark = dataVerificadoresMark & "}"											
										rs.movenext
										if not rs.eof then
											dataVerificadoresMark = dataVerificadoresMark & ","
										end if
									loop
									dataVerificadoresMark=dataVerificadoresMark & "]"								
									rs.close											
								%>                	
								</tbody>
							</table>
						</div>
					</div>		
					
				</div>
			</div>
		</div>
	</div>
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm12s5" id="frm12s5" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s5" name="btn_frm12s5"><%=txtBoton%></button>
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
					<input type="hidden" id="Step" name="Step" value="5" />		
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
				$("span.text-muted").slideDown("slow",function(){
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
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});		
		var objmarTable;
		var dataObjetivosMark = <%=dataObjetivosMark%>
		loadTableObjetivosMark(dataObjetivosMark);
        $('#tbl-objmark').css('width','100%')
		
		function loadTableObjetivosMark(data) {	
			$(".objetivos").html(data.length);
			objmarTable = $('#tbl-objmark').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsOBJ%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		$("#btn_frm12s5_1").click(function(){
			formValidate("#frm12s5_1")
			if($("#frm12s5_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm12s5_1").attr("action"),
					data: $("#frm12s5_1").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						objmarTable.clear().draw();
						objmarTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".objetivos").html(objmarTable.data().count());
						if(param[0]=="200"){
							$("#frm12s5_1")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Objetivo agregado correctamente'
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
		
		$("#pry-content").on("click",".delobjmark",function(e){
			e.preventDefault();
			e.stopPropagation();
			var OPM_Id = $(this).children().data("opm"); 
			var PRY_Id = $(this).children().data("pry");
			
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
						url: '/elimina-objetivo-marketing',
						data: {PRY_Id:PRY_Id, OPM_Id:OPM_Id},
						success: function(data) {					
							param=data.split(bb);
							objmarTable.clear().draw();
							objmarTable.rows.add(jQuery.parseJSON(param[1])).draw();	
							
							$(".objetivos").html(objmarTable.data().count());
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
		
		
		var vermarTable;
		var dataVerificadoresMark = <%=dataVerificadoresMark%>
		loadTableVerificadoresMark(dataVerificadoresMark);
        $('#tbl-vermark').css('width','100%')
		
		function loadTableVerificadoresMark(data) {	
			$(".verificadores").html(data.length);
			vermarTable = $('#tbl-vermark').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsVER%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		$("#btn_frm12s5_2").click(function(){
			formValidate("#frm12s5_2")
			if($("#frm12s5_2").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm12s5_2").attr("action"),
					data: $("#frm12s5_2").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						vermarTable.clear().draw();
						vermarTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".verificadores").html(vermarTable.data().count());
						if(param[0]=="200"){
							$("#frm12s5_2")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Acción agregada correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos de la acción',					
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
		
		$("#pry-content").on("click",".delvermark",function(e){
			e.preventDefault();
			e.stopPropagation();
			var VPM_Id = $(this).data("vpm"); 
			var PRY_Id = $(this).data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará la Acción seleccionda",
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
						url: '/elimina-accion-comprometida',
						data: {PRY_Id:PRY_Id, VPM_Id:VPM_Id},
						success: function(data) {					
							param=data.split(bb);
							vermarTable.clear().draw();
							vermarTable.rows.add(jQuery.parseJSON(param[1])).draw();	
							
							$(".verificadores").html(vermarTable.data().count());
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Acción eliminada correctamente'
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
		
		$("#pry-content").on("click",".dovermrk",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var VPM_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-marketing',			
				data:{VPM_Id:VPM_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:106, ALU_Rut:ALU_Rut,OES_Id:VPM_Id};
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
								
		$("#btn_frm12s5").click(function(){
			formValidate("#frm12s5")
			if($("#frm12s5").valid()){
				var min = 2;
				if(vermarTable.data().count()<min || objmarTable.data().count()<min){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Debes ingresar al menos ' + min + ' objetivos específicos y ' + min + ' acciones antes de avanzar'							
					});
				}else{
				
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm12s5").attr("action"),
						data: $("#frm12s5").serialize(),
						success: function(data) {					
							param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Plan de Marketing grabado correctamente'
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
	});
</script>