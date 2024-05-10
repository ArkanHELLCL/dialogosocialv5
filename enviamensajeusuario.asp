<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%	
	TIP_Id = 1'Pregunta
	MEN_Texto = request("MEN_Texto")
	USR_Id = request("USR_Id")
	PER_Id="NULL"
	
	sql=""
	sqlx=""
	sqly=""
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
		
	sql = "exec spMensajePersonal_Agregar " & TIP_Id & ",'" & MEN_Texto & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs2 = cnn.Execute(sql)
	if not rs2.eof then
		MEN_Id=rs2("MEN_Id")
		MEN_Corr=rs2("MEN_Corr")
	else
		response.end()
	end if				

	sqlx = "exec spMensajeUsuario_Registrar " & MEN_Id & "," & MEN_Corr & "," & USR_Id & "," & PER_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	cnn.execute sqlx
	on error resume next			
	
	sqly = "exec spMensajeUsuario_Consultar " & MEN_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sqly)
	'on error resume next
	if not rs.eof then
		data = "{""MEN_Id"":""" & rs("MEN_Id") & """,""MEN_Corr"":""" & rs("MEN_Corr")  & """,""USR_Nombre"":""" & rs("USR_Nombre") & " " & rs("USR_Apellido") & """,""USR_NombreDestinatario"":""" & rs("USR_NombreDestinatario") & " " & rs("USR_ApellidoDestinatario") & """,""TIP_Mensaje"":""" & rs("TIP_Mensaje") & """,""MEN_Texto"":""" & rs("MEN_Texto") & """,""MEN_Fecha"":""" & rs("MEN_Fecha") & """,""R"":""" & rs("MaxCorrelativo") & """,""RES"":"" <i class='fas fa-chevron-right res' data-id='" & rs("MEN_Id") & "'></i> """
		data = data & "}"
	end if
	
  	rs2.Close
	rs.Close
  	cnn.Close
	
	response.write("200//" & data)
%>