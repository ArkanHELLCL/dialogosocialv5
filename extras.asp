<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%
	tipo=request("type")
	key1=request("key1")
	key2=request("key2")
	
	if(tipo="") then
		tipo=mid(key1,1,3)
	end if
	
	if(tipo="man") then
		titulo="<i class='fas fa-server'></i> Mantenedores"
	end if
	if(tipo="rep") then
		titulo="<i class='fas fa-print'></i> Reportes"
	end if
	if((session("ds5_usrperfil")=3)) then
		response.Write("403/@/Perfil no autorizado")
	   	response.End() 			   
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
		
	response.write("200/@/")
	'response.write(tipo & "-" & key1 & "-" & key2)
	'response.end	
		
	'response.write(archivo)
	'response.write(CRT_Step)
	'response.write("mode: " & mode)
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
				<a href="" class="white-text mx-3"><i class="fas fa-network-wired"></i> Funcionalidades extras</a>
				<div>
				</div>
			</div>
			<!--/Card image-->
			<div class="px-4">
				<div class="row">
					<div class="col-auto div">						
						<div id="pry-menu">							
							<div class="res" id="reportes" disabled></div>
							<div class="res" id="mantenedores" disabled></div>							
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
<!--container-body--><%

if(session("ds5_usrperfil")<>3) then 'todos menos ejecutor%>	
	<!-- Modal Sindicatos-->
	<div class="modal fade bottom" id="sindicatosModal" tabindex="-1" role="dialog" aria-labelledby="sindicatosModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal Sindicatos-->
	<!-- Modal Linea Formativa-->
	<div class="modal fade bottom" id="lineaformativaModal" tabindex="-1" role="dialog" aria-labelledby="lineaformativaLabel" aria-hidden="true">		
	</div>
	<!-- Modal Linea Formativa-->
	<!-- Modal Lineas-->
	<div class="modal fade bottom" id="lineasModal" tabindex="-1" role="dialog" aria-labelledby="lineasLabel" aria-hidden="true">		
	</div>
	<!-- Modal Lineas-->
	<!-- Modal Usuarios-->
	<div class="modal fade bottom" id="usuariosModal" tabindex="-1" role="dialog" aria-labelledby="usuariosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Usuarios-->
	<!-- Modal Afilaicion Central-->
	<div class="modal fade bottom" id="aficentralModal" tabindex="-1" role="dialog" aria-labelledby="aficentralLabel" aria-hidden="true">		
	</div>
	<!-- Modal Afilaicion Central-->
	<!-- Modal Rubros-->
	<div class="modal fade bottom" id="rubrosModal" tabindex="-1" role="dialog" aria-labelledby="rubrosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Rubros-->
	<!-- Modal Cursos-->
	<div class="modal fade bottom" id="cursosModal" tabindex="-1" role="dialog" aria-labelledby="cursosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Cursos-->
	<!-- Modal Perspectivas-->
	<div class="modal fade bottom" id="perspectivasModal" tabindex="-1" role="dialog" aria-labelledby="perspectivasLabel" aria-hidden="true">		
	</div>
	<!-- Modal Perspectivas-->
	<!-- Modal Módulos-->
	<div class="modal fade bottom" id="modulosModal" tabindex="-1" role="dialog" aria-labelledby="modulosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Módulos-->
	<!-- Modal Educacional-->
	<div class="modal fade bottom" id="educacionModal" tabindex="-1" role="dialog" aria-labelledby="educacionLabel" aria-hidden="true">		
	</div>
	<!-- Modal Educacional-->
	<!-- Modal Nacionalidades-->
	<div class="modal fade bottom" id="nacionalidadesModal" tabindex="-1" role="dialog" aria-labelledby="nacionalidadesLabel" aria-hidden="true">		
	</div>
	<!-- Modal Nacionalidades-->
	<!-- Modal Organizacion-->
	<div class="modal fade bottom" id="organizacionModal" tabindex="-1" role="dialog" aria-labelledby="organizacionLabel" aria-hidden="true">		
	</div>
	<!-- Modal Organizacion-->
	<!-- Modal Empresas-->
	<div class="modal fade bottom" id="empresasModal" tabindex="-1" role="dialog" aria-labelledby="empresasLabel" aria-hidden="true">		
	</div>
	<!-- Modal Empresas-->
	<!-- Modal Ministerios-->
	<div class="modal fade bottom" id="ministeriosModal" tabindex="-1" role="dialog" aria-labelledby="ministeriosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Ministerios-->
	<!-- Modal Servicios-->
	<div class="modal fade bottom" id="serviciosModal" tabindex="-1" role="dialog" aria-labelledby="serviciosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Servicios-->
	<!-- Modal NivelDialogo-->
	<div class="modal fade bottom" id="niveldialogoModal" tabindex="-1" role="dialog" aria-labelledby="niveldialogoLabel" aria-hidden="true">		
	</div>
	<!-- Modal NivelDialogo-->
	<!-- Modal Hitos-->
	<div class="modal fade bottom" id="hitosModal" tabindex="-1" role="dialog" aria-labelledby="hitosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Hitos-->
	<!-- Modal Documentos-->
	<div class="modal fade bottom" id="documentosModal" tabindex="-1" role="dialog" aria-labelledby="documentosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Documentos-->
	<!-- Modal Departamentos-->
	<div class="modal fade bottom" id="departamentosModal" tabindex="-1" role="dialog" aria-labelledby="departamentosLabel" aria-hidden="true">		
	</div>
	<!-- Modal Departamentos-->
	<!-- Modal Civiles-->
	<div class="modal fade bottom" id="civilesModal" tabindex="-1" role="dialog" aria-labelledby="civilesLabel" aria-hidden="true">		
	</div>
	<!-- Modal Civiles-->
	<!-- Modal TipoDiscapacidad-->
	<div class="modal fade bottom" id="tipodiscapacidadModal" tabindex="-1" role="dialog" aria-labelledby="tipodiscapacidadLabel" aria-hidden="true">		
	</div>
	<!-- Modal TipoDiscapacidad-->
	<!-- Modal TipoTrabajador-->
	<div class="modal fade bottom" id="tipotrabajadorModal" tabindex="-1" role="dialog" aria-labelledby="tipotrabajadorLabel" aria-hidden="true">		
	</div>
	<!-- Modal TipoTrabajador-->
	<!-- Modal EmpEjecutora-->
	<div class="modal fade bottom" id="empejecutoraModal" tabindex="-1" role="dialog" aria-labelledby="empejecutoraModalLabel" aria-hidden="true">		
	</div>
	<!-- Modal EmpEjecutora-->
	<!-- Modal Bases-->
	<div class="modal fade bottom" id="basesModal" tabindex="-1" role="dialog" aria-labelledby="basesLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Bases-->
	<!-- Modal Linea Formatica Licitacion-->
	<div class="modal fade bottom" id="lineaformativalicitacionModal" tabindex="-1" role="dialog" aria-labelledby="lineaformativalicitacionLabel" aria-hidden="true">		
	</div>
	<!-- Modal Linea Formatica Licitacion-->
	<!-- Modal Numeral Multas-->
	<div class="modal fade bottom" id="numeralmultasModal" tabindex="-1" role="dialog" aria-labelledby="numeralmultasLabel" aria-hidden="true">		
	</div>
	<!-- Modal Numeral Multas-->
	<!-- Modal Incumplimiento-->
	<div class="modal fade bottom" id="incumplimientoModal" tabindex="-1" role="dialog" aria-labelledby="incumplimientoLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Incumplimiento-->
	<!-- Modal Gravedad Incumplimiento-->
	<div class="modal fade bottom" id="gravedadincumplimientoModal" tabindex="-1" role="dialog" aria-labelledby="gravedadincumplimientoLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Gravedad Incumplimiento-->
	<!-- Modal Moneda-->
	<div class="modal fade bottom" id="monedaModal" tabindex="-1" role="dialog" aria-labelledby="monedaLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Moneda-->
	<!-- Modal Documento Gobierno-->
	<div class="modal fade bottom" id="documentogobiernoModal" tabindex="-1" role="dialog" aria-labelledby="documentogobiernoLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Documento Gobierno-->
	<!-- Modal Fondos-->
	<div class="modal fade bottom" id="fondosModal" tabindex="-1" role="dialog" aria-labelledby="fondosLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Fondos-->
	<!-- Modal Tipos de Estados-->
	<div class="modal fade bottom" id="tiposestadosModal" tabindex="-1" role="dialog" aria-labelledby="tiposestadosLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Estados-->
	<!-- Modal Tipos de Mesas-->
	<div class="modal fade bottom" id="tipomesaModal" tabindex="-1" role="dialog" aria-labelledby="tipomesaLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Mesas-->
	<!-- Modal Tipos de Adecuaciones-->
	<div class="modal fade bottom" id="tipoadecuacionModal" tabindex="-1" role="dialog" aria-labelledby="tipoadecuacionLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Adecuaciones-->
	<!-- Modal Tipos de Ejecutor-->
	<div class="modal fade bottom" id="tipoejecutorModal" tabindex="-1" role="dialog" aria-labelledby="tipoejecutorLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Ejecutor-->
	<!-- Modal Unidad de Medida-->
	<div class="modal fade bottom" id="unidadmedidaModal" tabindex="-1" role="dialog" aria-labelledby="unidadmedidaLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Unidad de Medida-->
	<!-- Modal Bases Linea Formativa-->
	<div class="modal fade bottom" id="baseslineaModal" tabindex="-1" role="dialog" aria-labelledby="baseslineaLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Bases Linea Formativa-->
	<!-- Modal Tipos de Mensaje-->
	<div class="modal fade bottom" id="tipomensajeModal" tabindex="-1" role="dialog" aria-labelledby="tipomensajeLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Mensaje-->
	<!-- Modal Tipos de Metodologías-->
	<div class="modal fade bottom" id="tpometodologiaModal" tabindex="-1" role="dialog" aria-labelledby="tpometodologiaLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tipos de Metodologías-->
	<!-- Modal Beneficiarios-->
	<div class="modal fade bottom" id="beneficiariosModal" tabindex="-1" role="dialog" aria-labelledby="beneficiariosLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Beneficiarios-->
	<!-- Modal Relatores-->
	<div class="modal fade bottom" id="relatoresModal" tabindex="-1" role="dialog" aria-labelledby="relatoresLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Relatores-->
	<!-- Modal Festivos-->
	<div class="modal fade bottom" id="festivosModal" tabindex="-1" role="dialog" aria-labelledby="festivosLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Festivos-->
	<!-- Modal Tramo Etareo-->
	<div class="modal fade bottom" id="etareoModal" tabindex="-1" role="dialog" aria-labelledby="etareoLabel" aria-hidden="true">		
	</div>	
	<!-- Modal Tramo Etareo-->
	
	<!--Reportes-->
	<!--Estados de Alumnos-->
	<div class="modal fade bottom" id="repestadosalumnosModal" tabindex="-1" role="dialog" aria-labelledby="repestadosalumnosModalLabel" aria-hidden="true">		
	</div>
	<!--Estados de Alumnos-->
	<!--Reportes--><%
end if%>
	
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
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		
		
		$("#pry-menu, #pry-scrollconten").mCustomScrollbar({
			theme:scrollTheme,
			advanced:{
				autoExpandHorizontalScroll:true,
				updateOnContentResize:true,
				autoExpandVerticalScroll:true
			},
		});		
		
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
				//url: '/mnu-extras',
				url: '/funcionalidades',
				data:{type:'<%=tipo%>',subtype:'<%=key2%>'},
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){						
						$("#pry-menucontent").html(param[1]);
						var tipo='<%=tipo%>'
						if(tipo=="man"){
							animateMenu(".manmenu","mantenedores",".repmenu","reportes");
						}
						if(tipo=="rep"){
							animateMenu(".repmenu","reportes",".manmenu","mantenedores");
						}
						var reporPos = $("#pry-menu ul").find("li.category.reportes").position();
						var mantePos = $("#pry-menu ul").find("li.category.mantenedores").position();						
						
						if(reporPos!=undefined){
							if($("li.category.reportes").index()==0){
								$("#menus").css("top",reporPos.top + "px")
								$("#menus").show();
							}else{
								$("#menus").css("top",(reporPos.top + 18) + "px")
								$("#menus").show();
							}
						}
						if(mantePos!=undefined){
							if($("li.category.mantenedores").index()==0){
								$("#menus").css("top",mantePos.top + "px")
								$("#menus").show();
							}else{
								$("#menus").css("top",(mantePos.top + 18) + "px")
								$("#menus").show();
							}
						}
						
						if(pinmenu){							
							$("#pry-menu").addClass("show");
						}else{							
						}
						
						/*$(".pin").click(function(){
							$("#pry-menu").toggleClass("show");
							if(pinmenu){
								pinmenu = false;
							}else{
								pinmenu = true;
							}							
						});*/
						if(firsttimenu && !pinmenu){
							setTimeout(function() {
								$("#pry-menu").toggleClass("show");	
								firsttimenu = false;
								setTimeout(function() {									
									moveMark_2(true);
									if(!pinmenu){
										setTimeout(function() {			
											$("#pry-menu").toggleClass("show");
										}, 1000);
									}
								}, 1000);				
							}, 1000);
						}else{
							setTimeout(function() {								
								moveMark_2(true);
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
		
		$("#pry-menu").on("click",".repmenu",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			animateMenu(".repmenu","reportes",".manmenu","mantenedores");
			
		})				
		
		$("#pry-menu").on("click",".manmenu",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();												
									
			animateMenu(".manmenu","mantenedores",".repmenu","reportes");
		})				
		
		$("#pry-menu").on("click",".mnustep",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();												
			
			var url = $(this).data("url");
			if($(this).hasClass("reportes")){
				$(".reportes").removeClass("active");				
			}
			if($(this).hasClass("mantenedores")){
				$(".mantenedores.active").removeClass("active");				
				$(".mantenedores").find(".globo.act").removeClass("act");
				$(".mantenedores").find(".globo.on").removeClass("on");
				$(".mantenedores").find("a.current").removeClass("current");
				var menu=".mantenedores";
			}
			
			if($(this).hasClass("reportes")){
				$(".reportes.active").removeClass("active");				
				$(".reportes").find(".globo.act").removeClass("act");
				$(".reportes").find(".globo.on").removeClass("on");
				$(".reportes").find("a.current").removeClass("current");
				var menu=".reportes";
			}
			
			$(this).addClass("active")
			$(this).find("a i.globo").addClass("act");			
			moveMark_2(false);			
			
			pryarc(menu);
		})
		
		function animateMenu(menu,submenu,menu2,submenu2){
			$(menu).toggleClass("openmenu");
			
			$(menu).addClass("disabled");
			$(menu2).removeClass("disabled");
			
			$('li[class*="' + submenu + '"]:not(.category)').each(function(){
				$(this).toggleClass("menuToggle");
				var x_1 = setInterval(function(){ 
					moveMark_2(false);
					clearTimeout(x_1);
				},600)				
			});
						
			$(menu2).removeClass("openmenu");
			$('li[class*="' + submenu2 + '"]:not(.category)').each(function(){
				$(this).removeClass("menuToggle");						
			});
			
			$("#reportes").css("width","0");
			$("#mantenedores").css("width","0");

			var timerMenu_1 = setInterval(function(){
				moveMark_2(false);

				clearTimeout(timerMenu_1);
				var timerMenu_2 = setInterval(function(){
					$("#reportes").css("width","calc(100% + 10px)");
					$("#mantenedores").css("width","calc(100% + 10px)");					
					clearTimeout(timerMenu_2);
				}, 600);							
			}, 600);
			
			if($(menu).hasClass("openmenu")){				
				pryarc("." + submenu)
			};
		}
		
		function pryarc(menu){			
			var url=$(menu + ".mnustep.active").data("url");				
			var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
			$.ajax( {
				type:'POST',
				url: url,					
				success: function ( data ) {
					param = data.split(sas);						
					if(param[0]==200){	
						$("#pry-content").hide();																		
						$("#pry-content").html(param[1]);
						$("#pry-content").show("slow");
						moveMark_2(false);
					}else{
						$("#pry-content").hide();
						$("#pry-content").html("<div class='row'><h5 style='padding-right: 15px; padding-left: 15px; display: block;'>ERROR: No fue posible encontrar el módulo correspondiente. (" + url + ")</h5></div>");
						$("#pry-content").show("slow")				
					}					
					changeURL(menu.replace(".",""),url.replace("/",""));
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){					
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				}
			});
		}
		
		function changeURL(menu,submenu){
			var href = window.location.href;
			var newhref = href.substr(href.indexOf("/home")+6,href.length);
			var href_split = newhref.split("/");			
						
			href_split[0]=menu;
			href_split[1]=submenu;
			
			var newurl="/home"
			$.each(href_split, function(i,e){
				newurl=newurl + "/" + e
			});			
			window.history.replaceState(null, "", newurl);
			cargabreadcrumb("/breadcrumbs","");
			
		};
		
		function exportTable(){
			$(".buttonExport").click(function(e){
				e.preventDefault();
				e.stopPropagation();
				var idTable = $(this).data("id")
						
				const inputValue=idTable + '.csv';
				const { value: csvFilename } = swalWithBootstrapButtons.fire({
					icon:'info',
					title: 'Ingresa el nombre del archivo',
					input: 'text',
					inputValue: inputValue,
					showCancelButton: true,
					confirmButtonText: '<i class="fas fa-sync-alt"></i> Generar',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
					inputValidator: (value) => {
					if (!value) {
					  return 'Debes escribir un nombre de archivo!';
					}
				  }
				}).then((result) => {
					if(result.value){				
						$('#tbl-'+idTable).exporttocsv({
							fileName  : result.value,
							separator : ';',
							table	  : 'dt'
						});				
					}

				});							
			});
		}
		
	});
</script>