<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id=request("PRY_Id")	
	
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
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spProyecto_Consultar")
		cnn.close 		
		response.end
	End If			
	
	if not rs.eof then	
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_Estado=rs("PRY_Estado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
	
	set rs=cnn.execute("spTematicaIdentificada_Listar " & PRY_Id)	
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spTematicaIdentificada_Listar")
		cnn.close 		
		response.end
	End If				
				
	dataEvaluTem = "{""data"":["
	do While Not rs.EOF		
		acciones = "<i class='fas fa-trash text-danger deltemmesa' data-toggle='tooltip' title='Elimina evaluación de temática' data-pry='" & PRY_Id & "' data-tid='" & rs("TID_Id") & "'></i> "
		if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then
			dataEvaluTem = dataEvaluTem & "[""" & rs("TID_Id") & """,""" & rs("TID_TematicaProblematica") & """,""" & rs("TID_Descripcion") & """,""" & acciones & """]" 	
		else
			dataEvaluTem = dataEvaluTem & "[""" & rs("TID_Id") & """,""" & rs("TID_TematicaProblematica") & """,""" & rs("TID_Descripcion") & """]" 
		end if
											
		rs.movenext
		if not rs.eof then
			dataEvaluTem = dataEvaluTem & ","
		end if
		
	loop
	dataEvaluTem=dataEvaluTem & "]}"	
	response.write(dataEvaluTem)
%>