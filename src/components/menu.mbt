///|
/// @zag-js/menu の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/menu から machine 関数をインポート
#module("@zag-js/menu")
extern "js" fn js_menu_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/menu から connect 関数をインポート
#module("@zag-js/menu")
extern "js" fn js_menu_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/menu から normalize をインポート
#module("@zag-js/menu")
extern "js" fn js_menu_normalize() -> @js.Any =
  "normalize"

// ============================================================
// Menu Context 型
// ============================================================

///|
/// Menu のコンテキスト
pub(all) struct MenuContext {
  id : String
  close_on_select : Bool?
  loop_ : Bool?
  dir : String?
}

///|
/// MenuContext を JS オブジェクトに変換
pub fn MenuContext::to_js(self : MenuContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.close_on_select {
    Some(v) => obj._set("closeOnSelect", @js.any(v))
    None => ()
  }

  match self.loop_ {
    Some(v) => obj._set("loop", @js.any(v))
    None => ()
  }

  match self.dir {
    Some(v) => obj._set("dir", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Menu Item Context 型
// ============================================================

///|
/// Menu Item のコンテキスト
pub(all) struct MenuItemContext {
  id : String
  disabled : Bool?
  value : String?
}

///|
/// MenuItemContext を JS オブジェクトに変換
pub fn MenuItemContext::to_js(self : MenuItemContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.disabled {
    Some(v) => obj._set("disabled", @js.any(v))
    None => ()
  }

  match self.value {
    Some(v) => obj._set("value", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Menu Machine
// ============================================================

///|
/// Menu Machine を表す不透明型
#external
pub(all) type MenuMachine

///|
/// machine 関数を呼び出して Menu Machine を作成
pub fn MenuMachine::create(context : MenuContext) -> MenuMachine {
  let js_options = context.to_js()
  let js_machine = js_menu_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn MenuMachine::to_js(self : MenuMachine) -> @js.Any = "%identity"

// ============================================================
// Menu Item Machine
// ============================================================

///|
/// Menu Item Machine を表す不透明型
#external
pub(all) type MenuItemMachine

///|
/// machine 関数を呼び出して MenuItem Machine を作成
pub fn MenuItemMachine::create(context : MenuItemContext) -> MenuItemMachine {
  let js_options = context.to_js()
  let js_machine = js_menu_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Item Machine を JS 値に変換
pub fn MenuItemMachine::to_js(self : MenuItemMachine) -> @js.Any = "%identity"

// ============================================================
// Service 作成関数
// ============================================================

///|
/// Menu Service を作成（machine から）
pub fn menu_create_service(machine : MenuMachine) -> @js.Any {
  machine.to_js()
}

///|
/// Menu Item Service を作成（machine から）
pub fn menu_item_create_service(machine : MenuItemMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Menu API (connect の結果)
// ============================================================

///|
/// Menu API（connect が返すオブジェクト）
pub(all) struct MenuApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから MenuApi を作成
pub fn MenuApi::from_js(js_api : @js.Any) -> MenuApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn MenuApi::to_js(self : MenuApi) -> @js.Any {
  self.js_api
}

///|
/// getTriggerProps を取得
pub fn MenuApi::get_trigger_props(self : MenuApi) -> @js.Any {
  self.js_api._get("getTriggerProps")._invoke([])
}

///|
/// getContentProps を取得
pub fn MenuApi::get_content_props(self : MenuApi) -> @js.Any {
  self.js_api._get("getContentProps")._invoke([])
}

///|
/// open 状態を取得
pub fn MenuApi::is_open(self : MenuApi) -> Bool {
  let open = self.js_api._get("open")
  @js.any(open).cast()
}

// ============================================================
// Menu Item API
// ============================================================

///|
/// Menu Item API
pub(all) struct MenuItemApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから MenuItemApi を作成
pub fn MenuItemApi::from_js(js_api : @js.Any) -> MenuItemApi {
  { js_api, }
}

///|
/// Item API を JS 値に変換
pub fn MenuItemApi::to_js(self : MenuItemApi) -> @js.Any {
  self.js_api
}

///|
/// getItemProps を取得
pub fn MenuItemApi::get_item_props(self : MenuItemApi) -> @js.Any {
  self.js_api._get("getItemProps")._invoke([])
}

///|
/// getLabelProps を取得
pub fn MenuItemApi::get_label_props(self : MenuItemApi) -> @js.Any {
  self.js_api._get("getLabelProps")._invoke([])
}

///|
/// focused 状態を取得
pub fn MenuItemApi::is_focused(self : MenuItemApi) -> Bool {
  let focused = self.js_api._get("focused")
  @js.any(focused).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn menu_connect(service : @js.Any) -> MenuApi {
  let normalize = js_menu_normalize()
  let js_api = js_menu_connect(service, normalize)
  MenuApi::from_js(js_api)
}

///|
/// item service を connect して API を取得
pub fn menu_item_connect(service : @js.Any) -> MenuItemApi {
  let normalize = js_menu_normalize()
  let js_api = js_menu_connect(service, normalize)
  MenuItemApi::from_js(js_api)
}
