///|
/// @zag-js/accordion デモ
/// MoonBit から zag.js Accordion を使用する例

// ============================================================
// デモエントリーポイント
// ============================================================

///|
/// Accordion デモのメイン関数
pub fn accordion_demo() -> Unit {
  // Context を作成
  let context = AccordionContext::{
    id: "accordion-demo",
    collapsible: Some(true),
    multiple: Some(false),
  }

  // Machine を作成
  let machine = AccordionMachine::create(context)

  // Service を作成
  let js_service = accordion_create_service(machine)

  // Connect して API を取得
  let api = accordion_connect(js_service)

  // 状態を確認
  @js.log(@js.any("=== Accordion Demo ==="))

  let root_props = api.get_root_props()
  @js.log(@js.any("Root Props:"))
  @js.log(root_props)

  // Item Context を作成
  let item_context = AccordionItemContext::{
    id: "item-1",
    disabled: Some(false),
  }

  // Item Machine を作成
  let item_machine = AccordionItemMachine::create(item_context)
  let item_service = accordion_item_create_service(item_machine)
  let item_api = accordion_item_connect(item_service)

  // Item Props を取得
  let item_root_props = item_api.get_root_props()
  @js.log(@js.any("Item Root Props:"))
  @js.log(item_root_props)

  let trigger_props = item_api.get_trigger_props()
  @js.log(@js.any("Trigger Props:"))
  @js.log(trigger_props)

  let content_props = item_api.get_content_props()
  @js.log(@js.any("Content Props:"))
  @js.log(content_props)

  // 状態チェック
  let expanded = item_api.is_expanded()
  @js.log(@js.any("Expanded:"))
  @js.log(@js.any(expanded))
}
