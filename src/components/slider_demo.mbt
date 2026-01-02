///|
/// @zag-js/slider デモ
/// MoonBit から zag.js Slider を使用する例

// ============================================================
// デモエントリーポイント
// ============================================================

///|
/// Slider デモのメイン関数
pub fn slider_demo() -> Unit {
  // Context を作成
  let context = SliderContext::{
    id: "slider-demo",
    value: [50],
    min: Some(0),
    max: Some(100),
    step: Some(1),
    min_steps_between_thumbs: Some(0),
    orientation: Some("horizontal"),
    origin: None,
    disabled: Some(false),
    invalid: None,
    read_only: None,
    name: Some("volume"),
    form: None,
    dir: None,
  }

  // Machine を作成
  let machine = SliderMachine::create(context)

  // Service を作成
  let js_service = slider_create_service(machine)

  // Connect して API を取得
  let api = slider_connect(js_service)

  // 状態を確認
  @js.log(@js.any("=== Slider Demo ==="))

  let root_props = api.get_root_props()
  @js.log(@js.any("Root Props:"))
  @js.log(root_props)

  let label_props = api.get_label_props()
  @js.log(@js.any("Label Props:"))
  @js.log(label_props)

  let track_props = api.get_track_props()
  @js.log(@js.any("Track Props:"))
  @js.log(track_props)

  let thumb_props = api.get_thumb_props(0)
  @js.log(@js.any("Thumb Props (index 0):"))
  @js.log(thumb_props)

  let control_props = api.get_control_props()
  @js.log(@js.any("Control Props:"))
  @js.log(control_props)

  // 状態チェック
  let value = api.get_value()
  @js.log(@js.any("Value:"))
  @js.log(@js.any(value))

  let thumb_value = api.get_thumb_value(0)
  @js.log(@js.any("Thumb Value (index 0):"))
  @js.log(@js.any(thumb_value))

  let dragging = api.is_dragging()
  @js.log(@js.any("Dragging:"))
  @js.log(@js.any(dragging))

  // 値を設定して確認
  api.set_value([75])

  let new_thumb_value = api.get_thumb_value(0)
  @js.log(@js.any("After setting to 75 - Thumb Value:"))
  @js.log(@js.any(new_thumb_value))
}
