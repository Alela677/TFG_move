using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using System.Data.SqlClient;
using System.Globalization;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventoController : ControllerBase
    {
       //Propiedad de solo lectura
        private readonly IConfiguration _config;

        public EventoController(IConfiguration config) {

            _config = config;
        }

        //Metodo POST: crea un registro en a tabla Evento 
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createEvento([FromBody] Evento evento) 
        {
            
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO evento (descripcion,numero_participantes,fecha_evento,ciudad,longitud,latitud,idDeporte,idPerfil)" +
                "VALUES ('"+evento.descripcion+"',"+evento.numero_participante+",'"+evento.fecha_evento+"','"+evento.ciudad+"',"+evento.longitud.ToString()+","+evento.latitud.ToString()+","+evento.idDeporte+","+evento.idPerfilUsuario+")";
            var create = await connection.ExecuteAsync(sql);

            return create > 0;
        
        }
        
        //Metodo GET: devulve una lista de objetos en formato JSON con los registros de la tabla Evento
        [HttpGet]
        public async Task<ActionResult<List<Evento>>> getEvento()
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM Evento";
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET:  devulve una lista de objetos en formato JSON con los registros de la tabla Evento 
        // con una fecha igual o superior a la actual
        [Route("activos/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<Evento>>> getEventoActivo(int id)
        {
            DateTime date = DateTime.Now;
            
            date.AddHours(7);
            
            string fecha = ""+date.Year+"-"+date.Month+"-"+date.Day+" "+date.Hour+":"+date.Minute+":"+date.Second+"";
            
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT evento.*, deporte.nombre, deporte.imagen " +
                      "FROM evento INNER JOIN deporte ON evento.idDeporte = deporte.id " +
                      "WHERE evento.id NOT IN(SELECT DISTINCT evento FROM participante WHERE perfil = "+id+") AND evento.fecha_evento >= '"+fecha+"' ";           
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET:  devulve una lista de objetos en formato JSON con los registros de la tabla Evento 
        // con una fecha igual o superior a la actual de un perfil por su id
        [Route("activos/user/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<Evento>>> getEventoActivoUser(int id)
        {
            DateTime date = DateTime.Now;
            date.AddHours(7);
            string fecha = "" + date.Year + "-" + date.Month + "-" + date.Day + " " + date.Hour + ":" + date.Minute + ":" + date.Second + "";
           
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT evento.*,deporte.nombre, deporte.imagen " +
                      "FROM evento " +
                      "INNER JOIN deporte ON evento.idDeporte = deporte.id  " +
                      "WHERE idPerfil = " + id+" AND fecha_evento >= '" + fecha + "'";
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET:  devulve una lista de objetos en formato JSON con los registros de la tabla Evento 
        // con una fecha igual o superior a la actual en los que el perfil es participante
        [Route("participando/{id:int}")]
        [HttpGet]
        public async Task<ActionResult<List<Evento>>> getEventoActivoParticipando(int id)
        {
            DateTime date = DateTime.Now;
            date.AddHours(7);
            string fecha = "" + date.Year + "-" + date.Month + "-" + date.Day + " " + date.Hour + ":" + date.Minute + ":" + date.Second + "";

            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT evento.*, deporte.nombre, deporte.imagen " +
                "FROM evento INNER JOIN deporte ON evento.idDeporte = deporte.id " +
                "WHERE evento.id IN(SELECT DISTINCT evento FROM participante WHERE perfil = " + id + ") " +
                "AND evento.idPerfil != "+id+"  AND evento.fecha_evento >= '" + fecha + "' ";
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET: devuelve un registro de la tabla Evento por su id
        [HttpGet("{id:int}")]
        public async Task<IActionResult> getEventoId(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM Evento WHERE id = @Id";
            return Ok(await connection.QueryAsync(sql,new { id }));
        }


        //Metodo PUT: atualiza un registro de la tabla Evento
        [Route("update")]
        [HttpPut]
        public async Task<bool> updateEvento([FromBody] Evento evento)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "UPDATE evento SET " +
                "descripcion = '"+evento.descripcion+"'," +
                "numero_participantes= "+evento.numero_participante+"," +
                "fecha_evento='"+evento.fecha_evento+"'," +
                "ciudad='" + evento.ciudad + "'," +
                "longitud='" + evento.longitud.ToString() + "'," +
                "latitud='" + evento.latitud.ToString() + "'," +
                "idDeporte='" +evento.idDeporte+"'," +
                "idPerfil='"+evento.idPerfilUsuario+"'" +
                "WHERE id = "+evento.id+"";
        
            var update = await connection.ExecuteAsync(sql);
            return update > 0;
        
        }

        //Metodo DELETE: elimina un registro de la tabla Evento
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deleteEvento(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM evento WHERE id = @Id";
            var delete = await connection.ExecuteAsync(sql,new { id });
            return delete > 0;
        }

        //Metodo GET: muestra el id del ultimo evento creado por un perfil 
        [HttpGet("ultimo/{id:int}")]
        public async Task<IActionResult> getEventoIdUltimo(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT TOP 1 id FROM evento WHERE idPerfil = "+id+" ORDER BY id DESC";
            return Ok(await connection.QueryAsync(sql));
        }


    }
}
