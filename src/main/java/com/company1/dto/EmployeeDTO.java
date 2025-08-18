package java.com.company1.dto;

public class EmployeeDTO {
    private String empId;       // 직원 아이디
    private String empPw;       // 비밀번호
    private String empName;     // 이름
    private String position;    // 직급
    private String auth;        // 권한 ('admin' 또는 'user')
    
    
    // Getters and Setters ... (private 처리된 내용을 빼서 사용하기위해 만듬)
    
    // Getter, Setter 자동 만들기 : 마우스 오른쪽버튼(클릭) -> Source -> Generate Getters and Satters -> Select all 선택
    
	public String getEmpId() {
		return empId;
	}
	public void setEmpId(String empId) {
		this.empId = empId;
	}
	public String getEmpPw() {
		return empPw;
	}
	public void setEmpPw(String empPw) {
		this.empPw = empPw;
	}
	public String getEmpName() {
		return empName;
	}
	public void setEmpName(String empName) {
		this.empName = empName;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
	}

   
}