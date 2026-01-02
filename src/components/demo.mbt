///|
/// @zag-js/switch デモ
/// MoonBit から zag.js Switch を使用する例

// ============================================================
// デモエントリーポイント
// ============================================================

///|
/// Switch デモのデモ関数
pub fn demo() -> Unit {
  // Context を作成
  let context = SwitchContext::{
    id: "switch-demo",
    default_checked: Some(false),
    disabled: Some(false),
    name: Some("toggle"),
    value: Some("on"),
    form: None,
    checked: None,
  }

  // Machine を作成
  let machine = SwitchMachine::create(context)

  // Service を作成
  let js_service = switch_create_service(machine)

  // Connectして API を取得
  let api = switch_connect(js_service)

  // 状態を確認
  @js.log(@js.any("=== Switch Demo ==="))

  @js.log(@js.any("Root Props:"))
  @js.log(api.get_root_props())

  @js.log(@js.any("Control Props:"))
  @js.log(api.get_control_props())

  @js.log(@js.any("Input Props:"))
  @js.log(api.get_input_props())

  // 状態チェック
  let checked = api.is_checked()
  @js.log(@js.any("Checked:"))
  @js.log(@js.any(checked))

  let disabled = api.is_disabled()
  @js.log(@js.any("Disabled:"))
  @js.log(@js.any(disabled))
}

///|
/// メインエントリーポイント
fn main {
  demo()
}
