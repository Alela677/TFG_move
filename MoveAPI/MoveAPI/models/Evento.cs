namespace MoveAPI.Models
{
    public class Evento
    {
        public int id { get; set; }
        public string descripcion { get; set;}
        public int numero_participante { get; set;}
        public String fecha_evento { get; set; }
        public String ciudad { get; set; }
        public double longitud { get; set; }
        public double latitud { get; set; }
        public int idDeporte { get; set; }
        public int idPerfilUsuario { get; set; }


    }
}
