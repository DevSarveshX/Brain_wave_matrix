<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    String message = "";

    if(isPost) {
        String item_name = request.getParameter("item_name");
        String quantity = request.getParameter("quantity");
        String supplier = request.getParameter("supplier");
        String purchase_date = request.getParameter("purchase_date");
        String expiry_date = request.getParameter("expiry_date");
        String unit_price = request.getParameter("unit_price");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            String sql = "INSERT INTO Inventory (item_name, quantity, supplier, purchase_date, expiry_date, unit_price) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, item_name);
            ps.setInt(2, Integer.parseInt(quantity));
            ps.setString(3, supplier);
            ps.setDate(4, (purchase_date != null && !purchase_date.isEmpty()) ? Date.valueOf(purchase_date) : null);
            ps.setDate(5, (expiry_date != null && !expiry_date.isEmpty()) ? Date.valueOf(expiry_date) : null);
            ps.setBigDecimal(6, new java.math.BigDecimal(unit_price));

            int inserted = ps.executeUpdate();
            if(inserted > 0) {
                response.sendRedirect("Inventory.jsp");
                return;
            } else {
                message = "Failed to add inventory.";
            }
            ps.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Inventory</title>
    <style>
        body { margin:0; font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #d9f1ff, #f0fff4);}
        h2 { text-align:center; color:#0f8b8d; margin-top:20px;}
        form { width:60%; margin:20px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);}
        label { display:block; margin:10px 0 5px; }
        input[type="text"], input[type="date"] {
            width:100%; padding:8px; margin-bottom:10px; border:1px solid #ccc; border-radius:4px;
        }
        button { background-color:#0f8b8d; color:white; padding:10px 20px; border:none; border-radius:4px; font-size:16px;}
        button:hover { background-color:#136c72;}
        .message { text-align:center; color:red; margin-bottom:10px; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
<h2>Add Inventory Item</h2>
<% if(!message.isEmpty()) { %>
    <div class="message"><%= message %></div>
<% } %>
<form method="post">
    <label>Item Name:</label>
    <input type="text" name="item_name" required>

    <label>Quantity:</label>
    <input type="text" name="quantity" required>

    <label>Supplier:</label>
    <input type="text" name="supplier">

    <label>Purchase Date:</label>
    <input type="date" name="purchase_date">

    <label>Expiry Date:</label>
    <input type="date" name="expiry_date">

    <label>Unit Price (₹):</label>
    <input type="text" name="unit_price" required>

    <button type="submit">Add Inventory</button>
</form>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
