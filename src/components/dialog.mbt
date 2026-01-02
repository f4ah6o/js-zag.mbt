///|
/// @zag-js/dialog の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/dialog から machine 関数をインポート
#module("@zag-js/dialog")
extern "js" fn js_dialog_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/dialog から connect 関数をインポート
#module("@zag-js/dialog")
extern "js" fn js_dialog_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/dialog から normalize をインポート
#module("@zag-js/dialog")
extern "js" fn js_dialog_normalize() -> @js.Any =
  "normalize"

// ============================================================
// Dialog Context 型
// ============================================================

///|
/// Dialog のコンテキスト
pub(all) struct DialogContext {
  id : String
  role : String?
  close_on_interact_outside : Bool?
  close_on_escape : Bool?
  trap_focus : Bool?
  persistent : Bool?
  lazy_mount : Bool?
}

///|
/// DialogContext を JS オブジェクトに変換
pub fn DialogContext::to_js(self : DialogContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.role {
    Some(v) => obj._set("role", @js.any(v))
    None => ()
  }

  match self.close_on_interact_outside {
    Some(v) => obj._set("closeOnInteractOutside", @js.any(v))
    None => ()
  }

  match self.close_on_escape {
    Some(v) => obj._set("closeOnEscape", @js.any(v))
    None => ()
  }

  match self.trap_focus {
    Some(v) => obj._set("trapFocus", @js.any(v))
    None => ()
  }

  match self.persistent {
    Some(v) => obj._set("persistent", @js.any(v))
    None => ()
  }

  match self.lazy_mount {
    Some(v) => obj._set("lazyMount", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Dialog Machine
// ============================================================

///|
/// Dialog Machine を表す不透明型
#external
pub(all) type DialogMachine

///|
/// machine 関数を呼び出して Dialog Machine を作成
pub fn DialogMachine::create(context : DialogContext) -> DialogMachine {
  let js_options = context.to_js()
  let js_machine = js_dialog_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn DialogMachine::to_js(self : DialogMachine) -> @js.Any = "%identity"

// ============================================================
// Service 作成関数
// ============================================================

///|
/// Dialog Service を作成（machine から）
pub fn dialog_create_service(machine : DialogMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Dialog API (connect の結果)
// ============================================================

///|
/// Dialog API（connect が返すオブジェクト）
pub(all) struct DialogApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから DialogApi を作成
pub fn DialogApi::from_js(js_api : @js.Any) -> DialogApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn DialogApi::to_js(self : DialogApi) -> @js.Any {
  self.js_api
}

///|
/// getRootProps を取得
pub fn DialogApi::get_root_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getRootProps")._invoke([])
}

///|
/// getBackdropProps を取得
pub fn DialogApi::get_backdrop_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getBackdropProps")._invoke([])
}

///|
/// getContentProps を取得
pub fn DialogApi::get_content_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getContentProps")._invoke([])
}

///|
/// getTitleProps を取得
pub fn DialogApi::get_title_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getTitleProps")._invoke([])
}

///|
/// getDescriptionProps を取得
pub fn DialogApi::get_description_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getDescriptionProps")._invoke([])
}

///|
/// getTriggerProps を取得
pub fn DialogApi::get_trigger_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getTriggerProps")._invoke([])
}

///|
/// getCloseTriggerProps を取得
pub fn DialogApi::get_close_trigger_props(self : DialogApi) -> @js.Any {
  self.js_api._get("getCloseTriggerProps")._invoke([])
}

///|
/// open 状態を取得
pub fn DialogApi::is_open(self : DialogApi) -> Bool {
  let open = self.js_api._get("open")
  @js.any(open).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn dialog_connect(service : @js.Any) -> DialogApi {
  let normalize = js_dialog_normalize()
  let js_api = js_dialog_connect(service, normalize)
  DialogApi::from_js(js_api)
}
