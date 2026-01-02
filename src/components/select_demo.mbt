///|
/// @zag-js/select デモ
/// MoonBit から zag.js Select を使用する例

// ============================================================
// デモエントリーポイント
// ============================================================

///|
/// Select デモのメイン関数
pub fn select_demo() -> Unit {
  // Select アイテムデータを JS 配列として作成
  let items_array = @js.new_array()

  // アイテムを追加
  let item1 = @js.new_object()
  item1._set("label", @js.any("Nigeria"))
  item1._set("value", @js.any("NG"))
  items_array._push(@js.any(item1))

  let item2 = @js.new_object()
  item2._set("label", @js.any("Japan"))
  item2._set("value", @js.any("JP"))
  items_array._push(@js.any(item2))

  let item3 = @js.new_object()
  item3._set("label", @js.any("Korea"))
  item3._set("value", @js.any("KO"))
  items_array._push(@js.any(item3))

  let item4 = @js.new_object()
  item4._set("label", @js.any("Kenya"))
  item4._set("value", @js.any("KE"))
  items_array._push(@js.any(item4))

  let item5 = @js.new_object()
  item5._set("label", @js.any("United Kingdom"))
  item5._set("value", @js.any("UK"))
  items_array._push(@js.any(item5))

  // Collection を作成
  let collection_options = SelectCollectionOptions::{
    items: items_array,
    item_to_string: None,
    item_to_value: None,
    item_to_disabled: None,
    group_by: None,
    group_sort: None,
  }

  let collection = select_collection(collection_options)

  // Context を作成
  let context = SelectContext::{
    id: "select-demo",
    collection: collection,
    name: Some("country"),
    form: None,
    disabled: Some(false),
    invalid: None,
    read_only: None,
    required: None,
    multiple: Some(false),
    default_value: None,
    value: None,
    close_on_select: None,
    loop_focus: None,
    deselectable: None,
    composite: None,
    dir: None,
  }

  // Machine を作成
  let machine = SelectMachine::create(context)

  // Service を作成
  let js_service = select_create_service(machine)

  // Connect して API を取得
  let api = select_connect(js_service)

  // 状態を確認
  @js.log(@js.any("=== Select Demo ==="))

  let root_props = api.get_root_props()
  @js.log(@js.any("Root Props:"))
  @js.log(root_props)

  let label_props = api.get_label_props()
  @js.log(@js.any("Label Props:"))
  @js.log(label_props)

  let control_props = api.get_control_props()
  @js.log(@js.any("Control Props:"))
  @js.log(control_props)

  let trigger_props = api.get_trigger_props()
  @js.log(@js.any("Trigger Props:"))
  @js.log(trigger_props)

  let positioner_props = api.get_positioner_props()
  @js.log(@js.any("Positioner Props:"))
  @js.log(positioner_props)

  let content_props = api.get_content_props()
  @js.log(@js.any("Content Props:"))
  @js.log(content_props)

  // Item Props を取得
  let item_props = api.get_item_props(item1)
  @js.log(@js.any("Item Props (Nigeria):"))
  @js.log(item_props)

  let item_text_props = api.get_item_text_props(item1)
  @js.log(@js.any("Item Text Props:"))
  @js.log(item_text_props)

  let item_indicator_props = api.get_item_indicator_props(item1)
  @js.log(@js.any("Item Indicator Props:"))
  @js.log(item_indicator_props)

  // Hidden Select Props
  let hidden_select_props = api.get_hidden_select_props()
  @js.log(@js.any("Hidden Select Props:"))
  @js.log(hidden_select_props)

  // 状態チェック
  let open = api.is_open()
  @js.log(@js.any("Open:"))
  @js.log(@js.any(open))

  let empty = api.is_empty()
  @js.log(@js.any("Empty:"))
  @js.log(@js.any(empty))

  let disabled = api.is_disabled()
  @js.log(@js.any("Disabled:"))
  @js.log(@js.any(disabled))

  let multiple = api.is_multiple()
  @js.log(@js.any("Multiple:"))
  @js.log(@js.any(multiple))

  let has_selected_items = api.has_selected_items()
  @js.log(@js.any("Has Selected Items:"))
  @js.log(@js.any(has_selected_items))

  let value_as_string = api.get_value_as_string()
  @js.log(@js.any("Value As String:"))
  @js.log(@js.any(value_as_string))

  // 値を選択して状態を確認
  api.select_value("JP")
  let new_value_as_string = api.get_value_as_string()
  @js.log(@js.any("After selecting JP - Value As String:"))
  @js.log(@js.any(new_value_as_string))

  let has_selected_after = api.has_selected_items()
  @js.log(@js.any("Has Selected Items (after selection):"))
  @js.log(@js.any(has_selected_after))
}
