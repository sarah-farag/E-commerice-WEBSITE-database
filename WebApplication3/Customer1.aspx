<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Customer1.aspx.cs" Inherits="WebApplication3.Customer1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
        <p>
        <asp:Button ID="ShowProducts"  runat="server" OnClick="ShowWebProduts" Text="view all products"  style="margin-left: 663px" />
        </p>
        <br />
        wishlistname
        <asp:TextBox ID="textbox_addtowishname" runat="server"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" OnClick="addAWishList" style="margin-left: 38px" Text="add a wishlist" Width="187px" />
        <p>
            Enter product serial_no:&nbsp;
            <asp:TextBox ID="textbox" runat="server" Width="109px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Enter Wishlist name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Enter Wishlist name:<asp:TextBox ID="TextBox3" runat="server" Width="119px"></asp:TextBox>
&nbsp;<asp:Button ID="Button2" runat="server" Height="21px" style="margin-left: 117px; margin-bottom: 0px;" Text="add a product to wish list" Width="159px" OnClick="add_a_product_to_wish_list" />
            <asp:Button ID="Button5" runat="server" Text="remove the product from the wish list" style="margin-left: 119px margin-bottom: 0px;" Height="28px" Width="234px"  OnClick="remove_a_product_to_wish_list"/>
        </p>
        <p>
            Enter Creditcard number:<asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
            Enter expirydate:
            <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
            (it sholud be in the following form &quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot; )&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Enter CVV<asp:TextBox ID="TextBox6" runat="server" ></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="Button3" runat="server" Text="add a credit card" OnClick="AddACreditCard" />
        </p>
        <p>
            Enter product serial_no :&nbsp;
            <asp:TextBox ID="TextBox7" runat="server" Width="109px"></asp:TextBox>
&nbsp;&nbsp;
            <asp:Button ID="Button4" runat="server" Text="add to cart"  OnClick="addToCart"/>
            <asp:Button ID="Button6" runat="server" Text="remove from cart" OnClick="remove_from_cart" />
        </p>
        <p>
            <asp:TextBox ID="mobile" runat="server"></asp:TextBox>
            <asp:Button ID="Button7" runat="server" Text="add a mobile number" OnClick="Button7_Click" />
        </p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="next" runat="server" OnClick="next2" Text="NEXT" Height="31px" Width="174px" />
        </p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
    </form>
</body>
</html>
