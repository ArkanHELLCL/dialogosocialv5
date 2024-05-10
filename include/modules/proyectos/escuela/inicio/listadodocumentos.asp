<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%		
	PRY_Id		= request("PRY_Id")	
	PRY_Hito	= request("PRY_Hito")
	VER_Corr	= request("VER_Corr")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503\\Error de conexion")
	   response.End() 			   
	end if		
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
	   response.write("503\\Error de conexion")
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		LFO_Id 				= rs("LFO_Id")
		'PRY_Carpeta			= rs("PRY_Carpeta")
		PRY_Identificador	= rs("PRY_Identificador")
		
		'PRY_Carpeta=Replace(PRY_Carpeta, "{", "") 
		'PRY_Carpeta=Replace(PRY_Carpeta, "}", "")
		
		PRY_Carpeta=rs("PRY_Carpeta")
		LFO_Id=rs("LFO_Id")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if len(VER_Corr)>1 then
			yVER_Corr=""
			for i=0 to len(VER_Corr)
				if(isnumeric(mid(VER_Corr,i,1))) then
					yVER_Corr=yVER_Corr & mid(VER_Corr,i,1)
				end if
			next
		else
			yVER_Corr=cint(VER_Corr)
		end if		
	else
		response.write("1\\Tabla proyectos sin datos")
		rs.close
		cnn.close
		response.end()
	end if
				
				
	carpeta_informe="no_definido"
	if LFO_Id=10 then
		if PRY_Hito=0 then
			carpeta_informe="informecreacion"
		else
			if PRY_Hito=1 then
				carpeta_informe="informeinicio"
			else
				if PRY_Hito=2 then
					carpeta_informe="informeparcial"
				else
					'if PRY_Hito=3 then
					'	carpeta_informe="informedesarrollo"
					'else
						'if PRY_Hito=4 then
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							carpeta_informe="no_definido"
						end if
					'end if
				end if
			end if
		end if
	else
		if LFO_Id=11 then
			if PRY_Hito=0 then
				carpeta_informe="informecreacion"
			else
				if PRY_Hito=1 then
					carpeta_informe="informeinicial"
				else
					if PRY_Hito=2 then
						carpeta_informe="informeavances"
					else
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							if PRY_Hito=999 then
								carpeta_informe="verificadoresmesas"
							else
								carpeta_informe="no_definido"
							end if												
						end if
					end if
				end if
			end if
		else
			if LFO_Id=12 then
				if PRY_Hito=0 then
					carpeta_informe="informecreacion"
				else
					if PRY_Hito=1 then
						carpeta_informe="informeinicio"
					else			
						if PRY_Hito=2 then
							carpeta_informe="informefinal"
						else						
							carpeta_informe="no_definido"
						end if 
					end if
				end if
			else
				if LFO_Id=13 then
					if PRY_Hito=0 then
						carpeta_informe="informecreacion"
					else
						if PRY_Hito=1 then
							carpeta_informe="informeinicial"
						else
							if PRY_Hito=2 then
								carpeta_informe="informeavances"
							else
								if PRY_Hito=3 then
									carpeta_informe="informefinal"
								else
									if PRY_Hito=999 then
										carpeta_informe="verificadoresrecuperacion"
									else
										carpeta_informe="no_definido"
									end if												
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
	
	path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\" & carpeta_informe & "\documentos\tpo-" & yVER_Corr
				
				
	cnn.close
	set cnn = nothing		
	
	response.write("200\\")%>	
	<table id="tbl-documentosinforme" class="table table-striped table-bordered table-sm" data-id="documentosinforme" data-page="false" data-selected="false" data-keys="0" style="margin-top:20px;" width="100%"> 
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
		Set directorio = fso.GetFolder (path)				
		For Each fichero IN directorio.Files
			Set file = fso.GetFile(fichero)								   								   								   
			corr=corr+1%> 
			<tr> 
				<td class="key"><%=corr%></td> 
				<td><%Response.Write (fichero.Name)%></td> 
				<td><%Response.Write (fichero.size)%></td> 
				<td><%Response.Write (fichero.DateLastModified)%></td> 														
				<th>
					<i class="fas fa-cloud-download-alt text-primary arcalm" data-file="<%=fichero.Name%>" data-pry="<%=PRY_Id%>" data-identificador="<%=PRY_Identificador%>" data-hito="<%=PRY_Hito%>" style="cursor:pointer;"></i>					
				</th>
			</tr><%
		Next%>
	</tbody>                 
</table>