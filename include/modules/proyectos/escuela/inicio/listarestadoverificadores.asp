<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	PRY_Id				= request("PRY_Id")	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	'Verificadores pendiente y rechazados
    'Patrocinios					
    PAT_EstadoSubidoTotal=0
    PAT_EstadoRevisadoTotal=0
    PAT_EstadoAprobadoTotal=0
    PAT_EstadoRechazadoTotal=0
    PAT_Total=0			
    
    'Patrocinios no se deben contar
    sql="exec [spPatrocinios_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        PAT_EstadoSubido=rs("PAT_EstadoSubido")
        PAT_EstadoRevisado=rs("PAT_EstadoRevisado")		
        PAT_EstadoAprobado=rs("PAT_EstadoAprobado")			
        PAT_EstadoRechazado=rs("PAT_EstadoRechazado")	

        if(PAT_EstadoSubido="" or IsNull(PAT_EstadoSubido) or PAT_EstadoSubido=0) then
            PAT_EstadoSubido=0
        else
            PAT_EstadoSubidoTotal=PAT_EstadoSubidoTotal+1
        end if
        if(PAT_EstadoRevisado="" or IsNull(PAT_EstadoRevisado) or PAT_EstadoRevisado=0) then
            PAT_EstadoRevisado=0		
        else
            PAT_EstadoRevisadoTotal=PAT_EstadoRevisadoTotal+1
        end if
        if(PAT_EstadoAprobado="" or IsNull(PAT_EstadoAprobado) or PAT_EstadoAprobado=0) then
            PAT_EstadoAprobado=0
        else
            PAT_EstadoAprobadoTotal=PAT_EstadoAprobadoTotal+1
        end if
        if(PAT_EstadoRechazado="" or IsNull(PAT_EstadoRechazado) or PAT_EstadoRechazado=0) then
            PAT_EstadoRechazado=0
        else
            PAT_EstadoRechazadoTotal=PAT_EstadoRechazadoTotal+1
        end if		
        PAT_Total=PAT_Total+1
        rs.movenext
    loop

    'Enfoques pedagogicos
    ENP_EstadoSubidoTotal=0
    ENP_EstadoRevisadoTotal=0
    ENP_EstadoAprobadoTotal=0
    ENP_EstadoRechazadoTotal=0
    ENP_Total=0			
    
    sql="exec [spEnfoquesPedagogicos_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        ENP_EstadoSubido=rs("ENP_EstadoSubido")
        ENP_EstadoRevisado=rs("ENP_EstadoRevisado")		
        ENP_EstadoAprobado=rs("ENP_EstadoAprobado")			
        ENP_EstadoRechazado=rs("ENP_EstadoRechazado")	

        if(ENP_EstadoSubido="" or IsNull(ENP_EstadoSubido) or ENP_EstadoSubido=0) then
            ENP_EstadoSubido=0
        else
            ENP_EstadoSubidoTotal=ENP_EstadoSubidoTotal+1
        end if
        if(ENP_EstadoRevisado="" or IsNull(ENP_EstadoRevisado) or ENP_EstadoRevisado=0) then
            ENP_EstadoRevisado=0		
        else
            ENP_EstadoRevisadoTotal=ENP_EstadoRevisadoTotal+1
        end if
        if(ENP_EstadoAprobado="" or IsNull(ENP_EstadoAprobado) or ENP_EstadoAprobado=0) then
            ENP_EstadoAprobado=0
        else
            ENP_EstadoAprobadoTotal=ENP_EstadoAprobadoTotal+1
        end if
        if(ENP_EstadoRechazado="" or IsNull(ENP_EstadoRechazado) or ENP_EstadoRechazado=0) then
            ENP_EstadoRechazado=0
        else
            ENP_EstadoRechazadoTotal=ENP_EstadoRechazadoTotal+1
        end if		
        ENP_Total=ENP_Total+1
        rs.movenext
    loop			

    'Estrategia Convocatoria
    ESC_EstadoSubidoTotal=0
    ESC_EstadoRevisadoTotal=0
    ESC_EstadoAprobadoTotal=0
    ESC_EstadoRechazadoTotal=0
    ESC_Total=0
    
    sql="exec [spEstrategiaConvocatoria_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        ESC_EstadoSubido=rs("ESC_EstadoSubido")
        ESC_EstadoRevisado=rs("ESC_EstadoRevisado")		
        ESC_EstadoAprobado=rs("ESC_EstadoAprobado")			
        ESC_EstadoRechazado=rs("ESC_EstadoRechazado")	

        if(ESC_EstadoSubido="" or IsNull(ESC_EstadoSubido) or ESC_EstadoSubido=0) then
            ESC_EstadoSubido=0
        else
            ESC_EstadoSubidoTotal=ESC_EstadoSubidoTotal+1
        end if
        if(ESC_EstadoRevisado="" or IsNull(ESC_EstadoRevisado) or ESC_EstadoRevisado=0) then
            ESC_EstadoRevisado=0		
        else
            ESC_EstadoRevisadoTotal=ESC_EstadoRevisadoTotal+1
        end if
        if(ESC_EstadoAprobado="" or IsNull(ESC_EstadoAprobado) or ESC_EstadoAprobado=0) then
            ESC_EstadoAprobado=0
        else
            ESC_EstadoAprobadoTotal=ESC_EstadoAprobadoTotal+1
        end if
        if(ESC_EstadoRechazado="" or IsNull(ESC_EstadoRechazado) or ESC_EstadoRechazado=0) then
            ESC_EstadoRechazado=0
        else
            ESC_EstadoRechazadoTotal=ESC_EstadoRechazadoTotal+1
        end if		
        ESC_Total=ESC_Total+1
        rs.movenext
    loop			

    'Plan comunicacional								
    PLC_EstadoSubidoTotal=0
    PLC_EstadoRevisadoTotal=0
    PCL_EstadoAprobadoTotal=0
    PCL_EstadoRechazadoTotal=0
    PCL_Total=0						
    
    sql="exec [spPlanComunicacional_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        PLC_EstadoSubido=rs("PLC_EstadoSubido")
        PLC_EstadoRevisado=rs("PLC_EstadoRevisado")		
        PLC_EstadoAprobado=rs("PLC_EstadoAprobado")			
        PLC_EstadoRechazado=rs("PLC_EstadoRechazado")

        if(PLC_EstadoSubido="" or IsNull(PLC_EstadoSubido) or PLC_EstadoSubido=0) then
            PLC_EstadoSubido=0
        else
            PLC_EstadoSubidoTotal=PLC_EstadoSubidoTotal+1
        end if
        if(PLC_EstadoRevisado="" or IsNull(PLC_EstadoRevisado) or PLC_EstadoRevisado=0) then
            PLC_EstadoRevisado=0		
        else
            PLC_EstadoRevisadoTotal=PLC_EstadoRevisadoTotal+1
        end if
        if(PLC_EstadoAprobado="" or IsNull(PLC_EstadoAprobado) or PLC_EstadoAprobado=0) then
            PLC_EstadoAprobado=0
        else
            PLC_EstadoAprobadoTotal=PLC_EstadoAprobadoTotal+1
        end if
        if(PLC_EstadoRechazado="" or IsNull(PLC_EstadoRechazado) or PLC_EstadoRechazado=0) then
            PLC_EstadoRechazado=0
        else
            PLC_EstadoRechazadoTotal=PLC_EstadoRechazadoTotal+1
        end if		
        PLC_Total=PLC_Total+1
        rs.movenext
    loop

    'Plan de contingencia								
    PCO_EstadoSubidoTotal=0
    PCO_EstadoRevisadoTotal=0
    PCO_EstadoAprobadoTotal=0
    PCO_EstadoRechazadoTotal=0
    PCO_Total=0						
    
    sql="exec [spPlanContingencia_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        PCO_EstadoSubido=rs("PCO_EstadoSubido")
        PCO_EstadoRevisado=rs("PCO_EstadoRevisado")		
        PCO_EstadoAprobado=rs("PCO_EstadoAprobado")			
        PCO_EstadoRechazado=rs("PCO_EstadoRechazado")

        if(PCO_EstadoSubido="" or IsNull(PCO_EstadoSubido) or PCO_EstadoSubido=0) then
            PCO_EstadoSubido=0
        else
            PCO_EstadoSubidoTotal=PCO_EstadoSubidoTotal+1
        end if
        if(PCO_EstadoRevisado="" or IsNull(PCO_EstadoRevisado) or PCO_EstadoRevisado=0) then
            PCO_EstadoRevisado=0		
        else
            PCO_EstadoRevisadoTotal=PCO_EstadoRevisadoTotal+1
        end if
        if(PCO_EstadoAprobado="" or IsNull(PCO_EstadoAprobado) or PCO_EstadoAprobado=0) then
            PCO_EstadoAprobado=0
        else
            PCO_EstadoAprobadoTotal=PCO_EstadoAprobadoTotal+1
        end if
        if(PCO_EstadoRechazado="" or IsNull(PCO_EstadoRechazado) or PCO_EstadoRechazado=0) then
            PCO_EstadoRechazado=0
        else
            PCO_EstadoRechazadoTotal=PCO_EstadoRechazadoTotal+1
        end if		
        PCO_Total=PCO_Total+1
        rs.movenext
    loop

    VER_Total = ESC_Total + PAT_Total + ENP_Total + PLC_Total + PCO_Total
    VER_RevisadosTotal = ESC_EstadoRevisadoTotal + PAT_EstadoRevisadoTotal + ENP_EstadoRevisadoTotal + PLC_EstadoRevisadoTotal + PCO_EstadoRevisadoTotal
    VER_SubidosPendientes = (ESC_EstadoSubidoTotal + PAT_EstadoSubidoTotal + ENP_EstadoSubidoTotal + PLC_EstadoSubidoTotal + PCO_EstadoSubidoTotal) - VER_RevisadosTotal    
    'Subidos no revisados    
    VER_RechazadosTotal = ESC_EstadoRechazadoTotal + PAT_EstadoRechazadoTotal + ENP_EstadoRechazadoTotal + PLC_EstadoRechazadoTotal + PCO_EstadoRechazadoTotal
    VER_SinSubir = VER_Total - (ESC_EstadoSubidoTotal + PAT_EstadoSubidoTotal + ENP_EstadoSubidoTotal + PLC_EstadoSubidoTotal + PCO_EstadoSubidoTotal)
    VER_EstadoAprobado = ESC_EstadoAprobadoTotal + PAT_EstadoAprobadoTotal + ENP_EstadoAprobadoTotal + PLC_EstadoAprobadoTotal + PCO_EstadoAprobadoTotal
    
    cnn.close
	set cnn = nothing
    %>
	{"state": 200, "message": "Ejecución exitosa","VER_Total":<%=VER_Total%>,"VER_RevisadosTotal":<%=VER_RevisadosTotal%>,"VER_SubidosPendientes":<%=VER_SubidosPendientes%>,"VER_RechazadosTotal":<%=VER_RechazadosTotal%>,"VER_SinSubir":<%=VER_SinSubir%>,
    "VER_EstadoAprobado":<%=VER_EstadoAprobado%>}