<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%					
	MEN_Id = request("MEN_Id")
	TIP_Id = 3	'Respuesta a una consulta
	
	MEN_Texto = request("MEN_Texto")
	PER_Id = "NULL"
	
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
	
	sql="exec spMensajeUsuario_Consultar " & MEN_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sql)
	on error resume next
	if not rx.eof then
		USR_Id=rx("USR_Id")	'Remitente		
	end if
	
	sql = "exec spMensajePersonal_Responder " & MEN_Id & "," & TIP_Id & ",'" & MEN_Texto & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	set rs = cnn.Execute(sql)
	on error resume next
	if not rs.eof then
		MEN_Id=rs("MEN_Id")
		MEN_Corr=rs("MEN_Corr")
	else
		response.end()
	end if

	sql = "exec spMensajeUsuario_Registrar " & MEN_Id & "," & MEN_Corr & "," & USR_Id & "," & PER_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	cnn.execute sql
	on error resume next
	
	response.write("200//")  	
	rx.Close
	rs.Close
  	cnn.Close
%>
