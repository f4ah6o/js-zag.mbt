///|
/// @zag-js/tabs の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/tabs から machine 関数をインポート
#module("@zag-js/tabs")
extern "js" fn js_tabs_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/tabs から connect 関数をインポート
#module("@zag-js/tabs")
extern "js" fn js_tabs_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/tabs から normalize をインポート
#module("@zag-js/tabs")
extern "js" fn js_tabs_normalize() -> @js.Any =
  "normalize"

// ============================================================
// Tabs Context 型
// ============================================================

///|
/// Tabs のコンテキスト
pub(all) struct TabsContext {
  id : String
  value : String?
  default_value : String?
  loop_ : Bool?
}

///|
/// TabsContext を JS オブジェクトに変換
pub fn TabsContext::to_js(self : TabsContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.value {
    Some(v) => obj._set("value", @js.any(v))
    None => ()
  }

  match self.default_value {
    Some(v) => obj._set("defaultValue", @js.any(v))
    None => ()
  }

  match self.loop_ {
    Some(v) => obj._set("loop", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Tabs Machine
// ============================================================

///|
/// Tabs Machine を表す不透明型
#external
pub(all) type TabsMachine

///|
/// machine 関数を呼び出して Tabs Machine を作成
pub fn TabsMachine::create(context : TabsContext) -> TabsMachine {
  let js_options = context.to_js()
  let js_machine = js_tabs_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn TabsMachine::to_js(self : TabsMachine) -> @js.Any = "%identity"

// ============================================================
// Service 作成関数
// ============================================================

///|
/// Tabs Service を作成（machine から）
pub fn tabs_create_service(machine : TabsMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Tabs API (connect の結果)
// ============================================================

///|
/// Tabs API（connect が返すオブジェクト）
pub(all) struct TabsApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから TabsApi を作成
pub fn TabsApi::from_js(js_api : @js.Any) -> TabsApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn TabsApi::to_js(self : TabsApi) -> @js.Any {
  self.js_api
}

///|
/// getRootProps を取得
pub fn TabsApi::get_root_props(self : TabsApi) -> @js.Any {
  self.js_api._get("getRootProps")._invoke([])
}

///|
/// getTriggerProps を取得（value付き）
pub fn TabsApi::get_trigger_props(self : TabsApi, value : String) -> @js.Any {
  let options = @js.new_object()
  options._set("value", @js.any(value))
  self.js_api._get("getTriggerProps")._invoke([options])
}

///|
/// getContentProps を取得（value付き）
pub fn TabsApi::get_content_props(self : TabsApi, value : String) -> @js.Any {
  let options = @js.new_object()
  options._set("value", @js.any(value))
  self.js_api._get("getContentProps")._invoke([options])
}

///|
/// getTabListProps を取得
pub fn TabsApi::get_tab_list_props(self : TabsApi) -> @js.Any {
  self.js_api._get("getTabListProps")._invoke([])
}

///|
/// value を取得
pub fn TabsApi::get_value(self : TabsApi) -> String {
  let value = self.js_api._get("value")
  @js.any(value).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn tabs_connect(service : @js.Any) -> TabsApi {
  let normalize = js_tabs_normalize()
  let js_api = js_tabs_connect(service, normalize)
  TabsApi::from_js(js_api)
}
