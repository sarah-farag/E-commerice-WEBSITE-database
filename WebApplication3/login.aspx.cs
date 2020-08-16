using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class login : System.Web.UI.Page
    {

        protected void loginn(object sender, EventArgs e)
        {
           
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            SqlConnection conn = new SqlConnection(connStr);

           
            SqlCommand cmd = new SqlCommand("userLogin", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username = text_user_name.Text;
            string password = text_password.Text;

          
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));

           
            SqlParameter success = cmd.Parameters.Add("@success", SqlDbType.Bit);
            SqlParameter type = cmd.Parameters.Add("@type", SqlDbType.Int);

            success.Direction = ParameterDirection.Output;
            type.Direction = ParameterDirection.Output;

            conn.Open();

            cmd.ExecuteNonQuery();
            conn.Close();

           // Response.Write(success.Value.ToString());


            if (success.Value.ToString().Equals("True"))
            {
                Response.Write("I'm here");

                if (type.Value.ToString().Equals("0"))
                {
                    Response.Write("Passed");

                  
                    Session["username"] = username;
              
                    Response.Redirect("Customer1.aspx", true);
                }
                else if (type.Value.ToString().Equals("1"))
                {
                    Response.Write("Passed");
                    Session["username"] = username;
                    Response.Redirect("vendor.aspx", true);
                }
            }
            else
            {
                Response.Write("please enter a valid username and password");
            }


        }
    }
}