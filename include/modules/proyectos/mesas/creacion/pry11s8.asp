<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	'response.write("200/@/" & LIN_Id & "-" & mode & "-" & PRY_Id)
	
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
		action="/mod-11-h0-s8"
		columns="{data: ""TPR_Id""},{data: ""PPR_Id""},{data: ""TPR_Nombre""},{className: 'delmodadd',orderable: false,data: ""Del""}"				
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
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
		columns="{data: ""TPR_Id""},{data: ""PPR_Id""},{data: ""TPR_Nombre""}"
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
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end%>
	<h5>Exposición Adicional</h5><%
	if(mode="mod") then%>
		<h6>Nombre de la Exposición</h6>
		<form role="form" action="/agregar-tematica" method="POST" name="frm11s7_1" id="frm11s7_1" class="needs-validation">			
			<div class="row"> 
				<div class="col-xs-12 col-sm-12 col-md-11 col-lg-11">
					<div class="md-form input-with-post-icon">
						<div class="error-message">								
							<i class="fas fa-tag input-prefix"></i>							
							<input type="text" id="TPR_Nombre" name="TPR_Nombre" class="form-control" <%=disabled%>>
							<span class="select-bar"></span>
							<label for="TPR_Nombre" class="<%=lblClass%>">Exposición Adicional</label>									
						</div>
					</div>
				</div>			
				<div class="col align-self-end">
					<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s7_1" name="btn_frm11s7_1" style="float: right;"><i class="fas fa-plus"></i></button>
				</div>
			</div>
			<input type="hidden" id="PRY_Id" value="<%=PRY_Id%>" name="PRY_Id">
			<input type="hidden" id="PRY_Identificador" value="<%=PRY_Identificador%>" name="PRY_Identificador">
		</form><%
	end if%>
	
	<h6>Exposición(es) Adicional(es) incorporada(s)</h6>
	<div class="row" style="padding-top:20px">		
		<div class="col-12">
			<table id="tbl-modadi" class="ts table table-striped table-bordered dataTable table-sm" data-id="modadi" data-page="true" data-selected="true" data-keys="1"> 
				<thead> 
					<tr> 
						<th style="width:10px;">Id</th>
						<th style="width:10px;">Id</th>
						<th>Exposición</th><%
						if(mode="mod") then%>
							<th>Eliminar</th><%
						end if%>
					</tr> 
				</thead>					
				<tbody> 
				<%
					set rs=cnn.execute("exec spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "',-1")
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   
						Response.end()
					End If
					dataModulosAdd = "["
					do While Not rs.EOF
						if(mode="mod") then
							dataModulosAdd = dataModulosAdd & "{""TPR_Id"":""" & rs("TPR_Id") & """,""PPR_Id"":""" & rs("PPR_Id") & """,""TPR_Nombre"":""" & rs("TPR_Nombre") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-tpr='" & rs("TPR_Id") & "' data-pry='" & PRY_Id & "' data-ppr='" & rs("PPR_Id") & "'></i>"""
						else
							dataModulosAdd = dataModulosAdd & "{""TPR_Id"":""" & rs("TPR_Id") & """,""PPR_Id"":""" & rs("PPR_Id") & """,""TPR_Nombre"":""" & rs("TPR_Nombre") & """"
						end if
						dataModulosAdd = dataModulosAdd & "}"											
						rs.movenext
						if not rs.eof then
							dataModulosAdd = dataModulosAdd & ","
						end if
					loop
					dataModulosAdd=dataModulosAdd & "]"								
					rs.close											
				%>                	
				</tbody>
			</table>
		</div>
	</div>		
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm11s7" id="frm11s7" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s7" name="btn_frm11s7"><%=txtBoton%></button>
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
					<input type="hidden" id="Step" name="Step" value="8" />		
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
					
		var modaddTable;
		var dataModulosAdd = <%=dataModulosAdd%>
		loadTableModulosAdd(dataModulosAdd);
        $('#tbl-modadi').css('width','100%')
		
		function loadTableModulosAdd(data) {			
			modaddTable = $('#tbl-modadi').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columns%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		$("#btn_frm11s7_1").click(function(){
			formValidate("#frm11s7_1")
			if($("#frm11s7_1").valid()){
				$.ajax({
					type: 'POST',			
					url: $("#frm11s7_1").attr("action"),
					data: $("#frm11s7_1").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						modaddTable.clear().draw();
						modaddTable.rows.add(jQuery.parseJSON(param[1])).draw();						
						if(param[0]=="200"){
							$("#frm11s7_1")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Módulo adicional agregado correctamente'
							});							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del Módulo adicional',					
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
		
		$("#pry-content").on("click",".delmodadd",function(e){
			e.preventDefault();
			e.stopPropagation();
			var TPR_Id = $(this).children().data("tpr");			
			var PRY_Id = $(this).children().data("pry");
			var PRY_Identificador = $("#PRY_Identificador").val();
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el módulo seleccionado",
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
						url: '/elimina-tematica',
						data: {PRY_Id:PRY_Id, TPR_Id:TPR_Id, PRY_Identificador:PRY_Identificador},
						success: function(data) {					
							param=data.split(bb);
							modaddTable.clear().draw();
							modaddTable.rows.add(jQuery.parseJSON(param[1])).draw();							
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Módulo Adicional eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar módulo adicional',					
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
		
		$("#btn_frm11s7").click(function(){
			formValidate("#frm11s7")
			if($("#frm11s7").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm11s7").attr("action"),
					data: $("#frm11s7").serialize(),
					success: function(data) {					
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Módulos adicionales grabados correctamente'
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
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
	});
</script>