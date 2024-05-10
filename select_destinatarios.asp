<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="session.min.inc" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")
	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	if isEmpty(session("ds5_usrid")) or isNull(session("ds5_usrid")) then
		response.Write("500//Error Parámetros no válidos")
		response.end()
	end if
	
	data = "{"
	set rx = cnn.Execute("exec spPerfil_Listar 1")
	on error resume next	
	do while not rx.eof
		data = data & """" & rx("PER_Nombre") & """:{"
		set rs = cnn.Execute("exec spMensajeDestinatario_Listar " & session("ds5_usrid") & "," & rx("PER_Id") )
		on error resume next	
		ok=false
		do While Not rs.eof 
			if rs("USR_Id")<>session("ds5_usrid") then
				data = data & """" & rs("USR_Id") & """:""" & rs("USR_Nombre") & " " & rs("USR_Apellido") & """"
				ok=true
			end if
			rs.movenext
			if not rs.eof and ok then
				data = data & ","
			end if
		loop
		data = data & "}"
		rx.movenext
		if not rx.eof then
			data = data & ","
		end if
	loop
	data = data & "}"
	response.write("200//" & data) 	
	rs.Close
	rx.Close
  	cnn.Close
%>
