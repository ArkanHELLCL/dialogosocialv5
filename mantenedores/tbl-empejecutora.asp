<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	set rs = cnn.Execute("exec spEmpresaEjecutora_Listar -1") 'todos
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spEmpresaEjecutora_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataEmpEjecutora = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataEmpEjecutora = dataEmpEjecutora & ","
		end if

		dataEmpEjecutora = dataEmpEjecutora & "[""" & rs("EME_Id") & """,""" & rs("EME_ROL") & """,""" & rs("EME_Nombre") & """,""" & rs("TEJ_Descripcion")	& """,""" & rs("REG_Id") & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Id") & """,""" & rs("COM_Nombre") & """,""" & rs("EME_Direccion") & """,""" & rs("EME_Telefono") & """,""" & rs("EME_NombreContacto") & """,""" & rs("EME_CargoContacto") & """,""" & rs("EME_MAIL") & """,""" & rs("EME_PaginaWeb") & """,""" & rs("EME_Estado") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataEmpEjecutora=dataEmpEjecutora & "]}"
	
	response.write(dataEmpEjecutora)
%>