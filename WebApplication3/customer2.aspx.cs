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
    public partial class customer2 : System.Web.UI.Page
    {

        protected void make_order_Click(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/


            SqlCommand cmd = new SqlCommand("makeOrder", conn);

            cmd.CommandType = CommandType.StoredProcedure;

            string username = (string)(Session["username"]);

            Response.Write("                                                                  Welcome" + username+" " );

            cmd.Parameters.Add(new SqlParameter("@customername", username));

            SqlParameter total = cmd.Parameters.Add("@total_amount", SqlDbType.Decimal);
            SqlParameter order = cmd.Parameters.Add("@order_number", SqlDbType.Int);

            total.Direction = ParameterDirection.Output;
            order.Direction = ParameterDirection.Output;


            conn.Open();

            cmd.ExecuteNonQuery();
            string sql2 = "SELECT max(order_no) FROM Orders";
          SqlCommand sql3 = new SqlCommand(sql2,conn);
            int orderid = Convert.ToInt32(sql3.ExecuteScalar().ToString());
            string sql4 = "SELECT total_amount FROM Orders where Orders.order_no=(SELECT max(order_no) FROM Orders)";
            SqlCommand sql5 = new SqlCommand(sql4, conn);
            decimal total_amount = Convert.ToDecimal(sql5.ExecuteScalar().ToString());
            // SqlCommand  sql = new SqlCommand("SELECT max(order_no) FROM orders",conn);
            // int orderid = sql.ExecuteNonQuery();
            //    int sql2 = int.Parse(sql);
            //    Session["orderid"] = sql;
            //            Response.Redirect("specify2.aspx", true);
         
            Response.Write(username + "your last order number is " +orderid+ " and the total amount is "+total_amount);
            conn.Close();



        }

        protected void cancelorder(object sender, EventArgs e)
        {


            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/


            SqlCommand cmd = new SqlCommand("cancelOrder", conn);

            cmd.CommandType = CommandType.StoredProcedure;

            //To read the input from the user
            string orderid = txtbox_orderid.Text;
            int orderid2 = int.Parse(orderid);
            cmd.Parameters.Add(new SqlParameter("@orderid", orderid2));
            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                Response.Write("success, order is cancelled ");

            }
            catch (Exception ex)
            {
                Response.Write("please give a valid order Id");
            }

            }

            protected void credit(object sender, EventArgs e)
            {

                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

                //create a new connection
                SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/

            //    int orderid = (int)(Session["orderid"]);
            string order_no = TextBox2.Text;
            int order_no2 = int.Parse(order_no);
              //  Response.Write("your order id is" + order_no);
                SqlCommand cmd = new SqlCommand("ChooseCreditCard", conn);
                cmd.CommandType = CommandType.StoredProcedure;


                string creditcard = creditcardnum.Text;
                cmd.Parameters.Add(new SqlParameter("@orderid", order_no2));
                cmd.Parameters.Add(new SqlParameter("@creditcard", creditcard));

            conn.Open();
            try
            {

                cmd.ExecuteNonQuery();
                Response.Write("A card is chosen ");
            }
            catch (Exception ex)
            {
                Response.Write("please , enter a correct card number ");
            }
            conn.Close();


        }



        protected void specify(object sender, EventArgs e)
            {
                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

                //create a new connection
                SqlConnection conn = new SqlConnection(connStr);

                /*create a new SQL command which takes as parameters the name of the stored procedure and
                 the SQLconnection name*/


                SqlCommand cmd = new SqlCommand("SpecifyAmount", conn);

                cmd.CommandType = CommandType.StoredProcedure;

                string username = (string)(Session["username"]);
                int orderid2 = int.Parse(TextBox1.Text);
            //int orderid =(int) Session["orderid"];
           // Response.Write("hi1");
                decimal cash2 = decimal.Parse(cash_amount.Text);
            // Response.Write(cash);
            //Response.Write(orderid2);
         //   Response.Write("hi2");

            decimal credit2 = decimal.Parse(credit_card_amount.Text);

            //  Response.Write(credit);

          

                cmd.Parameters.Add(new SqlParameter("@customername", username));
                cmd.Parameters.Add(new SqlParameter("@orderID", orderid2));
                cmd.Parameters.Add(new SqlParameter("@cash", cash2));
                cmd.Parameters.Add(new SqlParameter("@credit", credit2));

                conn.Open();
            try
            {

                cmd.ExecuteNonQuery();
                Response.Write("amount is spescified successfully ");
            }
            catch(Exception ex)
            {
                Response.Write("add valid numbers ");
            }
            conn.Close();

            }



        }
    }
