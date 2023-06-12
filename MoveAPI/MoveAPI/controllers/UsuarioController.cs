using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using System.Collections;
using System.Data.SqlClient;
using System.Reflection.Metadata.Ecma335;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        //Propeidad de solo lectura
        private readonly IConfiguration _config;
        public UsuarioController(IConfiguration config)
        {
            _config = config;
        }

        //Metodo GET: devulve una lista de la tabla Usuario en formato JSON
        [HttpGet]
        public async Task<ActionResult<List<Usuario>>> getUsers()
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var users = await connection.QueryAsync("SELECT * FROM usuario");
            return Ok(users);

        }

        //Metodo GET: devulve un registro de la tabla Usuario en formato JSON segun su id
        [HttpGet("{id:long}", Order = 0)]
        public async Task<IActionResult> getUsersId(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM usuario WHERE id = @Id";
            return Ok(await connection.QueryFirstOrDefaultAsync(sql, new { id }));

        }
        
        //Metodo GET: devulve un registro de la tabla Usuario en formato JSON segun su email
        [Route("comprobar/{email}")]
        [HttpGet]
        public async Task<IActionResult> getUsersEmail( String email)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM usuario WHERE correo_electronico = '"+email+"'";
            return  Ok( await connection.QueryFirstOrDefaultAsync(sql));
    
        }

        //Metodo GET: devulve un registro de la tabla Usuario en formato JSON segun su nombre y password
        [Route("{usuario}/{password}")]
        [HttpGet]
        public async Task<IActionResult> getUsersPassName( String usuario, String password)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM usuario WHERE nombre_usuario = '"+usuario+"' AND password = '"+password+"'";
            return Ok(await connection.QuerySingleAsync(sql));

        }

        //Metodo POST: inserta un nuevo registro en la tabla Uusario
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createUser(Usuario user)
        {
           var connection = new SqlConnection(_config.GetConnectionString("connection"));
           var create = await connection.ExecuteAsync("INSERT INTO usuario (nombre_usuario,password,correo_electronico) VALUES ('"+user.nombre_usuario+"', '"+user.password+"', '"+user.correo_electronico+"' )");
           return create > 0; 
        }

        // Metodo PUT: actualiza un registro de la tabla Usuario
        [Route("update")]
        [HttpPut]
        public async Task<bool> updateUser(Usuario user)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = @"UPDATE usuario SET nombre_usuario ='" + user.nombre_usuario + "' , password='" + user.password + "', correo_electronico='" + user.correo_electronico + "' WHERE id = " + user.id + "";

            var update = await connection.ExecuteAsync(sql, new { user.nombre_usuario, user.password, user.correo_electronico });
            return update > 0;
        }
        
        // Metodo DELETE: elimina un registro de la tabla Usuario
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deleteUser(int id )
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = @"DELETE FROM usuario WHERE id = @Id";

            var delete = await connection.ExecuteAsync(sql, new { id });
            return delete > 0;
        }

    }

    

}
