<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
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
MasterPage	= "Informe_Creacion"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	Response.end()
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		Response.end()
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
		PRY_IdLicitacion				 = rs("PRY_IdLicitacion")
		PRY_NombreLicitacion			 = rs("PRY_NombreLicitacion")
		FON_Nombre						 = rs("FON_Nombre")
		PRY_Carpeta						 = rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		PRY_ObjetivoGeneral				 = rs("PRY_ObjetivoGeneral")
		PRY_FundamentacionCriterioFocalizacion = rs ("PRY_FundamentacionCriterioFocalizacion")
		PRY_InformeInicioFechaOriginal	 = rs("PRY_InformeInicioFechaOriginal")
		PRY_InformeParcialFechaOriginal  = rs("PRY_InformeParcialFechaOriginal")
		PRY_InformeFinalFechaOriginal	 = rs("PRY_InformeFinalFechaOriginal")
		
		PRY_CodigoAsociado=rs("PRY_CodigoAsociado")
		MET_Id=rs("MET_Id")
		EME_Id=rs("EME_Id")
		PRY_UrlClase=rs("PRY_UrlClase")
		EME_Rol=rs("EME_Rol")
		MET_Descripcion=rs("MET_Descripcion")		
	else
		Response.end()
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
		Response.end()
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
	Response.end()
end if		
%>
	<body>
		<div class="container">        	
            <div id="contenido">
    	    	<h4>Personalización</h4>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Año</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_Nombre%></td>
                    <td width="50%"><%=PRY_AnioProyecto%></td>
                  </tr>
                </table>                                
				<table  border="0">
                  <tr>
                    <th scope="col">Empresa Ejecutora</th>
					<th scope="col">ROL/RUT</th>
                  </tr>
                  <tr>
                    <td><%=PRY_EmpresaEjecutora%></td>
					<td><%=EME_Rol%></td>
                  </tr>				  
                </table>                
				<table  border="0">
                  <tr>
                    <th scope="col" width="34%">Encargado/a de plataforma</th>
                    <th scope="col" width="33%">Revisor</th>
					<th scope="col" width="33%">Metodología</th>
                  </tr>
                  <tr>
                    <td width="34%"><%response.Write(USR_NombreEjecutor & " " & USR_ApellidoEjecutor)%></td>
                    <td width="33%"><%response.Write(USR_NombreRevisor & " " & USR_ApellidoRevisor)%></td>
					<td width="33%"><%=MET_Descripcion%></td>
                  </tr>
                </table>
				<%if(MET_Id=1) then%>
					<table  border="0">
					  <tr>
						<th scope="col" width="100%">Región</th>						
					  </tr>
					  <tr>
						<td width="100%"><%=REG_Nombre%></td>						
					  </tr>
					</table>
					<table  border="0">
					  <tr>						
						<th scope="col">URL</th>
					  </tr>
					  <tr>						
						<td><%=PRY_UrlClase%></td>
					  </tr>
					</table>					
				<%end if%>
				<%if(MET_Id=2) then%>
					<table  border="0">
					  <tr>
						<th scope="col" width="50%">Región</th>
						<th scope="col" width="50%">Comuna</th>
					  </tr>
					  <tr>
						<td width="50%"><%=REG_Nombre%></td>
						<td width="50%"><%=COM_Nombre%></td>
					  </tr>
					</table>
					<table  border="0">
					  <tr>
						<th scope="col">Dirección</th>						
					  </tr>
					  <tr>
						<td><%=PRY_DireccionEjecucion%></td>						
					  </tr>
					</table>					
				<%end if%>
				<%if(MET_Id=3) then%>
					<table  border="0">
					  <tr>
						<th scope="col" width="50%">Región</th>
						<th scope="col" width="50%">Comuna</th>
					  </tr>
					  <tr>
						<td width="50%"><%=REG_Nombre%></td>
						<td width="50%"><%=COM_Nombre%></td>
					  </tr>
					</table>
					<table  border="0">
					  <tr>
						<th scope="col">Dirección</th>
						<th scope="col">URL</th>
					  </tr>
					  <tr>
						<td><%=PRY_DireccionEjecucion%></td>
						<td><%=PRY_UrlClase%></td>
					  </tr>
					</table>					
				<%end if%>								
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Horas Pegagógicas Mínimas</th>
                    <th scope="col" width="50%">Monto</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_HorasPedagogicasMin%></td>
                    <td width="50%"><%=PRY_MontoAdjudicado%></td>
                  </tr>				  				  
                </table>
				<table  border="0">
                  <tr>
                    <th scope="col" width="20%">Id Licitación</th>
                    <th scope="col" width="30%">Nombre Licitación</th>
					<th scope="col" width="40%">Ítem Presupuestario</th>
					<%If (PRY_CodigoAsociado<>"" and not IsNULL(PRY_CodigoAsociado)) and PRY_CodigoAsociado>0 then%>
						<th scope="col" width="10%">Proyecto Asociado</th>
					<%end if%>
                  </tr>
                  <tr>
                    <td width="20%"><%=PRY_IdLicitacion%></td>
                    <td width="30%"><%=PRY_NombreLicitacion%></td>
					<td width="40%"><%=FON_Nombre%></td>
					<%If (PRY_CodigoAsociado<>"" and not IsNULL(PRY_CodigoAsociado)) and PRY_CodigoAsociado>0 then%>
						<td width="10%"><%=PRY_CodigoAsociado%></td>
					<%end if%>
                  </tr>				  				  
                </table>
				
					
				
								                
                <h4>Fechas de Cierre</h4>
				<h5>Fechas de Cierre Informadas</h5>
                <table  border="0">
                  <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Incial</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Parcial</th>
					<th scope="col" width="33%">Fecha Cierre Informe Final</th>
                  </tr>
                  <tr>
                    <td width="33%"><%=PRY_InformeInicioFecha%></td>
                    <td width="33%"><%=PRY_InformeParcialFecha%></td>
					<td width="33%"><%=PRY_InformeFinalFecha%></td>
                  </tr>
                </table>                
				<h5>Fecha de Cierre Originales</h5>
				<table  border="0">
                  <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Incial</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Parcial</th>
					<th scope="col" width="33%">Fecha Cierre Informe Final</th>
                  </tr>
                  <tr>
                    <td width="33%"><%=PRY_InformeInicioFechaOriginal%></td>
                    <td width="33%"><%=PRY_InformeParcialFechaOriginal%></td>
					<td width="33%"><%=PRY_InformeFinalFechaOriginal%></td>
                  </tr>
                </table>                
                                                
                <h4>Redes de Apoyo</h4>
				<h5>Sindicatos</h5>
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col">Sindicato</th>
                            <th scope="col">Afilición Central</th> 
                            <th scope="col">Rubro</th>
                        </tr> 
                    </thead>
					<tbody>
                    <%                                                                    
                        set rs=cnn.execute("spPatrocinio_Listar " & PRY_Id)
                        on error resume next
                        if cnn.Errors.Count > 0 then 
                            ErrMsg = cnn.Errors(0).description
                            'response.write ErrMsg & " strig= " & sq			
                            cnn.close 			   
                            Response.end()
                        End If
                        do while not rs.eof %>
                            <tr>                                
                                <td><%=rs("SIN_Nombre")%></td>                      	                  	
                                <td><%=rs("ACE_Nombre")%></td> 
                                <td><%=rs("RUB_Nombre")%></td>
                            </tr><%
                            rs.movenext
                        loop											
                        rs.close											
                    %>                	
                    </tbody>
                </table>
				<h5>Empresas</h5>
				<table border="0" width="100%"> 
					<thead>
						<tr> 							
							<th scope="col">Organización Empresarial</th>								 
							<th scope="col">Rubro</th>
						</tr> 
					</thead>
					<tbody>
					<%
						set rs=cnn.execute("spPatrocinioEmpresa_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If						
						do While Not rs.EOF%>
                            <tr>                                
                                <td><%=rs("EMP_Nombre")%></td>                                
                                <td><%=rs("RUB_Nombre")%></td>
                            </tr><%
                            rs.movenext
						loop						
					%>                	
					</tbody>
				</table>
				<h5>Organizaciones Civileas</h5>
				<table border="0" width="100%"> 	
					<thead>
						<tr> 							
							<th scope="col">Organización Civil</th>								 
							<th scope="col">Rubro</th>
						</tr>
					</thead>
					<tbody>
					<%
						set rs=cnn.execute("spPatrocinioCiviles_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If						
						do While Not rs.EOF%>
                            <tr>                                
                                <td><%=rs("CIV_Nombre")%></td>                                
                                <td><%=rs("RUB_Nombre")%></td>
                            </tr><%
                            rs.movenext							
						loop						
					%>   
					</tbody>
				</table>
				
				<h4>Objetivos del Proyecto</h4>
				<h5>Objetivo General</h5>
				<table  border="0">
                  <tr>
                    <th scope="col" width="100%">Objetivo General</th>                    
                  </tr>
                  <tr>
                    <td width="100%"><%=PRY_ObjetivoGeneral%></td>                    
                  </tr>
                </table>
				
				<h5>Objetivo y resultados ingresados</h5>
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col">Objetivo específico</th>
                            <th scope="col">Resultado esperado</th> 
                            <th scope="col">Indicador</th>
							<th scope="col">Verificador de Cumplimiento</th>
                        </tr> 
					</thead>
					<tbody><%
						dim fs,f	
						set fs=Server.CreateObject("Scripting.FileSystemObject")
						set rs=cnn.execute("spObjetivoEspecifico_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If
						do While Not rs.EOF
							OES_Id=rs("OES_Id")
							if len(OES_Id)>1 then
								yOES_Id=""
								for i=0 to len(OES_Id)
									if(isnumeric(mid(OES_Id,i,1))) then
										yOES_Id=yOES_Id & mid(OES_Id,i,1)
									end if
								next
							else
								yOES_Id=cint(OES_Id)
							end if
							path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresproyecto\p-" & yOES_Id
							archivos=0
							If fs.FolderExists(path) = true Then
								Set carpeta = fs.getfolder(path)
								Set ficheros = carpeta.Files
								For Each archivo In ficheros
									archivos = archivos + 1
								Next
							else
								archivos = 0
							end if
							arc="No"
							if(archivos>0) then
								arc="Si"
							end if%>
							<tr>
								<td><%=rs("OES_ObjetivoEspecifico")%></td>
								<td><%=rs("OES_ResultadoEsperado")%></td>
								<td><%=rs("OES_Indicador")%></td>
								<td><%response.write(arc & "(" & archivos & ")")%></td>
							</tr><%
							rs.movenext
						loop%>
					</tbody>
				</table>
				
				<h4>Plan de Marketing</h4>
				<h5>Objetivos Específicos</h5>								
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col">Objetivo específico</th>                            
                        </tr> 
					</thead>
					<tbody><%
						set rs=cnn.execute("spObjetivoEspPlanMarketing_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If
						do While Not rs.EOF%>
							<tr>
								<td><%=rs("OPM_ObjetivoEspecifico")%></td>								
							</tr><%
							rs.movenext
						loop%>
					</tbody>
				</table>
				<h5>Acciones</h5>								
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col">Acción Comprometida</th>
							<th scope="col">Etapa en la que se lleva acabo</th>
							<th scope="col">Verificador de cumplimiento</th>
							<th scope="col">Comprometida?</th>
                        </tr> 
					</thead>
					<tbody><%
						set rs=cnn.execute("spVerificadorPlanMarketing_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If
						do While Not rs.EOF							
							VPM_Id=rs("VPM_Id")
							if len(VPM_Id)>1 then
								yVPM_Id=""
								for i=0 to len(VPM_Id)
									if(isnumeric(mid(VPM_Id,i,1))) then
										yVPM_Id=yVPM_Id & mid(VPM_Id,i,1)
									end if
								next
							else
								yVPM_Id=cint(VPM_Id)
							end if
							path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresmarketing\m-" & yVPM_Id
							archivos=0
							If fs.FolderExists(path) = true Then
								Set carpeta = fs.getfolder(path)
								Set ficheros = carpeta.Files
								For Each archivo In ficheros
									archivos = archivos + 1
								Next
							else
								archivos = 0
							end if
							arc="No"
							if(archivos>0) then
								arc="Si"
							end if
							comp="No"
							if(rs("VPM_Comprometida")=1) then
								comp="Si"
							end if%>
							<tr>
								<td><%=rs("VPM_AccionComprometida")%></td>
								<td><%=rs("VPM_Etapa")%></td>
								<td><%=arc%></td>
								<td><%=comp%></td>
							</tr><%
							rs.movenext
						loop%>
					</tbody>
				</table><%
				
				if LIN_AgregaTematica then%>
					<h4>Módulos Adicionales</h4>
					<table> 
						<thead> 
							<tr> 
								<th>Id</th>
								<th>Id</th>
								<th>Curso</th> 
							</tr> 
						</thead>                     
						<tbody><%
							set rs=cnn.execute("exec spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "',-1")
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								Response.end()
							End If									
							do while not rs.eof %>
								<tr>
									<td ><%=rs("TPR_Id")%></td> 
									<td><%=rs("PPR_Id")%></td> 
									<td><%=rs("TPR_Nombre")%></td>
								</tr><%
								rs.movenext
							loop											
							rs.close%>                	
						</tbody>
					</table><%
				end if%>
				
				<h4>Criterios de Focalización</h4>
				<h5>Fundamentación de criterio de focalización</h5>								
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col">Fundamentación</th>
                        </tr> 
					</thead>
					<tbody>
						<tr>
							<td><%=PRY_FundamentacionCriterioFocalizacion%></td>
						</tr>
					</tbody>
				</table>
				<h5>Objetivos relacionados</h5>								
                <table border="0" width="100%"> 
                    <thead>
                        <tr>                             
                            <th scope="col" widht="50%">Objetivo relacionado</th>
                        </tr> 
					</thead>
					<tbody><%
						set rs=cnn.execute("exec spObjetivoEspRelacionado_Listar " & PRY_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							Response.end()
						End If									
						do while not rs.eof %>
							<tr>
								<td><%=rs("OER_ObjetivoEspRelacionado")%></td>							
							</tr><%
							rs.movenext
						loop											
						rs.close%>                	
					</tbody>
				</table>
            </div>    
        </div>
            	
	</body>
</html>