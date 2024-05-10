<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id					= request("PRY_Id")	
	PCO_RiesgoIdentificado	= LimpiarUrl(request("PCO_RiesgoIdentificado"))
	PCO_DescripcionRiesgo	= LimpiarUrl(request("PCO_DescripcionRiesgo"))
    PCO_Etapa	            = LimpiarUrl(request("PCO_Etapa"))
    PCO_MedidaMitigacion	= LimpiarUrl(request("PCO_MedidaMitigacion"))
    PCO_PlanContingencia    = ""
    PCO_Verificador         = ""

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	if not rs.eof then	
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Id=rs("LIN_Id")
		PRY_ObjetivoGeneral=rs("PRY_ObjetivoGeneral")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	else
		response.Write("503/@/Error Conexión:")
		response.End() 
	end if
	
	sql = "exec [spPlanContingencia_Agregar] " & PRY_Id & ",'" & PCO_PlanContingencia & "','" & PCO_RiesgoIdentificado & "','" & PCO_DescripcionRiesgo & "','" & PCO_Etapa & "','" & PCO_MedidaMitigacion & "','" & PCO_Verificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
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
	set rs=cnn.execute("spPlanContingencia_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	dataVerificadoresPCO = "["
    do While Not rs.EOF
        PCO_Id=rs("PCO_Id")
        if len(PCO_Id)>1 then
            yPCO_Id=""
            for i=0 to len(PCO_Id)
                if(isnumeric(mid(PCO_Id,i,1))) then
                    yPCO_Id=yPCO_Id & mid(PCO_Id,i,1)
                end if
            next
        else
            yPCO_Id=cint(PCO_Id)
        end if
        path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\verificadoresplancontingencia\p-" & yPCO_Id
        archivos=0
        If fs.FolderExists(path) = true Then
            Set carpeta = fs.getfolder(path)
            Set ficheros = carpeta.Files
            For Each archivo In ficheros
                archivos = archivos + 1
            Next
        else
            archivos = 0
        end if
        if(archivos>0) then			
            colordown="text-success"
            colordel="text-white-50"			
            disableddown="pointer"
            disableddel="not-allowed"
            data="data-id='" & rs("PCO_Id") & "' data-pry='" & PRY_Id & "'"
            clasedown="doplncon"
            clasedel=""
        else			
            colordown="text-white-50"
            colordel="text-danger"
            disableddown="not-allowed"
            disableddel="pointer"
            data=""
            clasedown=""
            clasedel="delplncon"
        end if        
        dataVerificadoresPCO = dataVerificadoresPCO & "{""PCO_Id"":""" & rs("PCO_Id") & """,""PCO_RiesgoIdentificado"":""" & rs("PCO_RiesgoIdentificado") & """,""PCO_DescripcionRiesgo"":""" & rs("PCO_DescripcionRiesgo") & """,""PCO_Etapa"":""" & rs("PCO_Etapa") & """,""PCO_MedidaMitigacion"":""" & rs("PCO_MedidaMitigacion") & """,""PCO_Verificador"":""<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar verificador' " & data & "></i>"",""Del"":""<i class='fas fa-trash-alt " & clasedel & " " & colordel & "' style='cursor: " & disableddel & "' data-pco='" & rs("PCO_Id") & "' data-pry='" & PRY_Id & "'></i>"""        
        dataVerificadoresPCO = dataVerificadoresPCO & "}"											
        rs.movenext
        if not rs.eof then
            dataVerificadoresPCO = dataVerificadoresPCO & ","
        end if
    loop
    dataVerificadoresPCO=dataVerificadoresPCO & "]"	
	rs.close							
	
	response.write("200\\" & dataVerificadoresPCO)
%>