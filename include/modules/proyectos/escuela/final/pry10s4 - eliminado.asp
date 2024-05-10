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
		action="/mod-10-h3-s4"
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
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
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
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
			PRY_ObsCumplimientosPropuestos=rs("PRY_ObsCumplimientosPropuestos")
			PRY_ObsCumplimientosFechas=rs("PRY_ObsCumplimientosFechas")			
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if		
	
	rs.close
	response.write("200/@/")%>

	<h5>Cumplimientos</h5>
	<h6>¿Se cumplieron los objetivos propuestos?</h6>
	<form role="form" action="<%=action%>" method="POST" name="frm10s4" id="frm10s4" class="needs-validation">
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_ObsCumplimientosPropuestos" name="PRY_ObsCumplimientosPropuestos" class="md-textarea form-control" rows="3" <%=disabled%>><%=PRY_ObsCumplimientosPropuestos%></textarea>
						<span class="select-bar"></span><%
						if(PRY_ObsCumplimientosPropuestos<>"") then
							clase="active"
						else
							clase=""
						end if%>
						<label for="PRY_ObsCumplimientosPropuestos" class="<%=clase%>">Objetivos Propuestos</label>
					</div>
				</div>
			</div>
		</div>
		<h6>¿Se cumplieron las fechas propuestas?</h6>
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_ObsCumplimientosFechas" name="PRY_ObsCumplimientosFechas" class="md-textarea form-control" rows="3" <%=disabled%>><%=PRY_ObsCumplimientosFechas%></textarea>
						<span class="select-bar"></span><%
						if(PRY_ObsCumplimientosFechas<>"") then
							clase="active"
						else
							clase=""
						end if%>
						<label for="PRY_ObsCumplimientosFechas" class="<%=clase%>">Fechas Propuestas</label>
					</div>
				</div>
			</div>
		</div>		
		<div class="row">		
			<div class="footer"><%
				if mode="mod" then%>				
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s4" name="btn_frm10s4"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="4">
					<input type="hidden" id="PRY_Hito" value="3" name="PRY_Hito"><%
				else%>				
					<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
					<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
				end if%>
			</div>			
		</div>						
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
		var tables = $.fn.dataTable.fnTables(true);
		$(tables).each(function () {
			$(this).dataTable().fnDestroy();				
		});	
		porejecutarTable = $('#tbl-porejecutar').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		ejecutadasTable = $('#tbl-ejecutadas').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		
		$("#btn_frm10s4").click(function(){
			formValidate("#frm10s4")
			if($("#frm10s4").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s4").attr("action"),
					data: $("#frm10s4").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Cumplimientos grabados correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:3};
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
		});		
	});
</script>