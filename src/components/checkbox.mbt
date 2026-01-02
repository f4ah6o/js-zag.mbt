///|
/// @zag-js/checkbox の FFI バインディング
/// js.mbt の設計思想に沿って実装
/// 参考: https://zenn.dev/mizchi/articles/moonbit-js-ffi

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/checkbox から machine 関数をインポート
#module("@zag-js/checkbox")
extern "js" fn js_checkbox_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/checkbox から connect 関数をインポート
// zag.js: connect(state, send, normalize) の3パラメータ
#module("@zag-js/checkbox")
extern "js" fn js_checkbox_connect(state : @js.Any, send : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// ============================================================
// Checkbox Context 型
// ============================================================

///|
/// Checkbox のコンテキスト
pub(all) struct CheckboxContext {
  id : String
  checked : Bool?
  default_checked : Bool?
  indeterminate : Bool?
  disabled : Bool?
  name : String?
  value : String?
  form : String?
  invalid : Bool?
  read_only : Bool?
  required : Bool?
  dir : String?
}

///|
/// CheckboxContext を JS オブジェクトに変換
pub fn CheckboxContext::to_js(self : CheckboxContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.checked {
    Some(v) => obj._set("checked", @js.any(v))
    None => ()
  }

  match self.default_checked {
    Some(v) => obj._set("defaultChecked", @js.any(v))
    None => ()
  }

  match self.indeterminate {
    Some(v) => obj._set("indeterminate", @js.any(v))
    None => ()
  }

  match self.disabled {
    Some(v) => obj._set("disabled", @js.any(v))
    None => ()
  }

  match self.name {
    Some(v) => obj._set("name", @js.any(v))
    None => ()
  }

  match self.value {
    Some(v) => obj._set("value", @js.any(v))
    None => ()
  }

  match self.form {
    Some(v) => obj._set("form", @js.any(v))
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

  match self.required {
    Some(v) => obj._set("required", @js.any(v))
    None => ()
  }

  match self.dir {
    Some(v) => obj._set("dir", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Checkbox Machine
// ============================================================

///|
/// Checkbox Machine を表す不透明型
#external
pub(all) type CheckboxMachine

///|
/// machine 関数を呼び出して Checkbox Machine を作成
pub fn CheckboxMachine::create(context : CheckboxContext) -> CheckboxMachine {
  let js_options = context.to_js()
  let js_machine = js_checkbox_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn CheckboxMachine::to_js(self : CheckboxMachine) -> @js.Any = "%identity"

// ============================================================
// Checkbox Service 作成関数
// ============================================================

///|
/// Checkbox Service を作成（machine から）
pub fn checkbox_create_service(machine : CheckboxMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Normalize Props (vanilla JS 用)
// ============================================================

// 自作 JS モジュールから invokeWithBool をインポート（setChecked用）
// create_normalize, invoke_no_args は switch.mbt で定義済み
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any =
  "invokeWithBool"

///|
/// JS 関数を Bool 引数で呼び出す
fn invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any {
  js_invoke_with_bool(func, value)
}

// ============================================================
// Checkbox API (connect の結果)
// ============================================================

///|
/// Checkbox API（connectが返すオブジェクト）
pub(all) struct CheckboxApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから CheckboxApi を作成
pub fn CheckboxApi::from_js(js_api : @js.Any) -> CheckboxApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn CheckboxApi::to_js(self : CheckboxApi) -> @js.Any {
  self.js_api
}

///|
/// rootProps を取得 (関数呼び出しが必要)
pub fn CheckboxApi::get_root_props(self : CheckboxApi) -> @js.Any {
  let get_root_props = self.js_api._get("getRootProps")
  invoke_no_args(get_root_props)
}

///|
/// labelProps を取得 (関数呼び出しが必要)
pub fn CheckboxApi::get_label_props(self : CheckboxApi) -> @js.Any {
  let get_label_props = self.js_api._get("getLabelProps")
  invoke_no_args(get_label_props)
}

///|
/// controlProps を取得 (関数呼び出しが必要)
pub fn CheckboxApi::get_control_props(self : CheckboxApi) -> @js.Any {
  let get_control_props = self.js_api._get("getControlProps")
  invoke_no_args(get_control_props)
}

///|
/// indicatorProps を取得 (関数呼び出しが必要)
pub fn CheckboxApi::get_indicator_props(self : CheckboxApi) -> @js.Any {
  let get_indicator_props = self.js_api._get("getIndicatorProps")
  invoke_no_args(get_indicator_props)
}

///|
/// inputProps を取得 (関数呼び出しが必要)
pub fn CheckboxApi::get_input_props(self : CheckboxApi) -> @js.Any {
  let get_input_props = self.js_api._get("getHiddenInputProps")
  invoke_no_args(get_input_props)
}

///|
/// checked 状態を取得
pub fn CheckboxApi::is_checked(self : CheckboxApi) -> Bool {
  let checked = self.js_api._get("checked")
  @js.any(checked).cast()
}

///|
/// disabled 状態を取得
pub fn CheckboxApi::is_disabled(self : CheckboxApi) -> Bool {
  let disabled = self.js_api._get("disabled")
  @js.any(disabled).cast()
}

///|
/// indeterminate 状態を取得
pub fn CheckboxApi::is_indeterminate(self : CheckboxApi) -> Bool {
  let indeterminate = self.js_api._get("indeterminate")
  @js.any(indeterminate).cast()
}

///|
/// focused 状態を取得
pub fn CheckboxApi::is_focused(self : CheckboxApi) -> Bool {
  let focused = self.js_api._get("focused")
  @js.any(focused).cast()
}

///|
/// checked 状態を設定
pub fn CheckboxApi::set_checked(self : CheckboxApi, checked : Bool) -> Unit {
  let set_checked = self.js_api._get("setChecked")
  invoke_with_bool(set_checked, checked) |> ignore
}

///|
/// checked 状態をトグル
pub fn CheckboxApi::toggle_checked(self : CheckboxApi) -> Unit {
  let toggle_checked = self.js_api._get("toggleChecked")
  invoke_no_args(toggle_checked) |> ignore
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
/// zag.js: service から state と send を取り出して connect に渡す
pub fn checkbox_connect(service : @js.Any) -> CheckboxApi {
  let normalize = create_normalize()
  let state = service._get("state")
  let send = service._get("send")
  let js_api = js_checkbox_connect(state, send, normalize)
  CheckboxApi::from_js(js_api)
}
