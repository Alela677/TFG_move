using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic.FileIO;
using MoveAPI.Models;
using MoveAPI.Utils;
using System.Data.SqlClient;

namespace MoveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImagenesController : ControllerBase
    {

        private readonly IConfiguration _config;
        private readonly IWebHostEnvironment _enviroment;
        
        public ImagenesController(IConfiguration config,IWebHostEnvironment environment)
        {
            _config = config;
            _enviroment = environment;
           
        }


        //Metodo GET: vevuelve un fichero con una imagen del fichero imgusuarios a partir de su nombre
        [Route("viewimage/{imagename}")]
        [HttpGet]
        public Task<ActionResult> viewImages([FromRoute] string imagename)
        {   
            //Creamos ruta para guarda el fichero
            var path = "wwwroot\\Imagenes\\imgusuarios\\";
            var filePath = Path.Combine(path, imagename);
            Console.WriteLine(filePath);
            
            //Si existe la ruta devolvemos el fichero
            if (System.IO.File.Exists(filePath))
            {
                Console.WriteLine("Existe");
                byte[] imageByte = System.IO.File.ReadAllBytes(filePath);
                return Task.FromResult<ActionResult>(File(imageByte , "image/jpg"));
            }
            Console.WriteLine(" No Existe");
            return Task.FromResult<ActionResult>(Ok(null));
        }

        //Metodo GET: devulve un registo de la tabla imagenes a partir de un id de perfil
        [Route("userimages/{id:int}", Order = 0)]
        [HttpGet]
        public async Task<IActionResult> getImagenIdUser(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM imagenes WHERE idPerfilU = "+id+"";

            return Ok(await connection.QueryAsync(sql));
        }

        //Metodo GET: devulve un registo de la tabla imagenes a partir de su id
        [HttpGet("{id:int}", Order = 1)]
        public async Task<IActionResult> getImagenId(int id)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "SELECT * FROM imagenes WHERE id = @Id";

            return Ok(await connection.QueryAsync(sql, new { id }));
        }

       
        //Metodo POST: inserta un nuevo registro en la tabla Imagenes
        // antes de añadir el registro recogemos el fichero que se nos pasa a por formulario 
        // y guardamos el fichero en la ruta indicada
        [Route("insert")]
        [HttpPost]
        public async Task<string> insertImagenes([FromForm]Imagenes imagen) 
        {
                //Comprobamos si el formulario contiene imagen
            if (imagen.imagen.Length > 0)
            {
                //Indicamos la ruta y nombramos el fichero 
                var nombreFicehro = imagen.idPerfilU + Guid.NewGuid().ToString() + ".jpg";
                var ruta = "wwwroot\\Imagenes\\imgusuarios\\";
                    //Si existe el fichero leemos los bytes y creamos un nuevo fichero con la imagen
                if (!Directory.Exists(ruta)) { 
                    //Si no esxite creamos el directorio
                    Directory.CreateDirectory(ruta);
                }
                await using (FileStream stream = System.IO.File.Create(ruta + nombreFicehro))
                {
                    await imagen.imagen.CopyToAsync(stream);
                    stream.Flush();

                    var url = "http://apimove.somee.com/api/Imagenes/viewimage/";
                    //Añadimos el registro a la tabla, el nombre de imagen estara compuesto por la url
                    //que ejucatara el metodo que devulve la imagen y su nombre
                    
                    añadirImgen(imagen.idPerfilU,url+nombreFicehro);
                    return "EXITO";
                }

            }
            else
            {
                return "ERROR";
            }
        }
        //Metodo PUT: acatualiza un registro de la tabla Imagenes por su id
        [Route("update")]
        [HttpPut]
        public async Task<bool> updateImagen([FromBody]Imagenes imagen)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "UPDATE imagenes SET imagen = @Imagen, idPerfilU = @IdPerfilU  WHERE id = @Id ";

            var update = await connection.ExecuteAsync(sql, new { imagen.imagen, imagen.idPerfilU, imagen.id });

            return update > 0;
        }

        //Metodo DELETE: eliminar un registro de la tabla Imagenes por su id
        [Route("delete/{id:int}")]
        [HttpDelete]
        public async Task<bool> deleteImagen(int id)
        {   

            UtilsImagenes utils = new UtilsImagenes();
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            //Buscamos el nombre del fichero en la base de datos y eliminamos el fichero de su directorio
            String file = utils.buscarImageneEliminadaPerfil(connection,id);
            utils.eliminarImagenPerfil(file,"imgusuarios");
            //Eliminamos el registro en base de datos
            var sql = "DELETE FROM imagenes WHERE id = @Id";
            var delete = await connection.ExecuteAsync(sql, new { id });
            return delete > 0;
        }

        //Metodo que inserta el registro el la tabla Imagenes en el metodo 'insertImagenes'
        private async void añadirImgen(int idUsuario, String path)
        {
            var connection = new SqlConnection(_config.GetConnectionString("connection"));
            var sql = "INSERT INTO imagenes(imagen, idPerfilU) VALUES('" + path + "', " + idUsuario + ")";
            await connection.ExecuteAsync(sql);

        }

    }
}
