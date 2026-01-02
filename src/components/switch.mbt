///|
/// @zag-js/switch の FFI バインディング
/// js.mbt の設計思想に沿って実装
/// 参考: https://zenn.dev/mizchi/articles/moonbit-js-ffi

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/switch から machine 関数をインポート
#module("@zag-js/switch")
extern "js" fn js_switch_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/switch から connect 関数をインポート
#module("@zag-js/switch")
extern "js" fn js_switch_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/switch から normalize をインポート
#module("@zag-js/switch")
extern "js" fn js_switch_normalize() -> @js.Any =
  "normalize"

///|
/// @zag-js/switch の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// Switch Context 型
// ============================================================

///|
/// Switch のコンテキスト
pub(all) struct SwitchContext {
  id : String
  checked : Bool?
  default_checked : Bool?
  disabled : Bool?
  name : String?
  value : String?
  form : String?
}

///|
/// SwitchContext を JS オブジェクトに変換
pub fn SwitchContext::to_js(self : SwitchContext) -> @js.Any {
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

  obj
}

// ============================================================
// Switch Machine
// ============================================================

///|
/// Switch Machine を表す不透明型
#external
pub(all) type SwitchMachine

///|
/// machine 関数を呼び出して Switch Machine を作成
pub fn SwitchMachine::create(context : SwitchContext) -> SwitchMachine {
  let js_options = context.to_js()
  let js_machine = js_switch_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn SwitchMachine::to_js(self : SwitchMachine) -> @js.Any = "%identity"

// ============================================================
// Switch Service 作成関数
// ============================================================

///|
/// Switch Service を作成（machine から）
pub fn switch_create_service(machine : SwitchMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Switch API (connect の結果)
// ============================================================

///|
/// Switch API（connectが返すオブジェクト）
pub(all) struct SwitchApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから SwitchApi を作成
pub fn SwitchApi::from_js(js_api : @js.Any) -> SwitchApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn SwitchApi::to_js(self : SwitchApi) -> @js.Any {
  self.js_api
}

///|
/// rootProps を取得
pub fn SwitchApi::get_root_props(self : SwitchApi) -> @js.Any {
  self.js_api._get("rootProps")
}

///|
/// controlProps を取得
pub fn SwitchApi::get_control_props(self : SwitchApi) -> @js.Any {
  self.js_api._get("controlProps")
}

///|
/// thumbProps を取得
pub fn SwitchApi::get_thumb_props(self : SwitchApi) -> @js.Any {
  self.js_api._get("thumbProps")
}

///|
/// inputProps を取得
pub fn SwitchApi::get_input_props(self : SwitchApi) -> @js.Any {
  self.js_api._get("inputProps")
}

///|
/// checked 状態を取得
pub fn SwitchApi::is_checked(self : SwitchApi) -> Bool {
  let checked = self.js_api._get("checked")
  @js.any(checked).cast()
}

///|
/// disabled 状態を取得
pub fn SwitchApi::is_disabled(self : SwitchApi) -> Bool {
  let disabled = self.js_api._get("disabled")
  @js.any(disabled).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn switch_connect(service : @js.Any) -> SwitchApi {
  let normalize = js_switch_normalize()
  let js_api = js_switch_connect(service, normalize)
  SwitchApi::from_js(js_api)
}
