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
		action="/mod-10-h0-s7"		
		columnsPCO="{data: ""PCO_Id""},{data: ""PCO_RiesgoIdentificado""},{data: ""PCO_DescripcionRiesgo""},{data: ""PCO_Etapa""},{data: ""PCO_MedidaMitigacion""},{data: ""PCO_Verificador""},{className: '',orderable: false,data: ""Del""}"

		columnsPLC="{data: ""PLC_Id""},{data: ""PLC_AccionDifusion""},{data: ""PLC_Descripcion""},{data: ""PLC_MedioComunicacion""},{data: ""PLC_FrecuenciaCantidad""},{data: ""PLC_EtapaDesarrollo""},{data: ""PLC_Verificador""},{className: '',orderable: false,data: ""Del""}"
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
		columnsPCO="{data: ""PCO_Id""},{data: ""PCO_RiesgoIdentificado""},{data: ""PCO_DescripcionRiesgo""},{data: ""PCO_Etapa""},{data: ""PCO_MedidaMitigacion""},{data: ""PCO_Verificador""}"

		columnsPLC="{data: ""PLC_Id""},{data: ""PLC_AccionDifusion""},{data: ""PLC_Descripcion""},{data: ""PLC_MedioComunicacion""},{data: ""PLC_FrecuenciaCantidad""},{data: ""PLC_EtapaDesarrollo""},{data: ""PLC_Verificador""}"
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
			LIN_AgregaTematica=rs("LIN_AgregaTematica")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		Step=6
		if(LIN_AgregaTematica) then
			Step=7
		end if
	end if
	
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	
	rs.close
	response.write("200/@/")
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end%>
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Planes</h5>		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">				
				<div class="content-nav">					
					<a id="plc2-tab" href="#plncomtab1" class="tab"><i class="fas fa-tasks"></i> Plan de Difusión 
						<span class="badge right blue plancom">0</span>
					</a>
					<a id="pln2-tab" href="#plncontab2" class="tab"><i class="fas fa-tasks"></i> Estrategia de Permanencia 
						<span class="badge right blue plancon">0</span>
					</a>
					<span class="yellow-bar"></span>					
				</div>				
			</div>
			<div class="tab-content">
				<div id="plncomtab1"><%
					if(mode="mod") then%>
						<form role="form" action="/agregar-plan-comunicacional" method="POST" name="frm10s7_1" id="frm10s7_1" class="needs-validation">			
							<div class="row" style="position:relative;padding-top:20px">								
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-edit prefix"></i>
											<textarea id="PLC_AccionDifusion" name="PLC_AccionDifusion" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PLC_AccionDifusion" class="">Acción de difusión</label>									
										</div>
									</div>
								</div>			
								<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">													
											<i class="fas fa-edit prefix"></i>
											<textarea id="PLC_Descripcion" name="PLC_Descripcion" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PLC_Descripcion" class="">Descripción</label>									
										</div>
									</div>
								</div>								
							</div>
							<div class="row" style="position:relative;padding-top:20px">								
								<div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-edit prefix"></i>
											<textarea id="PLC_MedioComunicacion" name="PLC_MedioComunicacion" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PLC_MedioComunicacion" class="">Medio de comuncación</label>									
										</div>
									</div>
								</div>											
								<div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
									<div class="md-form">
										<div class="error-message">													
											<i class="fas fa-edit prefix"></i>
											<textarea id="PLC_EtapaDesarrollo" name="PLC_EtapaDesarrollo" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PLC_EtapaDesarrollo" class="">Etapa en la cual se desarrolló</label>									
										</div>
									</div>
								</div>
								<div class="col-xs-12 col-sm-12 col-md-2 col-lg-2 row align-items-end">
									<div class="md-form input-with-post-icon">										
										<div class="error-message">
											<i class="fas fa-hashtag input-prefix"></i>											
											<input type="text" id="PLC_FrecuenciaCantidad" name="PLC_FrecuenciaCantidad" class="form-control" required>
											<span class="select-bar"></span>
											<label for="PLC_FrecuenciaCantidad">Frec./cant.</label>									
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-9">
								</div>
								<div class="col-2">									
								</div>
								<div class="col-1">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm10s7_1" name="btn_frm10s7_1"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
						</form><%
					end if%>
					<div class="row" style="padding-top:20px">
						<div class="col-12">
							<table id="tbl-plncom" class="ts table table-striped table-bordered dataTable table-sm" data-id="plncom" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">Id</th>
										<th>Acción de difusión</th>
										<th>Descripción</th>
										<th>Medio de comunicación</th>
										<th>Frecuancia o cantidad</th>
										<th>Etapa en la cual se desarrolló</th>
										<th>Verificador</th><%
										if(mode="mod") then%>
											<th>Eliminar</th><%
										end if%>
									</tr> 
								</thead>					
								<tbody> 
								<%
									set rs=cnn.execute("spPlanComunicacional_Listar " & PRY_Id)
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataVerificadoresPLC = "["
									do While Not rs.EOF
										PLC_Id=rs("PLC_Id")
										if len(PLC_Id)>1 then
											yPLC_Id=""
											for i=0 to len(PLC_Id)
												if(isnumeric(mid(PLC_Id,i,1))) then
													yPLC_Id=yPLC_Id & mid(PLC_Id,i,1)
												end if
											next
										else
											yPLC_Id=cint(PLC_Id)
										end if
										path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresplancomunicacional\p-" & yPLC_Id										
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
											data="data-id='" & rs("PLC_Id") & "' data-pry='" & PRY_Id & "'"
											clasedown="doplncom"
											clasedel=""
										else			
											colordown="text-white-50"
											colordel="text-danger"
											disableddown="not-allowed"
											disableddel="pointer"
											data=""
											clasedown=""
											clasedel="delplncom"
										end if										
										if(mode="mod") then
											dataVerificadoresPLC = dataVerificadoresPLC & "{""PLC_Id"":""" & rs("PLC_Id") & """,""PLC_AccionDifusion"":""" & rs("PLC_AccionDifusion") & """,""PLC_Descripcion"":""" & rs("PLC_Descripcion") & """,""PLC_MedioComunicacion"":""" & rs("PLC_MedioComunicacion") & """,""PLC_FrecuenciaCantidad"":""" & rs("PLC_FrecuenciaCantidad") & """,""PLC_EtapaDesarrollo"":""" & rs("PLC_EtapaDesarrollo") & """,""PLC_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-plc='" & rs("PLC_Id") & "' data-pry='" & PRY_Id & "'></i>"""											
										else
											dataVerificadoresPLC = dataVerificadoresPLC & "{""PLC_Id"":""" & rs("PLC_Id") & """,""PLC_AccionDifusion"":""" & rs("PLC_AccionDifusion") & """,""PLC_Descripcion"":""" & rs("PLC_Descripcion") & """,""PLC_MedioComunicacion"":""" & rs("PLC_MedioComunicacion") & """,""PLC_FrecuenciaCantidad"":""" & rs("PLC_FrecuenciaCantidad") & """,""PLC_EtapaDesarrollo"":""" & rs("PLC_EtapaDesarrollo") & """,""PLC_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
										end if
										dataVerificadoresPLC = dataVerificadoresPLC & "}"											
										rs.movenext
										if not rs.eof then
											dataVerificadoresPLC = dataVerificadoresPLC & ","
										end if
									loop
									dataVerificadoresPLC=dataVerificadoresPLC & "]"								
									rs.close											
								%>                	
								</tbody>
							</table>
						</div>
					</div>		
					
				</div>				
				<div id="plncontab2"><%
					if(mode="mod") then%>
						<form role="form" action="/agregar-plan-de-contingencia" method="POST" name="frm10s7_2" id="frm10s7_2" class="needs-validation">			
							<div class="row" style="position:relative;padding-top:20px">								
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-edit prefix"></i>
											<textarea id="PCO_RiesgoIdentificado" name="PCO_RiesgoIdentificado" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PCO_RiesgoIdentificado" class="">Riesgo identificado</label>									
										</div>
									</div>
								</div>			
								<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">													
											<i class="fas fa-edit prefix"></i>
											<textarea id="PCO_DescripcionRiesgo" name="PCO_DescripcionRiesgo" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PCO_DescripcionRiesgo" class="">Descripción</label>									
										</div>
									</div>
								</div>								
							</div>
							<div class="row" style="position:relative;padding-top:20px">								
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
									<div class="md-form">
										<div class="error-message">					
											<i class="fas fa-edit prefix"></i>
											<textarea id="PCO_Etapa" name="PCO_Etapa" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PCO_Etapa" class="">Etapa(s)</label>									
										</div>
									</div>
								</div>			
								<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">													
											<i class="fas fa-edit prefix"></i>
											<textarea id="PCO_MedidaMitigacion" name="PCO_MedidaMitigacion" class="md-textarea form-control" rows="3" required></textarea>
											<span class="select-bar"></span>
											<label for="PCO_MedidaMitigacion" class="">Medidas de mitigación</label>									
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-9">
								</div>
								<div class="col-2">									
								</div>
								<div class="col-1">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm10s7_2" name="btn_frm10s7_2"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
						</form><%
					end if%>
					<div class="row" style="padding-top:20px">						
						<div class="col-12">
							<table id="tbl-plncon" class="ts table table-striped table-bordered dataTable table-sm" data-id="plncon" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">Id</th>
										<th>Riesgo Identificado</th>
										<th>Descripción</th>
										<th>Etapa(s)</th>
										<th>Medidas de mitigación</th>
										<th>Verificador</th><%
										if(mode="mod") then%>
											<th>Eliminar</th><%
										end if%>
									</tr> 
								</thead>					
								<tbody> 
								<%
									set rs=cnn.execute("spPlanContingencia_Listar " & PRY_Id)
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataVerificadoresPCO = "["
									do While Not rs.EOF
										PCO_Id=rs("PCO_Id")
										if len(PCO_Id)>1 then
											yPCO_Id=""
											for i=0 to len(PCO_Id)
												if(isnumeric(mid(PCO_Id,i,1))) then
													yPCO_Id=yPCO_Id & mid(PCO_Id,i,1)
												end if
											next
										else
											yPCO_Id=cint(PCO_Id)
										end if
										path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresplancontingencia\p-" & yPCO_Id
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
											data="data-id='" & rs("PCO_Id") & "' data-pry='" & PRY_Id & "'"
											clasedown="doplncon"
											clasedel=""
										else			
											colordown="text-white-50"
											colordel="text-danger"
											disableddown="not-allowed"
											disableddel="pointer"
											data=""
											clasedown=""
											clasedel="delplncon"
										end if										
										if(mode="mod") then
											dataVerificadoresPCO = dataVerificadoresPCO & "{""PCO_Id"":""" & rs("PCO_Id") & """,""PCO_RiesgoIdentificado"":""" & rs("PCO_RiesgoIdentificado") & """,""PCO_DescripcionRiesgo"":""" & rs("PCO_DescripcionRiesgo") & """,""PCO_Etapa"":""" & rs("PCO_Etapa") & """,""PCO_MedidaMitigacion"":""" & rs("PCO_MedidaMitigacion") & """,""PCO_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-pco='" & rs("PCO_Id") & "' data-pry='" & PRY_Id & "'></i>"""
										else
											dataVerificadoresPCO = dataVerificadoresPCO & "{""PCO_Id"":""" & rs("PCO_Id") & """,""PCO_RiesgoIdentificado"":""" & rs("PCO_RiesgoIdentificado") & """,""PCO_DescripcionRiesgo"":""" & rs("PCO_DescripcionRiesgo") & """,""PCO_Etapa"":""" & rs("PCO_Etapa") & """,""PCO_MedidaMitigacion"":""" & rs("PCO_MedidaMitigacion") & """,""PCO_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
										end if
										dataVerificadoresPCO = dataVerificadoresPCO & "}"											
										rs.movenext
										if not rs.eof then
											dataVerificadoresPCO = dataVerificadoresPCO & ","
										end if
									loop
									dataVerificadoresPCO=dataVerificadoresPCO & "]"								
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
				<form role="form" action="<%=action%>" method="POST" name="frm10s7" id="frm10s7" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s7" name="btn_frm10s7"><%=txtBoton%></button>
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
					<input type="hidden" id="Step" name="Step" value="<%=Step%>" />		
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
		
		$("#btn_frm10s7").click(function(){
			formValidate("#frm10s7")
			if($("#frm10s7").valid()){
				var min = 0;
				if(plnconTable.data().count()<min){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Debes ingresar al menos ' + min + ' plan(es) de contingencia antes de avanzar'							
					});
				}else{
				
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm10s7").attr("action"),
						data: $("#frm10s7").serialize(),
						success: function(data) {					
							param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Plan de contingencia grabado correctamente'
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
				}
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})

		//Primer tab
		var plncomTable;
		var dataVerificadoresPLC = <%=dataVerificadoresPLC%>		
		loadTableVerificadoresPLC(dataVerificadoresPLC);
        $('#tbl-plncom').css('width','100%')
		
		function loadTableVerificadoresPLC(data) {	
			$(".plancom").html(data.length);
			plncomTable = $('#tbl-plncom').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsPLC%>],
				order: [
					[0, 'asc']
				]			
			});						
		}

		$("#btn_frm10s7_1").click(function(){
			formValidate("#frm10s7_1")
			if($("#frm10s7_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm10s7_1").attr("action"),
					data: $("#frm10s7_1").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						plncomTable.clear().draw();
						plncomTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".plancom").html(plncomTable.data().count());
						if(param[0]=="200"){
							$("#frm10s7_1")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Plan comunicacional agregado correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del plan',					
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

		$("#pry-content").on("click",".delplncom",function(e){
			e.preventDefault();
			e.stopPropagation();
			var PLC_Id = $(this).data("plc"); 
			var PRY_Id = $(this).data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el plan comunicacional seleccionado",
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
						url: '/elimina-plan-comunicacional',
						data: {PRY_Id:PRY_Id, PLC_Id:PLC_Id},
						success: function(data) {					
							param=data.split(bb);
							plncomTable.clear().draw();
							plncomTable.rows.add(jQuery.parseJSON(param[1])).draw();	
							
							$(".plancom").html(plncomTable.data().count());
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Plan comunicacional eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos del plan comunicacional',					
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

		$("#pry-content").on("click",".doplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-comunicacional',
				data:{PLC_Id:PLC_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-archivosplncom");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:117, ALU_Rut:ALU_Rut,PLC_Id:PLC_Id};
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

		//Segundo tab
		var plnconTable;
		var dataVerificadoresPCO = <%=dataVerificadoresPCO%>		
		loadTableVerificadoresPCO(dataVerificadoresPCO);
        $('#tbl-plncon').css('width','100%')
		
		function loadTableVerificadoresPCO(data) {	
			$(".plancon").html(data.length);
			plnconTable = $('#tbl-plncon').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsPCO%>],
				order: [
					[0, 'asc']
				]			
			});						
		}

		$("#btn_frm10s7_2").click(function(){
			formValidate("#frm10s7_2")
			if($("#frm10s7_2").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm10s7_2").attr("action"),
					data: $("#frm10s7_2").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						plnconTable.clear().draw();
						plnconTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".plancon").html(plnconTable.data().count());
						if(param[0]=="200"){
							$("#frm10s7_2")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Plan de contingencia agregado correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del plan',					
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
		
		$("#pry-content").on("click",".delplncon",function(e){
			e.preventDefault();
			e.stopPropagation();
			var PCO_Id = $(this).data("pco"); 
			var PRY_Id = $(this).data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el plan de contingencia seleccionado",
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
						url: '/elimina-plan-de-contingencia',
						data: {PRY_Id:PRY_Id, PCO_Id:PCO_Id},
						success: function(data) {					
							param=data.split(bb);
							plnconTable.clear().draw();
							plnconTable.rows.add(jQuery.parseJSON(param[1])).draw();	
							
							$(".plancon").html(plnconTable.data().count());
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Plan de contingencia eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos del plan de contingencia',					
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
		
		$("#pry-content").on("click",".doplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-contngencia',
				data:{PCO_Id:PCO_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-archivosplncon");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:118, ALU_Rut:ALU_Rut,PCO_Id:PCO_Id};
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