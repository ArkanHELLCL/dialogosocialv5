<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	SIN_Id=request("SIN_Id")
		
	sql = "exec spPatrocinio_Eliminar " & PRY_Id & "," & SIN_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("spPatrocinio_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataSindicales = "["
	do While Not rs.EOF
		dataSindicales = dataSindicales & "{""SIN_Id"":""" & rs("SIN_Id") & """,""SIN_Nombre"":""" & rs("SIN_Nombre")  & """,""ACE_Nombre"":""" & rs("ACE_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-sin='" & rs("SIN_Id") & "' data-pry='" & PRY_Id & "'></i>"""					
		dataSindicales = dataSindicales & "}"											
		rs.movenext
		if not rs.eof then
			dataSindicales = dataSindicales & ","
		end if
	loop
	dataSindicales=dataSindicales & "]"								
	rs.close							
	
	response.write("200\\" & dataSindicales)
%>