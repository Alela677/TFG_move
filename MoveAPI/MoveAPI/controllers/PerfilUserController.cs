
using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using MoveAPI.Utils;
using System.Data.SqlClient;
using static System.Net.Mime.MediaTypeNames;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PerfilUserController : ControllerBase
    {
        // Propieda de solo lectura
        private readonly IConfiguration _config;
        //Contructor
        public PerfilUserController(IConfiguration config)
        {

            _config = config;
        }
        //Metodo POST: inserta un nuevo registro en la tabla perfil_usuario
        [Route("insert")]
        [HttpPost]
        public async Task<string> createPerfil(PerfilUser perfil)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
             await connection.ExecuteAsync("INSERT INTO perfil_usuario (nombre_uno,sexo,edad,localidad,descripcion,deportes,idUsuario) " +
                "VALUES ('" + perfil.nombre_uno + "','" + perfil.sexo + "'," + perfil.edad + ",'" + perfil.localidad + "','" + perfil.descripcion + "','" + perfil.deportes + "','" + perfil.idUsuario + "')");
            
            return "OK";
               

        }
        //Metodo GET: devuelve una lista de objetos en formato JSON con los perfiles de la tabla perfil_usuario 
        [HttpGet]
        public async Task<ActionResult<List<PerfilUser>>> getPerfil(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var perfil = await connection.QueryAsync("SELECT * FROM perfil_usuario");
            return Ok(perfil);
        }
        //Metodo GET: devuelve una lista de objetos en formato JSON con los perfiles de la tabla perfil_usuario
        //con los perfiles que no tiene relacion en la tabla Amigos 
        [Route("perfiles/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<PerfilUser>>> getPerfilesSug(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var perfil = await connection.QueryAsync(
                "SELECT perfil_usuario.*, imagenperfil.imagen " +
                "FROM perfil_usuario " +
                "INNER JOIN imagenperfil ON perfil_usuario.id = imagenperfil.idPerfil " +
                "WHERE perfil_usuario.id NOT IN(SELECT perfil2 FROM amigos WHERE perfil1 = "+id+") " +
                "AND perfil_usuario.id != "+id+" ");
            return Ok(perfil);
        }

        //Metodo GET: devuelve una lista de objetos en formato JSON con los perfiles de la tabla perfil_usuario
        //que tenga realacion en la tabla amigos  
        [Route("misamigos/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<PerfilUser>>> getPerfilesMisamigos(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var perfil = await connection.QueryAsync(
                "SELECT perfil_usuario.* , imagenperfil.imagen " +
                "FROM perfil_usuario " +
                "INNER JOIN imagenperfil ON perfil_usuario.id = imagenperfil.idPerfil " +
                "WHERE perfil_usuario.id IN (SELECT perfil2 FROM amigos WHERE perfil1 = "+id+") ");

            return Ok(perfil);
        }

        //Metodo GET: devuelve un registro de la tabla perfil_usuario segun su id
        [HttpGet("{id:int}", Order = 0)]
        public async Task<IActionResult> getPerfilId(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM perfil_usuario WHERE id = @Id";
            return Ok(await connection.QueryFirstOrDefaultAsync(sql, new { id }));
        }

        //Metodo GET: devuelve un registro de la tabla perfil_usuario segun su id de usuario
        [Route("idUser/{idUsuario:int}", Order = 1)]
        [HttpGet]
        public async Task<IActionResult> getPerfilIdUser(int idUsuario)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM perfil_usuario WHERE idUsuario = @idUsuario";
     
            var result = await connection.QueryAsync(sql, new { idUsuario });
            return Ok(result); 
            
           
        }

        //Metodo PUT: actualiza un registro de la tabla perfil_usuario
        [Route("update")]
        [HttpPut]
        public async Task<bool> updatePerfil(PerfilUser perfil)
        { 
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            await connection.ExecuteAsync("UPDATE perfil_usuario " +
                      "SET nombre_uno='" + perfil.nombre_uno + "',sexo='" + perfil.sexo + "',edad= " + perfil.edad + ",localidad='" + perfil.localidad + "'," +
                      "descripcion='" + perfil.descripcion + "',deportes='" + perfil.deportes + "',idUsuario=" + perfil.idUsuario + " WHERE id = " + perfil.id + "");
            
            return true;
        }

       
        //Metodo DELETE: elimina un registro de la tabla perfil_usuario
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deletePerfil(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM perfil_usuario WHERE id = @Id";
            var delete = await connection.ExecuteAsync(sql, new { id });
            return delete > 0;
        }

        //Metodo DELETE: elimina el prefil completo
        [Route("deletePerfil/{idUsuario:int}/{idPerfil:int}")]
        [HttpDelete]
        public string eliminarPerfilCompleto(int idUsuario, int idPerfil) {

            try
            {
                var connection = new SqlConnection(_config.GetConnectionString("connection"));
                //Buscamos las imagenes de perfil y la eliminamos del directorio
                UtilsImagenes utils = new UtilsImagenes();
                List<String> imagenes =  utils.getAllImagenesPerfilEliminado(connection,idPerfil);

                foreach (var img in imagenes)
                {
                    Console.WriteLine(img);
                    utils.eliminarImagenPerfil(img,"imgusuarios");
                }
                //Buscamos la imagen de perfil y la eliminamos del directorio
                String imgPerfil = utils.buscarImagenPerfil(connection,idPerfil);
                Console.WriteLine();
                utils.eliminarImagenPerfil(imgPerfil, "imgperfil");
                //Ejecutamos el procedure
                ejecutarProcedure(idUsuario, idPerfil, connection);
                return "true";
            }

            catch (Exception e)  { 
                return e.ToString();
            }

            //Metodo que ejecuta un procedimiento de la base de datos para eliminar todos los registros de un perfil
            //en la base de datos
            static void ejecutarProcedure(int idUsuario, int idPerfil, SqlConnection connection)
            {
                SqlCommand comando = new SqlCommand("eliminar_usuario", connection);
                comando.CommandType = System.Data.CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@idUsuario", idUsuario);
                comando.Parameters.AddWithValue("@idPerfil", idPerfil);
                connection.Open();
                comando.ExecuteNonQuery();
            }

        }
        

    }
        


}
