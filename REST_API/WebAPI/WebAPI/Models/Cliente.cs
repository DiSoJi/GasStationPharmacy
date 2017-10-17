using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace WebAPI.Models
{
    public class Cliente
    {
        string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";//Valores de conexion de la DB

        public Cliente() {}
        /**
         * Inserta un nuevo cliente en la base de datos en la tabla CLIENTE
         * Entrdas: JObjecta temp_data (JSOn con toda la informacion necesaria para una insercion correcta)
         * Salida: JObject resultado (JSON con los resultados de la insercion, exito o error)
         * **/
        public JObject Insert(JObject temp_data) {
            dynamic data = temp_data;
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);//Se conecta con la base especificada en el string dataBase
                dbConexion.Open();//Abre la conexion
                SqlCommand Comando = new SqlCommand(string.Format(//Formato de comando para realizar un INSERT
                    "Insert Into CLIENTE (Cedula, FNacimiento, Contraseña, Nombre1, Nombre2, Apellido1, Apellido2, Provincia, Canton," +
                    "Distrito, Indicaciones, Telefono, Activo) values ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}')",
                    (int)data.cedula, (string)data.fNacimiento, (string)data.contraseña, (string)data.nombre1, (string)data.nombre2, (string)data.apellido1, (string)data.apellido2,
                    (string)data.provincia, (string)data.canton, (string)data.distrito, (string)data.indicaciones, (int)data.telefono, 1), dbConexion);
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp > 0)
                {
                    resultado.Add("descripcion", "Inserción Exitosa");
                    resultado.Add("codigo", 200);
                }
                else
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);
                }
            }
            catch (Exception ex) {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }
        /**
         * Selecciona la informacion de un cliente de la basde de datos, se utiliza para validar el login
         * 
         * **/
        public JObject SelectCliente(int user, string pass) {
            JObject resultado = new JObject();
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            //FOR JSON AUTO hace que SQL devuelva un JSON con la informacion del select
            var sqlResult = string.Format("Select Cedula, Nombre1, Nombre2, Apellido1, Apellido2, Provincia, Canton, Distrito, Indicaciones, Telefono, FNacimiento " +
                "From CLIENTE Where Cedula='{0}' and Contraseña='{1}' and Activo=1 FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER",user,pass);//Formato de comando para realizar un SELECT
            SqlCommand Comando = new SqlCommand(sqlResult, dbConexion);
            var jsonResult = new StringBuilder();
            //Comando almacena el JSON que devolvio la base de datos
            //.ExecuteReader() permite obtener el contenido de la variable Comando
            SqlDataReader reader = Comando.ExecuteReader();
            if (!reader.HasRows)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            else {
                //Se construye un string con los valores del JSON dentro de Comando 
                //Luego el string es parseado a JSON por medio de un JObject 
                //El JObject ya se puede manejar con normalidad
                while (reader.Read())
                {
                    jsonResult.Append(reader.GetValue(0).ToString());
                }
                resultado = JObject.Parse(jsonResult.ToString());
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
                resultado.Add("tipo", "Cliente");
            }    
            dbConexion.Close();
            reader.Close();
            return resultado;
        }
        /**
         * Cambia el atributo Activo del cliente indicado por medio de su numero de cedula
         * Se utiliza un Stored Procedure a nivel de DB que niega el estado actual, ejemplo si el CLIENTE esta activo lo desactiva,
         * pero si se encuentra desactivado lo vuelve a activar
         * La funcion es generar una Pseudo eliminacion solo desactivando el cliente pero manteniendo el registro
         * **/
        public Object ChangeStateCliente(int user)
        {
            JObject resultado = new JObject();
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand("UpdateCLIENTE_Activo", dbConexion);//LLama un Stored Procedur
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@Cedula", SqlDbType.Int).Value = user;
            int temp = Comando.ExecuteNonQuery();
            if (temp > 0)
            {
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
            }
            else
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }

        public JObject UpdateCliente(JObject x) {
            JObject resultado = new JObject();
            dynamic data = x;
            try {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand(string.Format(//Formato de comando para realizar un INSERT
                    "Update CLIENTE Set Cedula={0}, FNacimiento='{1}', Contraseña='{2}', Nombre1='{3}', Nombre2='{4}', Apellido1='{5}', Apellido2='{6}', Provincia='{7}', Canton='{8}'," +
                    "Distrito='{9}', Indicaciones='{10}', Telefono='{11}', Activo=1 WHERE Cedula={0}",
                    (int)data.cedula, (string)data.fNacimiento, (string)data.contraseña, (string)data.nombre1, (string)data.nombre2, (string)data.apellido1, (string)data.apellido2,
                    (string)data.provincia, (string)data.canton, (string)data.distrito, (string)data.indicaciones, (int)data.telefono), dbConexion);
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp > 0)
                {
                    resultado.Add("descripcion", "Actualizacion Exitosa");
                    resultado.Add("codigo", 200);
                }
                else
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);
                }
            }
            catch (Exception ex)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }


        public JObject TodoClientes(string comp)
        {
            JArray clientes = new JArray();
            JObject resultado;
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand("Select_TodoClientes", dbConexion);
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@NombreCompañia", SqlDbType.VarChar).Value = comp;
            var jsonResult = new StringBuilder();
            //Comando almacena el JSON que devolvio la base de datos
            //.ExecuteReader() permite obtener el contenido de la variable Comando
            SqlDataReader reader = Comando.ExecuteReader();
            if (!reader.HasRows)
            {
                resultado = new JObject(
                    new JProperty("codigo", 201),
                    new JProperty("descripcion", "Error")
                );

            }
            else
            {
                //Se construye un string con los valores del JSON dentro de Comando 
                //Luego el string es parseado a JSON por medio de un JObject 
                //El JObject ya se puede manejar con normalidad
                while (reader.Read())
                {
                    jsonResult.Append(reader.GetValue(0).ToString());
                }
                clientes = JArray.Parse(jsonResult.ToString());

                int count = 0;
                int tempCed = (int)clientes[0]["Cedula"];
                JArray clientesFinales = new JArray();
                var padecimientos = new List<string>();
                var fechapadecimientos = new List<string>();
                JObject tempJson = new JObject();
                dynamic myArray1;
                dynamic myArray2;
                /*
                 * La base de datos retorna tantos clientes como padecimientos tenga (toda la informacion repetida exepto por los datos del padecimiento)
                 * Mediante este metodo se reagrupan todos los padecimientos de un mismo cliente y se envia un solo JSON por cada cliente con toda su informacion
                 * */
                foreach (JObject content in clientes.Children<JObject>())//For por cada JSON contenido en clientes(JArray)
                {
                    if (tempCed == (int)content["Cedula"]) //comprueba que el cliente siguiente es igual al anterior
                    {
                        tempCed = (int)content["Cedula"];
                        padecimientos.Add((string)content["Descripcion"]);//Guarda la descripcion del padecimento 
                        fechapadecimientos.Add((string)content["FechaPadecimiento"]);//Guarda la fecha del padecimiento 
                    }
                    else { //Si el cliente que sigue no es igual, se debe guardar la informacion obtenida del cliente anterior(optimizar)
                        tempJson = (JObject)clientes[count]; //se toma el JSON contonedor del cliente a optimizar
                        tempJson.Remove("Descripcion");//Se elimina el atributo Descripcion
                        tempJson.Remove("FechaPadecimiento");//Se elimina el atributo FechaPadecimeinto
                        myArray1 = padecimientos.ToArray(); //Se pasa la lista a un array
                        myArray2 = fechapadecimientos.ToArray();//Se pasa la lista a un array
                        tempJson.Add("Padecimientos", JToken.FromObject(myArray1));//Se agrega el nuevo parametro 
                        tempJson.Add("FechaPadecimiento", JToken.FromObject(myArray2));//Se agrega el nuevo parametro 
                        clientesFinales.Add(tempJson);//Se agrega el nuevo cliente(Json) a la lista de clientes optimizada
                        padecimientos.Clear();//Se borra el contenido de la lista
                        fechapadecimientos.Clear();
                        tempCed = (int)content["Cedula"];
                        padecimientos.Add((string)content["Descripcion"]);//Se optienen los datos del nuevo cliente a optimizar
                        fechapadecimientos.Add((string)content["FechaPadecimiento"]);
                    }
                    count++;//cntador para saber cual JSON se debe modificar 
                   
                }
                //Para el ultimo cliente el proceso se realiza aqui
                tempJson = (JObject)clientes[count-1];
                tempJson.Remove("Descripcion");
                tempJson.Remove("FechaPadecimiento");
                myArray1 = padecimientos.ToArray();
                myArray2 = fechapadecimientos.ToArray();
                tempJson.Add("Padecimientos", JToken.FromObject(myArray1));
                tempJson.Add("FechaPadecimiento", JToken.FromObject(myArray2));
                clientesFinales.Add(tempJson);
                resultado = new JObject(
                    new JProperty("Clientes", clientesFinales),
                    new JProperty("codigo", 200),
                    new JProperty("descripcion", "Exito")
                );

              
            }
            dbConexion.Close();
            reader.Close();
            
            return resultado;

        }


    }
}