/**
 * 공지사항 등록버튼으로 등록처리로 이동
 */
function regSubmit() {
	// form1의 action에 있는 주소로 이동해서 처리(post)
	document.getElementById('form1').submit();
}

/**
 * 공지사항 수정버튼
 */
function moveUpdate(seq) {
	// 수정 페이지 접근(get방식)
	location.href = '/starbucks_web/admin_notice_update_form.jsp?sno=' + seq;
}

/**
 * 공지사항 수정버튼으로 수정처리로 이동
 */
function updateSubmit() {
	document.getElementById('form1').submit();
}


function deleteNotice(seq) {
	if(!confirm('번호  ' + seq + '을 정말 삭제하시겠습니까?')) {
		return false;
	}
	location.href = '/starbucks_web/admin_notice_delete.jsp?sno=' + seq;
}