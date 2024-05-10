<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	EMP_Id=request("EMP_Id")
		
	sql = "exec spPatrocinioEmpresa_Agregar " & PRY_Id & "," & EMP_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
		
	'Leyendo tabla para retornar todos los registros de ella	
	set rs=cnn.execute("spPatrocinioEmpresa_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataEmpresariales = "["
	do While Not rs.EOF
		dataEmpresariales = dataEmpresariales & "{""EMP_Id"":""" & rs("EMP_Id") & """,""EMP_Nombre"":""" & rs("EMP_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-emp='" & rs("EMP_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataEmpresariales = dataEmpresariales & "}"		
		rs.movenext
		if not rs.eof then
			dataEmpresariales = dataEmpresariales & ","
		end if
	loop
	dataEmpresariales=dataEmpresariales & "]"								
	rs.close							
	
	response.write("200\\" & dataEmpresariales)
%>