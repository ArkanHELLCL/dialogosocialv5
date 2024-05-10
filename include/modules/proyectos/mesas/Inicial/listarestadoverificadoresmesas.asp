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
    'Redes de Apoyo					
    PAT_EstadoSubidoTotal=0
    PAT_EstadoRevisadoTotal=0
    PAT_EstadoAprobadoTotal=0
    PAT_EstadoRechazadoTotal=0
    PAT_Total=0			
    
    sql="exec [spPatrociniosMesas_Listar] " & PRY_Id
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

    'Grupos Focales
    PRS_EstadoSubidoTotal=0
    PRS_EstadoRevisadoTotal=0
    PRS_EstadoAprobadoTotal=0
    PRS_EstadoRechazadoTotal=0
    PRS_Total=0			
    
    sql="exec [spGruposFocalessMesas_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        PRS_EstadoSubido=rs("PRS_EstadoSubido")
        PRS_EstadoRevisado=rs("PRS_EstadoRevisado")		
        PRS_EstadoAprobado=rs("PRS_EstadoAprobado")			
        PRS_EstadoRechazado=rs("PRS_EstadoRechazado")	

        if(PRS_EstadoSubido="" or IsNull(PRS_EstadoSubido) or PRS_EstadoSubido=0) then
            PRS_EstadoSubido=0
        else
            PRS_EstadoSubidoTotal=PRS_EstadoSubidoTotal+1
        end if
        if(PRS_EstadoRevisado="" or IsNull(PRS_EstadoRevisado) or PRS_EstadoRevisado=0) then
            PRS_EstadoRevisado=0		
        else
            PRS_EstadoRevisadoTotal=PRS_EstadoRevisadoTotal+1
        end if
        if(PRS_EstadoAprobado="" or IsNull(PRS_EstadoAprobado) or PRS_EstadoAprobado=0) then
            PRS_EstadoAprobado=0
        else
            PRS_EstadoAprobadoTotal=PRS_EstadoAprobadoTotal+1
        end if
        if(PRS_EstadoRechazado="" or IsNull(PRS_EstadoRechazado) or PRS_EstadoRechazado=0) then
            PRS_EstadoRechazado=0
        else
            PRS_EstadoRechazadoTotal=PRS_EstadoRechazadoTotal+1
        end if		
        PRS_Total=PRS_Total+1
        rs.movenext
    loop			

    'Estrategia Convocatoria
    CTR_EstadoSubidoTotal=0
    CTR_EstadoRevisadoTotal=0
    CTR_EstadoAprobadoTotal=0
    CTR_EstadoRechazadoTotal=0
    CTR_Total=0
    
    sql="exec [spCoordinacionActoresMesas_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        CTR_EstadoSubido=rs("CTR_EstadoSubido")
        CTR_EstadoRevisado=rs("CTR_EstadoRevisado")		
        CTR_EstadoAprobado=rs("CTR_EstadoAprobado")			
        CTR_EstadoRechazado=rs("CTR_EstadoRechazado")	

        if(CTR_EstadoSubido="" or IsNull(CTR_EstadoSubido) or CTR_EstadoSubido=0) then
            CTR_EstadoSubido=0
        else
            CTR_EstadoSubidoTotal=CTR_EstadoSubidoTotal+1
        end if
        if(CTR_EstadoRevisado="" or IsNull(CTR_EstadoRevisado) or CTR_EstadoRevisado=0) then
            CTR_EstadoRevisado=0		
        else
            CTR_EstadoRevisadoTotal=CTR_EstadoRevisadoTotal+1
        end if
        if(CTR_EstadoAprobado="" or IsNull(CTR_EstadoAprobado) or CTR_EstadoAprobado=0) then
            CTR_EstadoAprobado=0
        else
            CTR_EstadoAprobadoTotal=CTR_EstadoAprobadoTotal+1
        end if
        if(CTR_EstadoRechazado="" or IsNull(CTR_EstadoRechazado) or CTR_EstadoRechazado=0) then
            CTR_EstadoRechazado=0
        else
            CTR_EstadoRechazadoTotal=CTR_EstadoRechazadoTotal+1
        end if		
        CTR_Total=CTR_Total+1
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

    'Plan de trabajo								
    TED_EstadoSubidoTotal=0
    TED_EstadoRevisadoTotal=0
    TED_EstadoAprobadoTotal=0
    TED_EstadoRechazadoTotal=0
    TED_Total=0						
    
    sql="exec [spTematicaDialogo_Listar] " & PRY_Id
    set rs = cnn.Execute(sql)
    on error resume next			
    if cnn.Errors.Count > 0 then 
        ErrMsg = cnn.Errors(0).description
        'cnn.close 			   		
    End If	
    
    do while not rs.eof
        TED_EstadoSubido=rs("TED_EstadoSubido")
        TED_EstadoRevisado=rs("TED_EstadoRevisado")		
        TED_EstadoAprobado=rs("TED_EstadoAprobado")			
        TED_EstadoRechazado=rs("TED_EstadoRechazado")

        if(TED_EstadoSubido="" or IsNull(TED_EstadoSubido) or TED_EstadoSubido=0) then
            TED_EstadoSubido=0
        else
            TED_EstadoSubidoTotal=TED_EstadoSubidoTotal+1
        end if
        if(TED_EstadoRevisado="" or IsNull(TED_EstadoRevisado) or TED_EstadoRevisado=0) then
            TED_EstadoRevisado=0		
        else
            TED_EstadoRevisadoTotal=TED_EstadoRevisadoTotal+1
        end if
        if(TED_EstadoAprobado="" or IsNull(TED_EstadoAprobado) or TED_EstadoAprobado=0) then
            TED_EstadoAprobado=0
        else
            TED_EstadoAprobadoTotal=TED_EstadoAprobadoTotal+1
        end if
        if(TED_EstadoRechazado="" or IsNull(TED_EstadoRechazado) or TED_EstadoRechazado=0) then
            TED_EstadoRechazado=0
        else
            TED_EstadoRechazadoTotal=TED_EstadoRechazadoTotal+1
        end if		
        TED_Total=TED_Total+1
        rs.movenext
    loop

    VER_Total = CTR_Total + PAT_Total + PRS_Total + PLC_Total + TED_Total
    VER_RevisadosTotal = CTR_EstadoRevisadoTotal + PAT_EstadoRevisadoTotal + PRS_EstadoRevisadoTotal + PLC_EstadoRevisadoTotal + TED_EstadoRevisadoTotal
    VER_SubidosPendientes = (CTR_EstadoSubidoTotal + PAT_EstadoSubidoTotal + PRS_EstadoSubidoTotal + PLC_EstadoSubidoTotal + TED_EstadoSubidoTotal) - VER_RevisadosTotal    
    'Subidos no revisados
    VER_RechazadosTotal = CTR_EstadoRechazadoTotal + PAT_EstadoRechazadoTotal + PRS_EstadoRechazadoTotal + PLC_EstadoRechazadoTotal + TED_EstadoRechazadoTotal
    VER_SinSubir = VER_Total - (CTR_EstadoSubidoTotal + PAT_EstadoSubidoTotal + PRS_EstadoSubidoTotal + PLC_EstadoSubidoTotal + TED_EstadoSubidoTotal)
    VER_EstadoAprobado = CTR_EstadoAprobadoTotal + PAT_EstadoAprobadoTotal + PRS_EstadoAprobadoTotal + PLC_EstadoAprobadoTotal + TED_EstadoAprobadoTotal
    
    cnn.close
	set cnn = nothing
    %>
	{"state": 200, "message": "Ejecución exitosa","VER_Total":<%=VER_Total%>,"VER_RevisadosTotal":<%=VER_RevisadosTotal%>,"VER_SubidosPendientes":<%=VER_SubidosPendientes%>,"VER_RechazadosTotal":<%=VER_RechazadosTotal%>,"VER_SinSubir":<%=VER_SinSubir%>,
    "VER_EstadoAprobado":<%=VER_EstadoAprobado%>}