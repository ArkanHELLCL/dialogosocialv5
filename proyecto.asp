<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%
	mode=request("mode")
	LIN_Id=request("key1")
	PRY_Id=request("key2")	
	PRY_Hito=request("key3")	'Hito seleccionado
	CRT_Step=request("key4")	'Paso seleccionado
		
	if(PRY_Id="") then
		PRY_Id=0
	end if
	PRY_Step=0
	if LIN_Id="" then
		response.Write("1/@/Error de parámetros")
	   	response.End() 			   
	end if
	if(trim(lcase(mode))="add" and (session("ds5_usrperfil")<>1 and session("ds5_usrperfil")<>2)) then
		response.Write("403/@/Perfil no autorizado")
	   	response.End() 			   
	end if
	if(trim(lcase(mode))="mod" and (session("ds5_usrperfil")=4)) then
		'response.Write("403/@/Perfil no autorizado")
	   	'response.End() 			   
		mode="vis"
		modo=4
	end if		
	
	gradiente="blue-gradient"	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			

	sql="exec spLinea_Consultar " & LIN_Id
	set rs = cnn.Execute(sql)
	if not rs.eof then		
		titulo = rs("LFO_Nombre") & " " & rs("LIN_Nombre")
		LFO_Id = rs("LFO_Id")		
	end if		
		
	response.write("200/@/")
	'response.write(mode & "-" & LIN_Id & "-" & PRY_Id & "-" & PRY_Hito & "-" & CRT_Step)
	'response.end
	if (mode="add") then
		PRY_Hito=0
		CRT_Step=1
		PRY_Id=0		
		modo=1
	else
		if (mode="mod") then
			modo=2
		else
			modo=4
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
			PRY_Step=rs("PRY_Step")
			PRY_Estado=rs("PRY_Estado")
			PRY_Identificador=rs("PRY_Identificador")
			PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
			PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
			PRY_InformeParcialEstado=rs("PRY_InformeParcialEstado")
			PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")	'Escuela/Cursos final
			PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")	'Mesas final


			USR_IdRevisor=rs("USR_IdRevisor")
			USR_IdEjecutor=rs("USR_IdEjecutor")
			LIN_Hombre= rs("LIN_Hombre")
			LIN_Mujer= rs("LIN_Mujer")
			PRY_IdLicitacion=rs("PRY_IdLicitacion")
			PRY_NombreLicitacion=rs("PRY_NombreLicitacion")
			FON_Nombre=rs("FON_Nombre")
			PRY_AnioProyecto = rs("PRY_AnioProyecto")
			if(CRT_Step="") then
				CRT_Step=PRY_Step
			end if
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if

		if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
			PRY_InformeFinalEstado=0
		end if

		if(PRY_InformeSistematizacionEstado="" or IsNULL(PRY_InformeSistematizacionEstado)) then
			PRY_InformeSistematizacionEstado=0
		end if

		aut=0
		if(PRY_InformeSistematizacionEstado=1 or PRY_InformeFinalEstado=1) then
			aut=1
		end if
	
	end if
	anio=year(date())
	if(mode="add") then
		PRY_Anio = anio
		Proyecto = "Nuevo Proyecto"
	else
		PRY_Anio = PRY_AnioProyecto
		Proyecto = "Proyecto " & PRY_Id
	end if
	titulo = Proyecto & " - " & titulo & " - " & PRY_Anio
	
	mnuarc="/mnu-" & LFO_Id	
	'response.write(archivo)
	'response.write(CRT_Step)
	'response.write("mode: " & mode)	
	'response.write("Final: " & PRY_InformeFinalEstado & " - " & "Sistematizacion: " & PRY_InformeSistematizacionEstado & " - " & "Aut: " & aut)
%>
<div class="row container-header">

</div>
<!--container-body-->
<div class="row container-body">	
	<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
		<!-- Table with panel -->					
		<div class="card card-cascade narrower">
			<!--Card image-->
			<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center" style="height:3rem;">
				<div>
				</div>
				<a href="" class="white-text mx-3"><i class="fas fa-book"></i> <%=titulo%></a>
				<div>
				</div>
			</div>
			<!--/Card image-->
			<div class="px-4">
				<div class="row">
					<div class="col-auto div">
						<div id="pry-menu">
							<div class="res" id="pasos" disabled></div>
							<div class="res" id="hitos" disabled></div>
							<div class="res" id="menus" disabled></div>							
							<i class="fas fa-thumbtack pin text-primary"></i>
							<div id="pry-menucontent"></div>
						</div>
					</div>
					<div class="col">
						<div id="pry-scrollconten">
							<div id="pry-content"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Table with panel -->		
	</div>	  	
</div>
<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>"/>
<input type="hidden" id="CRT_Step" name="CRT_Step" value="<%=CRT_Step%>"/>
<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>"/>
<input type="hidden" id="PRY_Hito" name="PRY_Hito" value="<%=PRY_Hito%>"/>
<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>"/>
<!--container-body--><%

if(mode<>"add") then%>
	<!-- Modal Alumnos-->
	<div class="modal fade bottom" id="alumnosModal" tabindex="-1" role="dialog" aria-labelledby="alumnosModalLabel" aria-hidden="true" data-backdrop="false" data-keyboard="false">		
	</div>
	<!-- Modal Alumnos-->	
	<!-- Modal Contratos-->
	<div class="modal fade in" id="contratosModal" tabindex="-1" role="dialog" aria-labelledby="contratosModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Contratos-->	
	<!-- Modal Planificacion-->
	<div class="modal fade bottom" id="planificacionModal" tabindex="-1" role="dialog" aria-labelledby="planificacionModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Planificacion-->
	<!-- Modal MediosGraficos-->
	<div class="modal fade bottom" id="mediosgraficosModal" tabindex="-1" role="dialog" aria-labelledby="mediosgraficosModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal MediosGraficos-->
	<!-- Modal Presupuestos-->
	<div class="modal fade bottom" id="presupuestosModal" tabindex="-1" role="dialog" aria-labelledby="presupuestosModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Presupuestos-->
	<!-- Modal Asistencia-->
	<div class="modal fade bottom" id="asistenciaModal" tabindex="-1" role="dialog" aria-labelledby="asistenciaModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Asistencia-->
	<!-- Modal Calificaciones-->
	<div class="modal fade bottom" id="calificacionModal" tabindex="-1" role="dialog" aria-labelledby="calificacionModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Calificaciones-->
	<!-- Modal Adecuaciones-->
	<div class="modal fade bottom" id="adecuacionesModal" tabindex="-1" role="dialog" aria-labelledby="adecuacionesModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Adecuaciones-->
	<!-- Modal Verificadores-->
	<div class="modal fade bottom" id="verificadoresModal" tabindex="-1" role="dialog" aria-labelledby="verificadoresModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Verificadores-->
	<!-- Modal Mensajes-->
	<div class="modal fade bottom" id="mensajespryModal" tabindex="-1" role="dialog" aria-labelledby="mensajespryModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Mensajes-->
	<!-- Modal Representantes-->
	<div class="modal fade bottom" id="RepresentantesModal" tabindex="-1" role="dialog" aria-labelledby="RepresentantesModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Representantes-->
	<!-- Modal GruposFocales-->
	<div class="modal fade bottom" id="gruposfocalesModal" tabindex="-1" role="dialog" aria-labelledby="gruposfocalesModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal GruposFocales-->
	<!-- Modal Incumpliimientos-->
	<div class="modal fade bottom" id="incumplimientosModal" tabindex="-1" role="dialog" aria-labelledby="incumplimientosModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Incumpliimientos-->
	<!-- Modal Verificadores Mesas-->
	<div class="modal fade bottom" id="verificadoresModalMesas" tabindex="-1" role="dialog" aria-labelledby="verificadoresModalMesasLabel" aria-hidden="true">		
	</div>
	<!-- Modal Verificadores Mesas--><%
end if%>

<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>

<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	
	$(document).ready(function() {
		var LIN_Id=$("#LIN_Id").val();
		var PRY_Hito=$("#PRY_Hito").val();
		var PRY_Id=$("#PRY_Id").val();
		var CRT_Step=$("#CRT_Step").val();
		var PRY_Identificador=$("#PRY_Identificador").val();
		var data={modo:<%=modo%>,CRT_Step:CRT_Step,PRY_Id:PRY_Id,LIN_Id:LIN_Id,PRY_Hito:PRY_Hito,PRY_Identificador:PRY_Identificador};
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);					
		$("#pry-menu, #pry-scrollconten").mCustomScrollbar({
			theme:scrollTheme,
		})			
		cargamenu();
		cargabreadcrumb("/breadcrumbs","");				
		$.fn.modal.Constructor.prototype.enforceFocus = function () {
		$(document)
		  .off('focusin.bs.modal') // guard against infinite focus loop
		  .on('focusin.bs.modal', $.proxy(function (e) {
			if (this.$element[0] !== e.target && !this.$element.has(e.target).length) {
			  this.$element.focus()
			}
		  }, this))
		}
		
		function cargamenu(){
			$.ajax( {
				type:'POST',					
				url: '<%=mnuarc%>',
				data: data,
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){						
						$("#pry-menucontent").html(param[1]);
						var hitosPos = $("#pry-menu ul").find("li.category.hitos").position();
						var pasosPos = $("#pry-menu ul").find("li.category.pasos").position();
						var menusPos = $("#pry-menu ul").find("li.category.menus").position();						
						
						if($("li.category.hitos").index()==0){
							$("#hitos").css("top",hitosPos.top + "px")
							$("#hitos").show();
						}else{
							$("#hitos").css("top",(hitosPos.top + 18) + "px")
							$("#hitos").show();
						}
						if($("li.category.pasos").index()==0){
							$("#pasos").css("top",pasosPos.top + "px")
							$("#pasos").show();
						}else{
							$("#pasos").css("top",(pasosPos.top + 18) + "px")
							$("#pasos").show();
						}						
						if(menusPos!=undefined){
							if($("li.category.menus").index()==0){
								$("#menus").css("top",menusPos.top + "px")
								$("#menus").show();
							}else{
								$("#menus").css("top",(menusPos.top + 18) + "px")
								$("#menus").show();
							}
						}																		
						
						if(pinmenu){							
							$("#pry-menu").addClass("show");
						}else{							
						}
						
						$(".pin").click(function(){
							$("#pry-menu").toggleClass("show");
							if(pinmenu){
								pinmenu = false;
							}else{
								pinmenu = true;
							}							
						});
						if(firsttimenu && !pinmenu){
							setTimeout(function() {
								$("#pry-menu").toggleClass("show");	
								firsttimenu = false;
								setTimeout(function() {						
									moveMark(true);									
									if(!pinmenu){
										setTimeout(function() {			
											$("#pry-menu").toggleClass("show");
										}, 1000);
									}
								}, 1000);				
							}, 1000);
						}else{
							setTimeout(function() {						
								moveMark(true);								
							}, 1000);		
						}
						
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
		};
				
		$("#pry-menu").on("click",".menus",function(e){
			e.preventDefault();
			e.stopPropagation();
			
			$(".menus").removeClass("active");
			$(".menus a").removeClass("current");
			$(this).addClass("active");
			moveMark(false);			
			var ajaxurl=$(this).children().data("url");							
			$.ajax( {
				type:'POST',					
				url: ajaxurl,
				data: data,
				success: function ( data ) {
					param = data.split(bb)
					if(param[0]==200){							
						$(param[1]).html(param[2]);						
						if(ajaxurl=="/mediosgraficos-modal"){
							$.ajaxSetup({
								async: false
							});
							$.getScript('<%=HostName%>/appl/uploadfile/js/vendor/jquery.ui.widget.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/tmpl.min.js', function() {});
							$.getScript('<%=HostName%>/vendor/gallery/js/load-image.all.min.js', function() {});						
							$.getScript('<%=HostName%>/vendor/gallery/js/canvas-to-blob.min.js', function() {});
							$.getScript('<%=HostName%>/vendor/gallery/js/jquery.blueimp-gallery.min.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.iframe-transport.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-process.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-image.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-audio.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-video.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-validate.js', function() {});						
							$.getScript('<%=HostName%>/appl/uploadfile/js/jquery.fileupload-ui.js', function() {});
							$.getScript('<%=HostName%>/appl/uploadfile/js/main.js', function() {});		
							$.ajaxSetup({
								async: true
							});
						}
						moveMark(false);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto.',					
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
		})		
																				
		$(".modal").on('hidden.bs.modal', function(){
			$(".menus").removeClass("active");
			$(".menus a").removeClass("current");
			$(".menus").first("li").addClass("active")						
			moveMark(false);				
		});											
		
		$("#pry-menu").on("click",".step, .hitos",function(e){
			e.preventDefault();
			e.stopPropagation();
			var sPRY_Hito = $(this).data("hito");
			var sCRT_Step = $(this).data("step");
			var smodo	  = $(this).data("mode");	
			var ss		  = String.fromCharCode(47) + String.fromCharCode(47);
			var	pasos	  =  false;
			var	hitos	  =  false;
			var	menus	  =  false;

			if($(this).parent(".pasos")){
				pasos = true
			};
			if($(this).parent(".hitos")){
				hitos = true
			};
			if($(this).parent(".menus")){
				menus = true
			};
						
			var mnuarc = "/mnu-<%=LFO_Id%>"
			var PRY_Id = <%=PRY_Id%>
			if(PRY_Id==0 || PRY_Id==""){
				var href = window.location.href;
				var newhref = href.substr(href.indexOf("/home")+6,href.length);
				var href_split = newhref.split("/");
				PRY_Id=href_split[3];
			}
			var data   = {modo:smodo,CRT_Step:sCRT_Step,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,PRY_Hito:sPRY_Hito};			
			var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);			
			$.ajax( {
				type:'POST',					
				url: mnuarc,
				data: data,
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){	
						
						$("#pry-menucontent").html(param[1]);						
						moveMark(false);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto1',					
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
		})								

		$("#pry-content").on("click","#btn_avanzar, #btn_retroceder",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var split_href 	= window.location.href.split("/");
			var LIN_Id		= split_href[6];
			var PRY_Id		= split_href[7];
			var PRY_Hito	= split_href[8];
			var CRT_Step	= parseInt(split_href[9]);
			var mnuarc 		= "/mnu-<%=LFO_Id%>"
			if(window.location.href.indexOf("modificar")>0){
				modo=2
			}
			if(window.location.href.indexOf("visualizar")>0){
				modo=4
			}
			if($(this).attr("id")=="btn_avanzar"){
				CRT_Step=CRT_Step+1
			}
			if($(this).attr("id")=="btn_retroceder"){
				CRT_Step=CRT_Step-1
			}			
			var data   		= {modo:modo,CRT_Step:CRT_Step,PRY_Id:PRY_Id,LIN_Id:LIN_Id,PRY_Hito:PRY_Hito};			
			var sas 		= String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
						
			$.ajax( {
				type:'POST',					
				url: mnuarc,
				data: data,
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){	
						
						$("#pry-menucontent").html(param[1]);
						moveMark(false);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto1',					
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
		})
		
		$("btn_obsopen").on("click",function(){

		})		

		$("#pry-menucontent").on("click",".generar,.descargar,.historico,.abririnforme,.enviarmail",function(e){
			e.preventDefault();
			e.stopPropagation();
			
			var LFO_Id = <%=LFO_Id%>;
			var INF_Nombre = $(this).data("file");
			var INF_Id = $(this).data("id");
			var PRY_Hito = $(this).data("hito");
			var PRT_Informe = $(this).data("prt");
			
			var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador, PRY_Hito:PRY_Hito, INF_Id:INF_Id, mnuarc:'<%=mnuarc%>'};
			if($(this).hasClass("generar")){
				swalWithBootstrapButtons.fire({
					title: 'Generación de Informe',
					text: '¿Seguro que quieres generar el archivo ' + INF_Nombre + '?',
					icon: 'question',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Generar!',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
				}).then((result) => {
					if (result.value) {
						/*$.post("/genera-informe-pdf", data, function(data){						
							var param = data.split(sas);
							if(param[0]==200){												
								$("body").append("<div id='pry-reportpdf'></div>")							
								$("#pry-reportpdf").html(param[1]);														
								Toast.fire({
								  icon: 'success',
								  title: 'El archivo ' + INF_Nombre + ' fue generado exitosamante'
								});							
								$("#pry-reportpdf").remove();								
							}
						})*/						
						wrk_informes(PRT_Informe,INF_Nombre,PRY_Id,PRY_Identificador,'<%=mnuarc%>',<%=session("ds5_usrid")%>,'<%=session("ds5_usrtoken")%>');
					}
				})
			}
			
			if($(this).hasClass("descargar")){				
				var INF_Arc=$(this).data("file");				
				var PRY_Hito=$(this).data("hito");
				var ALU_Rut;
				var VER_Corr;

				var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador, INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut};			

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
			}
			
			if($(this).hasClass("historico")){
				ajax_icon_handling('load','Buscando informes históricos','','');
				$.ajax({
					type: 'POST',								
					url:'/listar-informes-historicos',			
					data:data,
					success: function(data) {
						var param=data.split(sas);			
						if(param[0]=="200"){				
							ajax_icon_handling(true,'Listado de informes históricos creado.','',param[1]);
							$(".swal2-popup").css("width","60rem");
							loadtables("#tbl-historico");
							$(".arcalm").click(function(){
								var INF_Arc = $(this).data("file");
								var PRY_Hito=$(this).data("hito");
								var ALU_Rut;
								var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador, INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut};			
								
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
							ajax_icon_handling(false,'No fue posible crear el listado de archivos historicos.','','');
						}						
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						ajax_icon_handling(false,'No fue posible crear el listado de archivos historicos.','','');	
					},
					complete: function(){																		
					}
				})
			}
			
			if($(this).hasClass("abririnforme")){
				var INF_Nombre = $(this).data("file");				
				var Hito = $(this).data("des");

				swalWithBootstrapButtons.fire({
					title: 'Abrir Informe ' + Hito,
					text: '¿Seguro que quieres abrir el Hito ' + Hito + ' y todos los hitos cerrados que esten bajo éste?',
					icon: 'question',
					input: 'textarea',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Abrir!',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, Cancelar!',
					inputValidator: (value) => {
						if (!value) {
							return 'Debes escribir una observación';
						}
					}
				}).then((result) => {
					if (result.value) {
						//console.log(result.value)
						var data={PRY_Id:PRY_Id,PRY_Identificador:PRY_Identificador,PRY_Hito:PRY_Hito, MEN_Texto:result.value};
						$.ajax({
							type: 'POST',			
							url: '/abrir-informe',
							data: data,
							success: function(data) {					
								param=data.split(sas);						
								if(param[0]=="200"){									
									Toast.fire({
										icon: 'success',
										title: 'Apertura del informe ' + Hito + ' exitosa!'
									});
									var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>};
									$.ajax( {
										type:'POST',					
										url: '/mnu-<%=LFO_Id%>',
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
										title: 'Ups!, no pude abrir el Hito',					
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
			}			
			
			if($(this).hasClass("enviarmail")){
				swalWithBootstrapButtons.fire({
					title: $(this).data("original-title"),
					text: '¿Seguro que quieres reenviar el mail a todos los destinatarios?',
					icon: 'question',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Enviar!',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
				}).then((result) => {
					if (result.value) {
						$.post("/reenviar-mail-aceptacion", data, function(data){						
							var param = data.split(sas);
							if(param[0]==200){											
								Toast.fire({
								  icon: 'success',
								  title: 'El envío del mail de aceptación fue enviado exitosamente.'
								});								
							}
						})
					}else{
						Toast.fire({
						  icon: 'info',
						  title: 'El envío del mail de aceptación fue cancelado.'
						});		
					}
				})
			}
						
		})				
		
	});
</script>

<script id="template-upload-1" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
	<tr class="template-upload fade">
		<td>
			<span class="preview"></span>
		</td>
		<td>
			<p class="name">{%=file.name%}</p>
			<strong class="error text-danger"></strong>
		</td>					
		<td>
			<input type="hidden" name="pryid[]" value="<%=PRY_Id%>"></p>
		</td>
		<td>
			<label class="title">
				<span>Title:</span><br>
				<input name="title[]" class="form-control">
			</label>
		</td>
		<td>
			<label class="description">
				<span>Description:</span><br>
				<input name="description[]" class="form-control">
			</label>
		</td>


		<td>
			<p class="size">Processing...</p>
			<div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
		</td>
		<td>
			{% if (!i && !o.options.autoUpload) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-primary start" disabled>
					<i class="glyphicon glyphicon-upload"></i>
					<span>Subir</span>
				</button>
			{% } %}
			{% if (!i) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-warning cancel">
					<i class="glyphicon glyphicon-ban-circle"></i>
					<span>Cancelar</span>
				</button>
			{% } %}
		</td>
	</tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download-1" type="text/x-tmpl">
{%
	var xhref = window.location.href;
	var xnewhref = xhref.substr(xhref.indexOf("/home")+6,xhref.length);
	var xhref_split = xnewhref.split("/");
	var mode=xhref_split[1];
	var aut=<%=aut%>;	
%}
{% for (var i=0, file; file=o.files[i]; i++) { %}
	<tr class="template-download fade">
		<td>
			<span class="preview">
				{% if (file.thumbnailUrl) { %}
					<a href="{%=file.url%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito={%=$('#PRY_Hito').val()%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito={%=$('#PRY_Hito').val()%}"></a>
				{% } %}
			</span>
		</td>
		<td>
			<p class="name">
				{% if (file.url) { %}
					<a href="{%=file.url%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito={%=$('#PRY_Hito').val()%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
				{% } else { %}
					<span>{%=file.name%}</span>
				{% } %}
			</p>
			{% if (file.error) { %}
				<div><span class="label label-danger">Error</span> {%=file.error%}</div>
			{% } %}
		</td>
		<td>
			<p class="title">{%=file.title%}</p>
		</td>
		<td>
			<p class="description">{%=file.description%}</p>
		</td>
		<td>
			<span class="size">{%=o.formatFileSize(file.size)%}</span>
		</td>
		<td>{%
			//if(mode!="visualizar" && aut==0) { 
			if(aut==0){ %}
			{% if (file.deleteUrl) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito={%=$('#PRY_Hito').val()%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
					<i class="glyphicon glyphicon-trash"></i>
					<span>Borrar</span>
				</button>                            
				<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
					<label class="input-checkbox checkbox-lightBlue">
						<input type="checkbox" id="VPM_Comprometida" name="VPM_Comprometida" name="delete" value="1" class="toggle">
						<span class="checkbox"></span>
					</label>
				</div>
			{% } else { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-warning cancel">
					<i class="glyphicon glyphicon-ban-circle"></i>
					<span>Cancelar</span>
				</button>
			{% } %}
			{% } %}
		</td>
	</tr>
{% } %}
</script>
<script id="template-upload-2" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
	<tr class="template-upload fade">
		<td>
			<span class="preview"></span>
		</td>
		<td>
			<p class="name">{%=file.name%}</p>
			<strong class="error text-danger"></strong>
		</td>					
		<td>
			<input type="hidden" name="pryid[]" value="<%=PRY_Id%>"></p>
		</td>
		<td>
			<label class="title">
				<span>Title:</span><br>
				<input name="title[]" class="form-control">
			</label>
		</td>
		<td>
			<label class="description">
				<span>Description:</span><br>
				<input name="description[]" class="form-control">
			</label>
		</td>


		<td>
			<p class="size">Processing...</p>
			<div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
		</td>
		<td>
			{% if (!i && !o.options.autoUpload) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-primary start" disabled>
					<i class="glyphicon glyphicon-upload"></i>
					<span>Subir</span>
				</button>
			{% } %}
			{% if (!i) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-warning cancel">
					<i class="glyphicon glyphicon-ban-circle"></i>
					<span>Cancelar</span>
				</button>
			{% } %}
		</td>
	</tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download-2" type="text/x-tmpl">
{%
	var xhref = window.location.href;
	var xnewhref = xhref.substr(xhref.indexOf("/home")+6,xhref.length);
	var xhref_split = xnewhref.split("/");
	var mode=xhref_split[1];
	var aut=<%=aut%>;	
%}
{% for (var i=0, file; file=o.files[i]; i++) { %}
	<tr class="template-download fade">
		<td>
			<span class="preview">
				{% if (file.thumbnailUrl) { %}
					<a href="{%=file.url%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito=99" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito=99"></a>
				{% } %}
			</span>
		</td>
		<td>
			<p class="name">
				{% if (file.url) { %}
					<a href="{%=file.url%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito=99" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
				{% } else { %}
					<span>{%=file.name%}</span>
				{% } %}
			</p>
			{% if (file.error) { %}
				<div><span class="label label-danger">Error</span> {%=file.error%}</div>
			{% } %}
		</td>
		<td>
			<p class="title">{%=file.title%}</p>
		</td>
		<td>
			<p class="description">{%=file.description%}</p>
		</td>
		<td>
			<span class="size">{%=o.formatFileSize(file.size)%}</span>
		</td>
		<td>{%
			//if(mode!="visualizar" && aut==0){ 
			if(aut==0){	%}
			{% if (file.deleteUrl) { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}&PRY_Id=<%=PRY_Id%>&PRY_Identificador=<%=PRY_Identificador%>&PRY_Hito=99"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
					<i class="glyphicon glyphicon-trash"></i>
					<span>Borrar</span>
				</button>                            
				<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
					<label class="input-checkbox checkbox-lightBlue">
						<input type="checkbox" id="VPM_Comprometida" name="VPM_Comprometida" name="delete" value="1" class="toggle">
						<span class="checkbox"></span>
					</label>
				</div>
			{% } else { %}
				<button class="btn btn-rounded btn-sm waves-effect btn-warning cancel">
					<i class="glyphicon glyphicon-ban-circle"></i>
					<span>Cancelar</span>
				</button>
			{% } %}
			{% } %}
		</td>
	</tr>
{% } %}
</script>