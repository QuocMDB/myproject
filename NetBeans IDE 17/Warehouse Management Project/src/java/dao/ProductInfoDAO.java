package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBContext.Context;
import model.CategoryProduct;
import model.ProductInfo;
import model.ProductStock;
import model.Supplier;
import model.Unit;

public class ProductInfoDAO {
  
  // Tham số cho các cột 
  private static final String COL_ID = "id";
  private static final String COL_NAME = "name";
  private static final String COL_CODE = "code";
  private static final String COL_CATE_ID = "cate_id";
  private static final String COL_UNIT_ID = "unit_id";
  private static final String COL_STATUS = "status";
  private static final String COL_DESCRIPTION = "description";

  /**
   * Get all active products with basic information
   * @return List of ProductInfo objects
   */
  //Lấy tất cả product 
  public List<ProductInfo> getAllProducts() {
      List<ProductInfo> list = new ArrayList<>();
      String sql = "SELECT id, name, code, cate_id, unit_id, status, description, min_stock_threshold FROM product_info WHERE status != 'deleted'";

      try (
              Connection con = Context.getJDBCConnection(); 
              PreparedStatement stmt = con.prepareStatement(sql); 
              ResultSet rs = stmt.executeQuery();) {
          while (rs.next()) {
              ProductInfo p = new ProductInfo();
              p.setId(rs.getInt(COL_ID));
              p.setName(rs.getString(COL_NAME));
              p.setCode(rs.getString(COL_CODE));
              p.setCate_id(rs.getInt(COL_CATE_ID));
              p.setUnit_id(rs.getInt(COL_UNIT_ID));
              p.setStatus(rs.getString(COL_STATUS));
              p.setDescription(rs.getString(COL_DESCRIPTION));
              p.setMinStockThreshold(rs.getBigDecimal("min_stock_threshold"));
              list.add(p);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }

      return list;
  }

  /**
   * Get product name by ID
   * @param productId The ID of the product
   * @return Product name as String
   */
  //Lấy product dựa trên id
  public String getProductNameById(int productId) {
      String sql = "SELECT name FROM product_info WHERE id = ?";
      try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

          stmt.setInt(1, productId);
          ResultSet rs = stmt.executeQuery();

          if (rs.next()) {
              return rs.getString("name");
          }

      } catch (SQLException e) {
          e.printStackTrace();
      }
      return "";
  }

  /**
   * Get products with stock information, pagination and search
   * @param page Page number
   * @param pageSize Number of products per page
   * @param search Search term
   * @param sortBy Column to sort by
   * @param sortOrder Sort order (ASC/DESC)
   * @return List of ProductStock objects
   */
  //Lấy product dựa trên số lượng trong kho
  public List<ProductStock> getProductsWithStock(int page, int pageSize, String search, String sortBy, String sortOrder) {
      List<ProductStock> list = new ArrayList<>();
      StringBuilder sql = new StringBuilder();
      sql.append("SELECT p.id, p.name, p.code, p.cate_id, p.unit_id, p.status, p.description, ");
      sql.append("p.min_stock_threshold, ");
      sql.append("COALESCE(s.qty, 0) as stock_qty, s.status as stock_status, ");
      sql.append("c.name as category_name, u.name as unit_name, u.symbol as unit_symbol ");
      sql.append("FROM product_info p ");
      sql.append("LEFT JOIN product_in_stock s ON p.id = s.product_id ");
      sql.append("LEFT JOIN category c ON p.cate_id = c.id ");
      sql.append("LEFT JOIN unit u ON p.unit_id = u.id ");
      sql.append("WHERE p.active_flag = 1 AND p.status != 'deleted' ");
      
      if (search != null && !search.trim().isEmpty()) {
          sql.append("AND (p.name LIKE ? OR p.code LIKE ? OR c.name LIKE ?) ");
      }
        if (sortBy != null && !sortBy.isEmpty()) {
          sql.append("ORDER BY ");
          switch (sortBy) {
              case COL_NAME -> sql.append("p.name ");
              case COL_CODE -> sql.append("p.code ");
              case "stock" -> sql.append("stock_qty ");
              case "category" -> sql.append("c.name ");
              default -> sql.append("p.id ");
          }
          sql.append(sortOrder != null && sortOrder.equals("desc") ? "DESC " : "ASC ");
      } else {
          sql.append("ORDER BY p.id ASC ");
      }
      
      sql.append("LIMIT ? OFFSET ?");

      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql.toString())) {
          
          int paramIndex = 1;
          if (search != null && !search.trim().isEmpty()) {
              String searchPattern = "%" + search.trim() + "%";
              stmt.setString(paramIndex++, searchPattern);
              stmt.setString(paramIndex++, searchPattern);
              stmt.setString(paramIndex++, searchPattern);
          }
          
          stmt.setInt(paramIndex++, pageSize);
          stmt.setInt(paramIndex, page * pageSize);
          
          ResultSet rs = stmt.executeQuery();            
          while (rs.next()) {
              ProductStock product = new ProductStock();
              product.setId(rs.getInt(COL_ID));
              product.setName(rs.getString(COL_NAME));
              product.setCode(rs.getString(COL_CODE));
              product.setCateId(rs.getInt(COL_CATE_ID));
              product.setUnitId(rs.getInt(COL_UNIT_ID));
              product.setStatus(rs.getString(COL_STATUS));
              product.setDescription(rs.getString(COL_DESCRIPTION));
              product.setStockQuantity(rs.getBigDecimal("stock_qty"));
              product.setStockStatus(rs.getString("stock_status"));
              product.setCategoryName(rs.getString("category_name"));
              product.setUnitName(rs.getString("unit_name"));
              product.setUnitSymbol(rs.getString("unit_symbol"));
              product.setMinStockThreshold(rs.getBigDecimal("min_stock_threshold"));
              
              // Check for low stock and near expiration
              product.checkLowStock();
              // For now, we'll set expiration to null since it's not in the database
              product.setExpirationDate(null);
              product.checkNearExpiration();
              
              list.add(product);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }

      return list;
  }

  /**
   * Get total count of active products for pagination
   * @param search Search term
   * @return Total count of products as int
   */
  //Lấy tổng số lượng product
  public int getTotalProductCount(String search) {
      StringBuilder sql = new StringBuilder();
      sql.append("SELECT COUNT(*) FROM product_info p ");
      sql.append("LEFT JOIN category c ON p.cate_id = c.id ");
      sql.append("WHERE p.active_flag = 1 AND p.status != 'deleted' ");
      
      if (search != null && !search.trim().isEmpty()) {
          sql.append("AND (p.name LIKE ? OR p.code LIKE ? OR c.name LIKE ?) ");
      }

      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql.toString())) {
          
          if (search != null && !search.trim().isEmpty()) {
              String searchPattern = "%" + search.trim() + "%";
              stmt.setString(1, searchPattern);
              stmt.setString(2, searchPattern);
              stmt.setString(3, searchPattern);
          }
          
          ResultSet rs = stmt.executeQuery();
          if (rs.next()) {
              return rs.getInt(1);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return 0;
  }

  /**
   * Add a new product with comprehensive information
   * @param product ProductInfo object with product details
   * @param createdBy User ID of the creator
   * @return true if addition was successful, false otherwise
   */
  //Thêm product mới
  public boolean addProduct(ProductInfo product, int createdBy) {
      String productSql = "INSERT INTO product_info (name, code, cate_id, unit_id, status, description, " +
                         "supplier_id, expiration_date, additional_notes, min_stock_threshold, created_by) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
      
      String stockSql = "INSERT INTO product_in_stock (product_id, qty, status) VALUES (?, ?, 'active')";
      
      System.out.println("DEBUG: Starting addProduct method");
      System.out.println("DEBUG: Product data - Name: " + product.getName() + ", Code: " + product.getCode());
      System.out.println("DEBUG: Category ID: " + product.getCate_id() + ", Unit ID: " + product.getUnit_id());
      System.out.println("DEBUG: Status: " + product.getStatus());
      System.out.println("DEBUG: Initial Stock Quantity: " + (product.getStockQuantity() != null ? product.getStockQuantity() : "0"));
      
      Connection con = null;
      try {
          con = Context.getJDBCConnection();
          if (con == null) {
              System.err.println("ERROR: Database connection is null!");
              return false;
          }
          
          // Start transaction
          con.setAutoCommit(false);
          System.out.println("DEBUG: Database connection successful, transaction started");
          
          int productId = -1;
          
          // Insert into product_info table
          try (PreparedStatement productStmt = con.prepareStatement(productSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
              productStmt.setString(1, product.getName());
              productStmt.setString(2, product.getCode());
              productStmt.setInt(3, product.getCate_id());
              productStmt.setInt(4, product.getUnit_id());
              productStmt.setString(5, product.getStatus());
              productStmt.setString(6, product.getDescription());
              
              // Handle supplier_id - set to null if 0 or not provided
              if (product.getSupplierId() > 0) {
                  productStmt.setInt(7, product.getSupplierId());
              } else {
                  productStmt.setNull(7, java.sql.Types.INTEGER);
              }
              
              productStmt.setDate(8, product.getExpirationDate());
              productStmt.setString(9, product.getAdditionalNotes());
              productStmt.setBigDecimal(10, product.getMinStockThreshold());
              productStmt.setInt(11, createdBy);
              
              System.out.println("DEBUG: Executing product insert query");
              int rowsAffected = productStmt.executeUpdate();
              
              if (rowsAffected > 0) {
                  // Get the generated product ID
                  try (ResultSet generatedKeys = productStmt.getGeneratedKeys()) {
                      if (generatedKeys.next()) {
                          productId = generatedKeys.getInt(1);
                          System.out.println("DEBUG: Product inserted successfully with ID: " + productId);
                      } else {
                          throw new SQLException("Failed to get generated product ID");
                      }
                  }
              } else {
                  throw new SQLException("Product insert failed, no rows affected");
              }
          }
          
          // Insert initial stock record
          try (PreparedStatement stockStmt = con.prepareStatement(stockSql)) {
              stockStmt.setInt(1, productId);
              
              // Set initial stock quantity (default to 0 if not provided)
              BigDecimal initialStock = product.getStockQuantity();
              if (initialStock == null) {
                  initialStock = BigDecimal.ZERO;
              }
              stockStmt.setBigDecimal(2, initialStock);
              
              System.out.println("DEBUG: Executing stock insert query for product ID: " + productId + " with quantity: " + initialStock);
              int stockRowsAffected = stockStmt.executeUpdate();
              
              if (stockRowsAffected > 0) {
                  System.out.println("DEBUG: Stock record inserted successfully");
              } else {
                  throw new SQLException("Stock insert failed, no rows affected");
              }
          }
          
          // Commit transaction
          con.commit();
          System.out.println("DEBUG: Transaction committed successfully");
          
          return true;
          
      } catch (SQLException e) {
          System.err.println("ERROR: SQL Exception in addProduct: " + e.getMessage());
          System.err.println("ERROR: SQL State: " + e.getSQLState());
          System.err.println("ERROR: Error Code: " + e.getErrorCode());
          e.printStackTrace();
          
          // Rollback transaction on error
          if (con != null) {
              try {
                  con.rollback();
                  System.out.println("DEBUG: Transaction rolled back due to error");
              } catch (SQLException rollbackEx) {
                  System.err.println("ERROR: Failed to rollback transaction: " + rollbackEx.getMessage());
              }
          }
          return false;
      } catch (Exception e) {
          System.err.println("ERROR: General Exception in addProduct: " + e.getMessage());
          e.printStackTrace();
          
          // Rollback transaction on error
          if (con != null) {
              try {
                  con.rollback();
                  System.out.println("DEBUG: Transaction rolled back due to error");
              } catch (SQLException rollbackEx) {
                  System.err.println("ERROR: Failed to rollback transaction: " + rollbackEx.getMessage());
              }
          }
          return false;
      } finally {
          // Restore auto-commit and close connection
          if (con != null) {
              try {
                  con.setAutoCommit(true);
                  con.close();
              } catch (SQLException e) {
                  System.err.println("ERROR: Failed to restore auto-commit or close connection: " + e.getMessage());
              }
          }
      }
  }
  
  /**
   * Check if a product code already exists
   * @param code Product code to check
   * @return true if code exists, false otherwise
   */
  //Kiểm tra product code có tồn tại hay không
  public boolean isProductCodeExists(String code) {
      String sql = "SELECT COUNT(*) FROM product_info WHERE code = ?";
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          stmt.setString(1, code);
          ResultSet rs = stmt.executeQuery();
          
          if (rs.next()) {
              return rs.getInt(1) > 0;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return false;
  }
  
  /**
   * Get all active categories for dropdown
   * @return List of CategoryProduct objects
   */
  //Lấy dữ liệu từ categories 
  public List<CategoryProduct> getAllActiveCategories() {
      List<CategoryProduct> categories = new ArrayList<>();
      String sql = "SELECT id, name FROM category WHERE active_flag = 1 ORDER BY name";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql); 
           ResultSet rs = stmt.executeQuery()) {
          
          while (rs.next()) {
              CategoryProduct category = new CategoryProduct();
              category.setId(rs.getInt("id"));
              category.setName(rs.getString("name"));
              categories.add(category);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return categories;
  }
  
  /**
   * Get all active units for dropdown
   * @return List of Unit objects
   */
  //Lấy dữ liệu từ Unit 
  public List<Unit> getAllActiveUnits() {
      List<Unit> units = new ArrayList<>();
      String sql = "SELECT id, name, symbol FROM unit ORDER BY name";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql); 
           ResultSet rs = stmt.executeQuery()) {
          
          while (rs.next()) {
              Unit unit = new Unit();
              unit.setId(rs.getInt("id"));
              unit.setName(rs.getString("name"));
              unit.setSymbol(rs.getString("symbol"));
              units.add(unit);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return units;
  }
  
  /**
   * Get all active suppliers for dropdown
   * @return List of Supplier objects
   */
  //Lấy dữ liệu từ Suppliers
  public List<Supplier> getAllActiveSuppliers() {
      List<Supplier> suppliers = new ArrayList<>();
      String sql = "SELECT id, name FROM supplier WHERE active_flag = 1 ORDER BY name";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql); 
           ResultSet rs = stmt.executeQuery()) {
          
          while (rs.next()) {
              Supplier supplier = new Supplier();
              supplier.setSupplierID(rs.getInt("id"));
              supplier.setName(rs.getString("name"));
              suppliers.add(supplier);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return suppliers;
  }
  
  /**
   * Get a single product by ID for editing
   */
  //Lấy dữ liệu từ product dựa trên id 
  public ProductInfo getProductById(int productId) {
      // First check if min_stock_threshold column exists
      boolean hasMinStockThreshold = checkColumnExists("product_info", "min_stock_threshold");
      
      String sql;
      if (hasMinStockThreshold) {
          sql = "SELECT p.id, p.name, p.code, p.cate_id, p.unit_id, p.status, p.description, " +
                "p.min_stock_threshold, " +
                "COALESCE(s.qty, 0) as stock_qty " +
                "FROM product_info p " +
                "LEFT JOIN product_in_stock s ON p.id = s.product_id " +
                "WHERE p.id = ?";
      } else {
          sql = "SELECT p.id, p.name, p.code, p.cate_id, p.unit_id, p.status, p.description, " +
                "COALESCE(s.qty, 0) as stock_qty " +
                "FROM product_info p " +
                "LEFT JOIN product_in_stock s ON p.id = s.product_id " +
                "WHERE p.id = ?";
      }
      
      System.out.println("DEBUG: getProductById called with ID: " + productId);
      System.out.println("DEBUG: Using SQL: " + sql);
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          if (con == null) {
              System.err.println("ERROR: Database connection is null in getProductById!");
              return null;
          }
          
          System.out.println("DEBUG: Database connection successful in getProductById");
          stmt.setInt(1, productId);
          
          try (ResultSet rs = stmt.executeQuery()) {
              if (rs.next()) {
                  ProductInfo product = new ProductInfo();
                  product.setId(rs.getInt("id"));
                  product.setName(rs.getString("name"));
                  product.setCode(rs.getString("code"));
                  product.setCate_id(rs.getInt("cate_id"));
                  product.setUnit_id(rs.getInt("unit_id"));
                  product.setStatus(rs.getString("status"));
                  product.setDescription(rs.getString("description"));
                  
                  // Set default values for fields that might not exist
                  product.setSupplierId(0);
                  product.setAdditionalNotes("");
                  product.setCreatedBy(0);
                  product.setUpdatedBy(0);
                  
                  // Set expiration date to null since it's not in the database
                  product.setExpirationDate(null);
                  
                  // Handle min_stock_threshold
                  if (hasMinStockThreshold) {
                      BigDecimal minStockThreshold = rs.getBigDecimal("min_stock_threshold");
                      if (minStockThreshold != null) {
                          product.setMinStockThreshold(minStockThreshold);
                      } else {
                          product.setMinStockThreshold(BigDecimal.ZERO);
                      }
                  } else {
                      product.setMinStockThreshold(BigDecimal.ZERO);
                  }
                  
                  // Set stock quantity
                  BigDecimal stockQty = rs.getBigDecimal("stock_qty");
                  if (stockQty != null) {
                      product.setStockQuantity(stockQty.doubleValue());
                  } else {
                      product.setStockQuantity(0.0);
                  }
                  
                  // Debug log
                  System.out.println("DEBUG: Product loaded successfully from DB: " + product.getName());
                  return product;
              } else {
                  System.out.println("DEBUG: No product found with ID: " + productId + " in database");
              }
          }
      } catch (SQLException e) {
          System.err.println("ERROR: SQL Exception in getProductById: " + e.getMessage());
          System.err.println("ERROR: SQL State: " + e.getSQLState());
          System.err.println("ERROR: Error Code: " + e.getErrorCode());
          e.printStackTrace();
      } catch (Exception e) {
          System.err.println("ERROR: General Exception in getProductById: " + e.getMessage());
          e.printStackTrace();
      }
      return null;
  }
  
  /**
   * Check if a column exists in a table
   */
  private boolean checkColumnExists(String tableName, String columnName) {
      String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS " +
                   "WHERE TABLE_SCHEMA = DATABASE() " +
                   "AND TABLE_NAME = ? AND COLUMN_NAME = ?";
      
      try (Connection con = Context.getJDBCConnection();
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          stmt.setString(1, tableName);
          stmt.setString(2, columnName);
          
          try (ResultSet rs = stmt.executeQuery()) {
              if (rs.next()) {
                  return rs.getInt(1) > 0;
              }
          }
      } catch (SQLException e) {
          System.err.println("ERROR checking column existence: " + e.getMessage());
      }
      return false;
  }

  /**
   * Update product information
   */
  //Update dữ liệu của product
  public boolean updateProduct(ProductInfo product) {
      // Check if min_stock_threshold column exists
      boolean hasMinStockThreshold = checkColumnExists("product_info", "min_stock_threshold");
      
      String sql;
      if (hasMinStockThreshold) {
          sql = "UPDATE product_info SET " +
                "name = ?, code = ?, cate_id = ?, unit_id = ?, " +
                "status = ?, description = ?, expiration_date = ?, " +
                "min_stock_threshold = ? " +
                "WHERE id = ?";
      } else {
          sql = "UPDATE product_info SET " +
                "name = ?, code = ?, cate_id = ?, unit_id = ?, " +
                "status = ?, description = ?, expiration_date = ? " +
                "WHERE id = ?";
      }
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          stmt.setString(1, product.getName());
          stmt.setString(2, product.getCode());
          stmt.setInt(3, product.getCate_id());
          stmt.setInt(4, product.getUnit_id());
          stmt.setString(5, product.getStatus());
          stmt.setString(6, product.getDescription());
          stmt.setDate(7, product.getExpirationDate());
          
          if (hasMinStockThreshold) {
              stmt.setBigDecimal(8, product.getMinStockThreshold());
              stmt.setInt(9, product.getId());
          } else {
              stmt.setInt(8, product.getId());
          }
          
          int rowsAffected = stmt.executeUpdate();
          return rowsAffected > 0;
          
      } catch (SQLException e) {
          e.printStackTrace();
          return false;
      }
  }
  
  /**
   * Update product stock quantity
   */
  //Update số lượng tồn kho của product 
  public boolean updateProductStock(int productId, double newQuantity) {
      // First try to update existing stock record
      String updateSql = "UPDATE product_in_stock SET qty = ? WHERE product_id = ?";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement updateStmt = con.prepareStatement(updateSql)) {
          
          updateStmt.setDouble(1, newQuantity);
          updateStmt.setInt(2, productId);
          
          int rowsAffected = updateStmt.executeUpdate();
          
          // If no rows were updated, insert a new stock record
          if (rowsAffected == 0) {
              String insertSql = "INSERT INTO product_in_stock (product_id, qty, status) VALUES (?, ?, 'active')";
              try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
                  insertStmt.setInt(1, productId);
                  insertStmt.setDouble(2, newQuantity);
                  return insertStmt.executeUpdate() > 0;
              }
          }
          
          return true;
          
      } catch (SQLException e) {
          e.printStackTrace();
          return false;
      }
  }
  
  /**
   * Check if product code exists for other products (for duplicate validation during update)
   */
  //Kiểm tra trùng lặp product dựa trên code 
  public boolean isProductCodeExistsForOtherProduct(String code, int excludeProductId) {
      String sql = "SELECT COUNT(*) FROM product_info WHERE code = ? AND id != ?";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          stmt.setString(1, code);
          stmt.setInt(2, excludeProductId);
          
          try (ResultSet rs = stmt.executeQuery()) {
              if (rs.next()) {
                  return rs.getInt(1) > 0;
              }
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return false;
  }
  
  /**
   * Soft delete a product by ID
   * @param productId The ID of the product to delete
   * @return true if soft deletion was successful, false otherwise
   */   
  //Soft delete product 
  public boolean deleteProduct(int productId) {
      String sql = "UPDATE product_info SET status = 'deleted' WHERE id = ?";
      
      System.out.println("ProductInfoDAO: Attempting to soft delete product with ID: " + productId);
      
      try (Connection con = Context.getJDBCConnection();
           PreparedStatement stmt = con.prepareStatement(sql)) {
          
          stmt.setInt(1, productId);
          int rowsAffected = stmt.executeUpdate();
          
          System.out.println("ProductInfoDAO: Soft delete operation affected " + rowsAffected + " rows");
          return rowsAffected > 0;
          
      } catch (SQLException e) {
          System.out.println("ProductInfoDAO: Error soft deleting product - " + e.getMessage());
          e.printStackTrace();
          return false;
      }
  }
  
  /**
   * Check if a product can be safely deleted (no dependencies)
   * @param productId The ID of the product to check
   * @return true if product can be deleted, false if it has dependencies
   */    
  //Kiểm tra xem có xóa product được không
  public boolean canDeleteProduct(int productId) {
      // Check if product is referenced in other tables
      String[] dependencyTables = {
          "product_in_stock",
          "request_items", 
          "invoice_detail"
      };
      
      for (String table : dependencyTables) {
          String sql = "SELECT COUNT(*) FROM " + table + " WHERE product_id = ?";
          try (Connection con = Context.getJDBCConnection();
               PreparedStatement stmt = con.prepareStatement(sql)) {
              
              stmt.setInt(1, productId);
              try (ResultSet rs = stmt.executeQuery()) {
                  if (rs.next() && rs.getInt(1) > 0) {
                      System.out.println("ProductInfoDAO: Found " + rs.getInt(1) + " dependencies in table " + table);
                      return false; // Found dependencies
                  }
              }
          } catch (SQLException e) {
              System.out.println("ProductInfoDAO: Error checking dependencies in table " + table + " - " + e.getMessage());
              e.printStackTrace();
              return false; // Error occurred, safer to not allow deletion
          }
      }
      System.out.println("ProductInfoDAO: No dependencies found for product " + productId);
      return true; // No dependencies found
  }

  /**
   * Recover a soft-deleted product by setting status to 'active'
   */
  public boolean recoverProduct(int productId) {
      String sql = "UPDATE product_info SET status = 'active' WHERE id = ?";
      try (Connection con = Context.getJDBCConnection();
           PreparedStatement stmt = con.prepareStatement(sql)) {
          stmt.setInt(1, productId);
          int rowsAffected = stmt.executeUpdate();
          return rowsAffected > 0;
      } catch (SQLException e) {
          e.printStackTrace();
          return false;
      }
  }

  /**
   * Get all soft-deleted products (status = 'deleted')
   */
  public List<ProductInfo> getDeletedProducts() {
      List<ProductInfo> list = new ArrayList<>();
      String sql = "SELECT id, name, code, cate_id, unit_id, status, description, min_stock_threshold FROM product_info WHERE status = 'deleted'";
      try (
              Connection con = Context.getJDBCConnection();
              PreparedStatement stmt = con.prepareStatement(sql);
              ResultSet rs = stmt.executeQuery();) {
          while (rs.next()) {
              ProductInfo p = new ProductInfo();
              p.setId(rs.getInt(COL_ID));
              p.setName(rs.getString(COL_NAME));
              p.setCode(rs.getString(COL_CODE));
              p.setCate_id(rs.getInt(COL_CATE_ID));
              p.setUnit_id(rs.getInt(COL_UNIT_ID));
              p.setStatus(rs.getString(COL_STATUS));
              p.setDescription(rs.getString(COL_DESCRIPTION));
              p.setMinStockThreshold(rs.getBigDecimal("min_stock_threshold"));
              list.add(p);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return list;
  }
  /**
 * Get product information with unit symbol by product ID
 * @param productId The ID of the product
 * @return ProductInfo object with unit symbol
 */
public ProductInfo getProductWithUnitSymbol(int productId) {
    String sql = "SELECT p.id, p.name, p.code, p.cate_id, p.unit_id, p.status, p.description, " +
                "p.min_stock_threshold, u.symbol as unit_symbol " +
                "FROM product_info p " +
                "LEFT JOIN unit u ON p.unit_id = u.id " +
                "WHERE p.id = ? AND p.status != 'deleted'";
    
    try (Connection con = Context.getJDBCConnection(); 
         PreparedStatement stmt = con.prepareStatement(sql)) {
        
        stmt.setInt(1, productId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                ProductInfo product = new ProductInfo();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setCode(rs.getString("code"));
                product.setCate_id(rs.getInt("cate_id"));
                product.setUnit_id(rs.getInt("unit_id"));
                product.setStatus(rs.getString("status"));
                product.setDescription(rs.getString("description"));
                product.setUnitSymbol(rs.getString("unit_symbol"));
                
                // Xử lý min_stock_threshold
                BigDecimal minStockThreshold = rs.getBigDecimal("min_stock_threshold");
                if (minStockThreshold != null) {
                    product.setMinStockThreshold(minStockThreshold);
                } else {
                    product.setMinStockThreshold(BigDecimal.ZERO);
                }
                
                return product;
            }
        }
    } catch (SQLException e) {
        System.err.println("ERROR: SQL Exception in getProductWithUnitSymbol: " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}

/**
 * Get all products with their unit symbols
 * @return List of ProductInfo objects with unit symbols
 */
public List<ProductInfo> getAllProductsWithUnitSymbols() {
    List<ProductInfo> products = new ArrayList<>();
    String sql = "SELECT p.id, p.name, p.code, p.cate_id, p.unit_id, p.status, p.description, " +
                "p.min_stock_threshold, u.symbol as unit_symbol " +
                "FROM product_info p " +
                "LEFT JOIN unit u ON p.unit_id = u.id " +
                "WHERE p.status != 'deleted' " +
                "ORDER BY p.name";
    
    try (Connection con = Context.getJDBCConnection(); 
         PreparedStatement stmt = con.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        
        while (rs.next()) {
            ProductInfo product = new ProductInfo();
            product.setId(rs.getInt("id"));
            product.setName(rs.getString("name"));
            product.setCode(rs.getString("code"));
            product.setCate_id(rs.getInt("cate_id"));
            product.setUnit_id(rs.getInt("unit_id"));
            product.setStatus(rs.getString("status"));
            product.setDescription(rs.getString("description"));
            product.setUnitSymbol(rs.getString("unit_symbol"));
            
            // Xử lý min_stock_threshold
            BigDecimal minStockThreshold = rs.getBigDecimal("min_stock_threshold");
            if (minStockThreshold != null) {
                product.setMinStockThreshold(minStockThreshold);
            } else {
                product.setMinStockThreshold(BigDecimal.ZERO);
            }
            
            products.add(product);
        }
    } catch (SQLException e) {
        System.err.println("ERROR: SQL Exception in getAllProductsWithUnitSymbols: " + e.getMessage());
        e.printStackTrace();
    }
    return products;
}

}