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
		action="/mod-10-h1-s2"
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
			PRY_Responsable1=rs("PRY_Responsable1")
			PRY_Responsable1Mail=rs("PRY_Responsable1Mail")			
			PRY_Responsable1Celular=rs("PRY_Responsable1Celular")
			SEX_IdResponsable1=rs("SEX_IdResponsable1")
			
			PRY_Responsable2=rs("PRY_Responsable2")
			PRY_Responsable2Mail=rs("PRY_Responsable2Mail")
			PRY_Responsable2Celular=rs("PRY_Responsable2Celular")
			SEX_IdResponsable2=rs("SEX_IdResponsable2")
			RES2_Adjunto=rs("RES2_Adjunto")
			RES1_Adjunto=rs("RES1_Adjunto")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm10s2" id="frm10s2" class="needs-validation">
	<h5>Responsables de Rendición</h5>
	<h6>Responsable Nro 1</h6>
	<div class="row align-items-center"> 
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_Responsable1" name="PRY_Responsable1" class="form-control" <%=disabled%> value="<%=PRY_Responsable1%>"><%
					else%>
						<input type="text" id="PRY_Responsable1" name="PRY_Responsable1" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable1<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable1" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_Responsable1Mail" name="PRY_Responsable1Mail" class="form-control" <%=disabled%> value="<%=PRY_Responsable1Mail%>"><%
					else%>
						<input type="email" id="PRY_Responsable1Mail" name="PRY_Responsable1Mail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable1Mail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable1Mail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: center;">			
			<label for="SEX_IdResponsable1" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdResponsable1=1) or (IsNULL(SEX_IdResponsable1)) then%>
					<input id="SEX_IdResponsable1femenino" type="radio" name="SEX_IdResponsable1" checked value="1" <%=checkbox%>><%
				else%>
					<input id="SEX_IdResponsable1femenino" type="radio" name="SEX_IdResponsable1" value="1" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdResponsable1femenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdResponsable1=2) then%>
					<input id="SEX_IdResponsable1masculino" type="radio" name="SEX_IdResponsable1" checked value="2" <%=checkbox%>><%
				else%>
					<input id="SEX_IdResponsable1masculino" type="radio" name="SEX_IdResponsable1" value="2" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdResponsable1masculino">Masculino</label>
			</div>			
		</div>
	</div>
	
	<div class="row align-items-center" style="padding-bottom:30px;"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_Responsable1Celular" name="PRY_Responsable1Celular" class="form-control" <%=disabled%> value="<%=PRY_Responsable1Celular%>"><%
					else%>
						<input type="number" id="PRY_Responsable1Celular" name="PRY_Responsable1Celular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable1Celular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable1Celular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>			
		<div class="col-sm-12 col-md-9 col-lg-9" id="">
			<div class="md-form input-with-post-icon">
				<div class="error-message">														
					<i class="fas fa-cloud-upload-alt input-prefix"></i>
					<input type="text" id="RES1_AdjuntoX" name="RES1_AdjuntoX" class="form-control" <%=disabled%> readonly value="<%=RES1_Adjunto%>">
					<input type="file" id="RES1_Adjunto" name="RES1_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">										
					<span class="select-bar"></span><%
					if(RES1_Adjunto<>"") then
						classdown="text-primary arcadj"
						styledown="cursor:pointer; pointer-events: all !important;"
						data = "data-pry='" & PRY_Id & "'" & " data-arc='" & RES1_Adjunto & "'" & " data-token='" & PRY_Identificador & "'" & " data-hito='124'"%>
						<label for="RES1_AdjuntoX" class="active">Adjunto</label><%
					else
						classdown="disabled text-white-50"
						styledown="cursor:not-allowed; pointer-events: all !important;"
						data=""%>
						<label for="RES1_AdjuntoX" class="">Adjunto</label><%
					end if%>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-1 col-lg-1" id="">
			<i class="fas fa-cloud-download-alt fa-3x <%=classdown%>" title="Bajar adjunto" style="<%=styledown%>" id="RES1_AdjuntoDownload" <%=data%>></i>
		</div>
	</div>
	
	
	<h6>Responsable Nro 2</h6>
	<div class="row">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_Responsable2" name="PRY_Responsable2" class="form-control" <%=disabled%> value="<%=PRY_Responsable2%>"><%
					else%>
						<input type="text" id="PRY_Responsable2" name="PRY_Responsable2" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable2<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable2" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_Responsable2Mail" name="PRY_Responsable2Mail" class="form-control" <%=disabled%> value="<%=PRY_Responsable2Mail%>"><%
					else%>
						<input type="email" id="PRY_Responsable2Mail" name="PRY_Responsable2Mail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable2Mail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable2Mail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: center;">			
			<label for="SEX_IdResponsable2" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdResponsable2=1) or (IsNULL(SEX_IdResponsable2)) then%>
					<input id="SEX_IdResponsable2femenino" type="radio" name="SEX_IdResponsable2" checked <%=checkbox%> value=1><%
				else%>
					<input id="SEX_IdResponsable2femenino" type="radio" name="SEX_IdResponsable2" <%=checkbox%> value=1><%
				end if%>
				<label for="SEX_IdResponsable2femenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdResponsable2=2) then%>
					<input id="SEX_IdResponsable2masculino" type="radio" name="SEX_IdResponsable2" checked <%=checkbox%> value="2"><%
				else%>
					<input id="SEX_IdResponsable2masculino" type="radio" name="SEX_IdResponsable2" <%=checkbox%> value="2"><%
				end if%>
				<label for="SEX_IdResponsable2masculino">Masculino</label>
			</div>			
		</div>
	</div>
	
	<div class="row align-items-center"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_Responsable2Celular" name="PRY_Responsable2Celular" class="form-control" <%=disabled%> value="<%=PRY_Responsable2Celular%>"><%
					else%>
						<input type="number" id="PRY_Responsable2Celular" name="PRY_Responsable2Celular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Responsable2Celular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Responsable2Celular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-9 col-lg-9" id="">
			<div class="md-form input-with-post-icon">
				<div class="error-message">														
					<i class="fas fa-cloud-upload-alt input-prefix"></i>
					<input type="text" id="RES2_AdjuntoX" name="RES2_AdjuntoX" class="form-control" <%=disabled%> readonly value="<%=RES2_Adjunto%>">
					<input type="file" id="RES2_Adjunto" name="RES2_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
					<span class="select-bar"></span><%
					if(RES2_Adjunto<>"") then
						classdown="text-primary arcadj"
						styledown="cursor:pointer; pointer-events: all !important;"
						data = "data-pry='" & PRY_Id & "'" & " data-arc='" & RES2_Adjunto & "'" & " data-token='" & PRY_Identificador & "'" & " data-hito='125'"%>
						<label for="RES2_AdjuntoX" class="active">Adjunto</label><%
					else
						classdown="disabled text-white-50"
						styledown="cursor:not-allowed; pointer-events: all !important;"
						data=""%>
						<label for="RES2_AdjuntoX" class="">Adjunto</label><%
					end if%>					
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-1 col-lg-1" id="">
			<i class="fas fa-cloud-download-alt fa-3x <%=classdown%>" title="Bajar adjunto" style="<%=styledown%>" id="RES2_AdjuntoDownload" <%=data%>></i>
		</div>
	</div>		
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s2" name="btn_frm10s2"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="Step" name="Step" value="2" />	
</form>
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
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);								
		
		
		$("#frm10s2").on("click",".arcadj",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PRY_Hito = $(this).data("hito")	
		
			ajax_icon_handling('load','Buscando adjuntos','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-responsables-proyecto',			
				data:{PRY_Hito:PRY_Hito,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de responsables creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcenc").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut};
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
						ajax_icon_handling(false,'No fue posible crear el listado de responsables.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de responsables.','','');	
				},
				complete: function(){																		
				}
			})
		})				
		$("#RES1_AdjuntoX").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#RES1_Adjunto").click();
		})
		$("#RES1_Adjunto").change(function(click){
			click.preventDefault();
			click.stopImmediatePropagation();
			click.stopPropagation();
			var fakepath_1 = "C:" + ss + "fakepath" + ss
			var fakepath_2 = "C:" + bb + "fakepath" + bb
			var fakepath_3 = "C:" + s + "fakepath" + s
			var fakepath_4 = "C:" + b + "fakepath" + b	

			var cont = 0;
			$.each (this.files,function(e){					
				cont = cont +1;
			});
			$('#RES1_AdjuntoX').val($("#RES1_Adjunto").val().replace(fakepath_4,""));								
		})
		$("#RES2_AdjuntoX").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#RES2_Adjunto").click();
		})
		$("#RES2_Adjunto").change(function(click){
			click.preventDefault();
			click.stopImmediatePropagation();
			click.stopPropagation();
			var fakepath_1 = "C:" + ss + "fakepath" + ss
			var fakepath_2 = "C:" + bb + "fakepath" + bb
			var fakepath_3 = "C:" + s + "fakepath" + s
			var fakepath_4 = "C:" + b + "fakepath" + b	

			var cont = 0;
			$.each (this.files,function(e){					
				cont = cont +1;
			});
			$('#RES2_AdjuntoX').val($("#RES2_Adjunto").val().replace(fakepath_4,""));								
		})		
		$("#btn_frm10s2").click(function(){
			formValidate("#frm10s2")
			if($("#frm10s2").valid()){	
				var formdata = new FormData();
				var data1 = $("#frm10s2").serializeArray();								
				var file_data_1 = $('#RES1_Adjunto').prop('files');
				var file_data_2 = $('#RES2_Adjunto').prop('files');								
				if(file_data_1[0]!=undefined){					
					formdata.append("RES1_Adjunto", "1")
				}else{
					formdata.append("RES1_Adjunto", "0")
				}
				if(file_data_2[0]!=undefined){
					formdata.append("RES2_Adjunto", "1")
				}else{
					formdata.append("RES2_Adjunto", "0")
				}
				var sizerror=false;
				var tipo=0;
				var sumsize1=0;
				var sumsize2=0;
				for (var i = 0; i < file_data_1.length; i++) {
					formdata.append(file_data_1[i].name, file_data_1[i]);
					sumsize1=sumsize1+file_data_1[i].size;
					if(file_data_1[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
						tipo=1
					}
				}				
				for (var i = 0; i < file_data_2.length; i++) {
					formdata.append(file_data_2[i].name, file_data_2[i]);
					sumsize2=sumsize2+file_data_2[i].size;
					if(file_data_2[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
						tipo=2;
					}
				}
				if(((sumsize1+sumsize2)>parseInt(maxupload[maxsize].size)) && (tipo==0)){
					sizerror=true;
					tipo=3;
				};				
				$.each(data1, function(i, field) { 
                   formdata.append(field.name,field.value);
                });	
				if(sizerror){
					if((tipo==1) || (tipo==3)){
						$("#RES1_AdjuntoX").removeClass("is-valid");
						$("#RES1_AdjuntoX").addClass("is-invalid");
						$("#RES1_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#RES1_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#RES1_AdjuntoX").parent().after('<div id="RES1_AdjutnoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">' + maxupload[maxsize]['msg-invalid'] + '</div>') 
					}
					if((tipo==2) || (tipo==3)){
						$("#RES2_AdjuntoX").removeClass("is-valid");
						$("#RES2_AdjuntoX").addClass("is-invalid");
						$("#RES2_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#RES2_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#RES2_AdjuntoX").parent().after('<div id="RES1_AdjutnoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">' + maxupload[maxsize]['msg-invalid'] + '</div>') 
					}					
					Toast.fire({
						icon: 'error',
						title: maxupload[maxsize]['msg-toast']
					});
				}else{
					$.ajax({
						url: $("#frm10s2").attr("action"),					
						method: 'POST',					
						data:formdata,
						enctype: 'multipart/form-data',
						cache: false,
						contentType: false,
						processData: false,					
						success: function(data) {						
							param=data.split(bb);						
							if(param[0]=="200"){
								Toast.fire({
								icon: 'success',
								title: 'Responsables del proyecto grabados correctamente'
								});
								var modo = <%=modo%>;
								var PRY_Id = <%=PRY_Id%>;
								if(modo==1){
									PRY_Id=param[1];
									modo=2;
								}
								var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0,PRY_Hito:1};
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
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Corrige los campos con error antes de grabar la información'
				});
			}
		});		
	});
</script>