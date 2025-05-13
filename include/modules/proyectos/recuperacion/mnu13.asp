<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	modo=request("modo")
	PRY_Id=request("PRY_Id")
	CRT_Step=request("CRT_Step")	'Paso seleccioando
	PRY_Hito=request("PRY_Hito")	'Hito seleccionado
	LIN_Id=request("LIN_Id")
	Modulo=request("Modulo")		'Opcion para no cargar el paso actual
	if(Modulo="") then
		Modulo=true					'Por defecto siempre se carga la paso actual
	end if
	
	key1=request("key1")
	key2=request("key2")
	key3=request("key3")
	key4=request("key4")
	key5=request("key5")
	
	xPRY_Id = PRY_Id
	xPRY_Hito = PRY_Hito
	xCRT_Step = CRT_Step	
	xmodo = modo	
	
	
	if(PRY_Id="") then
		PRY_Id = key2
	end if
	if(LIN_Id="") then
		LIN_Id = key1		
	end if
	if(PRY_Hito="") then
		PRY_Hito = key3		
	end if
	if(CRT_Step="") then
		CRT_Step = key4
	end if	
	if(CRT_Step="") then
		CRT_Step = 1
	end if	

	if(CRT_Step)=0 then
		CRT_Step=1
		PRY_Hito = PRY_Hito - 1
	end if
	if(PRY_Hito<0) then
		PRY_Hito=0
	end if
	
	PRY_CreacionProyectoEstado=0
	PRY_InformeInicialEstado=0
	PRY_InformeConsensosEstado=0
	PRY_InformeSistematizacionEstado=0
	
	PRY_InformeInicialAceptado=0
	PRY_InformeConsensosAceptado=0
	PRY_InformeSistematizacionAceptado=0
	USR_IdRevisor=0
	
	observaciones=false
	existe_archivo=false
		
	ruta=replace(ruta,"#","")
	splitruta=split(ruta,"/")
	if(UBound(splitruta))>=5 then
		xm=splitruta(5)
	else
		xm="modificar"
	end if
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
		if(PRY_Id="") then
			PRY_Id=splitruta(7)
		end if
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
		PRY_Id=splitruta(7)
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	if((xm="agregar") and (modo="") or (modo=1)) then
		modo=1
		mode="add"
		PRY_Id=0
		CRT_Step=1
	end if
	if((xm="agregar") and (modo=2)) then		
		mode="mod"
		modo=2
		if(PRY_Id="") then
			PRY_Id=splitruta(7)
		end if
		if(LIN_Id="") then
			LIN_Id=splitruta(6)
		end if
	end if
	
	CRT_Step=CInt(CRT_Step)	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	if(LIN_Id<>"") then
		LIN_Id=CInt(LIN_Id)
		sql="exec spLinea_Consultar " & LIN_Id
		set rs = cnn.Execute(sql)
		if not rs.eof then
			titulo = rs("LFO_Nombre") & " " & rs("LIN_Nombre")
			LFO_Id = rs("LFO_Id")
			LIN_AgregaTematica = rs("LIN_AgregaTematica")			
		end if
	end if
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión:" & ErrMsg)
	    response.End()
	End If
	
	nuevo=false
	if not rs.eof then
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Step=rs("PRY_Step")
		PRY_Estado=rs("PRY_Estado")
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
		
		PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")						'Inicial
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")					'Avances
		PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")		'Final
		
		PRY_InformeInicialAceptado=rs("PRY_InformeInicialAceptado")
		PRY_InformeConsensosAceptado=rs("PRY_InformeConsensosAceptado")
		PRY_InformeSistematizacionAceptado=rs("PRY_InformeSistematizacionAceptado")
		
		PRY_TipoMesa=rs("PRY_TipoMesa")
		USR_IdRevisor=rs("USR_IdRevisor")
		PRY_Carpeta=rs("PRY_Carpeta")
	else
		if modo<>1 then
			response.Write("100/@/Error: Sin información " & modo & "-" & PRY_Id)
	    	response.End()
		else
			nuevo=true
		end if
	end if
	
	if(PRY_CreacionProyectoEstado="") then
		PRY_CreacionProyectoEstado=0
	end if	
	if(PRY_InformeInicialEstado="") then
		PRY_InformeInicialEstado=0
	end if
	if(PRY_InformeConsensosEstado="") then
		PRY_InformeConsensosEstado=0
	end if
	if(PRY_InformeSistematizacionEstado="") then
		PRY_InformeSistematizacionEstado=0
	end if
	
	if(IsNull(PRY_InformeInicialAceptado)) then
		PRY_InformeInicialAceptado=0
	end if
	if(IsNull(PRY_InformeConsensosAceptado)) then
		PRY_InformeConsensosAceptado=0
	end if
	if(IsNull(PRY_InformeSistematizacionAceptado)) then
		PRY_InformeSistematizacionAceptado=0
	end if
	xPRY_Hito = PRY_Hito

	menulen=0
	
	'Mesas
	if(PRY_CreacionProyectoEstado=0) and (PRY_Hito>0 or PRY_Hito="") then
		PRY_Hito=0
	else
		if((PRY_InformeInicialEstado=0) and (PRY_Hito>1 or PRY_Hito="")) or (PRY_InformeInicialEstado=1 and PRY_InformeInicialAceptado=0 and PRY_Hito="") then
			PRY_Hito=1
		else
			if((PRY_InformeConsensosEstado=0) and (PRY_Hito>2 or PRY_Hito="")) or (PRY_InformeConsensosEstado=1 and PRY_InformeConsensosAceptado=0 and PRY_Hito="") then
				PRY_Hito=2
			else
				if((PRY_InformeSistematizacionEstado=0) and (PRY_Hito>3 or PRY_Hito="")) or (PRY_InformeSistematizacionEstado=1 and PRY_InformeSistematizacionAceptado=0 and PRY_Hito="") then
					PRY_Hito=3
				else

				end if
			end if
		end if
	end if		
	'Mesas
	yPRY_Hito = PRY_Hito
	
	if PRY_Estado=1 then 'Modificar
		if PRY_Hito=0 and PRY_CreacionProyectoEstado=1 then	'Hito Creacion			
			if not LIN_AgregaTematica and CRT_Step>=5 then
				PRY_Hito=1
				CRT_Step=1
			else
				if LIN_AgregaTematica and CRT_Step>=6 then
					PRY_Hito=1
					CRT_Step=1
				end if
			end if			
		else
			if PRY_Hito=1 and PRY_InformeInicialEstado=1 and CRT_Step>=2 then	'Hito Inicial
				if(PRY_InformeInicialEstado=1 and PRY_InformeInicialAceptado=0) then
					PRY_Hito=1
					CRT_Step=2
				else				
					PRY_Hito=2
					CRT_Step=1
				end if
			else
				if PRY_Hito=2 and PRY_InformeConsensosEstado=1 and CRT_Step>=2 then 'Hito Avances
					if(PRY_InformeConsensosEstado=1 and PRY_InformeConsensosAceptado=0) then
						PRY_Hito=2
						CRT_Step=2
					else				
						PRY_Hito=3
						CRT_Step=1
					end if					
				else
					if PRY_Hito=3 and PRY_InformeSistematizacionEstado=1 and CRT_Step>=3 then 'Hito Final
						if(PRY_InformeSistematizacionEstado=1 and PRY_InformeSistematizacionAceptado=0) then
							PRY_Hito=3
							CRT_Step=3
						else
							PRY_Hito=3
							CRT_Step=1
						end if
					else
					end if
				end if
			end if
		end if
	end if	
	finalizar=0
	
	mode="vis"			
	modo=4
	caso=0	
	do
		select case PRY_Hito
			case 0	'Creación
				if LIN_AgregaTematica then
					menulen=5
				else
					menulen=4
				end if				
				do
					select case PRY_CreacionProyectoEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) or ((session("ds5_usrperfil")=5) and CRT_Step>1) then
								if(nuevo) then
									modo=1
									mode="add"
									caso=9
								else
									mode="mod"
									modo=2
									caso=1
								end if									
							end if
							exit do
						case 1	'Cerrado		
							'Si el hito esta cerrado no es posible modificar (todos)
							mode="vis"			
							modo=4
							caso=2
							exit do
					end select
					exit do
				loop
				exit do
			case 1	'Inicial
				menulen=1
				do
					select case PRY_InformeInicialEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) then
								mode="mod"
								modo=2
								caso=3
							end if
							exit do
						case 1	'Cerrado		
							if(PRY_InformeInicialAceptado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) and CRT_Step=menulen+1 then
								mode="mod"
								modo=2
								caso=4
							end if
							exit do
					end select
					exit do
				loop
				exit do
			case 2	'Avances
				menulen=1
				do
					select case PRY_InformeConsensosEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) then
								mode="mod"
								modo=2
								caso=5
							end if
							exit do
						case 1	'Cerrado		
							if(PRY_InformeConsensosAceptado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1)) and CRT_Step=menulen+1 then
								mode="mod"
								modo=2
								caso=6
							end if
							exit do
					end select
					exit do
				loop
				exit do
			case 3	'Final	
				menulen=2
				do
					select case PRY_InformeSistematizacionEstado
						case 0	'Abierto
							if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) then
								mode="mod"
								modo=2
								caso=7
							end if
							exit do
						case 1	'Cerrado		
							if(PRY_InformeSistematizacionAceptado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) and CRT_Step=menulen+1) then
								mode="mod"
								modo=2
								caso=8
							end if
							exit do
					end select
					exit do
				loop
				exit do
		end select	
		exit do
	loop
	'response.write("200/@/" & "caso:" & caso & " - menulen+1:" & menulen + 1 & " - PRY_Hito:" & PRY_Hito & " - CRT_Step:" & CRT_Step)		
	response.write("200/@/")
		
	call menu(PRY_Hito,PRY_Step,CRT_Step,modo)	
	yCRT_Step=CRT_Step
	if(PRY_Hito="") then
		PRY_Hito=0
	end if	

	pryarc="pry-13-h" & PRY_Hito & "-s" & yCRT_Step
	if(PRY_Hito=0) then	'Creacion
		if(CRT_Step=finalizar+1 and not LIN_AgregaTematica) then
			pryarc="pry-13-h0-fin"
		end if
		if(CRT_Step=finalizar+1 and LIN_AgregaTematica) then
			pryarc="pry-13-h0-fin"
		end if
	end if
	if(PRY_Hito=1) then	'Inicial
		if(CRT_Step=finalizar+1) then
			pryarc="pry-13-h1-fin"
		end if
		if(PRY_InformeInicialAceptado=0 and PRY_InformeInicialEstado=1 and (CRT_Step=finalizar+1)) then
			pryarc="pry-13-h1-acepta"
		end if
	end if
	
	if(PRY_Hito=2) then	'Concensos
		if(CRT_Step=finalizar+1) then
			pryarc="pry-13-h2-fin"
		end if
		if(PRY_InformeConsensosAceptado=0 and PRY_InformeConsensosEstado=1 and (CRT_Step=finalizar+1)) then
			pryarc="pry-13-h2-acepta"
		end if
	end if
	
	if(PRY_Hito=3) then	'Sistematización
		if(CRT_Step=finalizar+1) then
			pryarc="pry-13-h3-fin"
		end if
		if(PRY_InformeSistematizacionAceptado=0 and PRY_InformeSistematizacionEstado=1 and (CRT_Step=finalizar+1)) then
			pryarc="pry-13-h3-acepta"
		end if
	end if	

	function menu(xPRY_Hito,xPRY_Step,xCRT_Step,modo)		
		'Buscando las cabeceras de mensajes nuevos para el proyecto activo solo si no es hito creacion
		if modo<>1 then
			'Adecuaciones ahora mensajes
			sql = "exec spUsuarioMensajeProyectoHeadNuevo_Contar " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 			   		
			End If	
			if not rs.eof then
				MensajeProyectosNuevos=rs("MensajeProyectosNuevos")		
			else
				MensajeProyectosNuevos=0
			end if	

			'Buscando respuestas nuevas en los proyectos
			sql = "exec spUsuarioMensajeProyectoRespuestaNuevo_Contar " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				'cnn.close 			   		
			End If	
			if not rs.eof then
				MensajeRespuestaProyectosNuevos=rs("MensajeRespuestaProyectosNuevos")		
			else
				MensajeRespuestaProyectosNuevos=0
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

			VER_Total = PRS_Total + PAT_Total + CTR_Total + PLC_Total + TED_Total
			VER_RevisadosTotal = PRS_EstadoRevisadoTotal + PAT_EstadoRevisadoTotal + CTR_EstadoRevisadoTotal + PLC_EstadoRevisadoTotal + TED_EstadoRevisadoTotal
			VER_SubidosPendientes = (PRS_EstadoSubidoTotal + PAT_EstadoSubidoTotal + CTR_EstadoSubidoTotal + PLC_EstadoSubidoTotal + TED_EstadoSubidoTotal) - VER_RevisadosTotal		'Subidos no revisados
			VER_RechazadosTotal = PRS_EstadoRechazadoTotal + PAT_EstadoRechazadoTotal + CTR_EstadoRechazadoTotal + PLC_EstadoRechazadoTotal + TED_EstadoRechazadoTotal
			VER_SinSubir = VER_Total - (PRS_EstadoSubidoTotal + PAT_EstadoSubidoTotal + CTR_EstadoSubidoTotal + PLC_EstadoSubidoTotal + TED_EstadoSubidoTotal)

			'Adecuaciones Pendientes
			set rs = cnn.Execute("exec spAdecuaciones_SolicitudesPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				'cnn.close				
			End If
			SolPen=0
			globo=""
			do while not rs.eof
				SolPen=SolPen + 1							
				rs.movenext
			loop									

			'Linea Formativa
			sql = "exec spLineaFormativa_Consultar " & LFO_Id

			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 			   		
			End If	
			if not rs.eof then
				LFO_Calif=rs("LFO_Calif")
			else
				LFO_Calif=0
			end if
						
			
			'Documentos pendientes
			sql="exec [spVerificadorProyecto_Listar] 1," & PRY_Id & "," & PRY_Hito & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rs = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then
			End If

			VPR_EstadoSubidoTotal=0
			VPR_EstadoRevisadoTotal=0
			VPR_EstadoAprobadoTotal=0
			VPR_EstadoRechazadoTotal=0
			VPR_Total=0			
			do while not rs.eof				
				VPR_EstadoSubido=rs("VPR_EstadoSubido")
				VPR_EstadoRevisado=rs("VPR_EstadoRevisado")		
				VPR_EstadoAprobado=rs("VPR_EstadoAprobado")			
				VPR_EstadoRechazado=rs("VPR_EstadoRechazado")	

				if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido) or VPR_EstadoSubido=0) then
					VPR_EstadoSubido=0
				else
					VPR_EstadoSubidoTotal=VPR_EstadoSubidoTotal+1
				end if
				if(VPR_EstadoRevisado="" or IsNull(VPR_EstadoRevisado) or VPR_EstadoRevisado=0) then
					VPR_EstadoRevisado=0		
				else
					VPR_EstadoRevisadoTotal=VPR_EstadoRevisadoTotal+1
				end if
				if(VPR_EstadoAprobado="" or IsNull(VPR_EstadoAprobado) or VPR_EstadoAprobado=0) then
					VPR_EstadoAprobado=0
				else
					VPR_EstadoAprobadoTotal=VPR_EstadoAprobadoTotal+1
				end if
				if(VPR_EstadoRechazado="" or IsNull(VPR_EstadoRechazado) or VPR_EstadoRechazado=0) then
					VPR_EstadoRechazado=0
				else
					VPR_EstadoRechazadoTotal=VPR_EstadoRechazadoTotal+1
				end if		
				VPR_Total=VPR_Total+1				
				rs.movenext
			loop			
		else
			MensajeProyectosNuevos=0
			MensajeRespuestaProyectosNuevos=0
			VerificadorNuevos=0
			SolPen=0
		end if

		if(MensajeProyectosNuevos>0 and MensajeRespuestaProyectosNuevos>0) then
			mensajesproyectos="<i class='fas fa-comment'></i>Mensajes <span class='badge red' style='font-size:9px;'>" & MensajeProyectosNuevos & "</span> <span class='badge blue' style='font-size:9px;'>" & MensajeRespuestaProyectosNuevos & "</span>"
		else
			if(MensajeProyectosNuevos>0 and MensajeRespuestaProyectosNuevos=0) then
				mensajesproyectos="<i class='fas fa-comment'></i>Mensajes <span class='badge red' style='font-size:9px;'>" & MensajeProyectosNuevos & "</span>"
			else
				if(MensajeProyectosNuevos=0 and MensajeRespuestaProyectosNuevos>0) then
					mensajesproyectos="<i class='fas fa-comment'></i>Mensajes <span class='badge blue' style='font-size:9px;'>" & MensajeRespuestaProyectosNuevos & "</span>"
				else
					mensajesproyectos="<i class='fas fa-comment'></i>Mensajes"
				end if
			end if
		end if

		
		
		if(VER_SubidosPendientes>0) and (VER_RechazadosTotal<=0) and (VER_SinSubir<=0) then
			verificadores="<i class='fas fa-check'></i>Verificadores <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" & VER_SubidosPendientes & "</span>"
		else
			if(VER_SubidosPendientes>0) and (VER_RechazadosTotal>0) and (VER_SinSubir<=0) then
				verificadores= "<i class='fas fa-check'></i>Verificadores <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" & VER_SubidosPendientes & "</span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VER_RechazadosTotal & "</span>"
			else
				if(VER_SubidosPendientes>0) and (VER_RechazadosTotal>0) and (VER_SinSubir>0) then
					verificadores= "<i class='fas fa-check'></i>Verificadores <span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" & VER_SinSubir & "</span> <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" & VER_SubidosPendientes & "</span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VER_RechazadosTotal & "</span>"
				else
					if(VER_SubidosPendientes>0) and (VER_RechazadosTotal<=0) and (VER_SinSubir>0) then
						verificadores= "<i class='fas fa-check'></i>Verificadores <span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" & VER_SinSubir & "</span> <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" & VER_SubidosPendientes
					else
						if(VER_SubidosPendientes<=0) and (VER_RechazadosTotal>0) and (VER_SinSubir>0) then
							verificadores= "<i class='fas fa-check'></i>Verificadores <span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" & VER_SinSubir & "</span> </span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VER_RechazadosTotal & "</span>"
						else
							if(VER_SubidosPendientes<=0) and (VER_RechazadosTotal<=0) and (VER_SinSubir>0) then
								verificadores= "<i class='fas fa-check'></i>Verificadores <span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" & VER_SinSubir							
							else
								if(VER_SubidosPendientes<=0) and (VER_RechazadosTotal>0) and (VER_SinSubir<=0) then
									verificadores= "<i class='fas fa-check'></i>Verificadores </span> </span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VER_RechazadosTotal & "</span>"
								else
									verificadores="<i class='fas fa-check'></i>Verificadores"
								end if
							end if
						end if
					end if
				end if
			end if
		end if	
						
		if(SolPen>0) then
			adecuaciones="<i class='fas fa-edit'></i>Adecuaciones <span class='badge green' style='font-size:9px;'>" & SolPen & "</span>"
		else
			adecuaciones="<i class='fas fa-edit'></i>Adecuaciones"
		end if

		clase="category text-primary"
						
		if(session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Administrador, revisor, auditor
			if(PRY_InformeInicialAceptado<>0) then
				menucierre=array(adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
				menucierrepag=array("/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
			else
				menucierre=array(mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
				menucierrepag=array("/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
			end if			
		else
			if(session("ds5_usrperfil")=3) then
				if(PRY_InformeInicialAceptado<>0) then
					menucierre=array(adecuaciones,mensajesproyectos,verificadores)
					menucierrepag=array("/adecuaciones-modal","/mensajes-proyecto-modal")
				else
					menucierre=array(mensajesproyectos,verificadores)
					menucierrepag=array("/mensajes-proyecto-modal")
				end if
			else
				if(session("ds5_usrperfil")=5) then	'Administrativo
					if(PRY_InformeInicialAceptado<>0) then
						menucierre=array(adecuaciones,mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
						menucierrepag=array("/adecuaciones-modal","/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
					else
						menucierre=array(mensajesproyectos,"<i class='fas fa-file-signature'></i>Contratos","<i class='fas fa-hand-holding-usd'></i>Presupuesto")
						menucierrepag=array("/mensajes-proyecto-modal","/contratos-modal","/presupuestos-modal")
					end if					
				end if				
			end if
		end if		
				
		menucierrelen=ubound(menucierre)
		
		hitoscerrados=array(PRY_CreacionProyectoEstado,PRY_InformeInicialEstado,PRY_InformeConsensosEstado,PRY_InformeSistematizacionEstado)
		hitosaceptados=array(true,PRY_InformeInicialAceptado,PRY_InformeConsensosAceptado,PRY_InformeSistematizacionAceptado)
		hitos=array("Creación","Inicial","Desarrollo","Final")	
		hitoslen=3
		informesnombre=array("informecreacionrecuperacion.pdf","informeinicialrecuperacion.pdf","informeavancesrecuperacion.pdf","informefinalrecuperacion.pdf")
		informessubdir=array("informecreacion","informeinicial","informeavances","informefinal")
		prtinformes=array("/prt-informecreacionrecuperacion","/prt-informeinicialrecuperacion","/prt-informeavancesrecuperacion","/prt-informefinalrecuperacion")
		dir="d:\DocumentosSistema\dialogosocial\" & replace(replace(PRY_Carpeta,"{",""),"}","") & "\informes\"
		dim fs
		informesexiste = array(false,false,false,false)
		for i=0 to hitoslen
			Archivo=dir & informessubdir(i) & "\" & informesnombre(i)
			set fs=Server.CreateObject("Scripting.FileSystemObject")
			if fs.FileExists(Archivo) then
			  informesexiste(i)=true
			else
			  informesexiste(i)=false
			end if
			set fs=nothing
			'response.write(Archivo)
			'response.write(informesexiste(i))
		next
		
		dim menus(4,14)
		'Creación
		if LIN_AgregaTematica then			
			menus(0,0)="Personalización"
			menus(0,1)="Fechas de Cierre"			
			menus(0,2)="Responsables del Proyecto"
			'menus(0,3)="Diagnóstico Social Laboral"
			menus(0,3)="Metodología de Investigación"
			'menus(0,4)="Redes de Apoyo"
			'menus(0,5)="Representantes Mesas"
			'menus(0,6)="Metodología y Resultados Esperados"
			menus(0,4)="Exposición Adicional"			
			menus(0,5)="Finalizar"			
		else			
			menus(0,0)="Personalización"
			menus(0,1)="Fechas de Cierre"			
			menus(0,2)="Responsables del Proyecto"
			'menus(0,3)="Diagnóstico Social Laboral"
			menus(0,3)="Metodología de Investigación"
			'menus(0,4)="Redes de Apoyo"
			'menus(0,5)="Representantes Mesas"
			'menus(0,6)="Metodología y Resultados Esperados"
			menus(0,4)="Finalizar"			
		end if	
		
		
		PenSubir = VPR_Total - VPR_EstadoSubidoTotal
		PenRevisar = VPR_Total - VPR_EstadoRevisadoTotal
		'texto="Documentos"		
		texto=""
		if(PenSubir>0) then
			texto=texto & " <span class='badge orange' style='font-size:9px;' title='Archivos pendientes de subir' data-toggle='tooltip'>" & PenSubir & "</span>"
		end if		
		if(PenRevisar>0) then
			texto=texto & " <span class='badge purple' style='font-size:9px;' title='Archivos pendientes de revisar' data-toggle='tooltip'>" & PenRevisar & "</span>"
		end if
		if(VPR_EstadoAprobadoTotal>0) then
			texto=texto & " <span class='badge green' style='font-size:9px;' title='Archivos aceptados' data-toggle='tooltip'>" & VPR_EstadoAprobadoTotal & "</span>"
		end if
		if(VPR_EstadoRechazadoTotal>0) then
			texto=texto & " <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" & VPR_EstadoRechazadoTotal & "</span>"
		end if
		'Inicial				
		'menus(1,0)="Plan de Trabajo"
		menus(1,0)="Informe Nro.: 1 " & texto
		if(PRY_InformeInicialEstado=0) then			
			menus(1,1)="Finalizar"
		else
			if(PRY_InformeInicialAceptado=0) then
				menus(1,1)="Aceptar"
			end if
		end if		

		'Avances
		'menus(2,0)="Grupos Focales"
		'menus(2,1)="Coordinación entre Actores"
		'menus(2,2)="Plan Comunicacional"
		menus(2,0)="Informe Nro.: 2 " & texto
		if(PRY_InformeConsensosEstado=0) then
			menus(2,1)="Finalizar"
		else
			if(PRY_InformeConsensosAceptado=0) then
				menus(2,1)="Aceptar"
			end if
		end if		

		'Final				
		menus(3,0)="Sugerencias"		
		menus(3,1)="Informe Nro.: 3 " & texto		
		if(PRY_InformeSistematizacionEstado=0) then			
			'menus(3,10)="Finalizar"
			menus(3,2)="Finalizar"
		else
			if(PRY_InformeSistematizacionAceptado=0) then
				'menus(3,10)="Aceptar"
				menus(3,2)="Aceptar"
			end if
		end if					
		
		param=""
		salida=""
		
		salida = salida + "<ul class='nav nav-stacked nav-tree' role='tab-list'>"	
		'response.write(LIN_AgregaTematica)
		if hitoscerrados(0)=1 then
			salida= salida +  "<li role='presentation' class='category text-primary menus'><i class='fas fa-bars' aria-hidden='true'></i> Menú</li>"
			for j=0 to menucierrelen	'Mostrando el menu de la cabecera solo cuando el hito esta cerrado
				salida = salida + "<li role='presentation' class='menus'><a role='tab' href='#' data-url='" & menucierrepag(j) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' data-step='" & xCRT_Step & "'>" & menucierre(j) & "</a></li>"
			next
		else
			if(xPRY_Step>0) then
				salida= salida +  "<li role='presentation' class='category text-primary menus'><i class='fas fa-bars' aria-hidden='true'></i> Menú</li>"
				for j=0 to 1
					salida = salida + "<li role='presentation' class='menus'><a role='tab' href='#' data-url='" & menucierrepag(j) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' data-step='" & xCRT_Step & "'>" & menucierre(j) & "</a></li>"
				next
			end if
		end if		
		salida = salida + "<li class='pasos' style='padding-top:15px;opacity:0;visiblity:hidden'></li>"
		salida = salida + "<li role='presentation' class='" & clase & " pasos' style='margin-top:0;'><i class='fas fa-indent' aria-hidden='true' style='padding-right:7px;'></i> PASOS HITO : " + hitos(xPRY_Hito) & "</li>"		

		if hitoscerrados(xPRY_Hito)=0 then	'Hito aun esta abierto
			if(xCRT_Step>PRY_Step and PRY_Step>0) then
				xCRT_Step=PRY_Step
			end if
			for j=0 to menulen
				if (j+1)=xCRT_Step then
					clase="active"
					param=""
					if(xCRT_Step<=xPRY_Step) then						
						clase2="act done"
					else						
						clase2="act"
					end if
				else		
					if xPRY_Step<(j+1) then		
						clase="disabled"
						clase2="pend"
						param=""
					else
						clase=""
						clase2="done"
						param="data-step='" & j+1 & "' data-mode='" & modo & "' class='step' data-hito='" & xPRY_Hito & "'"
					end if
				end if
				if clase="" then
					salida= salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' " & param & "><i class='globo " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"			
				else
					salida= salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' " & param & "><i class='globo " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				end if
			next
		else	'Hito Cerrado pero no aceptado
			if (not hitosaceptados(xPRY_Hito)) then
				for j=0 to menulen 	'Mostrar ultimo step aceptar si no se ha aceptado y si es administrador o revisor
					if (j+1)=xCRT_Step then
						clase="active"
						clase2="act"
					else
						clase=""
						clase2="done"
					end if
					salida = salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' data-step='" & (j+1) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' class='step'><i class='globo pull-left " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				next				
			else 'Hito cerrado y aceptado
				for j=0 to menulen - 1	'Sin step Aceptar cuando esta cerrado y aceptado
					if (j+1)=xCRT_Step then
						clase="active"
						clase2="act"
					else
						clase=""
						clase2="done"
					end if										
					salida = salida + "<li role='presentation' class='" & clase & " pasos'><a role='tab' href='#' data-step='" & (j+1) & "' data-mode='" & modo & "' data-hito='" & xPRY_Hito & "' class='step'><i class='globo pull-left " & clase2 & "'>" & (j+1) & "</i>" & menus(xPRY_Hito,j) & "</a></li>"
				next					
			end if	'Fin Hito Cerrado	
		end if	'Fin Hito Cerrado pero no aceptado
		salida = salida + "<li class='hitos' style='padding-top:15px;opacity:0;visiblity:hidden'></li>"
		salida = salida + "<li role='presentation' class='category text-primary hitos' style='margin-top:0;'><i class='fas fa-map-marker-alt' style='padding-right:7px;'></i> Hitos </li>"
		
		sw=0
		for j=0 to hitoslen		'Menu Hitos	
			'response.write(hitosaceptados(j) & " " & j)
			if CInt(xPRY_Hito)=j then
				clase="active"
				clase2="act"
				param=""
			else
				if hitosaceptados(j-1) and hitoscerrados(j-1)=1 then
					clase=""
					clase2="done"
					param="data-step='1' data-mode='" & modo & "' class='step'" & " data-hito='" & j & "'"
				else
					sw=1
				end if
			end if				
			if sw=1 then			
				param=""
				clase="disabled"
				clase2="pend"
			end if			
			aceptado=""
			check="fa-check"
			texto="Cerrado"
			mail=""
			if hitosaceptados(j) and hitoscerrados(j)=1 then
				'aceptado="<i class='fas fa-check-double aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " Cerrado y Aceptado'></i>"
				check="fa-check-double"
				mail="<i class='fas fa-paper-plane enviarmail' data-toggle='tooltip' title='Reenviar mail de aceptación de informe " & hitos(j) & "' data-pry='" & PRY_Id & "' data-hito='" & j & "'></i>"
				texto="Cerrado y Aceptado"
			end if			
			if hitoscerrados(j)=1 then				
				if (session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and USR_IdRevisor=session("ds5_usrid"))) and j>0 then	'Solo Adm y Rev pueden abrir hitos cerrados				
					aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "'></i>" & mail & "<i class='fas fa-folder-open abririnforme' aria-hidden='true' data-hito='" & j & "' data-toggle='tooltip' data-placement='right' title='Abrir informe " & hitos(j) & "' data-file='" & informesnombre(j) & "' data-des='" & hitos(j) & "'></i>"
				else
					if (session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and USR_IdRevisor=session("ds5_usrid")) and j=1) then
						aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "'></i> <i class='fas fa-folder-open abririnforme' aria-hidden='true' data-hito='" & j & "' data-toggle='tooltip' data-placement='right' title='Abrir informe " & hitos(j) & "' data-file='" & informesnombre(j) & "' data-des='" & hitos(j) & "'></i>"
					else
						aceptado="<i class='fas " & check & " aceptado' aria-hidden='true' data-toggle='tooltip' data-placement='right' title='Hito " & hitos(j) & " " & texto & "' data-des='" & hitos(j) & "'></i>"
					end if
				end if
			end if
						
			'Informe
			informe=""
			if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=5) and hitoscerrados(j)=1 then				
				informe = "<i class='fas fa-sync text-warning aceptado generar' id='' data-file='" & informesnombre(j) & "' data-id='" & j & "' data-hito='" & j & "' data-step='" & xCRT_Step & "' data-toggle='tooltip' data-placement='top' title='Generar Informe " & informesnombre(j) & "' data-prt=" & prtinformes(j) &"></i>"
			end if				
			if informesexiste(j) and hitoscerrados(j)=1 then										
				informe = informe + "<i class='fas fa-cloud-download-alt text-primary aceptado descargar' data-file='" & informesnombre(j) & "' id='' data-toggle='tooltip' data-placement='right' data-hito='" & j & "' title='Descargar informe " & informesnombre(j) & "'></i>"
				
				informe = informe + "<i class='fas fa-history text-secondary aceptado historico' data-file='' id='' data-toggle='tooltip' data-placement='right' data-hito='" & j & "' title='Informes Históricos para " & informesnombre(j) & "'></i>"
			end if			
			'Informe
			
			salida = salida + "<li role='presentation' class='" & clase & " hitos'><a role='tab' href='#'" & param &"><i class='globo " & clase2 & "'>" & ucase(mid(hitos(j),1,1)) & "</i>" & hitos(j) & " " & informe & aceptado & " </a></li>"
			if not hitosaceptados(j) then			
				'exit for			
				sw=1
			end if
		next		

		salida = salida + "</ul>"				
		finalizar=menulen
		response.write(salida)		
	end function		
%>
<script>
	var ss  = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	changeURL(<%=modo%>,<%=PRY_Hito%>,<%=CRT_Step%>,<%=PRY_Id%>);
	var data={LIN_Id:<%=LIN_Id%>,mode:'<%=mode%>',PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'};<%
	if(Modulo) then%>	
		$("#pry-content").html("Cargando el modulo...");
		$("#pry-content").append("<div class='loader_wrapper'><div class='loader'></div></div>");
		$.ajax( {
			type:'POST',					
			url: '/<%=pryarc%>',
			data: data,
			success: function ( data ) {
				param = data.split(sas)
				
				if(param[0]==200){
					$("#pry-content").hide();
					$("#pry-content").html(param[1]);
					$("#pry-content").show("slow")
				}else{				
					$("#pry-content").hide();
					$("#pry-content").html("<div class='row'><h5 style='padding-right: 15px; padding-left: 15px; display: block;'>ERROR: No fue posible encontrar el módulo correspondiente.</h5></div>");
					$("#pry-content").show("slow")
				}			
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){				
				swalWithBootstrapButtons.fire({
					icon:'error',								
					title: 'Ups!, no pude cargar los campos del proyecto'					
				});				
			},
			complete: function(){
				$(".loader_wrapper").remove();
			}
		});<%
	end if%>		
		
	function changeURL(Modo,Hito,Step,PRY_Id){				
		var href = window.location.href;
		var newhref = href.substr(href.indexOf("/home")+6,href.length);
		var href_split = newhref.split("/")				
		
		if(href_split[1]=="modificar" || href_split[1]=="visualizar" || href_split[1]=="agregar"){
			if(Modo==2){
				href_split[1]="modificar";
				href_split[3]=PRY_Id;
			}
			if(Modo==4){
				href_split[1]="visualizar";
				href_split[3]=PRY_Id;
			}
			if(Modo!=1){
				href_split[4]=Hito;
				href_split[5]=Step;			
				var newurl="/home"
				$.each(href_split, function(i,e){
					newurl=newurl + "/" + e
				});
				window.history.replaceState(null, "", newurl);
			}
			cargabreadcrumb("/breadcrumbs","");
		}		
		
	};
			
</script><%
response.write("/@/" & pryarc)%>