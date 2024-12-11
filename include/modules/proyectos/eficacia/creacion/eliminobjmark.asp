<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	OPM_Id=request("OPM_Id")
		
	sql = "exec [spObjetivoEspPlanMarketing_Eliminar] " & PRY_Id & "," & OPM_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("spObjetivoEspPlanMarketing_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataObjetivosMark = "["
	do While Not rs.EOF
		dataObjetivosMark = dataObjetivosMark & "{""OPM_Id"":""" & rs("OPM_Id") & """,""OPM_ObjetivoEspecifico"":""" & rs("OPM_ObjetivoEspecifico") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-opm='" & rs("OPM_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataObjetivosMark = dataObjetivosMark & "}"		
		rs.movenext
		if not rs.eof then
			dataObjetivosMark = dataObjetivosMark & ","
		end if
	loop
	dataObjetivosMark=dataObjetivosMark & "]"								
	rs.close							
	
	response.write("200\\" & dataObjetivosMark)
%>