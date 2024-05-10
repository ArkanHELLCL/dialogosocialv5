<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRY_Id = request("PRY_Id")
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec [spProyecto_Consultar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error spProyecto_Consultar")
		cnn.close 		
		response.end
	End If
	if(not rs.eof) then
		USR_Id=rs("USR_Id")	'Revisor
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
	end if
	if(PRY_CreacionProyectoEstado="" or IsNULL(PRY_CreacionProyectoEstado)) then
		PRY_CreacionProyectoEstado=0
	end if
	
	set rs = cnn.Execute("exec [spRelatoresProyecto_Listar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("503/@/Error spRelatoresProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	dataRelPry = "{""data"":["
	do While Not rs.EOF			
		acciones=""
		if (session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and (USR_Id=session("ds5_usrid")))) and PRY_CreacionProyectoEstado=0 then
			acciones="<i class='fas fa-trash text-danger delrel' data-id='" & rs("RLP_Id") & "'></i>"
		else
			acciones="<i class='fas fa-trash text-white-50' style='cursor:not-allowed'></i>"
		end if
	
		dataRelPry = dataRelPry & "[""" & rs("RLP_Id") & """,""" & rs("REL_Rut") & """,""" & rs("REL_Nombres") & """,""" & rs("REL_Paterno") & """,""" & rs("REL_Materno") & """,""" & rs("SEX_Descripcion") & """,""" & rs("REL_NombreCarrera") & """,""" & rs("TRE_Descripcion") & """,""" & acciones & """]"
		
		rs.movenext
		if not rs.eof then
			dataRelPry = dataRelPry & ","
		end if
	loop
	dataRelPry=dataRelPry & "]}"
	
	response.write(dataRelPry)
%>