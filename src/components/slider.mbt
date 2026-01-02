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
extern "js" fn js_slider_connect(state : @js.Any, send : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// ============================================================
// Slider Context 型
// ============================================================

///|
/// Slider のコンテキスト
pub(all) struct SliderContext {
  id : String
  value : Array[Int]
  min : Int?
  max : Int?
  step : Int?
  min_steps_between_thumbs : Int?
  orientation : String?
  origin : String?
  disabled : Bool?
  invalid : Bool?
  read_only : Bool?
  name : String?
  form : String?
  dir : String?
}

///|
/// SliderContext を JS オブジェクトに変換
pub fn SliderContext::to_js(self : SliderContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))
  obj._set("value", @js.any(self.value))

  // オプションフィールド
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

  match self.min_steps_between_thumbs {
    Some(v) => obj._set("minStepsBetweenThumbs", @js.any(v))
    None => ()
  }

  match self.orientation {
    Some(v) => obj._set("orientation", @js.any(v))
    None => ()
  }

  match self.origin {
    Some(v) => obj._set("origin", @js.any(v))
    None => ()
  }

  match self.disabled {
    Some(v) => obj._set("disabled", @js.any(v))
    None => ()
  }

  match self.invalid {
    Some(v) => obj._set("invalid", @js.any(v))
    None => ()
  }

  match self.read_only {
    Some(v) => obj._set("readOnly", @js.any(v))
    None => ()
  }

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
// Slider Service 作成関数
// ============================================================

///|
/// Slider Service を作成（machine から）
pub fn slider_create_service(machine : SliderMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Normalize Props (vanilla JS 用)
// ============================================================

// 自作 JS モジュールから createNormalize をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_create_normalize() -> @js.Any =
  "createNormalize"

///|
/// vanilla JS 用の normalize オブジェクトを作成
fn create_normalize() -> @js.Any {
  js_create_normalize()
}

// 自作 JS モジュールから invokeNoArgs をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_no_args(func : @js.Any) -> @js.Any =
  "invokeNoArgs"

///|
/// JS 関数を引数なしで呼び出す
fn invoke_no_args(func : @js.Any) -> @js.Any {
  js_invoke_no_args(func)
}

// 自作 JS モジュールから invokeWithObject をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any =
  "invokeWithObject"

///|
/// JS 関数をオブジェクト引数で呼び出す
fn invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any {
  js_invoke_with_object(func, arg)
}

// 自作 JS モジュールから invokeWithInt をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_int(func : @js.Any, value : Int) -> @js.Any =
  "invokeWithInt"

///|
/// JS 関数を Int 引数で呼び出す
fn invoke_with_int(func : @js.Any, value : Int) -> @js.Any {
  js_invoke_with_int(func, value)
}

// 自作 JS モジュールから invokeWithNumberArray をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_number_array(func : @js.Any, arg : @js.Any) -> @js.Any =
  "invokeWithNumberArray"

///|
/// JS 関数を数値配列引数で呼び出す
fn invoke_with_number_array(func : @js.Any, arg : @js.Any) -> @js.Any {
  js_invoke_with_number_array(func, arg)
}

// ============================================================
// Slider API (connect の結果)
// ============================================================

///|
/// Slider API（connectが返すオブジェクト）
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

// --- Props 取得メソッド ---

///|
/// rootProps を取得
pub fn SliderApi::get_root_props(self : SliderApi) -> @js.Any {
  let get_root_props = self.js_api._get("getRootProps")
  invoke_no_args(get_root_props)
}

///|
/// labelProps を取得
pub fn SliderApi::get_label_props(self : SliderApi) -> @js.Any {
  let get_label_props = self.js_api._get("getLabelProps")
  invoke_no_args(get_label_props)
}

///|
/// valueTextProps を取得
pub fn SliderApi::get_value_text_props(self : SliderApi) -> @js.Any {
  let get_value_text_props = self.js_api._get("getValueTextProps")
  invoke_no_args(get_value_text_props)
}

///|
/// trackProps を取得
pub fn SliderApi::get_track_props(self : SliderApi) -> @js.Any {
  let get_track_props = self.js_api._get("getTrackProps")
  invoke_no_args(get_track_props)
}

///|
/// thumbProps を取得（indexを引数に渡す）
pub fn SliderApi::get_thumb_props(self : SliderApi, index : Int) -> @js.Any {
  let get_thumb_props = self.js_api._get("getThumbProps")
  let arg = @js.new_object()
  arg._set("index", @js.any(index))
  invoke_with_object(get_thumb_props, arg)
}

///|
/// hiddenInputProps を取得（indexを引数に渡す）
pub fn SliderApi::get_hidden_input_props(self : SliderApi, index : Int) -> @js.Any {
  let get_hidden_input_props = self.js_api._get("getHiddenInputProps")
  let arg = @js.new_object()
  arg._set("index", @js.any(index))
  invoke_with_object(get_hidden_input_props, arg)
}

///|
/// rangeProps を取得
pub fn SliderApi::get_range_props(self : SliderApi) -> @js.Any {
  let get_range_props = self.js_api._get("getRangeProps")
  invoke_no_args(get_range_props)
}

///|
/// controlProps を取得
pub fn SliderApi::get_control_props(self : SliderApi) -> @js.Any {
  let get_control_props = self.js_api._get("getControlProps")
  invoke_no_args(get_control_props)
}

///|
/// markerGroupProps を取得
pub fn SliderApi::get_marker_group_props(self : SliderApi) -> @js.Any {
  let get_marker_group_props = self.js_api._get("getMarkerGroupProps")
  invoke_no_args(get_marker_group_props)
}

///|
/// markerProps を取得（valueを引数に渡す）
pub fn SliderApi::get_marker_props(self : SliderApi, value : Int) -> @js.Any {
  let get_marker_props = self.js_api._get("getMarkerProps")
  let arg = @js.new_object()
  arg._set("value", @js.any(value))
  invoke_with_object(get_marker_props, arg)
}

///|
/// draggingIndicatorProps を取得（indexを引数に渡す）
pub fn SliderApi::get_dragging_indicator_props(self : SliderApi, index : Int) -> @js.Any {
  let get_dragging_indicator_props = self.js_api._get("getDraggingIndicatorProps")
  let arg = @js.new_object()
  arg._set("index", @js.any(index))
  invoke_with_object(get_dragging_indicator_props, arg)
}

// --- 状態取得メソッド ---

///|
/// dragging 状態を取得
pub fn SliderApi::is_dragging(self : SliderApi) -> Bool {
  let dragging = self.js_api._get("dragging")
  @js.any(dragging).cast()
}

///|
/// focused 状態を取得
pub fn SliderApi::is_focused(self : SliderApi) -> Bool {
  let focused = self.js_api._get("focused")
  @js.any(focused).cast()
}

///|
/// value を取得（配列として）
pub fn SliderApi::get_value(self : SliderApi) -> Array[Int] {
  let value = self.js_api._get("value")
  @js.any(value).cast()
}

///|
/// 指定された index の thumb の値を取得
pub fn SliderApi::get_thumb_value(self : SliderApi, index : Int) -> Int {
  let get_thumb_value = self.js_api._get("getThumbValue")
  let result = invoke_with_int(get_thumb_value, index)
  @js.any(result).cast()
}

///|
/// 値をパーセンテージに変換
pub fn SliderApi::get_value_percent(self : SliderApi, value : Int) -> Int {
  let get_value_percent = self.js_api._get("getValuePercent")
  let result = invoke_with_int(get_value_percent, value)
  @js.any(result).cast()
}

///|
/// 指定された index の thumb のパーセンテージを取得
pub fn SliderApi::get_thumb_percent(self : SliderApi, index : Int) -> Int {
  let get_thumb_percent = self.js_api._get("getThumbPercent")
  let result = invoke_with_int(get_thumb_percent, index)
  @js.any(result).cast()
}

///|
/// 指定された index の thumb の最小値を取得
pub fn SliderApi::get_thumb_min(self : SliderApi, index : Int) -> Int {
  let get_thumb_min = self.js_api._get("getThumbMin")
  let result = invoke_with_int(get_thumb_min, index)
  @js.any(result).cast()
}

///|
/// 指定された index の thumb の最大値を取得
pub fn SliderApi::get_thumb_max(self : SliderApi, index : Int) -> Int {
  let get_thumb_max = self.js_api._get("getThumbMax")
  let result = invoke_with_int(get_thumb_max, index)
  @js.any(result).cast()
}

// --- アクションメソッド ---

///|
/// value を設定
pub fn SliderApi::set_value(self : SliderApi, value : Array[Int]) -> Unit {
  let set_value = self.js_api._get("setValue")
  invoke_with_number_array(set_value, @js.any(value)) |> ignore
}

///|
/// 指定された index の thumb の値を設定
pub fn SliderApi::set_thumb_value(self : SliderApi, index : Int, value : Int) -> Unit {
  let set_thumb_value = self.js_api._get("setThumbValue")
  // setThumbValue(index, value) - 2引数版はヘルパーが必要
  // JS側で { index, value } オブジェクトを作成して渡す
  let arg = @js.new_object()
  arg._set("index", @js.any(index))
  arg._set("value", @js.any(value))
  invoke_with_object(set_thumb_value, arg) |> ignore
}

///|
/// 指定された index の thumb のパーセンテージを設定
pub fn SliderApi::set_thumb_percent(self : SliderApi, index : Int, percent : Int) -> Unit {
  let set_thumb_percent = self.js_api._get("setThumbPercent")
  let arg = @js.new_object()
  arg._set("index", @js.any(index))
  arg._set("percent", @js.any(percent))
  invoke_with_object(set_thumb_percent, arg) |> ignore
}

///|
/// 指定された index の値を増分
pub fn SliderApi::increment(self : SliderApi, index : Int) -> Unit {
  let increment = self.js_api._get("increment")
  invoke_with_int(increment, index) |> ignore
}

///|
/// 指定された index の値を減分
pub fn SliderApi::decrement(self : SliderApi, index : Int) -> Unit {
  let decrement = self.js_api._get("decrement")
  invoke_with_int(decrement, index) |> ignore
}

///|
/// フォーカスを設定
pub fn SliderApi::focus(self : SliderApi) -> Unit {
  let focus = self.js_api._get("focus")
  invoke_no_args(focus) |> ignore
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn slider_connect(service : @js.Any) -> SliderApi {
  let normalize = create_normalize()
  let state = service._get("state")
  let send = service._get("send")
  let js_api = js_slider_connect(state, send, normalize)
  SliderApi::from_js(js_api)
}
