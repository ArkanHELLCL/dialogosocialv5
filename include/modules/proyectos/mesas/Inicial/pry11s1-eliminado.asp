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
		action="/mod-11-h1-s1"
		checkbox="required"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
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
			PRY_Estado=rs("PRY_Estado")
			PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")
			PRY_Identificador=rs("PRY_Identificador")
			PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
			PRY_EncargadoProyectoMail=rs("PRY_EncargadoProyectoMail")			
			PRY_EncargadoProyectoCelular=rs("PRY_EncargadoProyectoCelular")
			SEX_IdEncargadoProyecto=rs("SEX_IdEncargadoProyecto")
			
			PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
			PRY_EncargadoActividadesMail=rs("PRY_EncargadoActividadesMail")
			PRY_EncargadoActividadesCelular=rs("PRY_EncargadoActividadesCelular")
			SEX_IdEncargadoActividades=rs("SEX_IdEncargadoActividades")
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
<form role="form" action="" method="POST" name="frm11s1_1" id="frm11s1_1" class="needs-validation">
	<h5>Plan de Trabajo</h5><%
	if(mode="mod") then%>
	<div class="row">
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="TIM_Id" id="TIM_Id" class="validate select-text form-control" <%=disabled%>>
							<option value="" selected readonly></option><%
							x=1
							set rs = cnn.Execute("exec spTipoMesa_Listar 1")
							on error resume next
							if cnn.Errors.Count > 0 then 
							   ErrMsg = cnn.Errors(0).description	   
							   cnn.close
							   response.Write("503/@/Error Conexión:" & ErrMsg)
							   response.End() 			   
							end if	
							do While Not rs.EOF%>								
								<option value="<%=rs("TIM_Id")%>"><%=rs("TIM_NombreMesa")%></option><%							
								rs.MoveNext
							loop
							rs.Close%>
						</select>
						<i class="fas fa-tag input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label">Selección de HITO</label>
					</div>
				</div>
			</div>							
		</div>						
		<div class="col-sm-12 col-md-9 col-lg-9">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="REL_Id" id="REL_Id" class="validate select-text form-control" <%=disabled%>>
							<option value="" disabled selected></option><%													
							set rx = cnn.Execute("exec spRelator_Listar -1")
							on error resume next					
							do While Not rx.eof%>
								<option value="<%=rx("REL_Id")%>"><%=FormatNumber(mid(rx("REL_Rut"),1,len(rx("REL_Rut"))-1),0)%>-<%=mid(rx("REL_Rut"),len(rx("REL_Rut")),1)%>&nbsp;-&nbsp;<%=rx("REL_Nombres")%>&nbsp;<%=rx("REL_Paterno")%>&nbsp;<%=rx("REL_Materno")%></option><%
								rx.movenext						
							loop
							rx.Close%>
						</select>														
						<i class="fas fa-user-graduate input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Relator</label>
					</div>
				</div>	
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-users input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="text" id="TED_ActoresConvocados" name="TED_ActoresConvocados" class="form-control" <%=disabled%> value="<%=TED_ActoresConvocados%>"><%
					else%>
						<input type="text" id="TED_ActoresConvocados" name="TED_ActoresConvocados" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if TED_ActoresConvocados<>"" then
						lblClass="active"
					end if%>
					<label for="TED_ActoresConvocados" class="<%=lblClass%>">Actores Involucrados</label>									
				</div>
			</div>
		</div>
	</div>	
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-comments input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="TED_Nombre" name="TED_Nombre" class="form-control" <%=disabled%> value="<%=TED_Nombre%>"><%
					else%>
						<input type="text" id="TED_Nombre" name="TED_Nombre" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if TED_Nombre<>"" then
						lblClass="active"
					end if%>
					<label for="TED_Nombre" class="<%=lblClass%>">Temática y/o módulo a abordar</label>									
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form">
				<div class="error-message">								
					<i class="fas fa-comment prefix"></i>
						<textarea id="TED_Contenidos" name="TED_Contenidos" class="md-textarea form-control" required="" rows="5"><%=TED_Contenidos%></textarea>
					<span class="select-bar"></span><%
					if TED_Contenidos<>"" then
						lblClass="active"
					end if%>
					<label for="" class="<%=lblClass%>">Contenidos</label>									
				</div>
			</div>
		</div>						
	</div>
	
	<h6>Ubicación en donde se realizarán las actividades</h6>
	<div class="row"> 		
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="REG_Id" id="REG_Id" class="validate select-text form-control" <%=disabled%>>
							<option value="" readonly selected></option><%
							set rs = cnn.Execute("exec spRegion_Listar")
							on error resume next					
							do While Not rs.eof%>
								<option value="<%=rs("REG_Id")%>"><%=rs("REG_Nombre")%></option><%								
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-map-marker-alt input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label">Región</label>
					</div>
				</div>
			</div>							
		</div>
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="COM_Id" id="COM_Id" class="validate select-text form-control" <%=disabled%>>
							<option value="" disabled selected></option><%
							set rs = cnn.Execute("exec spComuna_Listar 0")
							on error resume next					
							do While Not rs.eof%>
								<option value="<%=rs("COM_Id")%>"><%=rs("COM_Nombre")%></option><%									
								rs.movenext						
							loop
							rs.Close%>							
						</select>
						<i class="fas fa-map-marker-alt input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label">Comuna</label>
					</div>
				</div>
			</div>							
		</div>
	</div>
	<div class="row align-items-center">
		<div class="col-sm-12 col-md-5 col-lg-5">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-home input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="TED_Direccion" name="TED_Direccion" class="form-control" <%=disabled%> value="<%=TED_Direccion%>"><%
					else%>
						<input type="text" id="TED_Direccion" name="TED_Direccion" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if TED_Direccion<>"" then
						lblClass="active"
					end if%>
					<label for="TED_Direccion" class="<%=lblClass%>">Dirección</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-calendar input-prefix"></i><%
					if(mode="mod") then%>
						<input type="text" id="TED_Fecha" name="TED_Fecha" class="form-control calendario" readonly required value="<%=TED_Fecha%>"><%
					else%>
						<input type="text" id="TED_Fecha" name="TED_Fecha" class="form-control" readonly value="<%=TED_Fecha%>"><%
					end if%>
					<span class="select-bar"></span><%
					if TED_Fecha<>"" then
						lblClass="active"
					end if%>
					<label for="TED_Fecha" class="<%=lblClass%>">Fecha</label>									
				</div>
			</div>
		</div>	
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod") then%>
						<input type="text" id="TED_HoraInicio" name="TED_HoraInicio" class="form-control hora" readonly required value="<%=TED_HoraInicio%>"><%
					else%>
						<input type="text" id="TED_HoraInicio" name="TED_HoraInicio" class="form-control" readonly value="<%=TED_HoraInicio%>"><%
					end if%>
					<span class="select-bar"></span><%
					if TED_HoraInicio<>"" then
						lblClass="active"
					end if%>
					<label for="TED_HoraInicio" class="<%=lblClass%>">Hora Inicio</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod") then%>
						<input type="text" id="TED_HoraTermino" name="TED_HoraTermino" class="form-control hora" readonly required value="<%=TED_HoraTermino%>"><%
					else%>
						<input type="text" id="TED_HoraTermino" name="TED_HoraTermino" class="form-control" readonly value="<%=TED_HoraTermino%>"><%
					end if%>
					<span class="select-bar"></span><%
					if TED_HoraTermino<>"" then
						lblClass="active"
					end if%>
					<label for="TED_HoraTermino" class="<%=lblClass%>">Hora Término</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-1 col-lg-1" style="text-align:left;">
			<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s1_1" name="btn_frm11s1_1" style="float:right;"><i class="fas fa-plus"></i></button>
		</div>
	</div><%
	end if%>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
</form>
<h6 style="padding-bottom:30px;">Plan de trabajo ingresados</h6>
<table id="tbl-plantrabajomesa" class="ts table table-striped table-bordered dataTable table-sm tbl-plantrabajomesa" data-id="plantrabajomesa" data-page="true" data-selected="true" data-keys="1"> 
	<thead> 
		<tr> 
			<th style="width:10px;">#</th>
			<th>Hito</th>
			<th>Relator</th>
			<th>Actores Involucrados</th>
			<th>Temática y/o módulo a abordar</th>
			<th>Región</th>
			<th>Comuna</th>
			<th>Dirección</th>
			<th>Fecha</th>
			<th>Hora Inicio</th>
			<th>Hora Termino</th>
			<th>Acciones</th>
		</tr> 
	</thead>					
	<tbody>
	</tbody>
</table>
<form role="form" action="<%=action%>" method="POST" name="frm11s1" id="frm11s1" class="needs-validation">
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s1" name="btn_frm11s1"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="Step" name="Step" value="1" />	
	<input type="hidden" id="PRY_Hito" name="PRY_Hito" value="1" />	
</form>

<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var bb = String.fromCharCode(92) + String.fromCharCode(92);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var s  = String.fromCharCode(47);
	var b  = String.fromCharCode(92);
	
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	
	if ($(".calendario").val() ==  null){
		$(".calendario").datepicker().datepicker("setDate", new Date());
	}else{
		$(".calendario").datepicker();
	}	
	$('.hora').timepicker({
		timeFormat: 'H:mm',
		interval: 5,
		minTime: '6',
		maxTime: '22:00',
		startTime: '6:00',
		dynamic: true,
		dropdown: true,
		scrollbar: true,
		change:function(time){									
			$(this).siblings("label").addClass("active");								
		},
		beforeShow: function(input, inst) {
			$(document).off('focusin.bs.modal');
		},
		onClose:function(){
			$(document).on('focusin.bs.modal');
		},
	});	
						
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	$(document).ready(function() {				
	
		$('select#REG_Id').on('change',function(){
			var region = $(this).val();    	
			$.ajax({
				type: 'POST',			
				url: '/seleccionar-comunas',
				data: {REG_Id:region},
				success: function(data) {					
					$('#COM_Id').html(data);
					setInterval(blink('#COM_Id'), 2200);								
				}
			});
		});	
			
		$("#TIM_Id").on('change',function(){
			oblgrela();
		})

		function oblgrela(){
			$.ajax({
				url: "/consultar-obligacion-relator",
				method: 'POST',					
				data:{TIM_Id:$("#TIM_Id").val()},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){
						//console.log(data.TIM_RelatorObligatorio);
						if(data.TIM_RelatorObligatorio==1){
							$("#REL_Id").removeAttr("required")
							$("#REL_Id").attr("required","")
						}
						if(data.TIM_RelatorObligatorio==0){
							$("#REL_Id").removeAttr("required")	
							$("#REL_Id").removeClass("is-invalid")
						}
					}
				}
			});
		}
		var plantrabajoMESA;
		loadTablePlantrabajoMESA();
		
		function loadTablePlantrabajoMESA(){
			if($.fn.DataTable.isDataTable( "#tbl-plantrabajomesa")){				
				if(plantrabajoMESA!=undefined){
					plantrabajoMESA.destroy();
				}else{
					$('#tbl-plantrabajomesa').dataTable().fnClearTable();
					$('#tbl-plantrabajomesa').dataTable().fnDestroy();
				}
			}				
			plantrabajoMESA = $("#tbl-plantrabajomesa").DataTable({
				lengthMenu: [ 5,10,20 ],				
				ajax:{
					url:"/plan-de-trabajo-mesa",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-plantrabajomesa').css('width','99%');
			$('#tbl-plantrabajomesa').parent().css('overflow-x','scroll');
		}	
		
		$("#pry-content").on("click",".delplntra",function(){
			var TED_Id=$(this).data("ted");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás el plan de trabajo seleccionada!",
			  	icon: 'warning',
			  	showCancelButton: true,
			  	confirmButtonColor: '#3085d6',
			  	cancelButtonColor: '#d33',
			  	confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
			  	cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-plan-de-trabajo",
						data: {PRY_Id:<%=PRY_Id%>,TED_Id:TED_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								plantrabajoMESA.ajax.reload();
								Toast.fire({
									icon: 'success',
									title: 'Plan de trabajo eliminado correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})
		
		$("#btn_frm11s1_1").click(function(){
			formValidate("#frm11s1_1")
			if($("#frm11s1_1").valid()){
				$.ajax({
					type: 'POST',			
					url: "/grabar-plan-de-trabajo",
					data: $("#frm11s1_1").serialize(),
					dataType:"json",
					success: function(data) {	
						if(data.state==200){						
							plantrabajoMESA.ajax.reload();	
							$("#frm11s1_1")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Plan de trabajo grabado correctamente'
							});
						}else{
						
						}
					}
				})
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
		
		$("#btn_frm11s1").click(function(){
			if(plantrabajoMESA.data().count()>0){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',					
					url: $("#frm11s1").attr("action"),
					data: $("#frm11s1").serialize(),					
					success: function(data) {						
						param=data.split(bb);
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Plan de trabajo grabados correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};
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
			}else{
				swalWithBootstrapButtons.fire({
					icon:'error',								
					title: 'Debes agregar al menos un plan de trabajo antes de pasar al siguiente paso'							
				});
			}
		});	
		
		$("#pry-content").on("click",".doverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-de-trabajo',			
				data:{TED_Id:TED_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:123, ALU_Rut:ALU_Rut,ENP_Id:TED_Id};
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