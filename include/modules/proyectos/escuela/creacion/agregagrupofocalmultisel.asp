<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		

	PRY_Id=request("PRY_Id")			
	GRF_Id=request("GRF_Id")

    NAC_Id=request("NAC_Id")
    SEX_Id=request("SEX_Id")
    EDU_Id=request("EDU_Id")
    TDI_Id=request("TDI_Id")
    RUB_Id=request("RUB_Id")
    TTR_Id=request("TTR_Id")
    TRE_Id=request("TRE_Id")
		
	sql = "exec spGruposFocalizacionMultiseleccion_Agregar " & GRF_Id & "," & NAC_Id & "," & SEX_Id & "," & EDU_Id & "," & TDI_Id & "," & RUB_Id & "," & TTR_Id & "," & TRE_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"    

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if				

	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
		
	'Leyendo tabla para retornar todos los registros de ella	
	set rs=cnn.execute("exec spGruposFocalizacionMultiseleccion_Listar " & GRF_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	
	dataGrpMultiSelect = "["
	do While Not rs.EOF		        
		dataGrpMultiSelect = dataGrpMultiSelect & "{""GFM_Id"":""" & rs("GFM_Id") & """,""NAC_Nombre"":""" & rs("NAC_Nombre") & """,""SEX_Descripcion"":""" & rs("SEX_Descripcion") & """,""EDU_Nombre"":""" & rs("EDU_Nombre") & """,""TDI_Nombre"":""" & rs("TDI_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""TTR_Nombre"":""" & rs("TTR_Nombre") & """,""TRE_Descripcion"":""" & rs("TRE_Descripcion") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-GRF='" & rs("GRF_Id") & "' data-pry='" & PRY_Id & "' data-GFM='" & rs("GFM_Id") & "'></i>"""
        dataGrpMultiSelect = dataGrpMultiSelect & "}"
		rs.movenext
		if not rs.eof then
			dataGrpMultiSelect = dataGrpMultiSelect & ","
		end if
	loop
	dataGrpMultiSelect=dataGrpMultiSelect & "]"								
	rs.close							
	
	response.write("200\\" & dataGrpMultiSelect)
%>