<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%		
	PRY_Id		= request("PRY_Id")	
	'PRY_Hito	= request("PRY_Hito")
	COO_Id		= request("COO_Id")
    COO_Tipo    = request("COO_Tipo")
		
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
		PRY_Identificador	= rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if len(COO_Id)>1 then
			yCOO_Id=""
			for i=0 to len(COO_Id)
				if(isnumeric(mid(COO_Id,i,1))) then
					yCOO_Id=yCOO_Id & mid(COO_Id,i,1)
				end if
			next
		else
			yCOO_Id=cint(COO_Id)
		end if

        if(COO_Tipo="TRA") then
            tipo="Trabajadores"
            subcarpeta="\verificadorcoordactorestra\t-"
			PRY_Hito=119
        else
            if(COO_Tipo="EMP") then
                tipo="Empresas"
                subcarpeta="\verificadorcoordactoresemp\e-"
				PRY_Hito=120
            else                
                if(rs("COO_Tipo")="GOB") then
                    tipo="Gobierno"
                    subcarpeta="\verificadorcoordactoresgob\g-"
                    PRY_Hito = 121
                end if                
            end if
        end if
        path="D:\DocumentosSistema\dialogosocial\" & carpeta & subcarpeta & yCOO_Id
	else
		response.write("1\\Tabla proyectos sin datos")
		rs.close
		cnn.close
		response.end()
	end if
				
	cnn.close
	set cnn = nothing		
	
	response.write("200\\")%>	
	<table id="tbl-archivospryobj" class="table table-striped table-bordered table-sm" data-id="archivospryobj" data-page="false" data-selected="false" data-keys="0" style="margin-top:20px;" width="100%"> 
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