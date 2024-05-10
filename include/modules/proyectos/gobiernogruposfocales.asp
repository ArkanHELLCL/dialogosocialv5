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
		
	set rs = cnn.Execute("exec spPatrocinioGobierno_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spPatrocinioGobierno_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1	
				
	dataGfoGOB = "{""data"":["
	do While Not rs.EOF
		set rx = cnn.Execute("spProyGrupoFocalServicio_Listar "  & PRY_Id & "," & rs("SER_Id"))
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error spProyGrupoFocalServicio_Listar")
			cnn.close 		
			response.end
		End If
		if not rx.eof then
			Total=rx("Total")
		else
			Total=0
		end if
		If(Total>0) then
			detalle="<i class='fas fa-chevron-down text-secondary vergfogob' data-toggle='tooltip' title='Ver Integrantes' data-pry='" & PRY_Id & "' data-ser='" & rs("SER_Id") & "'></i>"
		else
			detalle=""
		end if
		
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			acciones = "<i class='fas fa-user-plus text-success addgfogob' data-toggle='tooltip' title='Agregar Integrantes' data-pry='" & PRY_Id & "' data-ser='" & rs("SER_Id") & "'></i> " & detalle
		else
			acciones = detalle
		end if
		dataGfoGOB = dataGfoGOB & "[""" & rs("SER_Id") & """,""" & rs("SER_Nombre") & """,""" & rs("GOB_Nombre") & """,""" & Total & """,""" & acciones & """]" 
									
		rs.movenext
		if not rs.eof then
			dataGfoGOB = dataGfoGOB & ","
		end if
		
	loop
	dataGfoGOB=dataGfoGOB & "]}"	
	response.write(dataGfoGOB)
%>