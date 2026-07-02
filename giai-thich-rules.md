# Giải thích các Rule trong CLAUDE.md

Tài liệu này giải thích **lý do** đằng sau từng rule, để sau này nhìn lại còn nhớ tại sao đặt ra.

## User Rules

### 1. Trả lời bằng tiếng Việt
Để đọc nhanh, không tốn công dịch trong đầu khi trao đổi.

### 2. Tự đọc file, không hỏi
Tránh vòng lặp "Tôi có nên đọc file X không?" → mất thời gian. Cứ đọc thẳng rồi làm.

### 3. Không sửa/format code không liên quan đến task
Giữ diff sạch, mỗi dòng thay đổi đều truy được về yêu cầu. Tránh "tiện tay refactor" gây nhiễu review và dễ sinh bug ngoài ý muốn.

### 4. Comment code bằng tiếng Anh
Code base dùng chung, comment tiếng Anh để đồng bộ và dễ chia sẻ.

### 5. Không tự `git push`, chỉ thông báo
Push là thao tác khó thu hồi và ảnh hưởng remote/người khác. Người quyết định cuối cùng là mình, nên AI chỉ chuẩn bị sẵn rồi báo để mình tự bấm.

### 6. Khi cần Browser: chỉ dùng skill `playwright-cli`
Thống nhất một công cụ duy nhất cho thao tác trình duyệt, tránh mỗi lần một kiểu khó kiểm soát.

### 7. E2E / Playwright nhiều bước: đẩy sang sub-agent
Output của Playwright rất nặng (snapshot DOM, console log, network, screenshot) — mỗi bước hàng nghìn token. Chạy ở luồng chính sẽ ngốn context window, đẩy thứ quan trọng ra ngoài. Sub-agent gánh phần nặng và chỉ trả về **kết luận** (pass/fail, lỗi ở đâu), giữ luồng chính sạch và ổn định.
Sub-agent này **mặc định dùng model Sonnet** — E2E chủ yếu là thao tác máy móc (navigate, click, assert), không cần model mạnh nhất, dùng Sonnet vừa đủ lại tiết kiệm.
**Ngoại lệ:** check nhanh trực tiếp mà mình đang xem live thì chạy luôn ở luồng chính cho thấy ngay.

### 8. Tra cứu code: dùng codegraph trước grep/Read
Codegraph là index dựng sẵn (symbol, call chain, file) — một lệnh trả về source + ai gọi + ảnh hưởng đâu, nhanh và ít token hơn nhiều so với vòng lặp grep + read.
**Ngoại lệ:** Codegraph chỉ index code (PHP/JS/TS/XML/YAML/liquid), **không index CSS/LESS/SCSS** → với các file style này vẫn phải dùng `grep`.
**Không đẩy codegraph sang sub-agent** (khác với Playwright ở rule 7): output codegraph vốn nhẹ và gọn, delegate chỉ tốn thêm round-trip và mất lợi thế thấy blast radius (ai gọi, ảnh hưởng đâu) ngay tại luồng chính. Sub-agent chỉ hợp với tool output nặng như Playwright.

## Behavioral Guidelines (Karpathy)

Nguyên tắc giảm lỗi thường gặp khi LLM viết code, thiên về cẩn thận hơn là nhanh.

1. **Think Before Coding** — nêu giả định rõ ràng, hỏi khi không chắc, không tự quyết im lặng.
2. **Simplicity First** — viết lượng code tối thiểu, không thêm tính năng/abstraction/flexibility không được yêu cầu.
3. **Surgical Changes** — chỉ đụng đúng phần cần thiết, không refactor thứ không hỏng.
4. **Goal-Driven Execution** — định nghĩa tiêu chí thành công, loop tới khi verify được.
   **Chỉ viết test cho task rủi ro cao** (bug logic, validation, refactor có nguy cơ hồi quy). Task nhỏ/một lần thì bỏ qua test, verify trực tiếp — tránh làm chậm không cần thiết.
