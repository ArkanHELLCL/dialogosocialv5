<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%if session("ds5_usrperfil")<>1 and session("ds5_usrperfil")<>2 then	'Solo adminisgtrador y fiscalizador pueden entrar a los mantenedores'
	response.Write("403/@/Error Perfil no autoizado")
	response.end()
end if%>
<%=response.write("200/@/")%>
<div class="row container-header">
	
</div>			
<div class="row container-body">
	<!--wrapper-editor-->
	<div class="wrapper-editor">
		<div class="block">
			<div class="d-flex justify-content-center">
			  <p class="createShowP">0 fila seleccionada</p>
			</div>
		</div>
	  	<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
		<!-- Table with panel -->					
		<div class="card card-cascade narrower">
			<!--Card image-->
			<div class="view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
				<div>
					<button class="btn btn-primary btn-rounded buttonView btn-sm waves-effect" disabled data-toggle="tooltip" title="Visualizar informe">Visualizar<i class="fas fa-eye ml-1"></i></button>
				</div>
				<a href="" class="white-text mx-3"><i class="fas fa-user-cog"></i> Perfiles</a>
				<div>					
					<button class="btn btn-default btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla">Exportar
						<i class="fas fa-download ml-1"></i>
					</button>
					<button type="button" class="btn btn-outline-white btn-rounded btn-sm px-2 btn-acc" data-url="/mantenedores">
						<i class="fas fa-times-circle mt-0"></i>
					</button>
				</div>
			</div>
			<!--/Card image-->
			<div class="px-4">
				<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-2">
				<!--Table-->
				<table id="tbl-perfiles" class="ts table table-striped table-bordered dataTable table-sm" data-id="perfiles" data-edit="true" data-keys="1" data-url="/perfiles-html" data-noajax="true" data-header="3" data-ajaxcallview="/mantenedores/perfiles/visualizar" data-ajaxcalledit="/mantenedores/perfiles/modificar">  
					<thead> 
						<tr> 							
							<th>#</th>
							<th>Perfil</th>
							<th>Estado</th>					
						</tr> 
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<!-- Table with panel -->
	</div>
</div>
