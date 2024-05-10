<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
		response.write("503/@/Error de conexion")
		response.End() 			   
	end if		
	
	PRY_Id		= request("PRY_Id")		
		
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
		
	cnn.close
	set cnn = nothing		
	
	response.write("200/@/")%>	
	<table id="tbl-contratos" class="table table-striped table-bordered table-sm" data-id="contratos" data-page="false" data-selected="false" data-keys="0" style="margin-top:20px;" width="100%"> 
	<thead> 
		<tr> 
			<th>Corr</th> 
			<th>Nombre</th>
			<th>Tamaño</th>			
			<th>Modificación</th>								
			<th>Descarga</th>
		</tr> 
	</thead> 	
	<tbody><%
		Set fso = CreateObject("Scripting.FileSystemObject")
		Set directorio = fso.GetFolder ("D:\DocumentosSistema\dialogosocial\" & PRY_Carpeta & "\contratos")
		For Each fichero IN directorio.Files
			Set file = fso.GetFile(fichero)								   								   								   
			corr=corr+1%> 
			<tr> 
				<td class="key"><%=corr%></td> 
				<td><%Response.Write (fichero.Name)%></td> 
				<td><%Response.Write (fichero.size)%></td> 
				<td><%Response.Write (fichero.DateLastModified)%></td> 														
				<th><i class="fas fa-cloud-download-alt text-primary arcalm" data-file="<%=fichero.Name%>" data-pry="<%=PRY_Id%>" style="cursor:pointer;"></i></th>
			</tr><%
		Next%>
	</tbody>                 
</table>