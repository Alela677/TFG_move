using System.Data.SqlClient;

namespace MoveAPI.Utils
{
    public  class UtilsImagenes
    {
        //Metodo que busca la imagen de perfil en la tabla imagenperfil segun el id de perfil
        public String buscarImagenPerfil(SqlConnection conexion, int idPerfil) {
            String? nombreFile = null;
            var sql = "SELECT imagen FROM imagenperfil WHERE idPerfil = "+idPerfil+"";
            SqlCommand comando = new SqlCommand(sql, conexion);
            conexion.Open();
            SqlDataReader reader = comando.ExecuteReader();
                
            while (reader.Read())
                {
                    nombreFile = reader.GetString(0).Split("/").Last();
                }
            
            reader.Close();
            conexion.Close();
            return nombreFile;
        }
        //Metodo que eliminar las imagenes indicadas con la ruta y el nombre del fichero que pasamos como parametros
        public void eliminarImagenPerfil(String nombreFile, String fichero) 
        {
           
            try {
                var ruta = "wwwroot\\Imagenes\\"+fichero+"\\"+nombreFile+"";
                Console.WriteLine("Existe");
                File.Delete(ruta);
            } catch (Exception e) 
            {
                Console.WriteLine(e);
            }
               
            
        }
        //Metodo que busca el nombre de una imagenen en la tabla imagenes segun el su id  
        public String buscarImageneEliminadaPerfil(SqlConnection conexion, int idImagen)
        {
            String? nombreFile = null;
            var sql = "SELECT imagen FROM imagenes WHERE id = " + idImagen + "";
            SqlCommand comando = new SqlCommand(sql, conexion);
            conexion.Open();
            SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                nombreFile = reader.GetString(0).Split("/").Last();
            }
            reader.Close();
            conexion.Close();
            return nombreFile;
        }

        //Metodo que busca todos los nombres de las imagenes de un perfil y devuelve una lista con todos ellos
        public List<String> getAllImagenesPerfilEliminado(SqlConnection conexion,int idPerfil) 
        {
            List<String> imagenes = new List<String>(); 

            var sql = "SELECT imagen FROM imagenes WHERE idPerfilU = "+idPerfil+"";
            
            SqlCommand comando = new SqlCommand(sql,conexion);
            conexion.Open();
            SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                String file = reader.GetString(0).Split("/").Last();
                imagenes.Add(file);
            }
            reader.Close();
            conexion.Close();

            return imagenes;

        }
    }
}
