package com.miniERP.servlet;

import com.company1.DBManager;
import com.company1.dao.ProductDAO;
import com.erp.model.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listProducts(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "edit":
                    editProductForm(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertProduct(request, response);
            } else if ("update".equals(action)) {
                updateProduct(request, response);
            } else {
                doGet(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Product> productList = productDAO.getAllProducts();
        request.setAttribute("productList", productList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("product_list.jsp");
        dispatcher.forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String pname = request.getParameter("pname");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Product newProduct = new Product();
        newProduct.setPname(pname);
        newProduct.setPrice(price);
        newProduct.setStock(stock);
        productDAO.addProduct(newProduct);
        response.sendRedirect("ProductServlet?action=list");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int pid = Integer.parseInt(request.getParameter("pid"));
        productDAO.deleteProduct(pid);
        response.sendRedirect("ProductServlet?action=list");
    }

    private void editProductForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int pid = Integer.parseInt(request.getParameter("pid"));
        Product existingProduct = productDAO.getProductById(pid);
        RequestDispatcher dispatcher = request.getRequestDispatcher("product_edit.jsp");
        request.setAttribute("product", existingProduct);
        dispatcher.forward(request, response);
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int pid = Integer.parseInt(request.getParameter("pid"));
        String pname = request.getParameter("pname");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Product product = new Product();
        product.setPid(pid);
        product.setPname(pname);
        product.setPrice(price);
        product.setStock(stock);
        productDAO.updateProduct(product);
        response.sendRedirect("ProductServlet?action=list");
    }
}
