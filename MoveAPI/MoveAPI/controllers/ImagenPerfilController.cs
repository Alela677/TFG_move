using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MoveAPI.Models;
using MoveAPI.Utils;
using System.Data.SqlClient;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public  class ImagenPerfilController : ControllerBase  
    {   
        //Atributo de solo lectura
        private readonly IConfiguration _config;
        
        public ImagenPerfilController(IConfiguration config) {

            _config = config;
        }


        //Metodo POST: inseta un neuvo registro en la tabla Imagenperfil 
        [Route("insert")]
        [HttpPost]
        public async Task<string> insertImgPerfil([FromForm] ImagenPerfil imagen) {

            //Comprabamos que la viene una imagenen en el forulario
            if (imagen.imagen.Length > 0)
            {
                //Indicamos la ruta y nombremos el fichero
                var nombreFicehro =  imagen.idPerfil + Guid.NewGuid().ToString() + ".jpg";
                var ruta = "wwwroot\\Imagenes\\imgperfil\\";
                //Si e fichero existe leemos los bytes y lo copiamos en un fichero nuevo dentro del directorio
                if (!Directory.Exists(ruta))
                {   
                    //Si no existe lo creamos
                    Directory.CreateDirectory(ruta);
                }
                await using (FileStream stream = System.IO.File.Create(ruta + nombreFicehro))
                {
                    await imagen.imagen.CopyToAsync(stream);
                    stream.Flush();

                    var url = "http://apimove.somee.com/api/ImagenPerfil/viewimage/";
                    var img = url + nombreFicehro;
                    //Insertamos el registro en base de datos
                    var connection = new SqlConnection(_config.GetConnectionString("connection"));
                    var sql = "INSERT INTO imagenperfil (imagen , idPerfil) VALUES ('" + img + "'," + imagen.idPerfil + ")";
                    await connection.ExecuteAsync(sql);
                    return "EXITO";
                }
            }
            else
            {
                return "ERROR";
            }
        }

        //Metodo DELETE: elimina un registro de la base de datos
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deleteImagen(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));

            UtilsImagenes utils = new UtilsImagenes();
            String file = utils.buscarImagenPerfil(connection,id);
            Console.WriteLine(file);
            utils.eliminarImagenPerfil(file,"imgperfil");

            var sql = "DELETE FROM imagenperfil WHERE idPerfil = " + id + "";
            var delete = await connection.ExecuteAsync(sql);
            return true;
        }

        //Metodo GET: devulve in registro de la tabla imagenPerfil 
        [Route("idPerfil/{id:int}")]
        [HttpGet]
        public async Task<IActionResult> getImagenIdPerfil(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM imagenperfil WHERE idPerfil = @Id";

            return Ok(await connection.QueryAsync(sql,new { id }));
        }



        //Metodo GET: devueve un fichero con la imagen de perfil
        [Route("viewimage/{imagename}")]
        [HttpGet]
        public async Task<ActionResult> viewImages([FromRoute] string imagename)
        {   
            //Indicamos la ruta 
            var path = "wwwroot\\Imagenes\\imgperfil\\";
            var filePath = Path.Combine(path, imagename);
            Console.WriteLine(filePath);
            //Si el fichero existe leemos los bytes y pasamos el fichero
            if (System.IO.File.Exists(filePath))
            {
                Console.WriteLine("Existe");
                byte[] imageByte = System.IO.File.ReadAllBytes(filePath);
                return (File(imageByte, "image/jpg"));
            }
            Console.WriteLine(" No Existe");
            return Ok(null);
        }

     }
}
