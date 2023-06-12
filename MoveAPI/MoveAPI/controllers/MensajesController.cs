using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.models;
using MoveAPI.Models;
using System.Data.SqlClient;

namespace MoveAPI.controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MensajesController : ControllerBase
    {
        //Propeida de solo lectura
        private readonly IConfiguration _config;

        //Constructor
        public MensajesController(IConfiguration config) { 
           
            _config = config;

        }
        //Metodo GET: devulve una lista de objetos Mensajes en formato JSON 
        [Route("{idEvento:int}")]
        [HttpGet]
        public async Task<ActionResult<List<Mensajes>>> getMensajes(int idEvento) 
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT chat.*, perfil_usuario.nombre_uno " +
                     "FROM chat " +
                    "INNER JOIN perfil_usuario ON chat.perfil = perfil_usuario.id " +
                    "WHERE chat.evento = " + idEvento + "";
            var respuesta = await connection.QueryAsync(sql);

            return Ok(respuesta);
        }
        //Metodo POST: inserta un nuevo registro en la tabla Chat
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createMensaje([FromBody] Mensajes mensaje)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO chat (perfil,evento,mensaje)" +
                      "VALUES ("+mensaje.perfil+" , "+mensaje.evento+", '"+mensaje.mensaje+"')";
            var inset = await connection.ExecuteAsync(sql);

            return inset > 0;
        }

        //Metodo DELETE: elimina un registro de la tabla Chat por la id de perfil
        [Route("delete/{idPerfil:int}")]
        [HttpDelete]
        public async Task<bool> deleteMensajePerfil(int idPerfil)
        {
            var connectio = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM chat WHERE perfil = " + idPerfil + "";
            var delete = await connectio.ExecuteAsync(sql);
            return delete > 0;
        }
    }
}
