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
		action="/mod-14-h0-s5"
		columnsSIN="{data: ""SIN_Id""},{data: ""SIN_Nombre""},{data: ""ACE_Nombre""},{data: ""RUB_Nombre""},{data: ""PAT_Compromiso""},{data: ""PAT_VerificadorCumplimiento""},{className: 'delsin',orderable: false,data: ""Del""}"
		columnsEMP="{data: ""EMP_Id""},{data: ""EMP_Nombre""},{data: ""RUB_Nombre""},{data: ""PEM_Compromiso""},{data: ""PEM_VerificadorCumplimiento""},{className: 'delemp',orderable: false,data: ""Del""}"
		columnsGOB="{data: ""SER_Id""},{data: ""SER_Nombre""},{data: ""PGO_Compromiso""},{data: ""PGO_VerificadorCumplimiento""},{className: 'delpgo',orderable: false,data: ""Del""}"
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"

		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		columnsSIN="{data: ""SIN_Id""},{data: ""SIN_Nombre""},{data: ""ACE_Nombre""},{data: ""RUB_Nombre""},{data: ""PAT_Compromiso""},{data: ""PAT_VerificadorCumplimiento""},"
		columnsEMP="{data: ""EMP_Id""},{data: ""EMP_Nombre""},{data: ""RUB_Nombre""},{data: ""PEM_Compromiso""},{data: ""PEM_VerificadorCumplimiento""}"
		columnsGOB="{data: ""SER_Id""},{data: ""SER_Nombre""},{data: ""PGO_Compromiso""},{data: ""PGO_VerificadorCumplimiento""}"
	end if
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		mode="vis"
		modo=4
		disabled="readonly disabled"		
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
			PRY_TipoMesa=rs("PRY_TipoMesa")	
			PRY_Carpeta=rs("PRY_Carpeta")
			PRY_Carpeta=Replace(PRY_Carpeta, "{", "") 
			PRY_Carpeta=Replace(PRY_Carpeta, "}", "")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
		if(PRY_TipoMesa="") then
			PRY_TipoMesa=0
		end if	
	end if			
	rs.close
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	response.write("200/@/")	
%>
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Redes de Apoyo</h5>		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">
				<div class="content-nav">
					<a id="org1-tab" href="#sintab1" class="active tab"><i class="fas fa-users"></i> Organizaciones Sindicales 
						<span class="badge right blue badgesin">0</span>
					</a>
					<a id="org2-tab" href="#emptab2" class="tab"><i class="fas fa-industry"></i> Organizaciones Empresariales 
						<span class="badge right blue badgeemp">0</span>
					</a><%
					if(PRY_TipoMesa=2) then%>
						<a id="org3-tab" href="#gobtab3" class="tab"><i class="fas fa-university"></i> Organizaciones de Gobierno 
							<span class="badge right blue badgegob">0</span>
						</a><%
					end if%>
					<span class="yellow-bar"></span>					
				</div>				
			</div>
			<div class="tab-content">
				<div id="sintab1">	<%'Organizaciones Sindicales
					if(mode="mod") then%>
						<form role="form" action="/agregar-sindicato" method="POST" name="frm14s5_1" id="frm14s5_1" class="needs-validation">
							<div class="row">                                                                         
								<div class="col-sm-5 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="SIN_Id" id="SIN_Id" class="validate select-text form-control" <%=disabled%>>
													
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label">Organización Sindical</label>
											</div>
										</div>
									</div>							
								</div>
								<div class="col-sm-6 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">					
											<i class="fas fa-tasks prefix"></i>
											<textarea id="PAT_Compromiso" name="PAT_Compromiso" class="md-textarea form-control" rows="5" required=""></textarea>
											<span class="select-bar"></span>
											<label for="PAT_Compromiso" class="active">Compromiso</label>							
										</div>
									</div>							
								</div>
								<div class="col-sm-1 col-md-1 col-lg-1" style="padding-top: 23px;text-align:left;">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm14s5_1" name="btn_frm14s5_1"><i class="fas fa-plus"></i></button>	
								</div>						
							</div>	
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">							
						</form><%
					end if%>
					
					<table id="tbl-orgsind" class="ts table table-striped table-bordered dataTable table-sm" data-id="orgsind" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">Id</th>
								<th>Organización Sindical</th>
								<th>Afilición Central</th> 
								<th>Rubro</th>
								<th>Compromiso</th>
								<th>Verificador</th><%
								if(mode="mod") then%>
									<th>Eliminar</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody> 
						<%
							set rs=cnn.execute("spPatrocinio_Listar " & PRY_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								Response.end()
							End If
							dataSindicales = "["
							do While Not rs.EOF
								SIN_Id=rs("SIN_Id")
								if len(SIN_Id)>1 then
									ySIN_Id=""
									for i=0 to len(SIN_Id)
										if(isnumeric(mid(SIN_Id,i,1))) then
											ySIN_Id=ySIN_Id & mid(SIN_Id,i,1)
										end if
									next
								else
									ySIN_Id=cint(SIN_Id)
								end if
								path="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\verificadorsindicato\s-" & ySIN_Id								
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
									clasedown="doverpat"
									disableddown="pointer"															
								else						
									colordown="text-white-50"
									clasedown=""
									disableddown="not-allowed"														
								end if
								data = "data-id='" & rs("SIN_Id") & "' data-pry='" & PRY_Id & "' data-tip='SIN' data-hito='112'"
								if(mode="mod") then
									dataSindicales = dataSindicales & "{""SIN_Id"":""" & rs("SIN_Id") & """,""SIN_Nombre"":""" & rs("SIN_Nombre")  & """,""ACE_Nombre"":""" & rs("ACE_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""PAT_Compromiso"":""" & rs("PAT_Compromiso") & """,""PAT_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-sin='" & rs("SIN_Id") & "' data-pry='" & PRY_Id & "'></i>"""
								else
									dataSindicales = dataSindicales & "{""SIN_Id"":""" & rs("SIN_Id") & """,""SIN_Nombre"":""" & rs("SIN_Nombre")  & """,""ACE_Nombre"":""" & rs("ACE_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""PAT_Compromiso"":""" & rs("PAT_Compromiso") & """,""PAT_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
								end if
								dataSindicales = dataSindicales & "}"											
								rs.movenext
								if not rs.eof then
									dataSindicales = dataSindicales & ","
								end if
							loop							
							dataSindicales=dataSindicales & "]"
							rs.close							
						%>                	
						</tbody>
					</table>
				</div>				
				<div id="emptab2">	<%'Organizaciones Empresariales
					if(mode="mod") then%>
						<form role="form" action="/agregar-empresa" method="POST" name="frm14s5_2" id="frm14s5_2" class="needs-validation">				
							<div class="row">                                                                         
								<div class="col-sm-5 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="EMP_Id" id="EMP_Id" class="validate select-text form-control" <%=disabled%>>
													
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label">Organización Empresarial</label>
											</div>
										</div>
									</div>							
								</div>
								<div class="col-sm-6 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">					
											<i class="fas fa-tasks prefix"></i>
											<textarea id="PEM_Compromiso" name="PEM_Compromiso" class="md-textarea form-control" rows="5" required=""></textarea>
											<span class="select-bar"></span>
											<label for="PEM_Compromiso" class="active">Compromiso</label>							
										</div>
									</div>							
								</div>
								<div class="col-sm-1 col-md-1 col-lg-1" style="padding-top: 23px;text-align:left;">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm14s5_2" name="btn_frm14s5_2"><i class="fas fa-plus"></i></button>	
								</div>						
							</div>	
							<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
						</form><%
					end if%>
					
					<table id="tbl-orgsemp" class="ts table table-striped table-bordered dataTable table-sm" data-id="orgsemp" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">Id</th>
								<th>Organización Empresarial</th>								 
								<th>Rubro</th>
								<th>Compromiso</th>
								<th>Verificador</th><%
								if(mode="mod") then%>
									<th>Eliminar</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody> 
						<%
							set rs=cnn.execute("spPatrocinioEmpresa_Listar " & PRY_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								Response.end()
							End If
							dataEmpresariales = "["
							do While Not rs.EOF
								EMP_Id=rs("EMP_Id")
								if len(EMP_Id)>1 then
									yEMP_Id=""
									for i=0 to len(EMP_Id)
										if(isnumeric(mid(EMP_Id,i,1))) then
											yEMP_Id=yEMP_Id & mid(EMP_Id,i,1)
										end if
									next
								else
									yEMP_Id=cint(EMP_Id)
								end if
								path="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\verificadorempresa\e-" & yEMP_Id
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
									clasedown="doverpat"
									disableddown="pointer"															
								else						
									colordown="text-white-50"
									clasedown=""
									disableddown="not-allowed"														
								end if
								data = "data-id='" & rs("EMP_Id") & "' data-pry='" & PRY_Id & "' data-tip='EMP' data-hito='114'"
								if(mode="mod") then
									dataEmpresariales = dataEmpresariales & "{""EMP_Id"":""" & rs("EMP_Id") & """,""EMP_Nombre"":""" & rs("EMP_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""PEM_Compromiso"":""" & rs("PEM_Compromiso") & """,""PEM_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-emp='" & rs("EMP_Id") & "' data-pry='" & PRY_Id & "'></i>"""
								else
									dataEmpresariales = dataEmpresariales & "{""EMP_Id"":""" & rs("EMP_Id") & """,""EMP_Nombre"":""" & rs("EMP_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""PEM_Compromiso"":""" & rs("PEM_Compromiso") & """,""PEM_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
								end if
								dataEmpresariales = dataEmpresariales & "}"											
								rs.movenext
								if not rs.eof then
									dataEmpresariales = dataEmpresariales & ","
								end if
							loop														
							dataEmpresariales=dataEmpresariales & "]"							
							rs.close							
						%>                	
						</tbody>
					</table>
				</div><%
				if(PRY_TipoMesa=2) then%>				
					<div id="gobtab3">	<%'Organizaciones de Gobierno
						if(mode="mod") then%>
							<form role="form" action="/agregar-gobierno" method="POST" name="frm14s5_3" id="frm14s5_3" class="needs-validation">				
								<div class="row">                                                                         
									<div class="col-sm-5 col-md-5 col-lg-5">
										<div class="md-form input-with-post-icon">
											<div class="error-message">
												<div class="select">
													<select name="SER_Id" id="SER_Id" class="validate select-text form-control" <%=disabled%>>

													</select>
													<i class="fas fa-map-marker-alt input-prefix"></i>
													<span class="select-highlight"></span>
													<span class="select-bar"></span>
													<label class="select-label">Organizaciones de Gobierno</label>
												</div>
											</div>
										</div>							
									</div>
									<div class="col-sm-6 col-md-6 col-lg-6">
										<div class="md-form input-with-post-icon">
											<div class="error-message">					
												<i class="fas fa-tasks prefix"></i>
												<textarea id="PGO_Compromiso" name="PGO_Compromiso" class="md-textarea form-control" rows="5" required=""></textarea>
												<span class="select-bar"></span>
												<label for="PGO_Compromiso" class="active">Compromiso</label>							
											</div>
										</div>							
									</div>
									<div class="col-sm-1 col-md-1 col-lg-1" style="padding-top: 23px;text-align:left;">
										<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm14s5_3" name="btn_frm14s5_3"><i class="fas fa-plus"></i></button>	
									</div>						
								</div>	
								<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
							</form><%
						end if%>
						
						<table id="tbl-orgsgob" class="ts table table-striped table-bordered dataTable table-sm" data-id="orgsgob" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">Id</th>
									<th>Organización de Gobierno</th>								
									<th>Compromiso</th>
									<th>Verificador</th><%
									if(mode="mod") then%>
										<th>Eliminar</th><%
									end if%>
								</tr> 
							</thead>					
							<tbody> 
							<%
								set rs=cnn.execute("spPatrocinioGobierno_Listar " & PRY_Id)
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description
									'response.write ErrMsg & " strig= " & sq			
									cnn.close 			   
									Response.end()
								End If
								dataGobierno = "["
								do While Not rs.EOF
									SER_Id=rs("SER_Id")
									if len(SER_Id)>1 then
										ySER_Id=""
										for i=0 to len(SER_Id)
											if(isnumeric(mid(SER_Id,i,1))) then
												ySER_Id=ySER_Id & mid(SER_Id,i,1)
											end if
										next
									else
										ySER_Id=cint(SER_Id)
									end if
									path="D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\verificadorgobierno\g-" & ySER_Id
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
										clasedown="doverpat"
										disableddown="pointer"															
									else						
										colordown="text-white-50"
										clasedown=""
										disableddown="not-allowed"														
									end if
									data = "data-id='" & rs("SER_Id") & "' data-pry='" & PRY_Id & "' data-tip='PGO' data-hito='115'"
									if(mode="mod") then								
										dataGobierno = dataGobierno & "{""SER_Id"":""" & rs("SER_Id") & """,""SER_Nombre"":""" & rs("SER_Nombre") & """,""PGO_Compromiso"":""" & rs("PGO_Compromiso") & """,""PGO_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt text-danger' data-ser='" & rs("SER_Id") & "' data-pry='" & PRY_Id & "'></i>"""
									else
										dataGobierno = dataGobierno & "{""SER_Id"":""" & rs("SER_Id") & """,""SER_Nombre"":""" & rs("SER_Nombre") & """,""PGO_Compromiso"":""" & rs("PGO_Compromiso") & """,""PGO_VerificadorCumplimiento"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"""
									end if
									dataGobierno = dataGobierno & "}"											
									rs.movenext
									if not rs.eof then
										dataGobierno = dataGobierno & ","
									end if
								loop							
								dataGobierno=dataGobierno & "]"							
								rs.close
							%>                	
							</tbody>
						</table>						
					</div><%
				end if%>
			</div>
			<!--tab-content-->			
		</div>
		<!--conatiner-nav-->
	</div>
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm14s5" id="frm14s5" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm14s5" name="btn_frm14s5"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="5">
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
		var mode = '<%=mode%>'
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
		if(mode=='mod'){
			loadSindicales();
		}
		
		$("#btn_frm14s5_1").click(function(){
			formValidate("#frm14s5_1")
			if($("#frm14s5_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm14s5_1").attr("action"),
					data: $("#frm14s5_1").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						sindicalesTable.clear().draw();
						sindicalesTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".badgesin").html(sindicalesTable.data().count());
						loadSindicales();
						if(param[0]=="200"){
							$("#PAT_Compromiso").val("");
							Toast.fire({
							  icon: 'success',
							  title: 'Organización Sindical agregada correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del Sindicato',					
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
		
		$("#pry-content").on("click",".delsin",function(e){
			e.preventDefault();
			e.stopPropagation();
			var SIN_Id = $(this).children().data("sin"); 
			var PRY_Id = $(this).children().data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará la organización sindical seleccionda",
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
						url: '/elimina-sindicato',
						data: {PRY_Id:PRY_Id, SIN_Id:SIN_Id},
						success: function(data) {					
							param=data.split(bb);

							sindicalesTable.clear().draw();
							sindicalesTable.rows.add(jQuery.parseJSON(param[1])).draw();
							
							$(".badgesin").html(sindicalesTable.data().count());
							loadSindicales();
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Organización Sindical eliminada correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos del Sindicato',					
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
		var sindicalesTable;
		var dataSindicales = <%=dataSindicales%>
		loadTableSindicales(dataSindicales);
        $('#tbl-orgsind').css('width','100%')
		
		function loadTableSindicales(data) {
			$(".badgesin").html(data.length);
			sindicalesTable = $('#tbl-orgsind').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsSIN%>],
				order: [
					[0, 'asc']
				]			
			});						
		}				
		
		function loadSindicales(){
			$.ajax({
				type: 'POST',			
				url: '/listar-sindicato-sin-patrocinio',
				data: {PRY_Id:$("#PRY_Id").val()},
				success: function(data) {					
					param=data.split(bb);									
					if(param[0]=="200"){
						$("#SIN_Id").html(param[1]);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar los Sindicato',					
							text:param[1]
						});
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, error al cargar archivo'							
					});
				}
			});
		}
		
		if(mode=='mod'){
			loadEmpresariales();
		}
		
		var empresarialesTable;
		var dataEmpresariales = <%=dataEmpresariales%>
		loadTableEmpresariales(dataEmpresariales);
        $('#tbl-orgsemp').css('width','100%')
		
		function loadTableEmpresariales(data) {
			$(".badgeemp").html(data.length);
			empresarialesTable = $('#tbl-orgsemp').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsEMP%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		function loadEmpresariales(){
			$.ajax({
				type: 'POST',			
				url: '/listar-empresa-sin-patrocinio',
				data: {PRY_Id:$("#PRY_Id").val()},
				success: function(data) {					
					param=data.split(bb);									
					if(param[0]=="200"){
						$("#EMP_Id").html(param[1]);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar las Empresas',					
							text:param[1]
						});
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, error al cargar archivo'							
					});
				}
			});
		}
		
		$("#btn_frm14s5_2").click(function(){
			formValidate("#frm14s5_2")
			if($("#frm14s5_2").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm14s5_2").attr("action"),
					data: $("#frm14s5_2").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						empresarialesTable.clear().draw();
						empresarialesTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".badgeemp").html(empresarialesTable.data().count());
						loadEmpresariales();
						if(param[0]=="200"){
							$("#PEM_Compromiso").val("");
							Toast.fire({
							  icon: 'success',
							  title: 'Organización Empresarial agregada correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos de la empresa',					
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
		
		$("#pry-content").on("click",".delemp",function(e){
			e.preventDefault();
			e.stopPropagation();
			var EMP_Id = $(this).children().data("emp"); 
			var PRY_Id = $(this).children().data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará la organización empresarial seleccionda",
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
						url: '/elimina-empresa',
						data: {PRY_Id:PRY_Id, EMP_Id:EMP_Id},
						success: function(data) {					
							param=data.split(bb);

							empresarialesTable.clear().draw();
							empresarialesTable.rows.add(jQuery.parseJSON(param[1])).draw();
							
							$(".badgeemp").html(empresarialesTable.data().count());
							loadEmpresariales();
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Organización Empresarial eliminada correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos de la empresas',					
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
		
		var TipoMesa = <%=PRY_TipoMesa%>;
		if(mode=='mod' && TipoMesa==2){
			loadGobierno();
		}

		if(TipoMesa==2){
			var gobiernoTable;
			var dataGobierno = <%=dataGobierno%>
			loadTableGobierno(dataGobierno);
			$('#tbl-orggob').css('width','100%')
		}

        $('#tbl-orgsgob').css('width','100%')
		
		function loadTableGobierno(data) {			
			$(".badgegob").html(data.length);
			gobiernoTable = $('#tbl-orgsgob').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsGOB%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		function loadGobierno(){
			$.ajax({
				type: 'POST',			
				url: '/listar-gobierno-sin-patrocinio',
				data: {PRY_Id:$("#PRY_Id").val()},
				success: function(data) {					
					param=data.split(bb);									
					if(param[0]=="200"){
						$("#SER_Id").html(param[1]);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar las Org. de Gobierno',					
							text:param[1]
						});
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, error al cargar archivo'							
					});
				}
			});
		}
		
		$("#btn_frm14s5_3").click(function(){
			formValidate("#frm14s5_3")
			if($("#frm14s5_3").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm14s5_3").attr("action"),
					data: $("#frm14s5_3").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						gobiernoTable.clear().draw();
						gobiernoTable.rows.add(jQuery.parseJSON(param[1])).draw();
						
						$(".badgegob").html(gobiernoTable.data().count());
						loadGobierno();
						if(param[0]=="200"){
							$("#PGO_Compromiso").val("");
							Toast.fire({
							  icon: 'success',
							  title: 'Organización de Gobierno agregada correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos de la org. de gobierno',					
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
		
		$("#pry-content").on("click",".delpgo",function(e){
			e.preventDefault();
			e.stopPropagation();
			var SER_Id = $(this).children().data("ser"); 
			var PRY_Id = $(this).children().data("pry");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará la organización de gobierno seleccionda",
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
						url: '/elimina-gobierno',
						data: {PRY_Id:PRY_Id, SER_Id:SER_Id},
						success: function(data) {					
							param=data.split(bb);

							gobiernoTable.clear().draw();
							gobiernoTable.rows.add(jQuery.parseJSON(param[1])).draw();
							$(".badgegob").html(gobiernoTable.data().count());
							loadGobierno();
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Organización de Gobierno eliminada correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos de la org. de gobierno',
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
								
		$("#btn_frm14s5").click(function(){
			formValidate("#frm14s5")
			if($("#frm14s5").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm14s5").attr("action"),
					data: $("#frm14s5").serialize(),
					success: function(data) {					
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Redes de Apoyo grabadas correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
							$.ajax( {
								type:'POST',					
								url: '/mnu-14',
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
		
		$("#pry-content").on("click",".doverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id")	
			var PAT_Tipo = $(this).data("tip")
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-patrocinios',			
				data:{PAT_Id:PAT_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PAT_Tipo:PAT_Tipo},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,PAT_Id:PAT_Id};
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