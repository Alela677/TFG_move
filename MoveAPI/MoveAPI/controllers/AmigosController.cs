using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using System.Data.SqlClient;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AmigosController : ControllerBase
    {   
        //Propiedades 
        private readonly IConfiguration _config;

        //Constructor controlador Amigos
        public AmigosController(IConfiguration config) {        
            _config = config;
        }
            
        //Metodo GET: devuelve una lista de objeto en formato JSON con todos lo registros de la tabla Amigos
        [HttpGet]
        public async Task<ActionResult<List<Amigos>>> getAmigos()
        {
            var connection =new SqlConnection( _config.GetConnectionString("connection"));
            var sql = await connection.QueryAsync("SELECT * FROM amigos");
            return Ok(sql);
        }
        
        //Metodo POST: crea un registro en la tabla Amigos
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createAmigo(Amigos amigo) 
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO amigos (solicitante,perfil1,perfil2) VALUES ("+amigo.solicitante+","+amigo.perfil1+","+amigo.perfil2+")";
            var create = await connection.ExecuteAsync(sql);
            return create > 0;

           
        }

        //Metodo DELETE: elimina un registro de la tabla Amigos segun la id del perfil1 y el perfil2
        [Route("delete/{id:int}/{idAmigo:int}")]
        [HttpDelete]
        public async Task<bool> deleteAmigo(int id, int idAmigo)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM amigos WHERE perfil1 = "+id+" AND perfil2 = "+idAmigo+" ";
            var delete = await connection.ExecuteAsync(sql);
            return delete > 0;
        }
        
    }
}
