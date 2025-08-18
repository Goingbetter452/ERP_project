package java.com.company1.dao;


import com.company1.DBManager; // 우리가 만든 DBManager
import com.company1.dto.EmployeeDTO; // 직원 바구니
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// 데이터베이스에 접속해 직원관련 SQL(추가, 조회, 수정, 삭제)을 실행하는 역할 담당 [ 쉽게 표현하면 해결사 ]
public class EmployeeDAO {
		// 모든 직원 목록 가져오기
		public List<EmployeeDTO> selectAllemployees() { /* ... */ }
		
		
		 /**
	     * 로그인 처리를 위해 아이디와 비밀번호가 일치하는 사용자가 있는지 확인하는 메서드
	     * @param empId 사용자 아이디
	     * @param empPw 사용자 비밀번호
	     * @return 로그인 성공 시 EmployeeDTO 객체, 실패 시 null
	     */
		
		 public EmployeeDTO checkLogin(String empId, String empPw) {
		        Connection conn = null;
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        EmployeeDTO emp = null;
		        
		        // 실제 DB테이블과 컬럼명에 맞게 수정해야하는 구역
		        String sql = "SELECT emp_id, emp_name, auth FROM employees WHERE emp_id = ? AND emp_pw = ?";
		        
		        try {
		            conn = DBManager.getConnection(); // DBManager로부터 커넥션 획득
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, empId);
		            pstmt.setString(2, empPw);
		            rs = pstmt.executeQuery();
		            
		            if (rs.next()) { // 일치하는 사용자가 있다면
		                emp = new EmployeeDTO();
		                emp.setEmpId(rs.getString("emp_id"));
		                emp.setEmpName(rs.getString("emp_name"));
		                emp.setAuth(rs.getString("auth"));
		                // 로그인 시 필요한 다른 정보들도 DTO에 담아줍니다.
		            }
		        } catch(Exception e) {
		        	e.printStackTrace();
		        } finally {
		        	DBManager.close(rs, pstmt, conn);	// DB 닫는 코드
		        }
		        return emp;    
		 }
		 
		 
		 /**
		     * 모든 직원 목록을 조회하는 메서드
		     * @return 직원 목록 (List<EmployeeDTO>)
		     */
		 
		 public List<EmployeeDTO> selectAllEmployees() {
			 List<EmployeeDTO> list = new ArrayList<>();
			 Connection conn = null;
			 PreparedStatement pstmt = null;
		     ResultSet rs = null;
		     String sql = "SELECT * FROM employees ORDER BY emp_id ASC";
			 
		     try {
		            conn = DBManager.getConnection();
		            pstmt = conn.prepareStatement(sql);
		            rs = pstmt.executeQuery();
		            
		            while (rs.next()) {
		                EmployeeDTO emp = new EmployeeDTO();
		                emp.setEmpId(rs.getString("emp_id"));
		                emp.setEmpName(rs.getString("emp_name"));
		                emp.setPosition(rs.getString("position"));
		                emp.setAuth(rs.getString("auth"));
		                
		                
		                list.add(emp);
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        } finally {
		            DBManager.close(rs, pstmt, conn);	// DB 닫는 코드
		        }
		        return list;							// 리스트로 돌아가기
		    }
		 
		 
		 
		 // 여기부터 직원등록(insert), 수정(update), 삭제(delete) 메서드를 추가가능
		 
		 
		 /**
		     * 새로운 직원을 등록하는 메서드
		     * @param empDto 등록할 직원의 정보가 담긴 DTO
		     */
		 
		 public void insertEmployee(EmployeeDTO empDTO) {
			  Connection conn = null;
		      PreparedStatement pstmt = null;
		        
		      String sql = "INSERT INTO employees (emp_id, emp_pw, emp_name, position, auth) VALUES (?, ?, ?, ?, ?)";
		        
		      
		      try {
		            conn = DBManager.getConnection();
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, empDto.getEmpId());
		            pstmt.setString(2, empDto.getEmpPw());
		            pstmt.setString(3, empDto.getEmpName());
		            pstmt.setString(4, empDto.getPosition());
		            pstmt.setString(5, empDto.getAuth());
		            pstmt.executeUpdate(); // INSERT, UPDATE, DELETE는 executeUpdate() 사용
		        } catch (Exception e) {
		            e.printStackTrace();
		        } finally {
		            DBManager.close(null, pstmt, conn); // ResultSet이 없으므로 첫 인자는 null
		        }
		    }
		}  
	