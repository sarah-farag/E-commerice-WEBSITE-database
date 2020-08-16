using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
namespace WebApplication3
{
    public partial class Customer1 : System.Web.UI.Page
    {
        protected void ShowWebProduts(object sender, EventArgs e)
        {

            Response.Redirect("view_products.aspx", true);

        }


        protected void addAWishList(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("createWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            string list_name = textbox_addtowishname.Text;

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@name", list_name));
            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("list created successfuly  ");

            }
            catch (Exception ex) {
                Response.Write("faild, please enter valid wishList name  ");


            };
            conn.Close();

        }


        protected void add_a_product_to_wish_list(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("AddtoWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            string list_name = TextBox3.Text;
            int serial_no = int.Parse(textbox.Text);
            Response.Write(serial_no);
            Response.Write(list_name);


            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@wishlistname", list_name));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("product added successfuly  ");

            }
            catch(Exception ex) { Response.Write("add a valid wishList name and a product serial number"); };
            conn.Close();


        }

        protected void remove_a_product_to_wish_list(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("removefromWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            string list_name = TextBox3.Text;
            int serial_no = int.Parse(textbox.Text);

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@wishlistname", list_name));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("product removed successfuly  ");

            }
            catch (Exception ex) { Response.Write("please, add a valid wishList name and a product serial number"); };
            conn.Close();

        }

        protected void addToCart(object sender, EventArgs e) //@customername varchar(20), @serial int
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("addToCart", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            int serial_no = int.Parse(TextBox7.Text);

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("product added sucessfuly  ");

            }
            catch (Exception ex) { Response.Write("please, add a valid product serial number"); };
            conn.Close();

        }

       

        protected void remove_from_cart(object sender, EventArgs e)
        {
            String connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("removefromCart", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            int serial_no = int.Parse(TextBox7.Text);

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("product removed sucessfuly  ");

            }
            catch (Exception ex) { Response.Write("please, add a valid product serial number"); };
            conn.Close();
        }


        protected void AddACreditCard(object sender, EventArgs e)//@creditcardnumber  @expirydate @cvv  @customername
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("AddCreditCard", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string username = (string)(Session["username"]);
            string creditcardnumber = TextBox4.Text;
            String date = TextBox5.Text;
            String cvv = TextBox6.Text;

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@creditcardnumber", creditcardnumber));
            cmd.Parameters.Add(new SqlParameter("@date", date));
            cmd.Parameters.Add(new SqlParameter("@cvv", cvv));


            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write(" card added successfully ");

            }
            catch (Exception ex)
            {
                Response.Write(" faild, please add valid info");
            };
            conn.Close();

        }

        

        protected void next2(object sender, EventArgs e)
        {
            Response.Redirect("customer2.aspx", true);
        }

        protected void Button7_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("addMobile", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string username = (string)(Session["username"]);
            string mob = mobile.Text;
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@mobile_number",mob));
            conn.Open();
                try{
                cmd.ExecuteNonQuery();
                Response.Write("phone added correctly");
            }
                catch(Exception ex)
            {
                Response.Write("phone have not been added correctly");
            };
            conn.Close();
            //To read the input from the user
            
        }
    }
    }