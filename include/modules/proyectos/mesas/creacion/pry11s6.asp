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
		action="/mod-11-h0-s6"
		columnsSIN="{data: ""RPS_Id""},{data: ""RPS_Nombre""},{data: ""RPS_ApellidoPaterno""},{data: ""RPS_ApellidoMaterno""},{data: ""RUT""},{data: ""RPS_Cargo""},{data: ""Sexo""}" 		
		columnsEMP="{data: ""RPE_Id""},{data: ""RPE_Nombre""},{data: ""RPE_ApellidoPaterno""},{data: ""RPE_ApellidoMaterno""},{data: ""RUT""},{data: ""RPE_Cargo""},{data: ""Sexo""}" 		
		columnsGOB="{data: ""RPG_Id""},{data: ""RPG_Nombre""},{data: ""RPG_ApellidoPaterno""},{data: ""RPG_ApellidoMaterno""},{data: ""RUT""},{data: ""RPG_Cargo""},{data: ""Sexo""}" 		
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"

		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		columnsSIN="{data: ""RPS_Id""},{data: ""RPS_Nombre""},{data: ""RPS_ApellidoPaterno""},{data: ""RPS_ApellidoMaterno""},{data: ""RUT""},{data: ""RPS_Cargo""},{data: ""Sexo""}" 
		columnsEMP="{data: ""RPE_Id""},{data: ""RPE_Nombre""},{data: ""RPE_ApellidoPaterno""},{data: ""RPE_ApellidoMaterno""},{data: ""RUT""},{data: ""RPE_Cargo""},{data: ""Sexo""}" 		
		columnsGOB="{data: ""RPG_Id""},{data: ""RPG_Nombre""},{data: ""RPG_ApellidoPaterno""},{data: ""RPG_ApellidoMaterno""},{data: ""RUT""},{data: ""RPG_Cargo""},{data: ""Sexo""}" 		
	end if
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
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
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer("LIN_Mujer")
			PRY_TipoMesa=rs("PRY_TipoMesa")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")	
%>		
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Representantes</h5>
		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">				
				<div class="content-nav">
					<a id="gob1-tab" href="#sintab1" class="active tab"><i class="fas fa-users"></i> Representantes Sindicato 						
					</a>
					<a id="gob2-tab" href="#emptab2" class="tab"><i class="fas fa-industry"></i> Representantes Empresa 						
					</a><%
					if PRY_TipoMesa=2 then		'Tripartita%>
						<a id="gob3-tab" href="#gobtab3" class="tab"><i class="fas fa-university"></i> Representantes Gobierno 							
						</a><%
					end if%>
					<span class="yellow-bar"></span>				
					<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
						<div class="animated-icon1"><span></span><span></span><span></span></div>
					</button>
				</div>				
			</div>
			<div class="tab-content">
				<!--sintab1-->
				<div id="sintab1"><%
					set rz = cnn.execute("spProyectoSindicato_Listar " & PRY_Id & ", -1")					
					on error resume next
					if cnn.Errors.Count > 0 then 
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close
					   response.Write("503/@/Error Conexión:" & ErrMsg)
					   response.End() 			   
					end if
					x=0
					do while not rz.eof
						x=x+1
						SINREP_Id=rz("SIN_Id")					
						existe=1

						set rx = cnn.Execute("exec spSindicato_Consultar " & SINREP_Id)		
						on error resume next
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close
						   response.Write("503/@/Error Conexión:" & ErrMsg)
						   response.End() 			   
						end if
						if not rx.eof then
							SINREP_Nombre = rx("SIN_Nombre")
						end if
						if x>0 then%>				
							<h5><%=x%>.- <%=SINREP_Nombre%></h5><%							
						end if%>									
						<h6 style="padding-bottom:20px;">Representantes del Sindicato</h6>
						<table id="tbl-repsind_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repsind" data-id="repsind" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>
									<th>Apellido Paterno</th>
									<th>Apellido Materno</th>
									<th>Rut</th>
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>					
							<tbody><%
								set rs = cnn.execute("spRepProyectoSindicato_Listar 1, " & PRY_Id & "," & rz("SIN_Id"))
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description
									'response.write ErrMsg & " strig= " & sq			
									cnn.close 			   
									Response.end()
								End If
								dataSindicales = "["
								do While Not rs.EOF									
									dataSindicales = dataSindicales & "{""RPS_Id"":""" & rs("RPS_Id") & """,""RPS_Nombre"":""" & rs("RPS_Nombre") & """,""RPS_ApellidoPaterno"":""" & rs("RPS_ApellidoPaterno") & """,""RPS_ApellidoMaterno"":""" & rs("RPS_ApellidoMaterno") & """,""RUT"":""" & rs("RPS_Rut") & "-" & rs("RPS_DV") & """,""RPS_Cargo"":""" & rs("RPS_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

									dataSindicales = dataSindicales & "}"											
									rs.movenext
									if not rs.eof then
										dataSindicales = dataSindicales & ","
									end if									
								loop
								dataSindicales=dataSindicales & "]"
								dataSindicalesArray=dataSindicalesArray & dataSindicales & ","
								rs.close%>                	
							</tbody>
						</table><%
						rz.movenext
					loop
					MaxSin = x
					dataSindicalesArray = "[" & dataSindicalesArray & "]"
					if MaxSin = 0 then
						MaxSin=1%>
						<h5>Sindicato sin representantes</h5>
						<h6 style="padding-bottom:20px;">Representantes del Sindicato</h6>
						<table id="tbl-repsind_1" class="ts table table-striped table-bordered dataTable table-sm tbl-repsind" data-id="repsind" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>
									<th>Apellido Paterno</th>
									<th>Apellido Materno</th>
									<th>Rut</th>
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>
							<tbody>
							</tbody>
						</table><%
					end if%>
				</div>
				<!--sintab1-->				
				<!--emptab2-->
				<div id="emptab2">	<%'Organizaciones Empresariales
					x=0
					set rz = cnn.execute("spProyectoEmpresa_Listar " & PRY_Id & ", -1")					
					on error resume next
					if cnn.Errors.Count > 0 then 
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close
					   response.Write("503/@/Error Conexión:" & ErrMsg)
					   response.End() 			   
					end if
					do while not rz.eof
						x=x+1
						EMPREP_Id=rz("EMP_Id")					
						existe=1

						set rx = cnn.Execute("exec spEmpresa_Consultar " & EMPREP_Id)		
						on error resume next
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close
						   response.Write("503/@/Error Conexión:" & ErrMsg)
						   response.End() 			   
						end if
						if not rx.eof then
							EMPREP_Nombre = rx("EMP_Nombre")
						end if
						if x>0 then%>				
							<h5><%=x%>.- <%=EMPREP_Nombre%></h5><%							
						end if%>									
						<h6 style="padding-bottom:20px;">Representantes de la Empresa</h6>
						<table id="tbl-repemp_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repemp" data-id="repemp" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>
									<th>Apellido Paterno</th>
									<th>Apellido Materno</th>
									<th>Rut</th>
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>					
							<tbody><%
								set rs = cnn.execute("spRepProyectoEmpresa_Listar 1, " & PRY_Id & "," & rz("EMP_Id"))
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description
									'response.write ErrMsg & " strig= " & sq			
									cnn.close 			   
									Response.end()
								End If
								dataEmpresariales = "["
								do While Not rs.EOF									
									dataEmpresariales = dataEmpresariales & "{""RPE_Id"":""" & rs("RPE_Id") & """,""RPE_Nombre"":""" & rs("RPE_Nombre") & """,""RPE_ApellidoPaterno"":""" & rs("RPE_ApellidoPaterno") & """,""RPE_ApellidoMaterno"":""" & rs("RPE_ApellidoMaterno") & """,""RUT"":""" & rs("RPE_Rut") & "-" & rs("RPE_DV") & """,""RPE_Cargo"":""" & rs("RPE_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

									dataEmpresariales = dataEmpresariales & "}"											
									rs.movenext
									if not rs.eof then
										dataEmpresariales = dataEmpresariales & ","
									end if									
								loop
								dataEmpresariales=dataEmpresariales & "]"
								dataEmpresarialesArray=dataEmpresarialesArray & dataEmpresariales & ","
								rs.close%>                	
							</tbody>
						</table><%
						rz.movenext
					loop
					MaxEmp = x
					dataEmpresarialesArray = "[" & dataEmpresarialesArray & "]"
					if MaxEmp = 0 then
						MaxEmp=1%>
						<h5>Empresa sin representantes</h5>
						<h6 style="padding-bottom:20px;">Representantes de la Empresa</h6>
						<table id="tbl-repemp_1" class="ts table table-striped table-bordered dataTable table-sm tbl-repemp" data-id="repemp" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>
									<th>Apellido Paterno</th>
									<th>Apellido Materno</th>
									<th>Rut</th>
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>
							<tbody>
							</tbody>
						</table><%
					end if%>
				</div>
				<!--emptab2--><%				
				if PRY_TipoMesa=2 then		'Tripartita%>
					<div id="gobtab3"><%'Organizaciones de gobierno
						x=0
						set rz = cnn.execute("spProyectoServicio_Listar " & PRY_Id & ", -1")					
						on error resume next
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close
						   response.Write("503/@/Error Conexión:" & ErrMsg)
						   response.End() 			   
						end if
						do while not rz.eof
							x=x+1
							GOBREP_Id=rz("SER_Id")					
							existe=1

							set rx = cnn.Execute("exec spServicio_Consultar " & GOBREP_Id & ",-1")		
							on error resume next
							if cnn.Errors.Count > 0 then 
							   ErrMsg = cnn.Errors(0).description	   
							   cnn.close
							   response.Write("503/@/Error Conexión:" & ErrMsg)
							   response.End() 			   
							end if
							if not rx.eof then
								GOBREP_Nombre = rx("SER_Nombre")
							end if
							set ry = cnn.Execute("exec spJustificacionGobSer_Consultar -1, " & GOBREP_Id & "," & PRY_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
							   ErrMsg = cnn.Errors(0).description	   
							   cnn.close
							   response.Write("503/@/Error Conexión:" & ErrMsg)
							   response.End() 			   
							end if
							if not ry.eof then
								JGS_Justificacion=ry("JGS_Justificacion")
							end if														
							if x>0 then%>				
								<h5><%=x%>.- <%=GOBREP_Nombre%></h5><%							
							end if%>									
							<h6 style="padding-bottom:20px;">Representantes del Servicio</h6>
							<table id="tbl-repgob_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repgob" data-id="repgob" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">#</th>
										<th>Nombre</th>
										<th>Apellido Paterno</th>
										<th>Apellido Materno</th>
										<th>Rut</th>
										<th>Cargo</th>
										<th>Sexo</th>
									</tr> 
								</thead>					
								<tbody><%
									set rs = cnn.execute("spRepProyectoGobierno_Listar 1, " & PRY_Id & "," & rz("SER_Id"))
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataGobierno = "["
									do While Not rs.EOF									
										dataGobierno = dataGobierno & "{""RPG_Id"":""" & rs("RPG_Id") & """,""RPG_Nombre"":""" & rs("RPG_Nombre") & """,""RPG_ApellidoPaterno"":""" & rs("RPG_ApellidoPaterno") & """,""RPG_ApellidoMaterno"":""" & rs("RPG_ApellidoMaterno") & """,""RUT"":""" & rs("RPG_Rut") & "-" & rs("RPG_DV") & """,""RPG_Cargo"":""" & rs("RPG_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

										dataGobierno = dataGobierno & "}"											
										rs.movenext
										if not rs.eof then
											dataGobierno = dataGobierno & ","
										end if									
									loop
									dataGobierno=dataGobierno & "]"	
									dataGobiernoArray=dataGobiernoArray & dataGobierno & ","
									rs.close%>                	
								</tbody>
							</table><%
							rz.movenext
						loop
						MaxGob = x
						dataGobiernoArray = "[" & dataGobiernoArray & "]"
						if MaxGob = 0 then
							MaxGob=1%>
							<h5>Servicio sin representantes</h5>
							<h6 style="padding-bottom:20px;">Representantes del Servicio</h6>
							<table id="tbl-repgob_1" class="ts table table-striped table-bordered dataTable table-sm tbl-repgob" data-id="repgob" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">#</th>
										<th>Nombre</th>
										<th>Apellido Paterno</th>
										<th>Apellido Materno</th>
										<th>Rut</th>
										<th>Cargo</th>
										<th>Sexo</th>
									</tr> 
								</thead>
								<tbody>
								</tbody>
							</table><%
						end if%>
					</div><%
				else
					MaxGob = 0
					dataGobiernoArray = "[]"
				end if%>
				</div>
				<!--tab-content-->
		</div>
		<!--conatiner-nav-->
	</div>
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm10s6" id="frm10s6" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s6" name="btn_frm10s6"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="6">
					<input type="hidden" id="PRY_Hito" value="0" name="PRY_Hito">
					<input type="hidden" id="PRY_TipoMesa" value="<%=PRY_TipoMesa%>" name="PRY_TipoMesa">
					
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
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});		
		
		$("#btn_frm10s6_1").click(function(){
			
		})				
		
		var dataSindicalesArray = [];
		var tableSin;
		dataSindicalesArray = <%=dataSindicalesArray%>		
		
		for(i=1;i<=<%=MaxSin%>;i++){
			tableSin = '#tbl-repsind_' + i
			loadTableSindicales(dataSindicalesArray[i-1],tableSin);
        	$(tableSin).css('width','100%')
		}
		
		function loadTableSindicales(data,table) {			
			$(table).DataTable({				
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
		
		var dataEmpresarialesArray = [];
		var tableEmp;
		dataEmpresarialesArray = <%=dataEmpresarialesArray%>		
		
		for(i=1;i<=<%=MaxEmp%>;i++){
			tableEmp = '#tbl-repemp_' + i
			loadTableEmpresariales(dataEmpresarialesArray[i-1],tableEmp);
        	$(tableEmp).css('width','100%')
		}
		
		function loadTableEmpresariales(data,table) {				
			$(table).DataTable({				
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
		
		$("#btn_frm10s6_2").click(function(){
			
		})		
		
		var TipoMesa = <%=PRY_TipoMesa%>;		
		if(TipoMesa==2){
			var dataGobiernoArray = [];
			var tableGob;
			dataGobiernoArray = <%=dataGobiernoArray%>			
			for(i=1;i<=<%=MaxGob%>;i++){
				tableGob = '#tbl-repgob_' + i
				loadTableGobierno(dataGobiernoArray[i-1],tableGob);
				$(tableGob).css('width','100%')
			}

			function loadTableGobierno(data,table) {		
				$(table).DataTable({				
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
		}
								
		$("#btn_frm10s6").click(function(){
			formValidate("#frm10s6")
			if($("#frm10s6").valid()){
				var valido=false;
				if($("#PRY_TipoMesa").val()==2){
					if(dataSindicalesArray.length>0 && dataEmpresarialesArray.length>0 && dataGobiernoArray.length>0){
						valido=true;
					}
				}else{
					if(dataSindicalesArray.length>0 && dataEmpresarialesArray.length>0){
						valido=true;
					}
				}				
				if(valido){
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm10s6").attr("action"),
						data: $("#frm10s6").serialize(),
						success: function(data) {					
							param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Representantes grabados correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
								$.ajax( {
									type:'POST',					
									url: '/mnu-11',
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
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Datos faltantes',
						text:'Debes ingresar al menos un representante por cada agrupación antes de avanzar'
					});
				}
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
		
	});
</script>