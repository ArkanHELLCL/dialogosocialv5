<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	'if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
	''	response.write("503/@/Error de conexion")
	''	response.End() 			   
	'end if		
	
	PRY_Id		= request("PRY_Id")	
	PRY_Hito	= request("PRY_Hito")	
		
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
		LFO_Id 				= rs("LFO_Id")
		PRY_Carpeta			= rs("PRY_Carpeta")
		PRY_Identificador	= rs("PRY_Identificador")
		
		PRY_Carpeta=Replace(PRY_Carpeta, "{", "") 
		PRY_Carpeta=Replace(PRY_Carpeta, "}", "")						
	else
		response.write("1/@/Tabla proyectos sin datos")
		rs.close
		cnn.close
		response.end()
	end if
	
	if LFO_Id=10 then
		if PRY_Hito=0 then
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_Hito=1 then
				informe="Inicio"
				carpeta="informeinicio"
				titulo="Informe Inicio"
			else
				if PRY_Hito=2 then
					informe="Parcial"
					carpeta="informeparcial"
					titulo="Informe Parcial"
				else
					if PRY_Hito=3 then
						informe="Final"
						carpeta="informefinal"
						titulo="Informe Final"
					else
						informe="desconocido"
						carpeta=""
						titulo="desconocido"
					end if								
				end if
			end if
		end if		
	end if
	
	if LFO_Id=11 or LFO_Id=13 then
		if PRY_Hito=0 then
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_Hito=1 then
				informe="Inicial"
				carpeta="informeinicial"
				titulo="Informe Inicial"
			else
				if PRY_Hito=2 then
					informe="Avances"
					carpeta="informeavances"
					titulo="Informe de Avances"
				else
					if PRY_Hito=3 then
						informe="Final"
						carpeta="informefinal"
						titulo="Informe Final"
					else
						if PRY_Hito=999 then
							informe="Verificadores"
							carpeta="verificadoresmesas"
							titulo="Verificadores para Mesas"
						else
							informe="desconocido"
							carpeta=""
							titulo="desconocido"
						end if
					end if
				end if
			end if
		end if
	end if
	
	if LFO_Id=12 then
		if PRY_Hito=0 then
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_Hito=1 then
				informe="Inicial"
				carpeta="informeinicio"
				titulo="Informe Inicio"
			else							
				if PRY_Hito=2 then
					informe="Final"
					carpeta="informefinal"
					titulo="Informe Final"
				else
					informe="desconocido"
					carpeta=""
					titulo="desconocido"
				end if															
			end if
		end if
	end if

	if LFO_Id=14 then
		if PRY_Hito=0 then
			informe="Creación"
			carpeta="informecreacion"
			titulo="Informe de Creación"
		else
			if PRY_Hito=1 then
				informe="Inicial"
				carpeta="informeinicial"
				titulo="Informe Inicio"
			else
				if PRY_Hito=2 then
					informe="Avances"
					carpeta="informeavances"
					titulo="Informe Avances"
				else
					if PRY_Hito=3 then
						informe="Desarrollo"
						carpeta="informedesarrollo"
						titulo="Informe Desarrollo"
					else
						if PRY_Hito=4 then
							informe="Final"
							carpeta="informefinal"
							titulo="Informe Final"
						else
							informe="desconocido"
							carpeta=""
							titulo="desconocido"
						end if
					end If
				end if
			end if
		end if
	end if
		
	cnn.close
	set cnn = nothing		
	
	response.write("200/@/")%>	
	<div style="height: 400px;overflow:auto;">
		<table id="tbl-historico" class="table table-striped table-bordered table-sm" data-id="historico" data-page="false" data-selected="false" data-keys="0" style="margin-top:20px;" width="100%"> 
		<thead> 
			<tr> 
				<th>Corr</th> 
				<th>Nombre</th>
				<th>Tamaño</th>			
				<th>Modificación</th>								
				<th class="filter-select filter-exact" data-placeholder="Todos">Descarga</th>
			</tr> 
		</thead> 	
		<tbody><%
			Set fso = CreateObject("Scripting.FileSystemObject")
			Set directorio = fso.GetFolder ("D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\informes\" & carpeta)				
			For Each fichero IN directorio.Files
				Set file = fso.GetFile(fichero)								   								   								   
				corr=corr+1%> 
				<tr> 
					<td class="key"><%=corr%></td> 
					<td><%Response.Write (fichero.Name)%></td> 
					<td><%Response.Write (fichero.size)%></td> 
					<td><%Response.Write (fichero.DateLastModified)%></td> 														
					<th><%											
						if ucase(mid(fichero.Name,len(fichero.Name)-3))=".PDF" then%>
							<i class="fas fa-cloud-download-alt text-primary arcalm" data-file="<%=fichero.Name%>" data-pry="<%=PRY_Id%>" data-identificador="<%=PRY_Identificador%>" data-hito="<%=PRY_Hito%>" style="cursor:pointer;"></i><%
						else
							response.Write("<i class='fas fa-ban text-danger'></i>")
						end if%>
					</th>
				</tr><%
			Next%>
		</tbody>                 
	</div>
</table>