using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using System.Data.SqlClient;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ParticipanteController : ControllerBase
    {
        //Porpieda de solo lectura
        private readonly IConfiguration _config;

        //Constructo
        public ParticipanteController(IConfiguration config)
        { 
            _config = config;
        }

        //Metodo POST: inserta un nuevo registro en la tabla Partipante
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createParticipante([FromBody] Participante participante)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO participante (perfil,evento) VALUES("+participante.perfil+","+participante.evento+")";
            var create = await connection.ExecuteAsync(sql);
            return create > 0;
        }

        //Metodo GET: devulve una lista de objetos de la tabla participantes en formato JSON
        [HttpGet]
        public async Task<ActionResult<List<Participante>>> getParticipante()
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM participante";
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET: devulve una lista de objetos de la tabla participante segun la id de evento en formato JSON
        [Route("numParticipantes/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<Participante>>> getParticipando(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT COUNT(perfil) FROM participante WHERE evento = @Id";
            return Ok(await connection.QueryAsync(sql,new { id }));
        }

        //Metodo GET: devulve una lista de objetos de la tabla participante segun la id de perfil en formato JSON
        [Route("idUsuario(id:int")]
        [HttpGet]
        public async Task<ActionResult<List<Participante>>> getParticipante(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM participante WHERE perfil = "+id+"";
            return Ok(await connection.QueryAsync(sql));
        }

        // Metodo GET: devulve una lista de perfiles formato JSON a apartir de un rango de valores obtenidos de la tabla partipante 
        // con los participantes de un evento, 
        [Route("participantesEvento/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<PerfilUser>>> getPerfilesSug(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var perfil = await connection.QueryAsync(
                "SELECT perfil_usuario.id ,perfil_usuario.nombre_uno, imagenperfil.imagen " +
                "FROM perfil_usuario " +
                "INNER JOIN imagenperfil ON perfil_usuario.id = imagenperfil.idPerfil " +
                "WHERE perfil_usuario.id IN(SELECT DISTINCT perfil FROM participante WHERE evento = "+id+")");
            return Ok(perfil);
        }
        //Metodo DELETE: elimina un registro de la tabla Particpantes segun su id y la id de perfil
        [Route("delete/{idEvento:int}/{idPerfil:int}")]
        [HttpDelete]
        public async Task<bool> deleteParticipante(int idEvento, int idPerfil)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM participante WHERE evento = "+idEvento+" AND perfil = "+idPerfil+" ";
            var delete = await connection.ExecuteAsync(sql);
            return delete > 0;
        }
        

    
    
    }
}
