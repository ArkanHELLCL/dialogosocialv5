<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
	end if		
	
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
		PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_Estado=1
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
	if(IsNULL(PRY_InformeInicialEstado) or PRY_InformeInicialEstado="") then
		PRY_InformeInicialEstado=0
	end if
	if(IsNULL(PRY_InformeConsensosEstado) or PRY_InformeConsensosEstado="") then
		PRY_InformeConsensosEstado=0
	end if
		
	set rs = cnn.Execute("exec spPatrocinio_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spPatrocinio_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
				
	dataRepSin = "{""data"":["
	do While Not rs.EOF
		set rx = cnn.Execute("spProyectoSindicato_Listar "  & PRY_Id & "," & rs("SIN_Id"))
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error spProyectoSindicato_Listar")
			cnn.close 		
			response.end
		End If
		if not rx.eof then
			Total=rx("Total")
		else
			Total=0
		end if
		If(Total>0) then
			detalle="<i class='fas fa-chevron-down text-secondary verrepsin' data-toggle='tooltip' title='Ver Representantes' data-pry='" & PRY_Id & "' data-sin='" & rs("SIN_Id") & "'></i>"
		else
			detalle=""
		end if
		
		if (PRY_InformeInicialEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=2) or (session("ds5_usrperfil")=1) or (session("ds5_usrperfil")=5)) then
			acciones = "<i class='fas fa-user-plus text-success addrepsin' data-toggle='tooltip' title='Agregar Representantes' data-pry='" & PRY_Id & "' data-sin='" & rs("SIN_Id") & "'></i> " & detalle
		else
			acciones = detalle
		end if
		dataRepSin = dataRepSin & "[""" & rs("SIN_Id") & """,""" & rs("SIN_Nombre") & """,""" & rs("SIN_rut") & """,""" & rs("TOR_Nombre") & """,""" & rs("RUB_Nombre")  & """,""" & rs("SIN_NumHombres") & """,""" & rs("SIN_NumMujeres") & """,""" & rs("SIN_NumHombres") + rs("SIN_NumMujeres") & """,""" & Total & """,""" & acciones & """]" 
									
		rs.movenext
		if not rs.eof then
			dataRepSin = dataRepSin & ","
		end if
		
	loop
	dataRepSin=dataRepSin & "]}"	
	response.write(dataRepSin)
%>