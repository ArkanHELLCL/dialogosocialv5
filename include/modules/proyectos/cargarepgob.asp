<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id = request("PRY_Id")	
	SER_Id = request("SER_Id")
	
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
		
	set rs = cnn.Execute("exec spRepProyectoGobierno_Listar -1," & PRY_Id & "," & SER_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRepProyectoEmpresa_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1			
	
	cont=0
	dataRepresentanteGOB = "{""data"":["
	do While Not rs.EOF		
		if cont=1 then
			dataRepresentanteGOB = dataRepresentanteGOB & ","				
		end if
		cont = 1				
		acciones="<i class='fas fa-trash text-danger delrepgob' data-pry='" & PRY_Id & "' data-rpg='" & rs("RPG_Id") & "' data-toogle='tooltip' title='Eliminar representante'></i>"
		dataRepresentanteGOB = dataRepresentanteGOB & "[""" & rs("RPG_Id") & """,""" & rs("RPG_Nombre") & """,""" & rs("RPG_ApellidoPaterno") & """,""" & rs("RPG_ApellidoMaterno") & """,""" & rs("RPG_Rut") & "-" & rs("RPG_DV") & """,""" & rs("SEX_Descripcion") & """,""" & acciones & """]"								

		rs.movenext
	loop
	dataRepresentanteGOB=dataRepresentanteGOB & "]}"
	
	response.write(dataRepresentanteGOB)
%>