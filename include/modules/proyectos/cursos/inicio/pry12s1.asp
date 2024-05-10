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
		action="/mod-12-h1-s1"
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
			PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
			PRY_EncargadoProyectoMail=rs("PRY_EncargadoProyectoMail")			
			PRY_EncargadoProyectoCelular=rs("PRY_EncargadoProyectoCelular")
			SEX_IdEncargadoProyecto=rs("SEX_IdEncargadoProyecto")
			
			PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
			PRY_EncargadoActividadesMail=rs("PRY_EncargadoActividadesMail")
			PRY_EncargadoActividadesCelular=rs("PRY_EncargadoActividadesCelular")
			SEX_IdEncargadoActividades=rs("SEX_IdEncargadoActividades")
			ENC_Adjunto=rs("ENC_Adjunto")
			COR_Adjunto=rs("COR_Adjunto")
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
<form role="form" action="<%=action%>" method="POST" name="frm12s1" id="frm12s1" class="needs-validation">
	<h5>Responsables del proyecto</h5>
	<h6>Coordinador/a de proyecto Nro 1</h6>
	<div class="row align-items-center"> 
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_EncargadoProyecto" name="PRY_EncargadoProyecto" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyecto%>"><%
					else%>
						<input type="text" id="PRY_EncargadoProyecto" name="PRY_EncargadoProyecto" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyecto<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyecto" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_EncargadoProyectoMail" name="PRY_EncargadoProyectoMail" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyectoMail%>"><%
					else%>
						<input type="email" id="PRY_EncargadoProyectoMail" name="PRY_EncargadoProyectoMail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyectoMail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyectoMail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: center;">			
			<label for="SEX_IdEncargadoProyecto" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoProyecto=1) or (IsNULL(SEX_IdEncargadoProyecto)) then%>
					<input id="SEX_IdEncargadoProyectofemenino" type="radio" name="SEX_IdEncargadoProyecto" checked value="1" <%=checkbox%>><%
				else%>
					<input id="SEX_IdEncargadoProyectofemenino" type="radio" name="SEX_IdEncargadoProyecto" value="1" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdEncargadoProyectofemenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoProyecto=2) then%>
					<input id="SEX_IdEncargadoProyectomasculino" type="radio" name="SEX_IdEncargadoProyecto" checked value="2" <%=checkbox%>><%
				else%>
					<input id="SEX_IdEncargadoProyectomasculino" type="radio" name="SEX_IdEncargadoProyecto" value="2" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdEncargadoProyectomasculino">Masculino</label>
			</div>			
		</div>
	</div>
	
	<div class="row align-items-center" style="padding-bottom:30px;"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_EncargadoProyectoCelular" name="PRY_EncargadoProyectoCelular" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyectoCelular%>"><%
					else%>
						<input type="number" id="PRY_EncargadoProyectoCelular" name="PRY_EncargadoProyectoCelular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyectoCelular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyectoCelular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>			
		<div class="col-sm-12 col-md-9 col-lg-9" id="">
			<div class="md-form input-with-post-icon">
				<div class="error-message">														
					<i class="fas fa-cloud-upload-alt input-prefix"></i>
					<input type="text" id="COR_AdjuntoX" name="COR_AdjuntoX" class="form-control" <%=disabled%> readonly value="<%=COR_Adjunto%>">
					<input type="file" id="COR_Adjunto" name="COR_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">										
					<span class="select-bar"></span><%
					if(COR_Adjunto<>"") then
						classdown="text-primary arcadj"
						styledown="cursor:pointer; pointer-events: all !important;"
						data = "data-pry='" & PRY_Id & "'" & " data-arc='" & COR_Adjunto & "'" & " data-token='" & PRY_Identificador & "'" & " data-hito='109'"%>
						<label for="COR_AdjuntoX" class="active">Adjunto</label><%
					else
						classdown="disabled text-white-50"
						styledown="cursor:not-allowed; pointer-events: all !important;"
						data=""%>
						<label for="COR_AdjuntoX" class="">Adjunto</label><%
					end if%>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-1 col-lg-1" id="">
			<i class="fas fa-cloud-download-alt fa-3x <%=classdown%>" title="Bajar adjunto" style="<%=styledown%>" id="COR_AdjuntoDownload" <%=data%>></i>
		</div>
	</div>
	
	
	<h6>Coordinador/a de proyecto Nro 2</h6>
	<div class="row">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_EncargadoActividades" name="PRY_EncargadoActividades" class="form-control" <%=disabled%> value="<%=PRY_EncargadoActividades%>"><%
					else%>
						<input type="text" id="PRY_EncargadoActividades" name="PRY_EncargadoActividades" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoActividades<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoActividades" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_EncargadoActividadesMail" name="PRY_EncargadoActividadesMail" class="form-control" <%=disabled%> value="<%=PRY_EncargadoActividadesMail%>"><%
					else%>
						<input type="email" id="PRY_EncargadoActividadesMail" name="PRY_EncargadoActividadesMail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoActividadesMail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoActividadesMail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: center;">			
			<label for="SEX_IdEncargadoActividades" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoActividades=1) or (IsNULL(SEX_IdEncargadoActividades)) then%>
					<input id="SEX_IdEncargadoActividadesfemenino" type="radio" name="SEX_IdEncargadoActividades" checked <%=checkbox%> value=1><%
				else%>
					<input id="SEX_IdEncargadoActividadesfemenino" type="radio" name="SEX_IdEncargadoActividades" <%=checkbox%> value=1><%
				end if%>
				<label for="SEX_IdEncargadoActividadesfemenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoActividades=2) then%>
					<input id="SEX_IdEncargadoActividadesmasculino" type="radio" name="SEX_IdEncargadoActividades" checked <%=checkbox%> value="2"><%
				else%>
					<input id="SEX_IdEncargadoActividadesmasculino" type="radio" name="SEX_IdEncargadoActividades" <%=checkbox%> value="2"><%
				end if%>
				<label for="SEX_IdEncargadoActividadesmasculino">Masculino</label>
			</div>			
		</div>
	</div>
	
	<div class="row align-items-center"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_EncargadoActividadesCelular" name="PRY_EncargadoActividadesCelular" class="form-control" <%=disabled%> value="<%=PRY_EncargadoActividadesCelular%>"><%
					else%>
						<input type="number" id="PRY_EncargadoActividadesCelular" name="PRY_EncargadoActividadesCelular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoActividadesCelular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoActividadesCelular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-9 col-lg-9" id="">
			<div class="md-form input-with-post-icon">
				<div class="error-message">														
					<i class="fas fa-cloud-upload-alt input-prefix"></i>
					<input type="text" id="ENC_AdjuntoX" name="ENC_AdjuntoX" class="form-control" <%=disabled%> readonly value="<%=ENC_Adjunto%>">
					<input type="file" id="ENC_Adjunto" name="ENC_Adjunto" readonly accept="image/png,image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,	application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
					<span class="select-bar"></span><%
					if(ENC_Adjunto<>"") then
						classdown="text-primary arcadj"
						styledown="cursor:pointer; pointer-events: all !important;"
						data = "data-pry='" & PRY_Id & "'" & " data-arc='" & ENC_Adjunto & "'" & " data-token='" & PRY_Identificador & "'" & " data-hito='110'"%>
						<label for="ENC_AdjuntoX" class="active">Adjunto</label><%
					else
						classdown="disabled text-white-50"
						styledown="cursor:not-allowed; pointer-events: all !important;"
						data=""%>
						<label for="ENC_AdjuntoX" class="">Adjunto</label><%
					end if%>					
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-1 col-lg-1" id="">
			<i class="fas fa-cloud-download-alt fa-3x <%=classdown%>" title="Bajar adjunto" style="<%=styledown%>" id="ENC_AdjuntoDownload" <%=data%>></i>
		</div>
	</div>		
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s1" name="btn_frm12s1"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="Step" name="Step" value="1" />	
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
		
		
		$("#frm12s1").on("click",".arcadj",function(e){
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
		$("#COR_AdjuntoX").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#COR_Adjunto").click();
		})
		$("#COR_Adjunto").change(function(click){
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
			$('#COR_AdjuntoX').val($("#COR_Adjunto").val().replace(fakepath_4,""));								
		})
		$("#ENC_AdjuntoX").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#ENC_Adjunto").click();
		})
		$("#ENC_Adjunto").change(function(click){
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
			$('#ENC_AdjuntoX').val($("#ENC_Adjunto").val().replace(fakepath_4,""));								
		})		
		$("#btn_frm12s1").click(function(){
			formValidate("#frm12s1")
			if($("#frm12s1").valid()){	
				var formdata = new FormData();
				var data1 = $("#frm12s1").serializeArray();								
				var file_data_1 = $('#COR_Adjunto').prop('files');
				var file_data_2 = $('#ENC_Adjunto').prop('files');								
				if(file_data_1[0]!=undefined){					
					formdata.append("COR_Adjunto", "1")
				}else{
					formdata.append("COR_Adjunto", "0")
				}
				if(file_data_2[0]!=undefined){
					formdata.append("ENC_Adjunto", "1")
				}else{
					formdata.append("ENC_Adjunto", "0")
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
						$("#COR_AdjuntoX").removeClass("is-valid");
						$("#COR_AdjuntoX").addClass("is-invalid");
						$("#COR_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#COR_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#COR_AdjuntoX").parent().after('<div id="COR_AdjutnoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">' + maxupload[maxsize]['msg-invalid'] + '</div>') 
					}
					if((tipo==2) || (tipo==3)){
						$("#ENC_AdjuntoX").removeClass("is-valid");
						$("#ENC_AdjuntoX").addClass("is-invalid");
						$("#ENC_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
						$("#ENC_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
						$("#ENC_AdjuntoX").parent().after('<div id="COR_AdjutnoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">' + maxupload[maxsize]['msg-invalid'] + '</div>') 
					}					
					Toast.fire({
						icon: 'error',
						title: maxupload[maxsize]['msg-toast']
					});
				}else{
					$.ajax({
						url: $("#frm12s1").attr("action"),					
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
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Corrige los campos con error antes de grabar la información'
				});
			}
		});		
	});
</script>