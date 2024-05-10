<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")
	PRY_Identificador=request("PRY_Identificador")
	TPR_Id=request("TPR_Id")
		
	sql = "exec spTematicaProyecto_Eliminar " & TPR_Id & "," & PRY_Id & ",'" & PRY_Identificador & "'"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\[{}]")
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\[]")
	    response.End()
	End If
		
	'Leyendo tabla para retornar todos los registros de ella	
	set rs=cnn.execute("spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "',-1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataModulosAdd = "["
	do While Not rs.EOF
		dataModulosAdd = dataModulosAdd & "{""TPR_Id"":""" & rs("TPR_Id") & """,""PPR_Id"":""" & rs("PPR_Id") & """,""TPR_Nombre"":""" & rs("TPR_Nombre") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-tpr='" & rs("TPR_Id") & "' data-pry='" & PRY_Id & "' data-ppr='" & rs("PPR_Id") & "'></i>"""
		dataModulosAdd = dataModulosAdd & "}"											
		rs.movenext
		if not rs.eof then
			dataModulosAdd = dataModulosAdd & ","
		end if
	loop
	dataModulosAdd=dataModulosAdd & "]"								
	rs.close							
	
	response.write("200\\" & dataModulosAdd)
%>