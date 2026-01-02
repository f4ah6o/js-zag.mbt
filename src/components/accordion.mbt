///|
/// @zag-js/accordion の FFI バインディング
/// js.mbt の設計思想に沿って実装

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/accordion から machine 関数をインポート
#module("@zag-js/accordion")
extern "js" fn js_accordion_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/accordion から connect 関数をインポート
#module("@zag-js/accordion")
extern "js" fn js_accordion_connect(service : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/accordion から normalize をインポート
#module("@zag-js/accordion")
extern "js" fn js_accordion_normalize() -> @js.Any =
  "normalize"

// ============================================================
// Accordion Context 型
// ============================================================

///|
/// Accordion のコンテキスト
pub(all) struct AccordionContext {
  id : String
  collapsible : Bool?
  multiple : Bool?
}

///|
/// AccordionContext を JS オブジェクトに変換
pub fn AccordionContext::to_js(self : AccordionContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.collapsible {
    Some(v) => obj._set("collapsible", @js.any(v))
    None => ()
  }

  match self.multiple {
    Some(v) => obj._set("multiple", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Accordion Item Context 型
// ============================================================

///|
/// Accordion Item のコンテキスト
pub(all) struct AccordionItemContext {
  id : String
  disabled : Bool?
}

///|
/// AccordionItemContext を JS オブジェクトに変換
pub fn AccordionItemContext::to_js(self : AccordionItemContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))

  // オプションフィールド
  match self.disabled {
    Some(v) => obj._set("disabled", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Accordion Machine
// ============================================================

///|
/// Accordion Machine を表す不透明型
#external
pub(all) type AccordionMachine

///|
/// machine 関数を呼び出して Accordion Machine を作成
pub fn AccordionMachine::create(context : AccordionContext) -> AccordionMachine {
  let js_options = context.to_js()
  let js_machine = js_accordion_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn AccordionMachine::to_js(self : AccordionMachine) -> @js.Any = "%identity"

// ============================================================
// Accordion Item Machine
// ============================================================

///|
/// Accordion Item Machine を表す不透明型
#external
pub(all) type AccordionItemMachine

///|
/// machine 関数を呼び出して AccordionItem Machine を作成
pub fn AccordionItemMachine::create(context : AccordionItemContext) -> AccordionItemMachine {
  let js_options = context.to_js()
  let js_machine = js_accordion_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Item Machine を JS 値に変換
pub fn AccordionItemMachine::to_js(self : AccordionItemMachine) -> @js.Any = "%identity"

// ============================================================
// Service 作成関数
// ============================================================

///|
/// Accordion Service を作成（machine から）
pub fn accordion_create_service(machine : AccordionMachine) -> @js.Any {
  machine.to_js()
}

///|
/// Accordion Item Service を作成（machine から）
pub fn accordion_item_create_service(machine : AccordionItemMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Accordion API (connect の結果)
// ============================================================

///|
/// Accordion API（connect が返すオブジェクトクト）
pub(all) struct AccordionApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから AccordionApi を作成
pub fn AccordionApi::from_js(js_api : @js.Any) -> AccordionApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn AccordionApi::to_js(self : AccordionApi) -> @js.Any {
  self.js_api
}

///|
/// getRootProps を取得
pub fn AccordionApi::get_root_props(self : AccordionApi) -> @js.Any {
  self.js_api._get("getRootProps")._invoke([])
}

///|
/// getItemProps を取得
pub fn AccordionApi::get_item_props(self : AccordionApi, options : @js.Any) -> @js.Any {
  self.js_api._get("getItemProps")._invoke([options])
}

///|
/// getContentProps を取得
pub fn AccordionApi::get_content_props(self : AccordionApi, options : @js.Any) -> @js.Any {
  self.js_api._get("getContentProps")._invoke([options])
}

///|
/// getTriggerProps を取得
pub fn AccordionApi::get_trigger_props(self : AccordionApi, options : @js.Any) -> @js.Any {
  self.js_api._get("getTriggerProps")._invoke([options])
}

// ============================================================
// Accordion Item API
// ============================================================

///|
/// Accordion Item API
pub(all) struct AccordionItemApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから AccordionItemApi を作成
pub fn AccordionItemApi::from_js(js_api : @js.Any) -> AccordionItemApi {
  { js_api, }
}

///|
/// Item API を JS 値に変換
pub fn AccordionItemApi::to_js(self : AccordionItemApi) -> @js.Any {
  self.js_api
}

///|
/// getRootProps を取得
pub fn AccordionItemApi::get_root_props(self : AccordionItemApi) -> @js.Any {
  self.js_api._get("getRootProps")._invoke([])
}

///|
/// getContentProps を取得
pub fn AccordionItemApi::get_content_props(self : AccordionItemApi) -> @js.Any {
  self.js_api._get("getContentProps")._invoke([])
}

///|
/// getTriggerProps を取得
pub fn AccordionItemApi::get_trigger_props(self : AccordionItemApi) -> @js.Any {
  self.js_api._get("getTriggerProps")._invoke([])
}

///|
/// expanded 状態を取得
pub fn AccordionItemApi::is_expanded(self : AccordionItemApi) -> Bool {
  let expanded = self.js_api._get("expanded")
  @js.any(expanded).cast()
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
pub fn accordion_connect(service : @js.Any) -> AccordionApi {
  let normalize = js_accordion_normalize()
  let js_api = js_accordion_connect(service, normalize)
  AccordionApi::from_js(js_api)
}

///|
/// item service を connect して API を取得
pub fn accordion_item_connect(service : @js.Any) -> AccordionItemApi {
  let normalize = js_accordion_normalize()
  let js_api = js_accordion_connect(service, normalize)
  AccordionItemApi::from_js(js_api)
}
