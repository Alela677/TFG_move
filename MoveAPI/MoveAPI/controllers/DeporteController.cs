using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using System.Data.SqlClient;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DeporteController : ControllerBase
    {
        //Propiedad de solo lectura
        private readonly IConfiguration _config;

        public DeporteController(IConfiguration config)
        {
            _config = config;
        }

        //Metodo POST: crear un resgistro en la tabla Deporte
        [Route("insert")]
        [HttpPost]
        public async Task<bool> createDeporte([FromBody] Deporte deporte)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO deporte (nombre, imagen) VALUES ('"+deporte.nombre+"','"+deporte.imagen+"')";

            var create = await connection.ExecuteAsync(sql);
            return create > 0;
        
        }

        //Metodo GET: metodo que devuelve un fichero con la imagen asignada al deporte a partir de su nombre
        [Route("viewimage/{imagename}")]
        [HttpGet]
        public async Task<ActionResult> viewImages([FromRoute] string imagename)
        {
            var path = "wwwroot\\Imagenes\\imgdeportes\\";
            var filePath = Path.Combine(path, imagename);
            Console.WriteLine(filePath);

            if (System.IO.File.Exists(filePath))
            {
                Console.WriteLine("Existe");
                byte[] imageByte = System.IO.File.ReadAllBytes(filePath);
                return (File(imageByte, "image/jpg"));
            }
            return Ok(null);
        }

        //Metodo GET: devuelve una lista de objetos Deporte en formato JSON con todos los registros de la tabla
        //Deporte
        [HttpGet]
        public async Task<ActionResult<List<Deporte>>> getDeporte()
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM deporte";
            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET: devuelve un registro en formato JSON de un Deporte segun su id
        [HttpGet("{id:int}")]
        public async Task<IActionResult> getDeporteId(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM deporte WHERE id =@Id";
            return Ok(await connection.QuerySingleAsync(sql,new { id }));
        }

        //Metodo PUT: metodo que actualiza un registro de la tabla Deporte
        [Route("update")]
        [HttpPut]
        public async Task<bool> updateDeporte([FromBody]Deporte deporte)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "UPDATE deporte SET nombre = @Nombre, imagen= @Imagen WHERE id = @Id";
            var update = await connection.ExecuteAsync(sql,new {deporte.nombre , deporte.imagen, deporte.id});
            return update > 0;
        }

        //Metodo DELETE: elimina un registro de la tabla Deporte a partir de su id 
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deleteDeporte(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "DELETE FROM deporte WHERE id = @Id";
            var delete = await connection.ExecuteAsync(sql, new { id });
            return  delete > 0;
        }
    }
}
