<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id = request("PRY_Id")	
	EMP_Id = request("EMP_Id")
	
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
		
	set rs = cnn.Execute("exec spRepProyectoEmpresa_Listar 1," & PRY_Id & "," & EMP_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRepProyectoEmpresa_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1			
	
	cont=0
	dataRepresentanteEMP = "{""data"":["
	do While Not rs.EOF		
		if cont=1 then
			dataRepresentanteEMP = dataRepresentanteEMP & ","				
		end if
		cont = 1				
		acciones="<i class='fas fa-trash text-danger delrepemp' data-pry='" & PRY_Id & "' data-rpe='" & rs("RPE_Id") & "' data-toogle='tooltip' title='Eliminar representante'></i>"
		dataRepresentanteEMP = dataRepresentanteEMP & "[""" & rs("RPE_Id") & """,""" & rs("RPE_Nombre") & """,""" & rs("RPE_ApellidoPaterno") & """,""" & rs("RPE_ApellidoMaterno") & """,""" & rs("RPE_Rut") & "-" & rs("RPE_DV") & """,""" & rs("SEX_Descripcion") & """,""" & acciones & """]"								

		rs.movenext
	loop
	dataRepresentanteEMP=dataRepresentanteEMP & "]}"
	
	response.write(dataRepresentanteEMP)
%>