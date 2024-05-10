<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id						= request("PRY_Id")	
	OER_ObjetivoEspRelacionado	= LimpiarUrl(request("OER_ObjetivoEspRelacionado"))
		
	sql = "exec spObjetivoEspRelacionado_Agregar '" & OER_ObjetivoEspRelacionado & "'," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("spObjetivoEspRelacionado_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataObjetivosRel = "["
	do While Not rs.EOF
		dataObjetivosRel = dataObjetivosRel & "{""OER_Id"":""" & rs("OER_Id") & """,""OER_ObjetivoEspRelacionado"":""" & rs("OER_ObjetivoEspRelacionado") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-oer='" & rs("OER_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataObjetivosRel = dataObjetivosRel & "}"		
		rs.movenext
		if not rs.eof then
			dataObjetivosRel = dataObjetivosRel & ","
		end if
	loop
	dataObjetivosRel=dataObjetivosRel & "]"								
	rs.close							
	
	response.write("200\\" & dataObjetivosRel)
%>