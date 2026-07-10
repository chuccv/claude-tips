# Chi phí session: tại sao Opus tốn nhất & khi nào dùng Sonnet

## Tại sao Opus tốn tiền nhất
Giá tính theo token. Opus đắt hơn Sonnet vài lần cho cùng lượng token:

| Model | Input / 1M | Output / 1M |
|---|---|---|
| Opus 4.8 | ~$5 | ~$25 |
| Sonnet 4.6 | ~$3 | ~$15 |
| Haiku 4.5 | ~$1 | ~$5 |

Cộng thêm: session càng dài, context (CLAUDE.md + memory + file project) nạp lại **mỗi lượt** → input token phình. Opus nhân chi phí đó lên → đắt nhất.

## Sonnet dùng được không? — Được, cho phần lớn việc
Chia model theo loại việc:

| Việc | Model |
|---|---|
| Điều hành, quyết định, review, tổng hợp | Opus (main) |
| Code, trace, search, refactor cơ học, việc lặp | **Sonnet (sub-agent)** |
| Việc máy móc rẻ tiền | Haiku |

Opus chỉ thắng rõ ở reasoning khó / kiến trúc / review sâu / đánh đổi. Còn lại Sonnet đủ.

## Cạm bẫy: sub-agent kế thừa Opus
`settings.json` set `model: opus` cho main, nhưng **không có field ép model sub-agent**. Mặc định sub-agent **kế thừa model của main** → cũng chạy Opus. Đây là chỗ đốt tiền âm thầm.

Không có toggle global nào đổi được → phải **truyền `model: sonnet` mỗi lần spawn** sub-agent (qua tham số, hoặc `model: sonnet` trong frontmatter agent definition).

## Cách giảm tiền
1. Đẩy heavy work xuống **sub-agent Sonnet** (ép `model: sonnet`).
2. `/compact` khi context > 50% — cắt input token phình mỗi lượt.
3. Dùng `--continue` thay vì đẻ session mới — đỡ nạp lại context.
4. Việc máy móc → Haiku.
