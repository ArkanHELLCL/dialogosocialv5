<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id = request("PRY_Id")	
	SIN_Id = request("SIN_Id")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then		
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
		
	set rs = cnn.Execute("exec spRepProyectoSindicato_Listar 1," & PRY_Id & "," & SIN_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRepProyectoSindicato_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1			
	
	cont=0
	dataRepresentanteSIN = "{""data"":["
	do While Not rs.EOF		
		if cont=1 then
			dataRepresentanteSIN = dataRepresentanteSIN & ","				
		end if
		cont = 1				
		acciones="<i class='fas fa-trash text-danger delrepsin' data-pry='" & PRY_Id & "' data-rps='" & rs("RPS_Id") & "' data-toogle='tooltip' title='Eliminar representante'></i>"
		dataRepresentanteSIN = dataRepresentanteSIN & "[""" & rs("RPS_Id") & """,""" & rs("RPS_Nombre") & """,""" & rs("RPS_ApellidoPaterno") & """,""" & rs("RPS_ApellidoMaterno") & """,""" & rs("RPS_Rut") & "-" & rs("RPS_DV") & """,""" & rs("SEX_Descripcion") & """,""" & acciones & """]"								

		rs.movenext
	loop
	dataRepresentanteSIN=dataRepresentanteSIN & "]}"
	
	response.write(dataRepresentanteSIN)
%>