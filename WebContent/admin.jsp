<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %> <%-- checks that user is logged in before accessing page --%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>

<head>
    <title>Administrator Page</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

    <h1>Administrator Sales Report by Day</h1>

    <table>
        <tr>
            <th>Order Date</th>
            <th>Total Order Amount</th>
        </tr>

        <%
            //query orderSummary table
            String sql = "SELECT CAST(orderDate AS DATE) AS dateOnly, SUM(totalAmount) AS summedTotalAmount "
                       + "FROM OrderSummary "
                       + "GROUP BY CAST(orderDate AS DATE)";

            getConnection();
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery(sql);

            //Set up formatters
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance();
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd LLL yyyy"); //eg 03 January 2024

            //Process queried data
            while(rst.next()) {
                //get the data
                java.sql.Date sqlOrderDate = rst.getDate("dateOnly");
                double summedTotalAmount = rst.getDouble("summedTotalAmount");
                
                //format the data
                LocalDate orderDate = sqlOrderDate.toLocalDate();
                String formattedDate = dateFormatter.format(orderDate);
                String formattedAmount = currencyFormatter.format(summedTotalAmount);

                //print the data
                String tableRow = String.format(
                    "<tr> <td>%s</td> <td>%s</td> </tr>",
                    formattedDate,
                    formattedAmount
                );

                out.println(tableRow);
            }

            
        %>

    </table>

    <h1>List of All Customers</h1>

    <table>
        <tr>
            <th>Customer ID</th>
            <th>Customer Information</th>
        </tr>

        <% 
            // setup the query and connection
            String customerquery = "SELECT * FROM customer";
            getConnection();
            Statement stmt2 = con.createStatement();
            ResultSet rsts = stmt2.executeQuery(customerquery);

            while(rsts.next()) {
                int customerID = rsts.getInt("customerId");
                String fname = rsts.getString("firstName");
                String lname = rsts.getString("lastName");
                String fullname = fname + " " + lname;
                String email = rsts.getString("email");
                String phonenum = rsts.getString("phonenum");
                String country = rsts.getString("country");

                String innerTable = String.format("<table> <tr><td>%s</td></tr> <tr><td>%s</td></tr> <tr><td>%s</td></tr> <tr><td>%s</td></tr> </table>", fullname, email, phonenum, country);

                out.println(String.format("<tr> <td>%d</td> <td>%s</td> </tr>", customerID, innerTable));


            }
            closeConnection();
        %>
    </table>







    <p><a href="index.jsp">Back to home page.</a></p>

</body>
</html>

<style>
table, th, td {
    text-align: center;
    border: 1px solid black;
    border-collapse: collapse;
    padding:5px
}

</style>

