<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Identificador=request("PRY_Identificador")
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="vis"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"		
		action="/mod-12-h1-s5"
		calendario="calendario"
		hora="hora"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"		
		calendario=""
		hora=""
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		hora=""
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
	
	lblClass=""
	if(mode="mod" or mode="vis") then
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)		
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & sql)
		   response.End() 			   
		end if		
		if not rs.eof then	
			PRY_LanzamientoFecha=rs("PRY_LanzamientoFecha")
			PRY_LanzamientoHora=rs("PRY_LanzamientoHora")
			PRY_LanzamientoDireccion=rs("PRY_LanzamientoDireccion")
			PRY_CierreFecha=rs("PRY_CierreFecha")
			PRY_CierreHora=rs("PRY_CierreHora")
			PRY_CierreDireccion=rs("PRY_CierreDireccion")
			MET_IdLanzamiento=rs("MET_IdLanzamiento")
			MET_DescripcionLanzamiento=rs("MET_DescripcionLanzamiento")
			MET_IdCierre=rs("MET_IdCierre")
			MET_DescripcionCierre=rs("MET_DescripcionCierre")
			PRY_UrlLanzamiento=rs("PRY_UrlLanzamiento")
			PRY_UrlCierre=rs("PRY_UrlCierre")
			PRY_ClaseCierreFecha=rs("PRY_ClaseCierreFecha")
			PRY_ClaseCierreHora=rs("PRY_ClaseCierreHora")
			MET_IdClaseCierre=rs("MET_IdClaseCierre")
			PRY_ClaseCierreDireccion=rs("PRY_ClaseCierreDireccion")
			PRY_UrlClaseCierre=rs("PRY_UrlClaseCierre")
			PRY_LanzamientoHoraFin=rs("PRY_LanzamientoHoraFin")
			PRY_ClaseCierreHoraFin=rs("PRY_ClaseCierreHoraFin")
			PRY_CierreHoraFin=rs("PRY_CierreHoraFin")
		end if					
	end if
	
	rs.close
	response.write("200/@/")
%>
<form role="form" action="<%=action%>" method="POST" name="frm12s5" id="frm12s5" class="needs-validation">
	<h5>Actividades</h5>
	<h6>Ceremonia de Inauguración</h6>
	<div class="row" style="position:relative;padding-bottom:30px">
		<div class="" id="FechaLanCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_LanzamientoFecha" name="PRY_LanzamientoFecha" class="form-control <%=calendario%>" readonly required value="<%=PRY_LanzamientoFecha%>"><%
					else%>
						<input type="text" id="PRY_LanzamientoFecha" name="PRY_LanzamientoFecha" class="form-control <%=calendario%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_LanzamientoFecha<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_LanzamientoFecha" class="<%=lblClass%>">Fecha</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraLanCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_LanzamientoHora" name="PRY_LanzamientoHora" class="form-control <%=hora%>" readonly required value="<%=PRY_LanzamientoHora%>"><%
					else%>
						<input type="text" id="PRY_LanzamientoHora" name="PRY_LanzamientoHora" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_LanzamientoHora<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_LanzamientoHora" class="<%=lblClass%>">Inicio</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraFinCol">		
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_LanzamientoHoraFin" name="PRY_LanzamientoHoraFin" class="form-control <%=hora%>" readonly required value="<%=PRY_LanzamientoHoraFin%>"><%
					else%>
						<input type="text" id="PRY_LanzamientoHoraFin" name="PRY_LanzamientoHoraFin" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_LanzamientoHoraFin<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_LanzamientoHoraFin" class="<%=lblClass%>">Término</label>									
				</div>
			</div>
		</div>
		<div class="" id="MetLanCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="MET_IdLanzamiento" id="MET_IdLanzamiento" class="validate select-text form-control" <%=disabled%>><%
							if(MET_IdLanzamiento="" or IsNull(MET_IdLanzamiento)) then
								lblSelect=""%>
								<option value="" disabled selected></option><%
							else
								lblSelect="active"
							end if
							set rs = cnn.Execute("exec spMetodologia_Listar 1")
							on error resume next					
							do While Not rs.eof
								if rs("MET_Id")=MET_IdLanzamiento then%>
									<option value="<%=rs("MET_Id")%>" selected ><%=rs("MET_Descripcion")%></option><%
								else%>
									<option value="<%=rs("MET_Id")%>"><%=rs("MET_Descripcion")%></option><%
								end if
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-graduation-cap input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Metodología</label>
					</div>
				</div>
			</div>
		</div>		
		<div class="" id="LanDirCol">
			<div id="LanzamientoDir">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_LanzamientoDireccion" name="PRY_LanzamientoDireccion" class="form-control" <%=disabled%> value="<%=PRY_LanzamientoDireccion%>"><%
						else%>
							<input type="text" id="PRY_LanzamientoDireccion" name="PRY_LanzamientoDireccion" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_LanzamientoDireccion<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_LanzamientoDireccion" class="<%=lblClass%>">Dirección</label>									
					</div>
				</div>
			</div>
		</div>		
		<div class="" id="LanUrlCol">
			<div id="LanzamientoUrl">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-globe-americas input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_UrlLanzamiento" name="PRY_UrlLanzamiento" class="form-control" <%=disabled%> value="<%=PRY_UrlLanzamiento%>"><%
						else%>
							<input type="text" id="PRY_UrlLanzamiento" name="PRY_UrlLanzamiento" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_UrlLanzamiento<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_UrlLanzamiento" class="<%=lblClass%>">Url</label>									
					</div>
				</div>
			</div>
		</div>
	</div>
	<h6>Clase de cierre</h6>
	<div class="row" style="position:relative;padding-bottom:30px">
		<div class="" id="FechaClaCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_ClaseCierreFecha" name="PRY_ClaseCierreFecha" class="form-control <%=calendario%>" readonly required value="<%=PRY_ClaseCierreFecha%>"><%
					else%>
						<input type="text" id="PRY_ClaseCierreFecha" name="PRY_ClaseCierreFecha" class="form-control <%=calendario%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_ClaseCierreFecha<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_ClaseCierreFecha" class="<%=lblClass%>">Fecha</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraClaCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_ClaseCierreHora" name="PRY_ClaseCierreHora" class="form-control <%=hora%>" readonly required value="<%=PRY_ClaseCierreHora%>"><%
					else%>
						<input type="text" id="PRY_ClaseCierreHora" name="PRY_ClaseCierreHora" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_ClaseCierreHora<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_ClaseCierreHora" class="<%=lblClass%>">Inicio</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraFinCla">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_ClaseCierreHoraFin" name="PRY_ClaseCierreHoraFin" class="form-control <%=hora%>" readonly required value="<%=PRY_ClaseCierreHoraFin%>"><%
					else%>
						<input type="text" id="PRY_ClaseCierreHoraFin" name="PRY_ClaseCierreHoraFin" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_ClaseCierreHoraFin<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_ClaseCierreHoraFin" class="<%=lblClass%>">Término</label>									
				</div>
			</div>
		</div>
		<div class="" id="MetClaCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="MET_IdClaseCierre" id="MET_IdClaseCierre" class="validate select-text form-control" <%=disabled%>><%
							if(MET_IdClaseCierre="" or IsNull(MET_IdClaseCierre)) then
								lblSelect=""%>
								<option value="" disabled selected></option><%
							else
								lblSelect="active"
							end if
							set rs = cnn.Execute("exec spMetodologia_Listar 1")
							on error resume next					
							do While Not rs.eof
								if rs("MET_Id")=MET_IdClaseCierre then%>
									<option value="<%=rs("MET_Id")%>" selected ><%=rs("MET_Descripcion")%></option><%
								else%>
									<option value="<%=rs("MET_Id")%>"><%=rs("MET_Descripcion")%></option><%
								end if
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-graduation-cap input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Metodología</label>
					</div>
				</div>
			</div>
		</div>
		<div class="" id="ClaDirCol">
			<div id="ClaseCierreDir">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_ClaseCierreDireccion" name="PRY_ClaseCierreDireccion" class="form-control" <%=disabled%> value="<%=PRY_ClaseCierreDireccion%>"><%
						else%>
							<input type="text" id="PRY_ClaseCierreDireccion" name="PRY_ClaseCierreDireccion" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_ClaseCierreDireccion<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_ClaseCierreDireccion" class="<%=lblClass%>">Dirección</label>									
					</div>
				</div>
			</div>
		</div>
		<div class="" id="ClaUrlCol">
			<div id="ClaseCierreUrl">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_UrlClaseCierre" name="PRY_UrlClaseCierre" class="form-control" <%=disabled%> value="<%=PRY_UrlClaseCierre%>"><%
						else%>
							<input type="text" id="PRY_UrlClaseCierre" name="PRY_UrlClaseCierre" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_UrlClaseCierre<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_UrlClaseCierre" class="<%=lblClass%>">Url</label>									
					</div>
				</div>		
			</div>
		</div>
	</div>
	<h6>Ceremonia de certificación</h6>
	<div class="row">
		<div class="" id="FechaCieCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_CierreFecha" name="PRY_CierreFecha" class="form-control <%=calendario%>" readonly required value="<%=PRY_CierreFecha%>"><%
					else%>
						<input type="text" id="PRY_CierreFecha" name="PRY_CierreFecha" class="form-control <%=calendario%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_CierreFecha<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_CierreFecha" class="<%=lblClass%>">Fecha</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraCieCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_CierreHora" name="PRY_CierreHora" class="form-control <%=hora%>" readonly required value="<%=PRY_CierreHora%>"><%
					else%>
						<input type="text" id="PRY_CierreHora" name="PRY_CierreHora" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_CierreHora<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_CierreHora" class="<%=lblClass%>">Inicio</label>									
				</div>
			</div>
		</div>
		<div class="" id="HoraFinCie">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-clock input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_CierreHoraFin" name="PRY_CierreHoraFin" class="form-control <%=hora%>" readonly required value="<%=PRY_CierreHoraFin%>"><%
					else%>
						<input type="text" id="PRY_CierreHoraFin" name="PRY_CierreHoraFin" class="form-control <%=hora%>" readonly required><%
					end if%>
					<span class="select-bar"></span><%
					lblClass=""
					if PRY_CierreHoraFin<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_CierreHoraFin" class="<%=lblClass%>">Término</label>									
				</div>
			</div>
		</div>
		<div class="" id="MetCieCol">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="MET_IdCierre" id="MET_IdCierre" class="validate select-text form-control" <%=disabled%>><%
							if(MET_IdCierre="" or IsNull(MET_IdCierre)) then
								lblSelect=""%>
								<option value="" disabled selected></option><%
							else
								lblSelect="active"
							end if
							set rs = cnn.Execute("exec spMetodologia_Listar 1")
							on error resume next					
							do While Not rs.eof
								if rs("MET_Id")=MET_IdCierre then%>
									<option value="<%=rs("MET_Id")%>" selected ><%=rs("MET_Descripcion")%></option><%
								else%>
									<option value="<%=rs("MET_Id")%>"><%=rs("MET_Descripcion")%></option><%
								end if
								rs.movenext						
							loop
							rs.Close%>
						</select>
						<i class="fas fa-graduation-cap input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Metodología</label>
					</div>
				</div>
			</div>
		</div>
		<div class="" id="CieDirCol">
			<div id="CierreDir">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_CierreDireccion" name="PRY_CierreDireccion" class="form-control" <%=disabled%> value="<%=PRY_CierreDireccion%>"><%
						else%>
							<input type="text" id="PRY_CierreDireccion" name="PRY_CierreDireccion" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_CierreDireccion<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_CierreDireccion" class="<%=lblClass%>">Dirección</label>									
					</div>
				</div>
			</div>
		</div>
		<div class="" id="CieUrlCol">
			<div id="CierreUrl">
				<div class="md-form input-with-post-icon">
					<div class="error-message">								
						<i class="fas fa-home input-prefix"></i><%
						if(mode="mod" or mode="vis") then%>
							<input type="text" id="PRY_UrlCierre" name="PRY_UrlCierre" class="form-control" <%=disabled%> value="<%=PRY_UrlCierre%>"><%
						else%>
							<input type="text" id="PRY_UrlCierre" name="PRY_UrlCierre" class="form-control" <%=disabled%>><%
						end if%>
						<span class="select-bar"></span><%
						lblClass=""
						if PRY_UrlCierre<>"" then
							lblClass="active"
						end if%>
						<label for="PRY_UrlCierre" class="<%=lblClass%>">Url</label>									
					</div>
				</div>		
			</div>
		</div>
	</div>	
	<div class="row">
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s5" name="btn_frm12s5"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="5" />	
</form>

<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var bb = String.fromCharCode(92) + String.fromCharCode(92);	
	
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	ordenColLan();
	ordenColCie();
	ordenColCla();
	function ordenColLan(){		
		$("#FechaLanCol").attr("class","");
		$("#HoraLanCol").attr("class","");
		$("#HoraFinCol").attr("class","");
		$("#MetLanCol").attr("class","");
		$("#LanDirCol").attr("class","");
		$("#LanUrlCol").attr("class","");
				
		if($("#MET_IdLanzamiento").val()==null){
			$("#FechaLanCol").addClass("col-sm-12 col-md-2 col-lg-4");
			$("#HoraLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraFinCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#MetLanCol").addClass("col-sm-12 col-md-2 col-lg-4");
		}
		if($("#MET_IdLanzamiento").val()==1){
			$("#FechaLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraLanCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCol").addClass("col-sm-12 col-md-2 col-lg-1");

			$("#MetLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#LanUrlCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#LanzamientoDir").hide("slow");
			$("#LanzamientoUrl").show("slow");
		}
		
		if($("#MET_IdLanzamiento").val()==2){
			$("#FechaLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraLanCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#LanDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#LanzamientoDir").show("slow");
			$("#LanzamientoUrl").hide("slow");
		}
		
		if($("#MET_IdLanzamiento").val()==3){
			$("#FechaLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraLanCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetLanCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#LanDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			$("#LanUrlCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#LanzamientoDir").show("slow");
			$("#LanzamientoUrl").show("slow");
		}
	}
	function ordenColCla(){		
		$("#FechaClaCol").attr("class","");
		$("#HoraClaCol").attr("class","");
		$("#HoraFinCla").attr("class","");
		$("#MetClaCol").attr("class","");
		$("#ClaDirCol").attr("class","");
		$("#ClaUrlCol").attr("class","");
				
		if($("#MET_IdClaseCierre").val()==null){
			$("#FechaClaCol").addClass("col-sm-12 col-md-2 col-lg-4");
			$("#HoraClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraFinCla").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#MetClaCol").addClass("col-sm-12 col-md-2 col-lg-4");			
		}
		if($("#MET_IdClaseCierre").val()==1){
			$("#FechaClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraClaCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCla").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#ClaUrlCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#ClaseCierreDir").hide("slow");
			$("#ClaseCierreUrl").show("slow");
		}
		
		if($("#MET_IdClaseCierre").val()==2){
			$("#FechaClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraClaCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCla").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#ClaDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#ClaseCierreDir").show("slow");
			$("#ClaseCierreUrl").hide("slow");
		}
		
		if($("#MET_IdClaseCierre").val()==3){
			$("#FechaClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraClaCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCla").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetClaCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#ClaDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			$("#ClaUrlCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#ClaseCierreDir").show("slow");
			$("#ClaseCierreUrl").show("slow");
		}
	}
	function ordenColCie(){
		$("#FechaCieCol").attr("class","");
		$("#HoraCieCol").attr("class","");
		$("#HoraFinCie").attr("class","");
		$("#MetCieCol").attr("class","");
		$("#CieDirCol").attr("class","");
		$("#CieUrlCol").attr("class","");
		
		if($("#MET_IdCierre").val()==null){
			$("#FechaCieCol").addClass("col-sm-12 col-md-2 col-lg-4");
			$("#HoraCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraFinCie").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#MetCieCol").addClass("col-sm-12 col-md-2 col-lg-4");
		}
		if($("#MET_IdCierre").val()==1){
			$("#FechaCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraCieCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCie").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#CieUrlCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#CierreDir").hide("slow");
			$("#CierreUrl").show("slow");
		}
		
		if($("#MET_IdCierre").val()==2){
			$("#FechaCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraCieCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCie").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#CieDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			
			$("#CierreDir").show("slow");
			$("#CierreUrl").hide("slow");
		}
		
		if($("#MET_IdCierre").val()==3){
			$("#FechaCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#HoraCieCol").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#HoraFinCie").addClass("col-sm-12 col-md-2 col-lg-1");
			$("#MetCieCol").addClass("col-sm-12 col-md-2 col-lg-2");
			$("#CieDirCol").addClass("col-sm-12 col-md-4 col-lg-6");
			$("#CieUrlCol").addClass("col-sm-12 col-md-4 col-lg-	");
			
			$("#CierreDir").show("slow");
			$("#CierreUrl").show("slow");
		}
	}
	
	$("#MET_IdLanzamiento").on("change",function(){
		ordenColLan();				
	})
	
	$("#MET_IdCierre").on("change",function(){
		ordenColCie();						
	})
	
	$("#MET_IdClaseCierre").on("change",function(){
		ordenColCla();						
	})	

	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});	
	$(".calendario").datepicker();
	
	$('.hora').timepicker({
		timeFormat: 'H:mm',
		interval: 5,
		minTime: '6',
		maxTime: '22:00',
		startTime: '6:00',
		dynamic: true,
		dropdown: true,
		scrollbar: true,
		change:function(time){									
			$(this).siblings("label").addClass("active");								
		},
		beforeShow: function(input, inst) {
			$(document).off('focusin.bs.modal');
		},
		onClose:function(){
			$(document).on('focusin.bs.modal');
		},
	});	
	
	$(document).ready(function() {	
		$("#btn_frm12s5").click(function(){
			formValidate("#frm12s5")
			if($("#frm12s5").valid()){												
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm12s5").attr("action"),
					data: $("#frm12s5").serialize(),
					success: function(data) {					
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
								icon: 'success',
								title: 'Actividades grabadas correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};							
							$.ajax( {
								type:'POST',					
								url: '/mnu-12',
								data: data,
								success: function ( data ) {
									param = data.split(sas)
									if(param[0]==200){						
										$("#pry-menucontent").html(param[1]);
										moveMark(false);
									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',								
											title: 'Ups!, no pude cargar el menú del proyecto',					
											text:param[1]
										});				
									}
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){					
									swalWithBootstrapButtons.fire({
										icon:'error',								
										title: 'Ups!, no pude cargar el menú del proyecto',					
									});				
								}
							});

						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del proyecto',					
								text:param[1]
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto'							
						});
					}
				});									
			}
		})
	});
</script>