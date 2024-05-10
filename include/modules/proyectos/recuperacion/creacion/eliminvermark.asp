<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	VPM_Id=request("VPM_Id")
			
	sql = "exec spVerificadorPlanMarketing_Eliminar " & PRY_Id & "," & VPM_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

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
	set rs=cnn.execute("spVerificadorPlanMarketing_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataVerificadoresMark = "["
	do While Not rs.EOF
		if(rs("VPM_Comprometida")=1) then
			switch="<i class='fas fa-thumbs-up text-success'></i><span style='display:none'>NO</span>"
		else
			switch="<i class='fas fa-thumbs-down text-danger'></i><span style='display:none'>NO</span>"
		end if
		dataVerificadoresMark = dataVerificadoresMark & "{""VPM_Id"":""" & rs("VPM_Id") & """,""VPM_AccionComprometida"":""" & rs("VPM_AccionComprometida") & """,""VPM_Etapa"":""" & rs("VPM_Etapa") & """,""VPM_VerificadorCumplimiento"":""" & rs("VPM_VerificadorCumplimiento") & """,""VPM_Comprometida"":""" & switch & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-vpm='" & rs("VPM_Id") & "' data-pry='" & PRY_Id & "'></i>"""
		dataVerificadoresMark = dataVerificadoresMark & "}"		
		rs.movenext
		if not rs.eof then
			dataVerificadoresMark = dataVerificadoresMark & ","
		end if
	loop
	dataVerificadoresMark=dataVerificadoresMark & "]"								
	rs.close							
	
	response.write("200\\" & dataVerificadoresMark)
%>