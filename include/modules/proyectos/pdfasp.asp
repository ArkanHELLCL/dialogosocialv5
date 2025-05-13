<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
		response.write("503/@/Error de conexion")
		response.End() 			   
	end if		
	
	PRY_Id		= request("PRY_Id")
	INF_Id		= request("INF_Id")	
	PRY_Hito	= request("PRY_Hito")
	mnuarc		= request("mnuarc")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if		
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
	   response.write("503/@/Error de conexion")
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		LFO_Id 						= rs("LFO_Id")
		PRY_Carpeta					= rs("PRY_Carpeta")
		PRY_Nombre					= rs("PRY_Nombre")
		PRY_EncargadoProyecto		= rs("PRY_EncargadoProyecto")
		PRY_EmpresaEjecutora		= rs("PRY_EmpresaEjecutora")
		
		PRY_CreacionProyectoEstado 	= rs("PRY_CreacionProyectoEstado")
		PRY_InformeInicioEstado		= rs("PRY_InformeInicioEstado")
		PRY_InformeParcialEstado	= rs("PRY_InformeParcialEstado")
		PRY_InformeFinalEstado		= rs("PRY_InformeFinalEstado")
		
		PRY_InformeInicioAceptado	= rs("PRY_InformeInicioAceptado")
		PRY_InformeParcialAceptado	= rs("PRY_InformeParcialAceptado")
		PRY_InformeFinalAceptado	= rs("PRY_InformeFinalAceptado")
		
		PRY_InformeInicialEstado	= rs("PRY_InformeInicialEstado")
		PRY_InformeConsensosEstado	= rs("PRY_InformeConsensosEstado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		
		if(IsNull(PRY_CreacionProyectoEstado)) then
			PRY_CreacionProyectoEstado=0
		end if
		if(IsNull(PRY_InformeInicioEstado)) then
			PRY_InformeInicioEstado=0
		end if
		if(IsNull(PRY_InformeParcialEstado)) then
			PRY_InformeParcialEstado=0
		end if
		if(IsNull(PRY_InformeFinalEstado)) then
			PRY_InformeFinalEstado=0
		end if
		if(IsNull(PRY_InformeInicioAceptado)) then
			PRY_InformeInicioAceptado=0
		end if
		if(IsNull(PRY_InformeParcialAceptado)) then
			PRY_InformeParcialAceptado=0
		end if
		if(IsNull(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=0
		end if
		if(IsNull(PRY_InformeInicialEstado)) then
			PRY_InformeInicialEstado=0
		end if
		if(IsNull(PRY_InformeConsensosEstado)) then
			PRY_InformeConsensosEstado=0
		end if
		if(IsNull(PRY_InformeSistematizacionEstado)) then
			PRY_InformeSistematizacionEstado=0
		end if						
	else
		response.write("1/@/Tabla proyectos sin datos")
		rs.close
		cnn.close
		response.end()
	end if
	
	if LFO_Id=10 then
		if PRY_CreacionProyectoEstado=1 and INF_Id=0 then		'Solo si el hito INICIO esta cerrado						
			INF_Url="/informe-creacion-escuela"
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_CreacionProyectoEstado=0 and INF_Id=0 then
				response.write("2/@/Hito Creacion no cerrado")
				response.end()
			end if
		end if		

		if PRY_InformeInicioEstado=1 and INF_Id=1 then		'Solo si el hito INICIO esta cerrado						
			INF_Url="/informe-inicio-escuela"
			informe="Inicio"
			carpeta="informeinicio"
			titulo="Informe Inicio"
		else
			if PRY_InformeInicioEstado=0 and INF_Id=1 then
				response.write("2/@/Hito Inicio no cerrado")				
				response.end()
			end if
		end if		

		if PRY_InformeParcialEstado=1 and INF_Id=2 then	
			INF_Url="/informe-parcial-escuela"
			informe="Parcial"
			carpeta="informeparcial"
			titulo="Informe Parcial"
		else
			if PRY_InformeParcialEstado=0 and INF_Id=2 then
				response.write("2/@/Hito Desarrollo no cerrado")
				response.end()
			end if
		end if
		
		if INF_Id=3 then	
			INF_Url="/informe-final-escuela"
			informe="Final"
			carpeta="informefinal"
			titulo="Informe Final"
		end if
		
	end if
	
	if LFO_Id=11 then
		if PRY_CreacionProyectoEstado=1 and INF_Id=0 then		'Solo si el hito CREACION esta cerrado						
			INF_Url="/informe-creacion-mesas"
			informe="Creación"
			carpeta="informecreacionmesa"
			titulo="Informe de Creación"
		else
			if PRY_CreacionProyectoEstado=0 and INF_Id=0 then
				response.write("2/@/Hito Creacion no cerrado")
				response.end()
			end if
		end if
		
		if PRY_InformeInicialEstado=1 and INF_Id=1 then		'Solo si el hito INICIAL esta cerrado						
			INF_Url="/informe-inicial-mesas"
			informe="Inicial"
			carpeta="informeinicialmesa"
			titulo="Informe Inicial"
		else
			if PRY_InformeInicialEstado=0 and INF_Id=1 then
				response.write("2/@/Hito Inicial no cerrado")				
				response.end()
			end if
		end if
		
		if PRY_InformeConsensosEstado=1 and INF_Id=2 then		'Solo si el hito CONCENSOS esta cerrado						
			INF_Url="/informe-avances-mesas"
			informe="Desarrollo"
			carpeta="informeavancesmesa"
			titulo="Informe de Desarrollo"
		else
			if PRY_InformeConsensosEstado=0 and INF_Id=2 then
				response.write("2/@/Hito Concensos no cerrado")				
				response.end()
			end if
		end if
		
		if PRY_InformeSistematizacionEstado=1 and INF_Id=3 then		'Solo si el hito SISTEMATIZACION esta cerrado						
			INF_Url="/informe-sistematizacion-mesas"
			informe="Sistematizacion"
			carpeta="informesistematizacionmesa"
			titulo="Informe de Sistematización"
		else
			if PRY_InformeSistematizacionEstado=0 and INF_Id=3 then
				response.write("2/@/Hito Concensos no cerrado")				
				response.end()
			end if
		end if	
		
	end if
	
	if LFO_Id=12 then
		if PRY_CreacionProyectoEstado=1 and INF_Id=0 then		'Solo si el hito INICIO esta cerrado						
			INF_Url="/informe-creacion-cursos"
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_CreacionProyectoEstado=0 and INF_Id=0 then
				response.write("2/@/Hito Concensos no cerrado")				
				response.end()
			end if
		end if		

		if PRY_InformeInicioEstado=1 and INF_Id=1 then		'Solo si el hito INICIO esta cerrado						
			INF_Url="/informe-inicio-cursos"
			informe="Inicio"
			carpeta="informeinicio"
			titulo="Informe Inicio"
		else
			if PRY_InformeInicioEstado=0 and INF_Id=1 then
				response.write("2/@/Hito Concensos no cerrado")
				response.end()
			end if
		end if				
	
		if INF_Id=2 then	
			INF_Url="/informe-final-cursos"
			informe="Final"
			carpeta="informefinal"
			titulo="Informe Final"
		end if
		
	end if
	
	fecha = "Santiago, " & Date()	
	INF_Path="d:/DocumentosSistema/dialogosocial/" & mid(PRY_Carpeta,2,len(PRY_Carpeta)-2) & "/informes/" & carpeta & "/" 
	INF_Archivo = carpeta
	cnn.close
	set cnn = nothing
	
	splitruta=split(ruta,"/")		
	LIN_Id=splitruta(6)
	PRY_Id=splitruta(7)
	PRY_Hito=splitruta(8)
	CRT_Step=splitruta(9)
	
	response.write("200/@/")%>
	
<script>
	$(document).ready(function() {
		$(function(){
			var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
			$.ajaxSetup({
				async: false			  	
			});
			$.ajax({
				type: 'POST',
				url: '<%=INF_Url%>',
				data:{PRY_Id:<%=PRY_Id%>},
				success: function(data) {
					$.ajax({
						type: 'POST',									
						url:'/genera-informe-html',
						data:{informe:data, INF_Path:'<%=INF_Path%>', INF_Archivo:'<%=INF_Archivo%>'},
						success: function(data) {																					
							$.ajax({
								type: 'POST',									
								url:'/genera-informe',
								data:{titulo: '<%=titulo%>', nombre: '<%=PRY_Nombre%>', encargado: '<%=PRY_EncargadoProyecto%>', ejecutor: '<%=PRY_EmpresaEjecutora%>', fecha: '<%=fecha%>', path: '<%=INF_Path%>' , archivo: '<%=INF_Archivo%>'},
								success: function(data) {																		
									console.log("Result:");
									console.log(data);									
									var xdata={LIN_Id:<%=LIN_Id%>,PRY_Id:<%=PRY_Id%>,PRY_Hito:<%=PRY_Hito%>,CRT_Step:<%=CRT_Step%>}
									
									$.ajax( {
										type:'POST',					
										url: '<%=mnuarc%>',
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
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){
									console.log('Error 1: ' + XMLHttpRequest)		
								}
							});		
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							console.log('Error 2: ' + XMLHttpRequest)
						}
					});		

				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					console.log('Error 3: ' + XMLHttpRequest)
				},
				complete: function(){
					$('#ajaxBusy').hide(); 
				}
			});
			$.ajaxSetup({
				async: true
			});
		})
	})
</script>