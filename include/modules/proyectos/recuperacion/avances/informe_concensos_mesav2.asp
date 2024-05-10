<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<!-- #INCLUDE file="session.min.inc" -->
</head>
<style>	
	h1 {
		display: block;
		font-size: 12pt;		
		margin-bottom: 0px;
		margin-left: 0;
		margin-right: 0;
		font-weight: bold;
		padding: 0;
		margin: 0;
	}
	h4 {
		display: block;
		font-size: 12pt;
		margin-top: 0px;
		margin-bottom: 1.33em;
		margin-left: 0;
		margin-right: 0;		
		font-weight: bold;
		padding-top: 10px;
	}
	h5 {
		display: block;
		font-size: 10pt;
		margin-top: 0px;
		margin-bottom: .7em;
		margin-left: 0;
		margin-right: 0;
		font-weight: bold;
	}	
	table {     
		font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;		
		width: 100%; 
		text-align: left;    
		border-collapse: collapse; 
	}

	th {     
		font-size: 10pt;
		font-weight: bold;
		padding: 2px;		
		background-color: #b9c9fe;    	
	}

	td { 
		font-size: 10px;
		padding: 2px;		
		background-color: #e8edff;     		
    	color: #669;    		
	}		
</style>
<%
PRY_Id		= request("PRY_Id")
MasterPage	= "Informe_Avances"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	response.end
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.end
	End If
			
	if not rs.eof then
		'PRY_Id							 = rs("PRY_Id")
		PRY_Identificador		         = rs("PRY_Identificador")
		PRY_Estado                       = rs("PRY_Estado")
		USR_IdRevisor			         = setNULL(rs("USR_IdRevisor"))
		USR_NombreRevisor		         = rs("USR_NombreRevisor")
		USR_ApellidoRevisor		         = rs("USR_ApellidoRevisor")
		USR_MailRevisor					 = rs("USR_MailRevisor")
		USR_TelefonoRevisor				 = rs("USR_TelefonoRevisor")
		USR_DireccionRevisor			 = rs("USR_DireccionRevisor")
		USR_NombreInstitucionRevisor	 = rs("USR_NombreInstitucionRevisor")					
		USR_IdEjecutor			         = setNULL(rs("USR_IdEjecutor"))
		USR_NombreEjecutor		         = rs("USR_NombreEjecutor")
		USR_ApellidoEjecutor	         = rs("USR_ApellidoEjecutor")
		USR_MailEjecutor				 = rs("USR_MailEjecutor")
		USR_TelefonoEjecutor			 = rs("USR_TelefonoEjecutor")
		USR_DireccionEjecutor			 = rs("USR_DireccionEjecutor")
		USR_NombreInstitucionEjecutor	 = rs("USR_NombreInstitucionEjecutor")										
		LIN_Id				             = setNULL(rs("LIN_Id"))
		LIN_Nombre 	                     = rs("LIN_Nombre")
		LFO_Id                           = setNULL(rs("LFO_Id"))
		LFO_Nombre                       = rs("LFO_Nombre")									
		COM_Id 			                 = setNULL(rs("COM_Id"))
		COM_Nombre			             = rs("COM_Nombre")
		REG_Id					         = rs("REG_Id")
		REG_Nombre				         = rs("REG_Nombre")
		PRY_Nombre		                 = rs("PRY_Nombre")
		PRY_AnioProyecto	             = rs("PRY_AnioProyecto")
		PRY_DireccionEjecucion           = rs("PRY_DireccionEjecucion")
		PRY_MontoAdjudicado              = rs("PRY_MontoAdjudicado")													
		PRY_EncargadoProyecto            = rs("PRY_EncargadoProyecto")
		PRY_EncargadoProyectoMail        = rs("PRY_EncargadoProyectoMail")	
		PRY_EncargadoProyectoCelular     = rs("PRY_EncargadoProyectoCelular")	
		PRY_EncargadoActividades         = rs("PRY_EncargadoActividades")
		PRY_EncargadoActividadesMail     = rs("PRY_EncargadoActividadesMail")
		PRY_EncargadoActividadesCelular  = rs("PRY_EncargadoActividadesCelular")
		SEX_IdEncargadoActividades	     = rs("SEX_IdEncargadoActividades")						
		SEX_IdEncargadoProyecto          = rs("SEX_IdEncargadoProyecto")
		PRY_UsuarioEdit					 = rs("PRY_UsuarioEdit")												
		PRY_FechaEdit					 = rs("PRY_FechaEdit")
		PRY_AccionEdit					 = rs("PRY_AccionEdit")
		PRY_InformeInicioFecha			 = rs("PRY_InformeInicioFecha")
		PRY_InformeInicioEstado			 = rs("PRY_InformeInicioEstado")
		PRY_InformeInicioFechaEnvio		 = rs("PRY_InformeInicioFechaEnvio")
		PRY_InformeParcialFecha			 = rs("PRY_InformeParcialFecha")
		PRY_InformeParcialEstado		 = rs("PRY_InformeParcialEstado")
		PRY_InformeParcialFechaEnvio	 = rs("PRY_InformeParcialFechaEnvio")
		PRY_InformeDesarrolloFecha		 = rs("PRY_InformeDesarrolloFecha")
		PRY_InformeDesarrolloEstado		 = rs("PRY_InformeDesarrolloEstado")
		PRY_InformeDesarrolloFechaEnvio	 = rs("PRY_InformeDesarrolloFechaEnvio")
		PRY_InformeFinalFecha			 = rs("PRY_InformeFinalFecha")
		PRY_InformeFinalEstado			 = rs("PRY_InformeFinalEstado")
		PRY_InformeFinalFechaEnvio		 = rs("PRY_InformeFinalFechaEnvio")
		PRY_Step						 = rs("PRY_Step")		
		PRY_CreacionProyectoEstado		 = rs("PRY_CreacionProyectoEstado")			
		PRY_CreacionProyectoFechaEnvio	 = rs("PRY_CreacionProyectoFechaEnvio")
		'Inicio
		PRY_CantPostuHombre				 = rs("PRY_CantPostuHombre")
		PRY_CantPostuMujer				 = rs("PRY_CantPostuMujer")	
											
		PRY_LanzamientoFecha			 = rs("PRY_LanzamientoFecha")	
		PRY_LanzamientoHora				 = rs("PRY_LanzamientoHora")	
		COM_IdLanzamiento				 = setNULL(rs("COM_IdLanzamiento"))
		PRY_LanzamientoDireccion		 = rs("PRY_LanzamientoDireccion")	
		PRY_CierreFecha					 = rs("PRY_CierreFecha")	
		PRY_CierreHora					 = rs("PRY_CierreHora")	
		COM_IdCierre					 = setNULL(rs("COM_IdCierre"))
		PRY_CierreDireccion				 = rs("PRY_CierreDireccion")
		PRY_HorasPedagogicasMin			 = rs("PRY_HorasPedagogicasMin")	
		LIN_AgregaTematica 				 = rs("LIN_AgregaTematica")
		PRY_Carpeta						 = rs("PRY_Carpeta")
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		
		PRY_InformeInicialEstado         = rs("PRY_InformeInicialEstado")
		PRY_InformeConsensosEstado       = rs("PRY_InformeConsensosEstado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeInicialFecha			 = rs("PRY_InformeInicialFecha")
		PRY_InformeConsensosFecha		 = rs("PRY_InformeConsensosFecha")
		PRY_InformeSistematizacionFecha	 = rs("PRY_InformeSistematizacionFecha")		
		PRY_TipoMesa					 = rs("PRY_TipoMesa")
		PRY_AvancesFacilitadores		 = rs("PRY_AvancesFacilitadores")
		PRY_AvancesObstaculizadores		 = rs("PRY_AvancesObstaculizadores")
		PRY_AvancesSintesis				 = rs("PRY_AvancesSintesis")
		 		
	else
		response.end	
	end if
	rs.Close
	if PRY_CreacionProyectoEstado=0 then		'Solo si el hito CREACION esta cerrado
		response.Write("1")
		response.End()	
	end if
	if PRY_Estado=0 then
		Estado="Desactivado"				
	end if
	if PRY_Estado=1 then
		Estado="Activado"
	end if
	
	set rs = cnn.Execute("exec spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close 			   
		response.end
	End If
	TotalInscri=0
	PRY_CantInscriMujer=0
	PRY_CantInscriHombre=0
	do While Not rs.EOF 
		TotalInscri=TotalInscri+1
		if rs("SEX_Id")=1 then	'Mujer
			PRY_CantInscriMujer=PRY_CantInscriMujer+1
		else
			PRY_CantInscriHombre=PRY_CantInscriHombre+1
		end if
		rs.movenext
	loop
else
	response.end
end if		
%>
	<body style="padding: 0;margin: 0;">
		<div class="container">
        	
            <div id="contenido">
    	    	<h4>Mesa bi/tripartita n°1</h4>				
				 <table> 
					<thead> 
						<tr> 							
							<th width="30">S.</th>
							<th width="80">Día</th>
							<th width="200">Módulos</th>
							<th width="300">Contenidos</th>
							<th width="340">Conclusiones</th>
						</tr> 
					</thead> 
					<tbody><%						
						set rx=cnn.execute("spMesaSectorialTrabajadores_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
						   'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							response.end
						End If
						rx.movefirst
						do while not rx.eof%>																			
							<tr class="">								
								<td width="30"><%=rx("MST_NumSesion")%></td>                      	                  	
								<td width="80"><%=rx("MST_DiaActividad")%></td> 
								<td width="200"><%=rx("MST_TematicaAbordada")%></td>											
								<td width="300"><%=rx("MST_ContenidosTrabajados")%></td>
								<td width="340"><%=rx("MST_Conclusion")%></td>											
							</tr><%
							rx.movenext
						loop											
						rx.close%>                            
					</tbody>
				</table>	
				
				<h4>Mesa bi/tripartita n°2</h4>				
				 <table> 
					<thead> 
						<tr> 							
							<th width="30">S.</th>
							<th width="80">Dia</th>
							<th width="200">Módulos</th>
							<th width="300">Contenidos</th>
							<th width="340">Conclusiones</th>
						</tr> 
					</thead> 
					<tbody><% 						
						set rx=cnn.execute("spMesaSectorialEmpleador_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
						   'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							response.end
						End If
						rx.movefirst
						do while not rx.eof%>																			
							<tr class="">						
								<td width="30"><%=rx("MSE_NumSesion")%></td>                      	                  	
								<td width="80"><%=rx("MSE_DiaActividad")%></td> 
								<td width="200"><%=rx("MSE_TematicaAbordada")%></td>											
								<td width="300"><%=rx("MSE_ContenidosTrabajados")%></td>
								<td width="340"><%=rx("MSE_Conclusion")%></td>											
							</tr><%
							rx.movenext
						loop											
						rx.close%>                            
					</tbody>
				</table>
				
				<h4>Mesa bi/tripartita n°3</h4>				
				 <table> 
					<thead> 
						<tr> 							
							<th width="30">S.</th>
							<th width="80">Dia</th>
							<th width="200">Módulos</th>
							<th width="300">Contenidos</th>
							<th width="340">Conclusiones</th>
						</tr> 
					</thead> 
					<tbody><% 						
						set rx=cnn.execute("spMesaSectorialGobierno_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
						   'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							response.end
						End If
						rx.movefirst
						do while not rx.eof%>																			
							<tr class="">								
								<td width="30"><%=rx("MSG_NumSesion")%></td>                      	                  	
								<td width="80"><%=rx("MSG_DiaActividad")%></td> 
								<td width="200"><%=rx("MSG_TematicaAbordada")%></td>											
								<td width="300"><%=rx("MSG_ContenidosTrabajados")%></td>
								<td width="340"><%=rx("MSG_Conclusion")%></td>											
							</tr><%
							rx.movenext
						loop											
						rx.close%>                            
					</tbody>
				</table>
				
				<h4>Evaluación de proceso</h4>				
				<table border="0"> 
					 <thead> 
						<tr> 
							<th>Facilitadores</th>							
						</tr> 
					</thead> 					
					<tbody>
						<tr>								
							<td><%=PRY_AvancesFacilitadores%></td>											
						</tr>						
					</tbody>
				</table>				 				 				 				
				<table border="0"> 
					 <thead> 
						<tr> 
							<th>Obstaculizadores</th>							
						</tr> 
					</thead> 					
					<tbody>
						<tr>								
							<td><%=PRY_AvancesObstaculizadores%></td>											
						</tr>						
					</tbody>
				</table>
				<table border="0"> 
					 <thead> 
						<tr> 
							<th>Síntesis de conclusiones mesas bi/tripartitas desarrolladas</th>
						</tr> 
					</thead> 					
					<tbody>
						<tr>								
							<td><%=PRY_AvancesSintesis%></td>											
						</tr>						
					</tbody>
				</table>
				
				<h5>Nuevas temáticas detectadas</h5>				
				<table border="0"> 
					<thead> 
						<tr> 
							<th style="width:10%;">#</th>										
							<th style="width:45%;">Temática</th>												
							<th style="width:45%;">Descripción</th>										
						</tr> 
					</thead> 					
					<tbody><%									
						set rx=cnn.execute("spTematicaIdentificada_Listar " & PRY_Id)									
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
						   'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							response.end
						End If
						do while not rx.eof%>																			
							<tr class="newtem">
								<td style="width:10%;"><%=rx("TID_Id")%></td> 											
								<td style="width:45%;"><%=rx("TID_TematicaProblematica")%></td>
								<td style="width:45%;"><%=rx("TID_Descripcion")%></td>																								
							</tr><%
							rx.movenext
						loop											
						rx.close%>
						<tr>								
							<th style="width:10%;">&nbsp;</th>
							<th style="width:45%;">&nbsp;</th>
							<th style="width:45%;">&nbsp;</th>							
						</tr>
					</tbody>
				</table>																	
			</div>
		</div>
            	
	</body>
</html>