var host	= window.location.hostname;
var count	= 1;
var theme	= 'cupertino';
var scrollbarTheme = 'inset-3';
var bootstrapTheme = 'bootstrap.min.css';
var changedata=false;
var wf='';
var modos=[undefined,"agregar","modificar",undefined,"visualizar"];
var pinmenu = false;
var firsttimenu = true;
var paramUrlFile = "";
var objFileupdate ={};
var error = false;
var scrollTheme = 'dark-thin';
var activeWorkers=[];
var maxsize='6M';
var maxupload={
	"5M": {
	  "size": "5242880",
	  "msg-toast": "El tamaño del(los) adjunto(s) no pueden superar los 5M",
	  "msg-invalid": "Por favor, adjunte un archivo menor a 5M"
	},
	"6M": {
		"size": "6291456",
		"msg-toast": "El tamaño del(los) adjunto(s) no pueden superar los 6M",
		"msg-invalid": "Por favor, adjunte un archivo menor a 6M"
	  },
	"7M": {
	  "size": "7340032",
	  "msg-toast": "El tamaño del(los) adjunto(s) no pueden superar los 7M",
	  "msg-invalid": "Por favor, adjunte un archivo menor a 7M"
	},
	"10M": {
	  "size": "10485760",
	  "msg-toast": "El tamaño del(los) adjunto(s) no pueden superar los 10M",
	  "msg-invalid": "Por favor, adjunte un archivo menor a 10M"
	}
  }

if (darkmode()){
	wf='waves-dark';
	scrollTheme = 'light-thin'
}

const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  onOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
})
const swalWithBootstrapButtons = Swal.mixin({
  customClass: {
    confirmButton: 'btn btn-primary btn-md waves-effect ' + wf,
    cancelButton: 'btn btn-secondary btn-md waves-effect '	+ wf	
  },
  buttonsStyling: false
})

//datatable
$.extend( true, $.fn.dataTable.defaults, {
    //"searching": false,
    //"ordering": false
	"language": {
		"lengthMenu": "Mostrando _MENU_ registros",
		"zeroRecords": "Sin coincidencia",
		//"info": "Mostrando del _PAGE_ de _PAGES_",
		"info": "Mostrando del _START_ al _END_ de _TOTAL_ registros",
		"infoEmpty": "No hay registros",
		"infoFiltered": "(Filtrado por _MAX_ registros máximo)",
		
		"decimal":        ",",
		"emptyTable":     "Tabla sin datos",						
		"infoPostFix":    "",
		"thousands":      ".",		
		"loadingRecords": "Leyendo...",
		"processing":     "Procesando...",
		"search":         "Buscar:",		
		"paginate": {
			"first":      "Primero",
			"last":       "Último",
			"next":       "Siguiente",
			"previous":   "Anterior"
		},
		"aria": {
			"sortAscending":  ": activar para oderden ascendente",
			"sortDescending": ": activar para oderden descendente"
		}
	}
	
} );
//calendario
jQuery(function($){
	$.datepicker.regional['es'] = {
		closeText: 'Cerrar',
		prevText: '&#x3c;Ant',
		nextText: 'Sig&#x3e;',
		currentText: 'Hoy',
		monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
		'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
		monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
		'Jul','Ago','Sep','Oct','Nov','Dic'],
		dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
		dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
		dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
		weekHeader: 'Sm',
		//dateFormat: 'dd-mm-yy',
		//dateFormat: 'yy-M-D',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: '',
		changeYear: true,
		changeMonth: true,
		yearRange: '-100:+2',
		timeFormat:  "hh:mm:ss"
		};
	$.datepicker.setDefaults($.datepicker.regional['es']);
});    

function blink(id)
{
	$(id).fadeTo(100, 0.1).fadeTo(200, 1.0);
}
$.validator.setDefaults( {
	submitHandler: function (e) {		
		$.ajax({
			type: 'POST',
			url:$(e).attr('action'),			
			data:$(e).serialize(),
			success: function(data) {
				var param=data.split("/@/");									
				if(param[0]=="200"){					
					changedata=false;
					swalWithBootstrapButtons.fire({
					  icon: 'success',					  
					  title: param[1],					  
					  text: param[2]
					  //footer: '<a href>Why do I have this issue?</a>'
					});
					$("#camPassModal").modal("hide");					
				}else{
					if(parseInt(param[0])<200){
						swalWithBootstrapButtons.fire({
						  icon: 'error',
						  title: 'Oops...',
						  text: param[1],
						  //footer: '<a href>Why do I have this issue?</a>'
						});						
					}else{
						errors(param[0]);
					}					
				}				
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){				
				//Swal.fire({
				swalWithBootstrapButtons.fire({
				  icon: 'error',
				  title: 'Oops...',
				  text: 'Hubo un problema al procesar la llamada.',
				  //footer: '<a href>Why do I have this issue?</a>'
				})		
			},
			complete: function(){						
				
			}
		});
		//Fin ajax		
	}
} );
function smooth(e,id){
	var clase = 'ripple' + id;
	if($(e).find('.' + clase).length === 0) {
		$(e).append('<span class="' + clase + '"></span>');
	}
	var ripple = $(e).find('.' + clase);
	eWidth = $(e).outerWidth() + 10;
	eHeight = $(e).outerHeight() + 10;
	size = Math.max(eWidth, eHeight);		
	ripple.css({'width': size, 'height': size});		
	ripple.css({'top':'-5px', 'left':'-5px'});
	ripple.addClass('animated');		
	var timerSmooth = setTimeout(function () {
		ripple.removeClass('animated');
		clearTimeout(timerSmooth);
	}, 400);

}
function round(value, precision) {
    var multiplier = Math.pow(10, precision | 0);
    return Math.round(value * multiplier) / multiplier;
}

function loadtables(id,data,columns){
	$(".table").removeClass("table-dark");

	if ($("body").hasClass("bootstrap-dark")){
		theme='ui-darkness';
		$(".table").addClass("table-dark");
	}			
}
function cargacomponente(target,data,content){
	var xtarget=target.replace(/[.]/gi,'/')
	error=false;
	if(content==undefined || content==""){
		content="#contenbody";
	}
	changedata=false;
	$.ajax({
		type: 'POST',								
		url:xtarget,			
		data:data,
		success: function(data) {
			var param=data.split("/@/");									
			if(param[0]=="200"){				
				$(content).html(param[1]);				
			}else{
				errors(param[0],content);
			}								
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){				
			$(content).load("/error404");			
			//$('#loading-image').fadeOut(200);
		},
		complete: function(){					
			//$('#loading-image').fadeOut(200);
			$.each($(".table"),function(i,e){
			
			
				var ajaxUrl=$(this).data("url");
				var noajax=$(this).data("noajax");
				var tableId=$(this).data("id");
				var keys=$(this).data("keys");

				if(noajax || noajax!=null){
					if(ajaxUrl!=null){
						//carga ajax de los datos de la tabla						
						var varValue;
						var varName;
						var data=[];
						var objeto={};
						var key=''							

						for(var i= 0; i < keys; i++) {
							varValue=$(this).data("key"+(i+1));
							varName = "key"+(i+1);			
							objeto[varName]=varValue;				
							key=key + '/' + varValue
						}						
						$.post(ajaxUrl, objeto, function(html) {
							var param=html.split("/@/");									
							if(param[0]=="200"){
								$("#tbl-" + tableId + " tbody").append(param[1]);																	  							
								loadtables("#tbl-" + tableId);
								
								//cargabarrapor();							
							}else{
								errors(param[0],content);									
							}										
						})																			
							
					}else{						
						swalWithBootstrapButtons.fire({
						  icon: 'error',
						  title: 'Oops...',
						  text: 'La url no es válida o no existe.',						  
						});
					}
				}else{					
					if(!$.fn.DataTable.isDataTable( "#tbl-" + tableId )){
						loadtables("#tbl-" + tableId);
					}					
				}	
			
			});
			//loadtables(".ts");
			if(darkmode()){
				$(".waves-effect").removeClass("waves-light");
				$(".waves-effect").addClass("waves-dark");
			}else{
				$(".waves-effect").addClass("waves-light");
				$(".waves-effect").removeClass("waves-dark");
			};
						
			iniButtonsActions();
			$(".sw-estado").click(function(){
				var element=$(this).data("field")
				if($("#"+element).is(':checked')) {  
					$(".sw-estado label").html("Activo");  
				} else {  
					$(".sw-estado label").html("Bloqueado");
				}  
			});
			formValidate(".form");
			$("#SEX_Id").change(function(){				
				if($(this).val()==1){
					$(this).parent().siblings("i").removeClass("fa-genderless");
					$(this).parent().siblings("i").removeClass("fa-mars");
					$(this).parent().siblings("i").addClass("fa-venus");					
				}else{
					if($(this).val()==2){
						$(this).parent().siblings("i").removeClass("fa-genderless");
						$(this).parent().siblings("i").removeClass("fa-venus");
						$(this).parent().siblings("i").addClass("fa-mars");						
					}
				};				
			});	
			$("#USR_Usuario").change(function(e){
				e.preventDefault();
				$.ajax({
					type: 'POST',								
					url:'/user-ldap/' + $("#USR_Usuario").val(),			
					data:data,
					success: function(data) {
						var param=data.split("/@/");			
						if(param[0]=="200"){				
							$(param).each(function(e){
								if(e>0){
									
									if((param[e]!="N/A") && (param[e]!="N/A-N/A")){										
										$($("input")[e]).siblings("label").addClass("active")
										$($("input")[e]).val(param[e])
									}else{
										$($("input")[e]).val("")
									}
									
								}								
							})						
						}else{
							//nada por ahora
						}						
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						ajax_icon_handling(false,'No fue posible crear el listado de usuarios LDAP.','','');	
					},
					complete: function(){	
						/*Swal.fire({
							title: "successfully deleted",
							type: "success"
						})*/												
					}
				})
			});
			$(".usrSearch").click(function(){
				ajax_icon_handling('load','Creando listado de usuarios LDAP','','');
				$.ajax({
					type: 'POST',								
					url:'/lista-usuario-ldap',			
					data:data,
					success: function(data) {
						var param=data.split("/@/");			
						if(param[0]=="200"){				
							ajax_icon_handling(true,'Listado de usuarios LDAP creado.','',param[1]);
							$(".swal2-popup").css("width","60rem");
							loadtables(".ts");
							$("#tbl-usuariosldap").on("click","tr.usrline",function(){
								$(this).find("td").each(function(e){									
									$($("input")[e]).val(this.innerText)
									$($("input")[e]).siblings("label").addClass("active")
								});																
								Swal.close();
								changedata=true;
							})
						}else{
							ajax_icon_handling(false,'No fue posible crear el listado de usuarios LDAP.','','');
						}						
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						ajax_icon_handling(false,'No fue posible crear el listado de usuarios LDAP.','','');	
					},
					complete: function(){	
						/*Swal.fire({
							title: "successfully deleted",
							type: "success"
						})*/												
					}
				})
							 
			});
			
		}
	});
}
function iniButtonsActions(){
	if(darkmode()){
		if($(".card").hasClass("modificar")){
			$(".card.modificar .card-header").removeClass("bg-warning border-warning");
			$(".card.modificar .card-header").removeClass("text-white");
			$(".card.modificar .card-header").removeClass("border-warning");
			$(".card.modificar .card-footer").removeClass("text-warning");
			$(".card.modificar .card-body").removeClass("bg-light");
			$(".card.modificar .card-footer").removeClass("bg-light border-warning");
			$(".card.modificar .card-header button.close").removeClass("text-white");

			$(".card.modificar").addClass("bg-dark text-warning border-warning");
			$(".card.modificar .card-header").addClass("border-warning");
			$(".card.modificar .card-header button.close").addClass("text-warning");
			
			
		}				
		if($(".card").hasClass("agregar")){
			$(".card.agregar .card-header").removeClass("bg-success border-success");
			$(".card.agregar .card-header").removeClass("text-white");
			$(".card.agregar .card-header").removeClass("border-success");
			$(".card.agregar .card-footer").removeClass("text-success");
			$(".card.agregar .card-body").removeClass("bg-light");
			$(".card.agregar .card-footer").removeClass("bg-light border-success");
			$(".card.agregar .card-header button.close").removeClass("text-white");

			$(".card.agregar").addClass("bg-dark text-success border-success");	
			$(".card.agregar .card-header").addClass("border-success");
			$(".card.agregar .card-header button.close").addClass("text-success");
		}
		if($(".card").hasClass("visualizar")){
			$(".card.visualizar .card-header").removeClass("bg-primary border-primary");
			$(".card.visualizar .card-header").removeClass("text-white");
			$(".card.visualizar .card-header").removeClass("border-primary");
			$(".card.visualizar .card-footer").removeClass("text-primary");
			$(".card.visualizar .card-body").removeClass("bg-light");
			$(".card.visualizar .card-footer").removeClass("bg-light border-primary");
			$(".card.visualizar .card-header button.close").removeClass("text-white");

			$(".card.visualizar").addClass("bg-dark text-primary border-primary");	
			$(".card.visualizar .card-header").addClass("border-primary");
			$(".card.visualizar .card-header button.close").addClass("text-primary");
		}
		if($(".card").hasClass("eliminar")){
			$(".card.eliminar .card-header").removeClass("bg-danger border-danger");
			$(".card.eliminar .card-header").removeClass("text-white");
			$(".card.eliminar .card-header").removeClass("border-danger");
			$(".card.eliminar .card-footer").removeClass("text-danger");
			$(".card.eliminar .card-body").removeClass("bg-light");
			$(".card.eliminar .card-footer").removeClass("bg-light border-danger");
			$(".card.eliminar .card-header button.close").removeClass("text-white");

			$(".card.eliminar").addClass("bg-dark text-danger border-danger");	
			$(".card.eliminar .card-header").addClass("border-danger");
			$(".card.eliminar .card-header button.close").addClass("text-danger");
		}
	}else{
		if($(".card").hasClass("modificar")){
			$(".card.modificar .card-header").removeClass("text-warning border-warning");
			$(".card.modificar .card-header button.close").removeClass("text-warning");
			
			$(".card.modificar .card-header").addClass("bg-warning border-warning");
			$(".card.modificar .card-header").addClass("text-white");
			$(".card.modificar .card-footer").addClass("text-warning");
			$(".card.modificar .card-body").addClass("bg-light");
			$(".card.modificar .card-footer").addClass("bg-light border-warning");						
			$(".card.modificar .card-header button.close").addClass("text-white");

		}
		if($(".card").hasClass("agregar")){
			$(".card.agregar .card-header").removeClass("text-success border-success");
			$(".card.agregar .card-header button.close").removeClass("text-success");

			$(".card.agregar .card-header").addClass("bg-success border-success");
			$(".card.agregar .card-header").addClass("text-white");
			$(".card.agregar .card-footer").addClass("text-success");
			$(".card.agregar .card-body").addClass("bg-light");
			$(".card.agregar .card-footer").addClass("bg-light border-success");
			$(".card.agregar .card-header button.close").addClass("text-white");
		}
		if($(".card").hasClass("visualizar")){
			$(".card.visualizar .card-header").removeClass("text-primary border-primary");
			$(".card.visualizar .card-header button.close").removeClass("text-primary");

			$(".card.visualizar .card-header").addClass("bg-primary border-primary");
			$(".card.visualizar .card-header").addClass("text-white");
			$(".card.visualizar .card-footer").addClass("text-primary");
			$(".card.visualizar .card-body").addClass("bg-light");
			$(".card.visualizar .card-footer").addClass("bg-light border-primary");
			$(".card.visualizar .card-header button.close").addClass("text-white");
		}
		if($(".card").hasClass("eliminar")){
			$(".card.eliminar .card-header").removeClass("text-danger border-danger");
			$(".card.eliminar .card-header button.close").removeClass("text-danger");

			$(".card.eliminar .card-header").addClass("bg-danger border-danger");
			$(".card.eliminar .card-header").addClass("text-white");
			$(".card.eliminar .card-footer").addClass("text-danger");
			$(".card.eliminar .card-body").addClass("bg-light");
			$(".card.eliminar .card-footer").addClass("bg-light border-danger");
			$(".card.eliminar .card-header button.close").addClass("text-white");
		}								
	}

	$(".card.modificar .card-footer .btn.modificar").addClass("btn-warning text-white");
	$(".card.agregar .card-footer .btn.agregar").addClass("btn-success text-white");
	$(".card.eliminar .card-footer .btn.eliminar").addClass("btn-danger text-white");
	$(".card .card-header .close").addClass("text-white");
	
	$("input, select, texarea").change(function(){
		changedata=true;
	})
	/*$(".close").click(function(){
		exit(this);
	});*/
};

function exit(objeto){
	if (!changedata){
		changedata=false;
		var url=$(objeto).data("url");
		cargacomponente(url,"");
		window.history.replaceState(null, "", "/home"+url);
		cargabreadcrumb("/breadcrumbs","");
	}else{
		//alert("página modificada")
		//Swal.fire({
		swalWithBootstrapButtons.fire({
		  title: '¿Estas seguro?',
		  text: "Aún no has guardado los datos en esta página!",
		  icon: 'warning',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6',
		  cancelButtonColor: '#d33',
		  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, salir igual!',
		  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
		}).then((result) => {
		  if (result.value) {
			/*Swal.fire(
			  'Deleted!',
			  'Your file has been deleted.',
			  'success'
			)*/
			
			changedata=false;
			var url=$(objeto).data("url");
			cargacomponente(url,"");
			window.history.replaceState(null, "", "/home"+url);
			cargabreadcrumb("/breadcrumbs","");
		  }
		})
	}
}
function errors(code,target){
	error=true;
	if(target==undefined || target==""){
		target="#contenbody";
	}
	if(code==403){
		$(target).load("/error403");
	}else{
		if(code==500){
			$(target).load("/error500");
		}else{
			if(code==503){
				$(target).load("/error503");
			}else{
				if(code==404){
					$(target).load("/error404");
				}else{
					if(code==504){
						$(target).load("/error504");
					}else{
						$(target).load("/error418");
					}
				}
			}	
		}								
	}
}
function salir(){
	swalWithBootstrapButtons.fire({
		title: '¿Estas seguro?',
		text: "Esta acción hará que cierres tu sesión en el sitio!",
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#3085d6',
		cancelButtonColor: '#d33',
		confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, salir igual!',
		  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
	}).then((result) => {
		if (result.value) {						  	
			window.location.href="/ingreso-de-credenciales"
		}else{
			//window.history.go(0)
		}
	});
}
function cargabreadcrumb(target,data){	
	$.ajax({
		type: 'POST',								
		url:target,			
		data:data,
		success: function(data) {
			var param=data.split("/@/");			
			if(param[0]=="200"){				
				$('#breadcrumbbody').html(param[1]);
			}else{
				//errors(param[0]);
				$('#breadcrumbbody').html(param[0] + "</br>" + param[1]);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){				
			$("#breadcrumbbody").load("/error404");						
		},
		complete: function(){			
			$("nav li a").click(function(e){
				e.stopPropagation();
				e.preventDefault();					
				var url=$(this).data("url");
				var keys=$(this).data("keys");
				var target=$(this).data("target");
				if (url!=undefined){
					if(url=="salir"){						
						salir();
					}else{																						
						if(keys!=undefined && keys>0){	
							var varValue;
							var varName;
							var data=[];
							var objeto={};
							var key=''							

							for(var i= 0; i < keys; i++) {
								varValue=$(this).data("key"+(i+1));
								varName = "key"+(i+1);			
								objeto[varName]=varValue;				
								key=key + '/' + varValue
							}													
							cargacomponente($(this).data("url"),objeto,target);
							window.history.replaceState(null, "", "/home"+$(this).data("url") + key);	
							cargabreadcrumb("/breadcrumbs","");
						}else{
							cargacomponente($(this).data("url"),"",target);
							window.history.replaceState(null, "", "/home"+$(this).data("url"));	
							cargabreadcrumb("/breadcrumbs","");
						}																												
					}
				}
			});
			
			$('.content-sistema ul li, .content-mantenedores ul li, .content-informes ul li, .content-acciones ul li').click(function(e){
				e.preventDefault();
				e.stopPropagation();
				var url=$(this).data("url");
				var keys=$(this).data("keys");
				var target=$(this).data("target");				
				if (url!=undefined){
					//if(keys!=undefined && keys>0){	
					var varValue;
					var varName;
					var data=[];
					var objeto={};
					var key='';
					var id = $(this).attr("id");
					var modo = $(this).data("modo");
					var acciones = false;
					var accion = false;
					var k=0;						
					if(modo==undefined){
						modo=4;
					}
					var path = location.pathname.replace($(this).parent().parent().parent().attr("id"),modos[modo]);

					if($(this).parent().hasClass("acciones")){
						acciones=true;
					}

					var split_path=window.location.pathname.split("/");
					if(acciones){
						for(i=2;i<split_path.length;i++){
							if(accion && $.isNumeric(split_path[i])){
								k=k+1;
								varValue=split_path[i];
								varName = "key"+k;
								objeto[varName]=varValue;													
							}
							if(split_path[i]=="modificar" || split_path[i]=="visualizar" || split_path[i]=="agregar"){
								accion=true;				
							}								
						}
						k=k+1;
						varValue=modo;
						varName = "key"+k;
						objeto[varName]=varValue;
					}else{
						for(var i= 0; i < keys; i++) {
							varValue=$(this).data("key"+(i+1));
							varName = "key"+(i+1);
							objeto[varName]=varValue;				
							key=key + '/' + varValue
						}
					};						
					cargacomponente($(this).data("url"),objeto,target);
					if(!acciones){
						window.history.replaceState(null, "", "/home"+$(this).data("url") + key);	
						cargabreadcrumb("/breadcrumbs","");
					}else{
						window.history.replaceState(null, "", path);	
						cargabreadcrumb("/breadcrumbs","");
					}					
				}
			})
		}
	});
}
function moveMark(animation){						
	var pos = $("#pry-menu ul").find("li.active.pasos").position();
	var posTop = pos.top + 4;
	if($("li.active.pasos").css("visibility")!="hidden") {
		$("#pasos").css("top",posTop + "px");
		if(animation){
			$("#pasos").on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', 
				function() {
					smooth(".pasos.active .globo.act","Pasos");
					$(".pasos.active .globo.act").addClass("on");
					$(".pasos.active a").addClass("current");
				});
		}else{
			smooth(".pasos.active .globo.act","Pasos");
			$(".pasos.active .globo.act").addClass("on");
			$(".pasos.active a").addClass("current");
		}
	}else{
		var pos = $("#pry-menu ul").find("li.category.pasos").position();
		var posTop = pos.top
		$("#pasos").css("top",posTop + "px");
	}
		
	var pos = $("#pry-menu ul").find("li.active.hitos").position();
	var posTop = pos.top + 4;
	if($("li.active.hitos").css("visibility")!="hidden") {
		$("#hitos").css("top",posTop + "px");		
		if(animation){

			$("#hitos").on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', 
				function() {
					smooth(".hitos.active .globo.act","Hitos");
					$(".hitos.active .globo.act").addClass("on")
					$(".hitos.active a").addClass("current");
				});
		}else{
			smooth(".hitos.active .globo.act","Hitos");
			$(".hitos.active .globo.act").addClass("on")
			$(".hitos.active a").addClass("current");
		}
	}else{
		var pos = $("#pry-menu ul").find("li.category.hitos").position();
		var posTop = pos.top
		$("#hitos").css("top",posTop + "px");
	}
	
	var pos = $("#pry-menu ul").find("li.active.menus").position();
	if($("li.active.menus").css("visibility")!="hidden") {
		if(pos!=undefined){		
			var posTop = pos.top
			$("#menus").css("top",posTop + "px");
			if(animation){

				$("#menus").on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', 
					function() {
						smooth(".menus.active .globo.act","Menus");
						$(".menus.active .globo.act").addClass("on")
						$(".menus.active a").addClass("current");
					});
			}else{
				smooth(".menus.active .globo.act","Menus");
				$(".menus.active .globo.act").addClass("on")
				$(".menus.active a").addClass("current");
			}
		}else{
			if(pos==undefined){	
				var pos = $("#pry-menu ul").find("li.category.menus").position();
				if(pos==undefined){
					$("#menus").hide();
				}else{
					var posTop = pos.top
					$("#menus").css("top",posTop + "px");
				}
			}
		}
	}else{
		if(pos==undefined){	
			var pos = $("#pry-menu ul").find("li.category.menus").position();
			if(pos==undefined){
				$("#menus").hide();
			}else{
				var posTop = pos.top
				$("#menus").css("top",posTop + "px");
			}
		}
	}
		
}

function moveMark_2(animation){
	var pos = $("#pry-menu ul").find("li.active.reportes").position();
	if($("li.active.reportes").css("visibility")!="hidden") {		
		if(pos!=undefined){		
			var posTop = pos.top
			$("#reportes").css("top",posTop + "px");
			if(animation){
				$("#reportes").on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', 
					function() {
						smooth(".reportes.active .globo.act","Reportes");
						$(".reportes.active .globo.act").addClass("on")
						$(".reportes.active a").addClass("current");
					});
			}else{
				smooth(".reportes.active .globo.act","Reportes");
				$(".reportes.active .globo.act").addClass("on")
				$(".reportes.active a").addClass("current");
			}
		}else{						
			var pos = $("#pry-menu ul").find("li.category.reportes").position();
			if(pos!=undefined){
				var posTop = pos.top;
			}else{
				var posTop = 0;	
			};
			$("#reportes").css("top",posTop + "px");
		}
	}else{
		var pos = $("#pry-menu ul").find("li.category.reportes").position();
		if(pos!=undefined){
			var posTop = pos.top;
		}else{
			var posTop = 0;	
		};
		$("#reportes").css("top",posTop + "px");
	}
	
	var pos = $("#pry-menu ul").find("li.active.mantenedores").position();
	if($("li.active.mantenedores").css("visibility")!="hidden") {		
		if(pos!=undefined){		
			var posTop = pos.top
			$("#mantenedores").css("top",posTop + "px");
			if(animation){
				$("#mantenedores").on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd', 
					function() {
						smooth(".mantenedores.active .globo.act","Mantenedores");
						$(".mantenedores.active .globo.act").addClass("on")
						$(".mantenedores.active a").addClass("current");
					});
			}else{
				smooth(".mantenedores.active .globo.act","Mantenedores");
				$(".mantenedores.active .globo.act").addClass("on")
				$(".mantenedores.active a").addClass("current");
			}
		}else{			
			var pos = $("#pry-menu ul").find("li.category.mantenedores").position();
			var posTop = pos.top
			$("#mantenedores").css("top",posTop + "px");	
		}
	}else{
		var pos = $("#pry-menu ul").find("li.category.mantenedores").position();
		var posTop = pos.top
		$("#mantenedores").css("top",posTop + "px");
	}
}

function cargaperfil(){	
	var target="/perfil";
	var data="";
	$.ajax({
		type: 'POST',								
		url:target,			
		data:data,
		success: function(data) {
			var param=data.split("/@/");			
			if(param[0]=="200"){				
				$('#perfilbody').html(param[1]);				
			}else{			
				$('#perfilbody').html(param[0] + "</br>" + param[1]);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){				
			$("#perfilbody").load("/error404");						
		},
		complete: function(){												
			$(".perfil span").click(function(e){
				e.stopPropagation();
				$(".content-perfil").toggle("slow");							
			})
			
			$(".menuperfil li").click(function(e){
				e.preventDefault();
				$(".content-perfil").toggle("slow");
				var url=$(this).data("url");
				if (url!=undefined){
					if(url=="salir"){						
						salir();
					}else{
						if(url=="/cambiar-clave"){
							$.ajax({
								type: 'POST',								
								url:url,			
								//data:data,
								success: function(data) {
									var param=data.split("/@/");			
									if(param[0]=="200"){				
										$('#perfilbody').html(param[1]);
									}else{
										//errors(param[0]);
										$('#perfilbody').html(param[0] + "</br>" + param[1]);
									}
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){				
									$("#perfilbody").load("/error404");						
								},
								complete: function(){	
								}
							});
						}else{							
							cargacomponente($(this).data("url"),"");
							window.history.replaceState(null, "", "/home"+$(this).data("url"));	
							cargabreadcrumb("/breadcrumbs","");
						}
					}
				}
			});
			var images = $(".imgPerfil");
			$(images).on("error", function(event) {
				$(event.target).css("display", "none");
			});
		}
	});
}

$(document).mouseup(e => {
	//const $menu = $(".content-perfil, .content-sistema, .content-mantenedores, .content-acciones");
	//const $container = $(".perfil, .sistema, .mantenedores, .acciones");
	const $menu = $(".content-perfil");
	const $container = $(".perfil");
   	if (!$container.is(e.target) // if the target of the click isn't the container...
   		&& $container.has(e.target).length === 0) // ... nor a descendant of the container
   	{
    	$menu.hide("slow");
  	}
});


function iniActions(){
	$('body').on('click','.btn-acc, .icon, .link',function(e){
		e.preventDefault();
		e.stopPropagation();		
				
		var keys;
		if ($(this).hasClass("btn") || $(this).hasClass("link")) {
			var keys=$(this).data("keys");			
			
			var varValue;
			var varName;
			var data=[];
			var objeto={};
			var url=$(this).data("url")
			for(var i= 0; i < keys; i++) {
				varValue=$(this).data("key"+(i+1));
				varName = "key"+(i+1);								
				url=url+"/"+varValue;				
				objeto[varName]=varValue;
				
				$("body").data(varName,varValue);
			}			
			cargacomponente($(this).data("url"),objeto);
			window.history.replaceState(null, "", "/home"+url);
			cargabreadcrumb("/breadcrumbs","");
			$("body").data("id",url.replace(/[/]/gi,'.'));
			$("body").data("keys",keys);
						
		}else{
			cargacomponente($(this).data("url"),"");
			window.history.replaceState(null, "", "/home"+$(this).data("url"));	
			cargabreadcrumb("/breadcrumbs","");
		}
	})
}
function darkmode(){
	if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
		// dark mode		
		return true
	}else{
		return false
	}	
}
function formValidate(id){	
	//Validate	
	$.validator.addMethod(
		"regex",
		function(value, element, regexp) 
		{
			if (regexp.constructor != RegExp)
				regexp = new RegExp(regexp);
			else if (regexp.global)
				regexp.lastIndex = 0;
			return this.optional(element) || regexp.test(value);
		},
		"Please check your input."
    );
	
	$.validator.addMethod("rutValido", function(value, element) {
	  return this.optional(element) || $.Rut.validar(value);
	}, "Este campo debe ser un rut valido.");

	$.validator.addMethod("rutMin", function(value, element) {
	  var rut=parseInt(value.replace(/[.-]/gi,'').substr(0,value.length-3));		  
	  if(rut<50000){
		return false;
	  }else{
		return true;
	  }		  
	}, "Este campo debe ser un rut valido.");

	$.validator.addMethod("extFile", function(value, element) {
		var fileName = value;
		var idxDot = fileName.lastIndexOf(".") + 1;
		var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();
		if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf" || fileName==""){
		   return true
		}else{
		   return false
		}   
	}, "Formato de archivo no válido.");
	
	$.validator.addMethod("maxNameFile", function(value, element) {
		var fileName = value;
		var idxDot = fileName.lastIndexOf(".");
		var nameFile = fileName.substr(0,idxDot).toLowerCase();
		if (nameFile.length<=60){
		   return true
		}else{
		   return false
		}   
	}, "Nombre de archvo superior a 60 caracteres");
	
	
	if(id=="#frmalumnotab1" || id=="#frmalumnotab2" || id=="#frmalumnotab3" || id=="#frmaddplanificacion" || id=="#frm10s5_evaluacion" || id=="#frm12s4_evaluacion" || id=="#frm11s1_1" || id=="#frm11s1_2" || id=="#frm11s1_3" || id=="#frm11s1_4" || id=="#frm13s1_1" || id=="#frm13s1_2" || id=="#frm13s1_3" || id=="#frm13s1_4" || id=="#frmbeneficiariostab1" || id=="#frmbeneficiariostab2" || id=="#frmbeneficiariostab3" || id==="#frmaddasistencia" ){									
		if(id=="#frmaddplanificacion"){
			$.validator.addMethod("timeRange", function(value, element, params) {				
				if(calculardiferencia(value,$(params).val())==undefined){
					return true;
				}else{
					return false;
				}		  
			}, "Rango de horas no válido");
			var rules = "{";			
			$('[name^="PLN_Hora"]').each(function(e){
				var data=$(this).attr("id").split("-");
				var typeReg=data[1];
				var TEM_Id=data[2];			
				var firstField = '#PLN_HoraInicio-' + typeReg + '-' + TEM_Id;
				var secondField = '#PLN_HoraFin-' + typeReg + '-' + TEM_Id;
				if(rules!="{"){
					rules=rules + ","
				}
				rules = rules + '"' + secondField + '":{"required": true,"timeRange" : "' + firstField + '"}'
			});
			rules = rules + "}"			
			//console.log(JSON.parse(rules));
			$( id ).validate({
				ignore: [],
				rules:JSON.parse(rules),
				errorElement: "div",
				errorPlacement: function ( error, element ) {
					if(error[0].innerHTML!=""){
						if(element.prev("i.prefix").length>0){					
							error.css("padding-left","2.5rem");
						}else{
							error.css("padding-left","0rem");					
						}

						// Add the `help-block` class to the error element
						error.addClass( "invalid-feedback" );
						if ( element.prop( "type" ) === "checkbox" ) {					
							error.insertAfter( element.parent(".error-message") );				
						} else {
							if ( element.prop( "type" ) === "select-one" ) {																		
								error.insertAfter( element );	
							} else {						
								if ( element.prop( "type" ) === "textarea" ) {
									error.addClass( "textarea" );
									error.insertAfter( element );	
								} else {						
									//error.insertAfter( element );
									error.insertAfter( element.parent(".error-message") );				
								}
							}
						}
					}
				},
				success: function ( label, element ) {		
				},
				highlight: function ( element, errorClass, validClass ) {			
					$( element ).addClass( "is-invalid" ).removeClass( "is-valid" );
					$(element).siblings("span.select-bar").addClass( "is-invalid" ).removeClass( "is-valid" );		
				},
				unhighlight: function (element, errorClass, validClass) {			
					$( element ).addClass( "is-valid" ).removeClass( "is-invalid" );
					$(element).parent().next().remove('.invalid-feedback');
					$(element).siblings("span.select-bar").addClass( "is-valid" ).removeClass( "is-invalid" );
				},
				invalidHandler: function() {
					setTimeout(function() {
						$('.content-nav a small.required').remove();
						var validatePane = $('.tab-content.tab-validate .tabs-pane:has(.form-control.is-invalid)').each(function() {
							var id = $(this).attr('id');
							$('.content-nav').find('a[href^="#' + id + '"]').append(' <small class="required">***</small>');
						});
					});
				}
			})
		}else{
			$.validator.addMethod("minAge", function(value, element, params) {
				const today = new Date();
				const fechaNac = new Date(value);
				let diffYears = today.getFullYear() - fechaNac.getFullYear();
				const m = today.getMonth() - fechaNac.getMonth();
				if (m < 0 || (m === 0 && today.getDate() < fechaNac.getDate())) {
					diffYears--;
				}
				return diffYears >= 18; 
			}, "Edad minima no válida");
			$( id ).validate( {
				ignore: [],
				rules:{
					ALU_Rut:{
						required: true,
						minlength:7,
						rutValido:true,
						rutMin:true
					},
					ALU_Nombre:{
						required: true,
					},
					ALU_ApellidoPaterno:{
						required: true,
					},
					ALU_ApellidoMaterno:{
						required: true,
					},
					NAC_Id:{
						required: true,
					},
					SEX_Id:{
						required: true,
					},
					EDU_Id:{
						required: true,
					},
					TDI_Id:{
						required: true,
					},					
					ALU_PuebloOriginario:{
						required: true,
					},
					ALU_FichaX:{						
						extFile: true,
						maxNameFile: true
					},
					PRY_AdjuntoX:{
						required: true,
						extFile: true,
						maxNameFile: true
					},
					ADE_AdjuntoX:{
						required: true,
						extFile: true,
						maxNameFile: true
					},
					EAD_AdjuntoX:{
						required: true,
						extFile: true,
						maxNameFile: true
					},
					CAD_AdjuntoX:{
						required: true,
						extFile: true,
						maxNameFile: true
					},
					FAD_AdjuntoX:{
						required: true,
						extFile: true,
						maxNameFile: true
					},
					REG_Id:{	
						required: true
					},
					COM_Id:{	
						required: true
					},
					ALU_Direccion:{
						required: true,
						minlength:10
					},
					ALU_Mail:{
						required: true,
					},
					ALU_Telefono:{
						required: true,
						minlength: 9
					},
					TTR_Id:{
						required: true,
					},
					ALU_NombreEmpresa:{
						required: true,
						minlength:3
					},
					RUB_Id:{
						required: true,
					},

					ALU_FechaIngreso:{
						required: true,
					},
					ALU_FechaNacimiento:{
						required: true,
						minAge:true
					},
					ALU_NombreOrganizacion:{
						required: true,
						minlength:10
					},
					ALU_RSU:{
						required: true,
					},
					ALU_TiempoDirigenteSindical:{
						required: true,
					},
					ALU_InstitucionCursoFormacionSindical:{
						required: true,
						minlength:10
					},
					ALU_AnioCursoFormacionSindical:{
						required: true,
						min:1900,
						max:new Date().getFullYear()
					},
					ALU_FechaInicioCargoDirectivo:{
						required: true,
					},
					ALU_NombreCargoDirectivo:{
						required: true,
						minlength:10
					}
				},
				messages: {								
					ALU_Rut:{
						required: "Por favor, ingrese un RUT",
						minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
						rutValido: "Por favor, ingresa un RUT válido",
						rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
					},
					ALU_Nombre:{
						required: "Por favor, ingrese un nombre",
					},
					ALU_ApellidoPaterno:{
						required: "Por favor, ingrese un apellido paterno",
					},
					ALU_ApellidoMaterno:{
						required: "Por favor, ingrese un apellido materno",
					},
					NAC_Id:{
						required: "Por favor, ingrese una nacionalidad",
					},
					SEX_Id:{
						required: "Por favor, ingrese un género",
					},
					EDU_Id:{
						required: "Por favor, ingrese un nivel educacional",
					},
					TDI_Id:{
						required: "Por favor, ingrese un tipo de discapacidad",
					},
					ALU_FechaCreacionRegistro:{
						required: "Por favor, ingrese una fecha de ingreso",
					},
					ALU_PuebloOriginario:{
						required: "Por favor, ingrese un nombre de pueblo originario",
					},
					ALU_FichaX:{
						required: "Por favor, agregue ficha o documento del alumno",
						extFile: "Extención de archivo no válido",
						maxNameFile: "Nombre de archivo supera los 60 caracteres"
					},
					ALU_Ficha:{
						//accept:"Formato de archivo no válido"
						accept:""
					},
					ADE_Adjunto:{
						accept:""
					},
					ADE_AdjuntoX:{
						required: "Por favor, agregue adjunto de solicitud",
						extFile: "Extención de archivo no válido",
						maxNameFile: "Nombre de archivo supera los 60 caracteres"
					},
					EAD_Adjunto:{
						accept:""
					},
					EAD_AdjuntoX:{
						required: "Por favor, agregue adjunto de solicitud",
						extFile: "Extención de archivo no válido",
						maxNameFile: "Nombre de archivo supera los 60 caracteres"
					},
					CAD_Adjunto:{
						accept:""
					},
					CAD_AdjuntoX:{
						required: "Por favor, agregue adjunto de solicitud",
						extFile: "Extención de archivo no válido",
						maxNameFile: "Nombre de archivo supera los 60 caracteres"
					},
					FAD_Adjunto:{
						accept:""
					},
					FAD_AdjuntoX:{
						required: "Por favor, agregue adjunto de solicitud",
						extFile: "Extención de archivo no válido",
						maxNameFile: "Nombre de archivo supera los 60 caracteres"
					},
					PRY_Adjunto:{
						//accept:"Formato de archivo no válido"
						accept:""
					},
					PRY_AdjuntoX:{
						extFile: "",
						maxNameFile: ""
					},
					REG_Id:{
						required: "Por favor, seleccione una región",
					},
					COM_Id:{
						required: "Por favor, seleccione una comuna",
					},
					ALU_Direccion:{
						required: "Por favor, ingresa una dirección",
						minlength:"LA dirección debe contener al menos 10 caracteres"
					},
					ALU_Mail:{
						required: "Por favor, ingresa un correo electrónico",
					},
					ALU_Telefono:{
						required: "Por favor, ingresa un teléfono",
						minlength: "El número debe contener 9 dígitos"
					},
					TTR_Id:{
						required: "Por favor, ingresa un tipo de trabajador",
					},
					ALU_NombreEmpresa:{
						required: "Por favor, ingresa un nombre de empresa",
						minlength:"El nombre de la empresa debe tener al menos 3 caracteres"
					},
					RUB_Id:{
						required: "Por favor, ingresa un rubro",
					},

					ALU_FechaIngreso:{
						required: "Por favor, ingresa una fecha",
					},
					ALU_NombreOrganizacion:{
						required: "Por favor, ingrese un nombre de organización",
						minlength:"El nombre debe contener al menos 10 caracteres"
					},
					ALU_RSU:{
						required: "Por favor, ingrese el RSU",
					},
					ALU_TiempoDirigenteSindical:{
						required: "Por favor, ingrese una fecha",
					},
					ALU_InstitucionCursoFormacionSindical:{
						required: "Por favor, ingrese una institución",
						minlength:"El nombre debe contener al menos 10 caracteres"
					},
					ALU_AnioCursoFormacionSindical:{
						required: "Por favor, ingrese el año del curso",
						min:"El año debe ser mayor a 1900",
						max:"El año no puede ser mayor a " + new Date().getFullYear(),
					},
					ALU_FechaInicioCargoDirectivo:{
						required: "Por favor, ingrese una fecha",
					},
					ALU_NombreCargoDirectivo:{
						required: "Por favor, ingrese un nombre de cargo",
						minlength:"El nombre debe contener al menos 10 caracteres"
					}
				},
				errorElement: "div",
				errorPlacement: function ( error, element ) {
					if(error[0].innerHTML!=""){
						if(element.prev("i.prefix").length>0){					
							error.css("padding-left","2.5rem");
						}else{
							error.css("padding-left","0rem");					
						}

						// Add the `help-block` class to the error element
						error.addClass( "invalid-feedback" );
						if ( element.prop( "type" ) === "checkbox" ) {					
							error.insertAfter( element.parent(".error-message") );				
						} else {
							if ( element.prop( "type" ) === "select-one" ) {																		
								error.insertAfter( element );	
							} else {						
								if ( element.prop( "type" ) === "textarea" ) {
									error.addClass( "textarea" );
									error.insertAfter( element );	
								} else {						
									//error.insertAfter( element );
									error.insertAfter( element.parent(".error-message") );				
								}
							}
						}
					}
				},
				success: function ( label, element ) {		
				},
				highlight: function ( element, errorClass, validClass ) {			
					$( element ).addClass( "is-invalid" ).removeClass( "is-valid" );
					$(element).siblings("span.select-bar").addClass( "is-invalid" ).removeClass( "is-valid" );		
				},
				unhighlight: function (element, errorClass, validClass) {			
					$( element ).addClass( "is-valid" ).removeClass( "is-invalid" );
					$(element).parent().next().remove('.invalid-feedback');
					$(element).siblings("span.select-bar").addClass( "is-valid" ).removeClass( "is-invalid" );
				},
				invalidHandler: function() {
					setTimeout(function() {
						$('.content-nav a small.required').remove();
						var validatePane = $('.tab-content.tab-validate .tabs-pane:has(.form-control.is-invalid)').each(function() {
							var id = $(this).attr('id');
							$('.content-nav').find('a[href^="#' + id + '"]').append(' <small class="required">***</small>');
						});
					});
				}		
			})
		}
	}else{		//Validacion general
		$.validator.addMethod("porTotal", function(value, element) {			
			if((parseInt($("#PRE_PorAvanceOri").val()) + parseInt($("#PRE_PorcentajeMonto").val()))>100){
				return false;
			}else{
				return true;
			}
		}, "Porcentaje ingresado supero el 100%.");
		
		$.validator.addMethod("montoFactura", function(value, element) {			
			if(parseInt(value)!=parseInt($("#PRE_MontoCuota").val()) && $(element).attr("required")!=undefined){
				return false;
			}else{
				return true;
			}
		}, "Monto factura diferente a monto cuota.");
		
		$.validator.addMethod("notEqual", function(value, element, secondelement) {
			return this.optional(element) || value != $(secondelement).val();
		}, "Archivos deben ser diferentes.");		
		$( id ).validate( {		
			rules: {
				USR_Rut:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				},
				RPS_Rut:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				},
				RPE_Rut:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				},
				RPG_Rut:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				},
				USR_Usuario:{
					required: true,
					pattern: /^[a-zA-Z0-9]{1,20}$/
				},
				USR_Apellido:{
					required: true,				
				},
				USR_Nombre:{
					required: true,				
				},				
				USR_Mail:{
					required: true,				
				},
				SEX_Id:{
					required: true,				
				},
				DEP_Idx:{
					required: true,				
				},
				PER_Id:{
					required: true,				
				},
				CAR_Id:{
					required: true,					
				},
				TDO_Nombre:{
					required: true,
				},
				CMP_Descripcion:{
					required: true,
				},
				DEP_Nombre:{
					required: true,
				},
				DEP_Codigo:{
					required: true,
				},
				usr_pass2:{	
					required: true,
					minlength: 6
				},
				inputPassword : {
					required: true,
					minlength : 8,
					maxlength : 16,
					regex: /^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$/
				},
				inputPasswordConfirm : {
					required: true,
					minlength : 8,
					maxlength : 16,
					regex: /^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$/,
					equalTo : "#inputPassword"
				},
				USR_Id:{
					required: true,
				},
				MEN_Texto:{
					required: true,
					minlength: 10
				},
				LIN_Id:{
					required: true,
				},
				"LIN_Id-10":{
					required: true,
				},
				"LIN_Id-11":{
					required: true,
				},
				"LIN_Id-12":{
					required: true,
				},
				PRY_Nonbre:{				
					minlength: 10,
					maxlength: 200
				},
				PRY_MontoAdjudicado:{
					min: 500000				
				},
				PRY_NombreLicitacion:{
					required: true,
					minlength: 10
				},
				SIN_Id:{
					required: true
				},
				PAT_Compromiso:{
					required: true
				},
				EMP_Id:{
					required: true
				},
				PEM_Compromiso:{
					required: true
				},
				CIV_Id:{
					required: true
				},
				PCI_Compromiso:{
					required: true
				},
				OES_ObjetivoEspecifico:{
					required: true,
					minlength: 10
				},
				OES_ResultadoEsperado:{
					required: true,
					minlength: 10
				},
				OES_Indicador:{
					required: true,
					minlength: 10
				},
				TPR_Nombre:{
					required: true,
					minlength: 5
				},
				PRY_ObjetivoGeneral:{
					required: true,
					minlength: 10
				},
				VPM_AccionComprometida:{
					required: true,
					minlength: 10
				},
				VPM_Etapa:{
					required: true,
					minlength: 10
				},
				OER_ObjetivoEspRelacionado:{
					required: true,
					minlength: 10
				},
				PRY_FundamentacionCriterioFocalizacion:{					
					minlength: 10
				},
				PRY_EncargadoProyecto:{
					required: true,
					minlength: 10
				},
				PRY_EncargadoProyectoMail:{
					required: true,
				},
				PRY_EncargadoProyectoCelular:{
					required: true,
					minlength: 9,
					maxlength: 9
				},
				PRY_EncargadoActividades:{
					required: true,
					minlength: 10
				},
				PRY_EncargadoActividadesMail:{
					required: true,
				},
				PRY_EncargadoActividadesCelular:{
					required: true,
					minlength: 9,
					maxlength: 9
				},
				PRY_CantPostuHombre:{
					required: true,
					min: 1,
				},
				PRY_CantPostuMujer:{
					required: true,
					min: 1,
				},
				PRY_LanzamientoFecha:{
					required: true,
				},
				PRY_LanzamientoHora:{
					required: true,
				},
				PRY_LanzamientoDireccion:{
					required: true,
					minlength: 10
				},				
				PRY_CierreFecha:{
					required: true,
				},
				PRY_CierreHora:{
					required: true,
				},
				PRY_CierreDireccion:{
					required: true,
					minlength: 10
				},
				PRY_Metodologia:{
					required: true,
					minlength: 10
				},
				MEN_TextoRechazo:{
					required: true,
					minlength: 10
				},
				
				SIN_rut:{
					required: true
				},
				SIN_Nombre:{
					required: true,
					minlength: 10
				},
				SIN_direccion:{
					required: true,
					minlength: 10
				},
				SIN_telefono:{
					required: true,
					minlength: 9
				},
				ACE_Id:{
					required: true
				},
				SIN_email:{
					required: true
				},
				RUB_Id:{
					required: true
				},
				TOR_Id:{
					required: true
				},
				SIN_DirPaginaWeb:{
					required: false
				},
				USR_Estado:{
					required: false
				},
				USR_Reset:{
					required: false
				},
				USR_LDAP:{
					required: false
				},
				PRE_NumCuota:{
					required: true
				},
				PRE_PorcentajeMonto:{
					required: true,
					porTotal:true,
					min:1
				},
				PRE_MontoFactura:{
					montoFactura: true
				},
				CDE_InfoCausaId:{
					required:true
				},
				RDE_InfoRazonId:{
					required:true
				},
				EST_InfoObservaciones:{
					minlength:10,
					maxlength:1000
				},
				INC_Veces:{
					min:1
				},
				PRY_CodigoAsociado:{
					required:false					
				},
				EME_Rol:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				},
				PRY_NumAnoExperiencia:{
					required: true,
					min:1,
					max:99
				},
				ENC_AdjuntoX:{						
					extFile: true,
					maxNameFile: true,
					notEqual: "#COR_AdjuntoX"
				},
				COR_AdjuntoX:{						
					extFile: true,
					maxNameFile: true,
					notEqual: "#ENC_AdjuntoX"
				},
				REL_AdjuntoX:{						
					extFile: true,
					maxNameFile: true				
				},
				REL_Rut:{
					required: true,
					minlength:7,
					rutValido:true,
					rutMin:true
				}				
			},
			messages: {
				USR_Rut:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				},
				RPS_Rut:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				},
				RPE_Rut:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				},
				RPG_Rut:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				},
				USR_Usuario:{
					required: "Por favor, selecciona un Usuario",
					pattern: "EL nombre de usuario no cumple con el formato"
				},
				USR_Apellido:{
					required: "Por favor, selecciona un Usuario",				
				},
				USR_Nombre:{
					required: "Por favor, selecciona un Usuario",				
				},				
				USR_Mail:{
					required: "Por favor, selecciona un Usuario",				
				},
				SEX_Id:{
					required: "Por favor, selecciona un Sexo",				
				},
				DEP_Idx:{
					required: "Por favor, selecciona un Usuario",				
				},
				PER_Id:{
					required: "Por favor, selecciona un Pefil",				
				},
				CAR_Id:{
					required: "Por favor, selecciona un Cargo",
				},
				TDO_Nombre:{
					required: "Por favor, ingresa un tipo de documento",
				},
				CMP_Descripcion:{
					required: "Por favor, ingresa una complejidad",
				},
				DEP_Nombre:{
					required: "Por favor, ingresa un departamento",
				},
				DEP_Codigo:{
					required: "Por favor, ingresa una dependencia",
				},
				usr_pass2: {
					required: "Por favor, ingrese tu Clave",
					minlength: "Tu Clave debe contener al menos 6 caracteres"
				},			
				inputPassword: {
					required: "Por favor, ungresa una clave",
					minlength: "Tu Clave debe contener al menos 8 caracteres",
					maxlength : "Tu Clave debe ser menor a 16 caracteres",
					equalTo: "Ups!, las claves no coinciden",
					regex: "Debe tener: mayúsculas, minúsculas, número y caracter especial"
				},
				USR_Id:{
					required: "Por favor, selecciona a un destinatario",
				},
				MEN_Texto:{
					required: "Por favor, escribe una consulta",
					minlength: "Tu consulta debe contener al menos 10 letras"
				},
				LIN_Id:{
					required: "Por favor, selecciona una Línea",
				},
				"LIN_Id-10":{
					required: "Por favor, selecciona una Línea para escuelas",
				},
				"LIN_Id-11":{
					required: "Por favor, selecciona una Línea para mesas",
				},
				"LIN_Id-12":{
					required: "Por favor, selecciona una Línea para cursos",
				},
				PRY_Nombre:{
					required: "Por favor, escriba un nombre para el proyecto",
					minlength: "El nombre debe contener al menos 10 letras",
					maxlength: "El nombre no debe superar las 200 letras"
				},
				REG_Id:{
					required: "Por favor, seleccione una región",
				},
				COM_Id:{
					required: "Por favor, seleccione una comuna",
				},
				REG_Id:{
					required: "Por favor, seleccione una región",
				},
				PRY_DireccionEjecucion:{
					required: "Por favor, escriba la dirección de la ejecución",
				},
				PRY_EmpresaEjecutora:{
					required: "Por favor, escriba el nombre de la empresa ejecutora",
				},
				USR_IdEjecutor:{
					required: "Por favor, seleccione un ejecutor",
				},
				USR_IdRevisor:{
					required: "Por favor, seleccione un revisor",
				},
				PRY_TipoMesa:{
					required: 'Por favor, seleccione un tipo de mesa'
				},
				PRY_MontoAdjudicado:{
					required: "Por favor, ingrese el monto adjudicado",
					minlength: 'EL monto no puede ser menor a $500.000'
				},
				PRY_IdLicitacion:{
					required: "Por favor, ingrese el id de la Licitación",
				},
				PRY_NombreLicitacion:{
					required: "Por favor, ingrese el nombre de la Licitación",
					minlength: "El nombreo debe contener al menos 10 letras"
				},
				SIN_Id:{
					required: "Por favor, seleccione una organización sindical",
				},
				PAT_Compromiso:{
					required: "Por favor, ingrese la descripción del compromiso",
				},
				EMP_Id:{
					required: "Por favor, seleccione una organización empresarial",
				},
				PEM_Compromiso:{
					required: "Por favor, ingrese la descripción del compromiso",
				},
				CIV_Id:{
					required: "Por favor, seleccione una organización civil",
				},
				PCI_Compromiso:{
					required: "Por favor, ingrese la descripción del compromiso",
				},
				OES_ObjetivoEspecifico:{
					required: "Por favor, escribe un objetivo específico",
					minlength: "Tu objetivo debe contener al menos 10 letras"
				},
				OES_ResultadoEsperado:{
					required: "Por favor, escribe un resultado esperado",
					minlength: "Tu resultado esperado debe contener al menos 10 letras"
				},
				OES_Indicador:{
					required: "Por favor, escribe un indicador",
					minlength: "Tu indicador debe contener al menos 10 letras"
				},
				TPR_Nombre:{
					required: "Por favor, escribe un nombre de módulo para agregar",
					minlength: "El nombre del módulo debe contener al menos 5 letras"
				},
				PRY_ObjetivoGeneral:{
					required: "Por favor, escribe un objetivo general",
					minlength: "Tu objetivo debe contener al menos 10 letras"
				},
				VPM_AccionComprometida:{
					required: "Por favor, escribe una Acción Comprometida/Propuesta",
					minlength: "Tu acción debe contener al menos 10 letras"
				},
				VPM_Etapa:{
					required: "Por favor, escribe la etapa donde se llevará a cabo",
					minlength: "Tu etapa debe contener al menos 10 letras"
				},
				OER_ObjetivoEspRelacionado:{
					required: "Por favor, escribe el objetivo relacionado",
					minlength: "Tu objetivo debe contener al menos 10 letras"
				},
				PRY_FundamentacionCriterioFocalizacion:{					
					minlength: "Tu fundamentación debe contener al menos 10 letras"
				},
				PRY_EncargadoProyecto:{
					required: "Por favor, escribe el nombre del/la encargado/a del proyecto",
					minlength: "El nombre debe contener al menos 10 letras"
				},
				PRY_EncargadoProyectoMail:{
					required: "Por favor, escribe el correo del/la encargado/a del proyecto",
				},
				PRY_EncargadoProyectoCelular:{
					required: "Por favor, ingresa teléfono encargado/a proyecto",
					minlength: "El número debe contener 9 dígitos"
				},
				PRY_EncargadoActividades:{
					required: "Por favor, escribe el nombre del/la encargado/a de las actividades",
					minlength: "El nombre debe contener al menos 10 letras"
				},
				PRY_EncargadoActividadesMail:{
					required: "Por favor, escribe el correo del/la encargado/a de las actividades",
				},
				PRY_EncargadoActividadesCelular:{
					required: "Por favor, ingresa teléfono encargado/a actividades",
					minlength: "El número debe contener 9 dígitos"
				},
				PRY_CantPostuHombre:{
					required: "Por favor, ingresa la cantidad de Postulantes hombres",
					min: "Debes ingresar una cantidad superior a 0",
				},
				PRY_CantPostuMujer:{
					required: "Por favor, ingresa la cantidad de Postulantes mujeres",
					min: "Debes ingresar una cantidad superior a 0",
				},
				PRY_LanzamientoFecha:{
					required: "Por favor, ingresa la fecha de lanzamiento",
				},
				PRY_LanzamientoHora:{
					required: "Por favor, ingresa la hora de lanzamiento",
				},
				PRY_LanzamientoDireccion:{
					required: "Por favor, ingresa la dirección de lanzamiento",
					minlength: "La dirección debe contener al menos 10 caracteres"
				},				
				PRY_CierreFecha:{
					required: "Por favor, ingresa la fecha de cierre",
				},
				PRY_CierreHora:{
					required: "Por favor, ingresa la hora de cierre",
				},
				PRY_CierreDireccion:{
					required: "Por favor, ingresa la dirección de cierre",
					minlength: "La dirección debe contener al menos 10 caracteres"
				},
				PRY_Metodologia:{
					required: "Por favor, ingresa la metodología",
					minlength: "La metodología debe contener al menos 10 caracteres"	
				},
				MEN_TextoRechazo:{
					required: "Por favor, ingresa un motivo de rechazo",
					minlength: "El rechazo debe contener al menos 10 caracteres"
				},				
				SIN_rut:{
					required: "Por favor, ingresa un identificador para el sindicato",
				},
				SIN_Nombre:{
					required: "Por favor, ingresa un nombre de sindicato",
					minlength: "El nombre debe contener al menos 10 caracteres"
				},
				SIN_direccion:{
					required: "Por favor, ingresa una dirección",
					minlength: "La dirección debe contener al menos 10 caracteres"
				},
				SIN_telefono:{
					required: "Por favor, escribe el número telefónico",
					minlength: "El número debe contener 9 dígitos"
				},
				ACE_Id:{
					required: "Por favor, ingrese una afiliación"
				},
				SIN_email:{
					required: "Por favor, ingrese una correo electronico"
				},
				RUB_Id:{
					required: "Por favor, ingrese una un rubro"
				},
				TOR_Id:{
					required: "Por favor, ingrese un tipo de organización"
				},
				SIN_DirPaginaWeb:{
					required: "Por favor, ingrese una dirección web del sindicato"
				},
				PRE_NumCuota:{
					required: "Número cuota"
				},
				PRE_PorcentajeMonto:{
					required: "Porcentaje cuota",
					porTotal: "Superas el 100%",
					min: "Porcentaje debe ser > 0"
				},
				PRE_MontoFactura:{
					montoFactura: "Monto factura diferente a monto cuota"
				},
				CDE_InfoCausaId:{
					required:"Por favor, ingresa una causa"
				},
				RDE_InfoRazonId:{
					required:"Por favor, ingresa una razon"
				},
				EST_InfoObservaciones:{
					minlength:"La observación debe ser mayor a 10 caracteres",
					maxlength:"La observación no puede pasar las 1000 letras",
					required:"Por favor, ingresa una descripción de la razón"
				},
				PRY_Facilitadores:{
					required:"Por favor, ingrese comentario sobre los facilitadores",					
				},
				PRY_Obstaculizadores:{
					required:"Por favor, ingrese comentario sobre los obstaculizadores"
				},
				PRY_MecMitigacion:{
					required:"Por favor, ingrese comentario sobre los mecanismos de mitigación"
				},
				INC_Veces:{
					min:"Deber ingresar un valor mayor cero"
				},
				EME_Rol:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				},
				PRY_NumAnoExperiencia:{
					required: "Por favor, ingrese cantidad de años",
					min: "Debe ser mayor a 0",
					max: "Debe ser menor a 99"
				},
				ENC_AdjuntoX:{
					required: "Por favor, agregue curriculum o documento del Encargado",
					extFile: "Extención de archivo no válido",
					maxNameFile: "Nombre de archivo supera los 60 caracteres",
					notEqual:"El archivo debe ser distinto al del Coordinador"
				},
				ENC_Adjunto:{
					//accept:"Formato de archivo no válido"
					accept:""
				},
				COR_AdjuntoX:{
					required: "Por favor, agregue curriculum o documento del Coordinador",
					extFile: "Extención de archivo no válido",
					maxNameFile: "Nombre de archivo supera los 60 caracteres",
					notEqual:"El archivo debe ser distinto al del Encargado"
				},
				COR_Adjunto:{
					//accept:"Formato de archivo no válido"
					accept:""
				},
				REL_AdjuntoX:{					
					extFile: "Extención de archivo no válido",
					maxNameFile: "Nombre de archivo supera los 60 caracteres",
					notEqual:"El archivo debe ser distinto al del Encargado"
				},
				REL_Adjunto:{
					//accept:"Formato de archivo no válido"
					accept:""
				},
				REL_Rut:{
					required: "Por favor, ingrese un RUT",
					minlength: "El RUT debe ser al menos de 6 dígitos mas un dv",
					rutValido: "Por favor, ingresa un RUT válido",
					rutMin:"El RUT debe ser al menos mayor o igual a 50.000"
				}				
			},
			errorElement: "div",
			errorPlacement: function ( error, element ) {
				if(error[0].innerHTML!=""){
					if(element.prev("i.prefix").length>0){					
						error.css("padding-left","2.5rem");
					}else{
						error.css("padding-left","0rem");					
					}

					// Add the `help-block` class to the error element
					error.addClass( "invalid-feedback" );
					if ( element.prop( "type" ) === "checkbox" ) {					
						error.insertAfter( element.parent(".error-message") );				
					} else {
						if ( element.prop( "type" ) === "select-one" ) {																		
							error.insertAfter( element );	
						} else {						
							if ( element.prop( "type" ) === "textarea" ) {
								error.addClass( "textarea" );
								error.insertAfter( element );	
							} else {						
								//error.insertAfter( element );
								error.insertAfter( element.parent(".error-message") );				
							}
						}
					}
				}
			},
			success: function ( label, element ) {		
			},
			highlight: function ( element, errorClass, validClass ) {			
				$( element ).addClass( "is-invalid" ).removeClass( "is-valid" );
				$(element).siblings("span.select-bar").addClass( "is-invalid" ).removeClass( "is-valid" );		
			},
			unhighlight: function (element, errorClass, validClass) {			
				$( element ).addClass( "is-valid" ).removeClass( "is-invalid" );
				$(element).parent().next().remove('.invalid-feedback');
				$(element).siblings("span.select-bar").addClass( "is-valid" ).removeClass( "is-invalid" );
			}				
		})
	}
}

$(document).ready(function(e) {
	"use strict";	
	if (window.history && window.history.pushState) {
		window.history.pushState('forward', null, window.location.href);
		$(window).on('popstate', function() {
			//alert('Back button was pressed.');
			salir();
			window.history.forward();
		});
	}	
	window.history.replaceState(null, "", window.location.href);        
	window.onpopstate = function() {
		window.history.replaceState(null, "", window.location.href);
	};	
	$('body').addClass("bootstrap");
	$('body').removeClass("bootstrap-dark");
	$(".waves-effect").addClass("waves-light");
	$(".waves-effect").removeClass("waves-dark");
	
	//if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
	if(darkmode()){
		// dark mode		
		$('body').addClass("bootstrap-dark");
		$('body').removeClass("bootstrap");
		theme='ui-darkness';
		scrollbarTheme='inset-3-dark'
		bootstrapTheme="bootstrap-dark.css"
		$(".waves-effect").removeClass("waves-light");
		$(".waves-effect").addClass("waves-dark");
	}
	var urltheme = "https://" + host + "/vendor/jquery/css/" + theme + ".jquery-ui.css";
	$("#ui-theme").attr('href',urltheme);
	
	urltheme = "https://" + host + "/vendor/bootstrap/css/" + bootstrapTheme;
	$("#bootstrap-theme").attr('href',urltheme);

	//Carga escritorio o cualquier otro elemento
	var keys=$("body").data("keys");			
	if(keys!=undefined && keys>0){	
		var varValue;
		var varName;
		var data=[];
		var objeto={};		
		
		for(var i= 0; i < keys; i++) {
			varValue=$("body").data("key"+(i+1));
			varName = "key"+(i+1);			
			objeto[varName]=varValue;				
		}			
		cargacomponente("/"+$("body").data("id"),objeto);
		cargabreadcrumb("/breadcrumbs","");
	}else{
		cargacomponente("/"+$("body").data("id"),"");
		cargabreadcrumb("/breadcrumbs","");
	}
	if(!error){
		cargaperfil();
		iniActions();				
		$(window).keydown(function(event){
			//if((event.which== 13) && ($(event.target)[0]!=$("#NUM_NumeralMultas")[0]) && $(event.target)[0]!=$(".jqte_editor")[0]) {
			//if((event.which== 13) && ($(event.target)[0]!=$(".jqte_editor")[0])) {
			if((event.which== 13) && !$(event.target).hasClass("jqte_editor")) {			
			  event.preventDefault();
			  return false;
			}
		});
	};
	//Descargar
	clearInterval(titdesani);
	var titdesani = setInterval(function(){		
		$("#descargas").css("bottom",-($("#descargas").height()+1) + "px");
		clearInterval(titdesani);
	},4000);
	$(".desarrow").on('click',function(){
		clearInterval(titdesani);
		$(this).toggleClass("openmenu");		
		if($("#descargas").css("bottom")=="-" + ($("#descargas").height()+1) + "px"){
			$("#descargas").css("bottom","5px");
		}else{			
			$("#descargas").css("bottom","-" + ($("#descargas").height()+1) + "px");
		}				
	})
});

//Session
function confirmarCierre() {
	let timerInterval
	swalWithBootstrapButtons.fire({
	  title: 'Cierre de sesión.',
	  html: 'Su sesión expirará en <b></b> segundos. </br>Presione OK para mantenerse activo.',
	  timer: 20000,
	  timerProgressBar: true,
	  allowOutsideClick: false,
	  allowEscapeKey: false,
	  showConfirmButton: true,
	  icon:'warning',
	  onBeforeOpen: () => {		
		timerInterval = setInterval(() => {
		  const content = swalWithBootstrapButtons.getContent()
		  if (content) {
			const b = content.querySelector('b')
			if (b) {
			  b.textContent = Math.trunc(swalWithBootstrapButtons.getTimerLeft() / 1000)
			}
		  }
		}, 100)
	  },
	  onClose: () => {
		clearInterval(timerInterval)
	  }
	}).then((result) => {
	  /* Read more about handling dismissals below */
	  if (result.dismiss === swalWithBootstrapButtons.DismissReason.timer) {		
		cerrarSesion();
	  }else{
	  	//clearTimeout(cerrar); //elimino el tiempo a la funcion cerrarSesion
		clearTimeout(temp); //elimino el tiempo a la funcion confirmarCierre
		//temp = setTimeout(confirmarCierre, 80000);
		
		$.ajax({
			type: 'POST',								
			url:"/reactivar-session",		
			success: function(data) {

			},
			error: function(XMLHttpRequest, textStatus, errorThrown){				

			},
			complete: function(){

			}
		})
		swalWithBootstrapButtons.fire(
		  'Sesión',
		  'Su cierre de sesión ha sido cancelado.',
		  'info'
		)
	  }
	})
}

function cerrarSesion() {
    $.ajax({
		type: 'POST',								
		url:"/cerrar-session",		
		success: function(data) {
			
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){				
			
		},
		complete: function(){
			
		}
	});
	    
	swalWithBootstrapButtons.fire(
	  'Sesión',
	  'Su sesión ha sido cerrada',
	  'info'
	).then((result) => {		
		window.location.href="/sesion-finalizada"
	})    
}

var temp = setTimeout(confirmarCierre, 60000*15);

$( document ).on('click keyup keypress keydown blur change', function(e) {
    clearTimeout(temp);    
    temp = setTimeout(confirmarCierre, 60000*15);    
});

function calculardiferencia(HraIni,HraIFin,HraTot){
	var hora_inicio = HraIni
	var hora_final = HraIFin
	var HraTot;

	// Expresión regular para comprobar formato
	var formatohora = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;

	// Si algún valor no tiene formato correcto sale
	if (!(hora_inicio.match(formatohora)
		&& hora_final.match(formatohora))){
	return;
	}

	// Calcula los minutos de cada hora
	var minutos_inicio = hora_inicio.split(':')
	.reduce((p, c) => parseInt(p) * 60 + parseInt(c));
	var minutos_final = hora_final.split(':')
	.reduce((p, c) => parseInt(p) * 60 + parseInt(c));

	// Si la hora final es anterior a la hora inicial sale
	if (minutos_final < minutos_inicio) return;

	// Diferencia de minutos
	var diferencia = minutos_final - minutos_inicio;

	// Cálculo de horas y minutos de la diferencia
	var horas = Math.floor(diferencia / 45);
	var minutos = diferencia % 45;

	/*$(HraTot).val(horas + ':'
	+ (minutos < 10 ? '0' : '') + minutos);  */
	
	HraTot = horas + ':'
	+ (minutos < 10 ? '0' : '') + minutos;
	
	return HraTot
}
$.fn.clearValidation = function(){
	var v = $(this).validate();
	$('[name]',this).each(function(){
		v.successList.push(this);
		v.showErrors();
	});
	v.resetForm();
	v.reset();
};

function shake(thing) {
  var interval = 100;
  var distance = 10;
  var times = 6;

  for (var i = 0; i < (times + 1); i++) {
    $(thing).animate({
      left:
        (i % 2 == 0 ? distance : distance * -1)
    }, interval);
  }
  $(thing).animate({
    left: 0,
    top: 0
  }, interval);
}
// end SHAKE

function bounce(thing) {
  var interval = 100;
  var distance = 20;
  var times = 6;
  var damping = 0.8;

  for (var i = 0; i < (times + 1); i++) {
    var amt = Math.pow(-1, i) * distance / (i * damping);
    $(thing).animate({
      top: amt
    }, 100);
  }
  $(thing).animate({
    top: 0
  }, interval);
}
// end BOUNCE
function hinge(thing) {
	$(thing).addClass('animated hinge');
  $(thing).on('animationend mozanimationend webkitAnimationEnd oAnimationEnd msanimationend', function() {
		$(thing).remove();
    // add a new button to restore the images, which were just removed
    $('div').append('<button id="restore">Restore</button>');
    // clicking that button runs this to rewrite the removed images
    // into the HTML where they were previously 
    $('#restore').click(function() {
			$('div').after(allImages);
      $('#restore').remove();
		});
	});
}
// end HINGE 

//Workers
function download_csv_file(csvFileData,header,filename) {
	var rowheader='';
	var csv='';
	header.forEach(function(field) {
			//rowheader += row.join(';');
			rowheader += field + ";";					
	});			
	//merge the data with CSV
	csvFileData.forEach(function(row) {
			csv += row.join(';');
			csv += "\n";
	});
	csv = '\uFEFF' + rowheader + "\n" + csv	
	//document.write(csv);			

	var hiddenElement = document.createElement('a');
	hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
	hiddenElement.target = '_blank';
		
	hiddenElement.download = filename + '.csv';
	hiddenElement.click();			
}

function wrk_reportes(worker,idTable){
	if("undefined" !== typeof Worker){
		var miWorker = new Worker('/wrk-reportes'); // Como argumento le pasamos la ruta del script
		var csvFileData;
		var row = [];

		$("#tbl-" + idTable).DataTable().columns().header().each(function(e,i){			
			row.push(e.innerText.replace(/(\r\n|\n|\r)/gm, ""))
		});	
		
		geninfo(idTable + '.csv',true)
		miWorker.postMessage(worker);
		activeWorkers.push(worker.replace('/',''));
		//console.log(activeWorkers);		
		miWorker.onmessage = function(evento){			
			//console.log(evento.data.status);
			if(evento.data.status=='0'){
				csvFileData = evento.data.data;
								
				//console.log(row)
				//console.log(evento.data.data);				
				download_csv_file(csvFileData,row,idTable);
				geninfo(idTable,false)
				if(activeWorkers.indexOf(worker.replace('/',''))!==-1){
					activeWorkers.splice(activeWorkers.indexOf(worker.replace('/','')),1);
				}
				//console.log(activeWorkers);
				miWorker.terminate();
			}
		}
	}
}

function geninfo(name, tipo){
	progressArea = document.querySelector("#descargas .progress-area"),
	uploadedArea = document.querySelector("#descargas .uploaded-area");
	
	if(tipo){
		let progressHTML = `<li class="row">
							<div class="content">
								<i class="fas fa-file-alt"></i>							
								<div class="details">
									<span class="name">${name} • Generando...</span>                              
								</div>
								<i class="loader"></i>
							</div>
							</li>`;		
		uploadedArea.classList.add("onprogress");
		progressArea.innerHTML = progressHTML;
		clearInterval(titdesani);
		var titdesani = setInterval(function(){
			$(".desarrow").removeClass("openmenu")
			$("#descargas").css("bottom",-($("#descargas").height()+1) + "px");
			clearInterval(titdesani);
		},4000);
	}else{
		progressArea.innerHTML = "";
		let uploadedHTML = `<li class="row">
                            <div class="content upload">
                              <i class="fas fa-file-alt"></i>
                              <div class="details">
                                <span class="name">${name} • Generado</span>                                
                              </div>
                            </div>
                            <i class="fas fa-check"></i>
                          </li>`;
		uploadedArea.classList.remove("onprogress");
		uploadedArea.insertAdjacentHTML("afterbegin", uploadedHTML);		
	}
	$(".desarrow").addClass("openmenu")
	$("#descargas").css("bottom","5px");
}

function wrk_informes(worker,name,PRY_Id, PRY_Identificador,menu,ds5_usrid,ds5_usrtoken){
	if("undefined" !== typeof Worker){
		var miWorker = new Worker('/wrk-informes'); // Como argumento le pasamos la ruta del script
		geninfo(name ,true)
		miWorker.postMessage({worker:worker,PRY_Id:PRY_Id,PRY_Identificador:PRY_Identificador,FileName:name,ds5_usrid:ds5_usrid,ds5_usrtoken:ds5_usrtoken});
		activeWorkers.push(worker.replace('/',''));
		miWorker.onmessage = function(evento){			
			if(evento.data.status=='0'){
				geninfo(name,false)
				if(activeWorkers.indexOf(worker.replace('/',''))!==-1){
					activeWorkers.splice(activeWorkers.indexOf(worker.replace('/','')),1);
				}				
				miWorker.terminate();
				var href = window.location.href;
				var newhref = href.substr(href.indexOf("/home")+6,href.length);
				var href_split = newhref.split("/")				

				var xdata={LIN_Id:href_split[2],PRY_Id:PRY_Id,PRY_Hito:href_split[4],CRT_Step:href_split[5],Modulo:false};
									
				$.ajax( {
					type:'POST',					
					url: menu,
					data: xdata,
					success: function ( data ) {											
						param = data.split(sas)											
						if(param[0]==200){												
							$("#pry-menucontent").html(param[1]);
							moveMark(false);
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						console.log('Error 0: ' + XMLHttpRequest)		
					}
				})				
			}
		}
	}
}

function calculardiferencia(tipo,hora_inicio,hora_final){	
	// Expresión regular para comprobar formato
	var formatohora = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
	
	// Si algún valor no tiene formato correcto sale
	if (!(hora_inicio.match(formatohora)
		  && hora_final.match(formatohora))){
	  return;
	}
	
	// Calcula los minutos de cada hora
	var minutos_inicio = hora_inicio.split(':')
	  .reduce((p, c) => parseInt(p) * 60 + parseInt(c));
	var minutos_final = hora_final.split(':')
	  .reduce((p, c) => parseInt(p) * 60 + parseInt(c));
	
	// Si la hora final es anterior a la hora inicial sale
	if (minutos_final < minutos_inicio) return;
	
	// Diferencia de minutos
	var diferencia = minutos_final - minutos_inicio;
	
	// Cálculo de horas y minutos de la diferencia
	var horas = Math.floor(diferencia / 60);
	var minutos = diferencia % 60;
	
	if(tipo=="m"){
		return diferencia;
	}
	if(tipo=="h"){
		return horas + ':' + (minutos < 10 ? '0' : '') + minutos;
	}	  	
}