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
		action="/mod-11-h2-s2"
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
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
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
			PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
			PRY_Estado=rs("PRY_Estado")
			PRY_AvancesFacilitadores=rs("PRY_AvancesFacilitadores")
			PRY_AvancesObstaculizadores=rs("PRY_AvancesObstaculizadores")
			PRY_AvancesSintesis=rs("PRY_AvancesSintesis")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")%>
	
	<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Evaluación de proceso</h5>
		<form role="form" action="<%=action%>" method="POST" name="frm11s2" id="frm11s2" class="needs-validation">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="md-form">
						<div class="error-message">								
							<i class="fas fa-comment prefix"></i>
								<textarea id="PRY_AvancesFacilitadores" name="PRY_AvancesFacilitadores" class="md-textarea form-control" <%=disabled%> rows="3"><%=PRY_AvancesFacilitadores%></textarea>
							<span class="select-bar"></span><%
							clase=""
							if(PRY_AvancesFacilitadores<>"") then
								clase="active"
							end if%>
							<label for="" class="<%=clase%>">Facilitadores</label>									
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="md-form">
						<div class="error-message">								
							<i class="fas fa-comment prefix"></i>
								<textarea id="PRY_AvancesObstaculizadores" name="PRY_AvancesObstaculizadores" class="md-textarea form-control" <%=disabled%> rows="3"><%=PRY_AvancesObstaculizadores%></textarea>
							<span class="select-bar"></span><%
							clase=""
							if(PRY_AvancesObstaculizadores<>"") then
								clase="active"
							end if%>
							<label for="" class="<%=clase%>">Obstaculizadores</label>									
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<div class="md-form">
						<div class="error-message">								
							<i class="fas fa-comment prefix"></i>
								<textarea id="PRY_AvancesSintesis" name="PRY_AvancesSintesis" class="md-textarea form-control" <%=disabled%> rows="3"><%=PRY_AvancesSintesis%></textarea>
							<span class="select-bar"></span><%
							clase=""
							if(PRY_AvancesSintesis<>"") then
								clase="active"
							end if%>
							<label for="" class="<%=clase%>">Síntesis de conclusiones mesas bi/tripartitas desarrolladas</label>									
						</div>
					</div>
				</div>
			</div>																														
			<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
			<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
			<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
			<input type="hidden" id="Step" name="Step" value="2">
			<input type="hidden" id="PRY_Hito" value="2" name="PRY_Hito">					
		</form><%
		if(mode="mod") then%>
			
			<form role="form" action="" method="POST" name="frm11s2_1" id="frm11s2_1" class="needs-validation">
				<h6>En caso de haber identificado problemáticas y/o temáticas durante el desarrollo de la mesa, (distintas a las definidas en el Informe Inicial) se deberán señalar y describir a continuación.</h6>
				
				<div class="row align-items-center">						
					<div class="col-sm-12 col-md-5 col-lg-5">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-list-ol input-prefix"></i>													
								<input type="text" id="TID_TematicaProblematica" name="TID_TematicaProblematica" class="form-control" required="" value="">
								<span class="select-bar"></span>
								<label for="TID_TematicaProblematica" class="">Temática</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-5 col-lg-5">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-calendar input-prefix"></i>													
								<input type="text" id="TID_Descripcion" name="TID_Descripcion" class="form-control calendario" required="" value="">
								<span class="select-bar"></span>
								<label for="TID_Descripcion" class="">Descripción</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s2_1" name="btn_frm11s2_1" style="float:right;"><i class="fas fa-plus"></i></button>
					</div>
				</div>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
			</form><%
		end if%>
		<h6>Lista de Nuevas Temáticas detectadas</h6>

		<table id="tbl-addnewtematicamesa" class="ts table table-striped table-bordered dataTable table-sm tbl-addnewtematicamesa" data-id="addnewtematicamesa" data-page="true" data-selected="true" data-keys="1"> 
			<thead> 
				<tr> 
					<th style="width:10px;">#</th>
					<th style="width:10px;">Temática</th>					
					<th>Descripción</th><%
					if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
						<th></th><%
					end if%>
				</tr> 
			</thead>					
			<tbody>
			</tbody>
		</table>
		 				
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>			
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s2" name="btn_frm11s2"><%=txtBoton%></button><%					
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
		
		var tematicaMESA;
		loadTabletematicaMESA();
		
		function loadTabletematicaMESA(){			
			if($.fn.DataTable.isDataTable( "#tbl-addnewtematicamesa")){				
				if(tematicaMESA!=undefined){
					tematicaMESA.destroy();
				}else{
					$('#tbl-addnewtematicamesa').dataTable().fnClearTable();
					$('#tbl-addnewtematicamesa').dataTable().fnDestroy();
				}
			}				
			tematicaMESA = $("#tbl-addnewtematicamesa").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/evaluacion-tematicas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-addnewtematicamesa').css('width','100%');
			$('#tbl-addnewtematicamesa').parent().css('overflow-x','scroll');
		}					
		
		$("#btn_frm11s2_1").click(function(){
			formValidate("#frm11s2_1");
			if($("#frm11s2_1").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-eval-tematica",
					data: $("#frm11s2_1").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							tematicaMESA.ajax.reload();	
							$("#frm11s2")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Evaluación de temática grabada correctamente'
							});
						}else{
						
						}
					}
				})																		
			}			
		})
		
		$("#pry-content").on("click",".deltemmesa",function(){
			var TID_Id=$(this).data("tid");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás la evaluación de la temática seleccionada!",
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
						url: "/elimina-eval-tematica",
						data: {PRY_Id:<%=PRY_Id%>,TID_Id:TID_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								tematicaMESA.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Evaluación de TEmática eliminada correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})		
		
								
		$("#btn_frm11s2").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm11s2");			
						
			if($("#frm11s2").valid()){
				
					$.ajax({
						type: 'POST',			
						url: $("#frm11s2").attr("action"),
						data: $("#frm11s2").serialize(),
						success: function(data) {								
							var param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Evaluación de proceso grabadas correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:2};
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
												text:data.message
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
			}
		})
		
	});
</script>