<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Identificador=request("PRY_Identificador")
	
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
		action="/mod-12-h1-s5"
		calendario="calendario"
		hora="hora"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"		
		calendario=""
		hora=""
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		hora=""
	end if
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if
	
	lblClass=""
	if(mode="mod" or mode="vis") then
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)		
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión 2:" & sql)
		   response.End() 			   
		end if		
		if not rs.eof then	
			PRY_Metodologia=rs("PRY_Metodologia")
			MET_Id=rs("MET_Id")
			MET_Descripcion=rs("MET_Descripcion")
		end if					
	end if
	
	sql="exec spPlanificacionPlantillaCreacion_Listar " & LIN_Id
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión 3:" & ErrMsg & " - " & sql)
	    response.End()
	End If
	PRY_HorasPedagogicasMin=0
	do while not rs.eof		
		PRY_HorasPedagogicasMin=PRY_HorasPedagogicasMin+CInt(rs("TEM_Horas"))		
		rs.movenext
	loop
	
	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión 4:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	PRY_HorasPedagogicasTot1=0
	PRY_HorasPedagogicasTot2=0
	do while not rs.eof		
		if(rs("MET_Id")=1) then
			PRY_HorasPedagogicasTot1=PRY_HorasPedagogicasTot1+CInt(rs("CANT_PLNSesion"))
		end if
		if(rs("MET_Id")=2) then
			PRY_HorasPedagogicasTot2=PRY_HorasPedagogicasTot2+CInt(rs("CANT_PLNSesion"))
		end if
		rs.movenext
	loop	 	
	rs.close
	
	PorTot1=FormatNumber((PRY_HorasPedagogicasTot1/PRY_HorasPedagogicasMin)*100,2)
	PorTot2=FormatNumber((PRY_HorasPedagogicasTot2/PRY_HorasPedagogicasMin)*100,2)
	
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.write("mode-" & mode)
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm12s5" id="frm12s5" class="needs-validation">
	<h5>Metodología</h5>
	<h6>Descripción</h6>
	<div class="row" style="padding-top:30px;">
		<div class="col-sm-12 col-md-12 col-lg-12">
			<div class="md-form">
				<div class="error-message">								
					<i class="fas fa-comment prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<textarea id="PRY_Metodologia" name="PRY_Metodologia" class="md-textarea form-control" <%=disabled%> rows="10"><%=PRY_Metodologia%></textarea><%
					else%>
						<textarea id="PRY_Metodologia" name="PRY_Metodologia" class="form-control" <%=disabled%> rows="10"></textarea><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Metodologia<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Metodologia" class="<%=lblClass%>">Metodología</label>									
				</div>
			</div>
		</div>
	</div>
	
	<h5>Modalidad</h5>
	<h6>Modalidad del curso</h6>
	<div class="row" style="padding-top:30px;">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-graduation-cap input-prefix"></i>
						<input type="text" id="MET_Descripcion" name="MET_Descripcion" class="form-control" readonly="" value="<%=MET_Descripcion%>">
					<span class="select-bar"></span>
					<label for="" class="active">Madalidad del curso</label>									
				</div>
			</div>			
		</div><%
		if(MET_Id)<>3 then%>
			<div class="col-sm-12 col-md-4 col-lg-4">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-percentage input-prefix"></i>
							<input type="text" class="form-control" readonly="" value="100">
						<span class="select-bar"></span>
						<label for="" class="active">% de horas <%=MET_DEscripcion%></label>									
					</div>
				</div>			
			</div><%
		else
			sql="exec spMetodologia_Consultar 1"
			set rs = cnn.Execute(sql)		
			on error resume next
			if cnn.Errors.Count > 0 then 
			   ErrMsg = cnn.Errors(0).description	   
			   cnn.close
			   response.Write("503/@/Error Conexión:" & sql)
			   response.End() 			   
			end if		
			if not rs.eof then
				MET_Descripcion=rs("MET_Descripcion")
			end if%>
			<div class="col-sm-12 col-md-4 col-lg-4">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-percentage input-prefix"></i>
							<input type="text" class="form-control" readonly="" value="<%=PorTot1%>">
						<span class="select-bar"></span>
						<label for="" class="active">% de horas <%=MET_DEscripcion%></label>									
					</div>
				</div>			
			</div><%
			sql="exec spMetodologia_Consultar 2"
			set rs = cnn.Execute(sql)		
			on error resume next
			if cnn.Errors.Count > 0 then 
			   ErrMsg = cnn.Errors(0).description	   
			   cnn.close
			   response.Write("503/@/Error Conexión:" & sql)
			   response.End() 			   
			end if		
			if not rs.eof then
				MET_Descripcion=rs("MET_Descripcion")
			end if%>
			<div class="col-sm-12 col-md-4 col-lg-4">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-percentage input-prefix"></i>
							<input type="text" class="form-control" readonly="" value="<%=PorTot2%>">
						<span class="select-bar"></span>
						<label for="" class="active">% de horas <%=MET_DEscripcion%></label>									
					</div>
				</div>			
			</div><%
		end if%>
	</div>
	
	<div class="row">
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s5" name="btn_frm12s5"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="5" />		
	
</form>

<script>
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
	
	$(document).ready(function() {	
		$("#btn_frm12s5").click(function(){
			formValidate("#frm12s5")
			if($("#frm12s5").valid()){
				if(Number($('#Horas_Pedagogicas').val())<$('#PRY_HorasPedagogicasMin').val()){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'La planificación esta incompleta.',						
						text:'El total de horas pedagógicas planificadas es menor al requerido (<%=PRY_HorasPedagogicasMin%>)'
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
								  title: 'Metodología grabada correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};							
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