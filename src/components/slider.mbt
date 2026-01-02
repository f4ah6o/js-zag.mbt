///|
/// @zag-js/slider の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/slider から machine 関数をインポート
#module("@zag-js/slider")
extern "js" fn js_slider_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/slider から connect 関数をインポート
#module("@zag-js/slider")
extern "js" fn js_slider_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/slider から normalize をインポート
#module("@zag-js/slider")
extern "js" fn js_slider_normalize() -> @js.Any =
  "normalize"

// ============================================================
// Slider Context 型
// ============================================================

///|
/// Slider のコンテキスト
pub(all) struct SliderContext {
  id : String
  name : String?
  form : String?
  dir : String?
  min : Int?
  max : Int?
  step : Int?
  value : Array[Int]?
  disabled : Bool?
}

///|
/// SliderContext を JS オブジェクトに変換
pub fn SliderContext::to_js(self : SliderContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.name {
    Some(v) => obj._set("name", @js.any(v))
    None => ()
  }

  match self.form {
    Some(v) => obj._set("form", @js.any(v))
    None => ()
  }

  match self.dir {
    Some(v) => obj._set("dir", @js.any(v))
    None => ()
  }

  match self.min {
    Some(v) => obj._set("min", @js.any(v))
    None => ()
  }

  match self.max {
    Some(v) => obj._set("max", @js.any(v))
    None => ()
  }

  match self.step {
    Some(v) => obj._set("step", @js.any(v))
    None => ()
  }

  match self.value {
    Some(v) => obj._set("value", @js.any(v))
    None => ()
  }

  match self.disabled {
    Some(v) => obj._set("disabled", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Slider Machine
// ============================================================

///|
/// Slider Machine を表す不透明型
#external
pub(all) type SliderMachine

///|
/// machine 関数を呼び出して Slider Machine を作成
pub fn SliderMachine::create(context : SliderContext) -> SliderMachine {
  let js_options = context.to_js()
  let js_machine = js_slider_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn SliderMachine::to_js(self : SliderMachine) -> @js.Any = "%identity"

// ============================================================
// Service 作成関数
// ============================================================

///|
/// Slider Service を作成（machine から）
pub fn slider_create_service(machine : SliderMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Slider API (connect の結果)
// ============================================================

///|
/// Slider API（connect が返すオブジェクト）
pub(all) struct SliderApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから SliderApi を作成
pub fn SliderApi::from_js(js_api : @js.Any) -> SliderApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn SliderApi::to_js(self : SliderApi) -> @js.Any {
  self.js_api
}

///|
/// getRootProps を取得
pub fn SliderApi::get_root_props(self : SliderApi) -> @js.Any {
  self.js_api._get("getRootProps")._invoke([])
}

///|
/// getThumbProps を取得（index付き）
pub fn SliderApi::get_thumb_props(self : SliderApi, index : Int) -> @js.Any {
  let options = @js.new_object()
  options._set("index", @js.any(index))
  self.js_api._get("getThumbProps")._invoke([options])
}

///|
/// getControlProps を取得
pub fn SliderApi::get_control_props(self : SliderApi) -> @js.Any {
  self.js_api._get("getControlProps")._invoke([])
}

///|
/// getTrackProps を取得
pub fn SliderApi::get_track_props(self : SliderApi) -> @js.Any {
  self.js_api._get("getTrackProps")._invoke([])
}

///|
/// getValueText を取得
pub fn SliderApi::get_value_text(self : SliderApi) -> String {
  let value_text = self.js_api._get("valueText")
  @js.any(value_text).cast()
}

///|
/// values を取得
pub fn SliderApi::get_values(self : SliderApi) -> Array[Int] {
  let values = self.js_api._get("values")
  @js.any(values).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn slider_connect(service : @js.Any) -> SliderApi {
  let normalize = js_slider_normalize()
  let js_api = js_slider_connect(service, normalize)
  SliderApi::from_js(js_api)
}
