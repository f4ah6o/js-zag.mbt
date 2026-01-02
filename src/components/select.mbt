///|
/// @zag-js/select の FFI バインディング
/// js.mbt の設計思想に沿って実装
/// 参考: https://zenn.dev/mizchi/articles/moonbit-js-ffi

// ============================================================
// ESM インポート
// ============================================================

// @zag-js/select から machine 関数をインポート
#module("@zag-js/select")
extern "js" fn js_select_machine(options : @js.Any) -> @js.Any =
  "machine"

// @zag-js/select から connect 関数をインポート
// zag.js: connect(state, send, normalize) の3パラメータ
#module("@zag-js/select")
extern "js" fn js_select_connect(state : @js.Any, send : @js.Any, normalize : @js.Any) -> @js.Any =
  "connect"

// @zag-js/select から collection 関数をインポート
#module("@zag-js/select")
extern "js" fn js_select_collection(options : @js.Any) -> @js.Any =
  "collection"

// ============================================================
// Select Context 型
// ============================================================

///|
/// Select のコンテキスト
pub(all) struct SelectContext {
  id : String
  collection : @js.Any
  name : String?
  form : String?
  disabled : Bool?
  invalid : Bool?
  read_only : Bool?
  required : Bool?
  multiple : Bool?
  default_value : Array[String]?
  value : Array[String]?
  close_on_select : Bool?
  loop_focus : Bool?
  deselectable : Bool?
  composite : Bool?
  dir : String?
}

///|
/// SelectContext を JS オブジェクトに変換
pub fn SelectContext::to_js(self : SelectContext) -> @js.Any {
  let obj = @js.new_object()

  // 必須フィールド
  obj._set("id", @js.any(self.id))
  obj._set("collection", self.collection)

  // オプションフィールド
  match self.name {
    Some(v) => obj._set("name", @js.any(v))
    None => ()
  }

  match self.form {
    Some(v) => obj._set("form", @js.any(v))
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

  match self.required {
    Some(v) => obj._set("required", @js.any(v))
    None => ()
  }

  match self.multiple {
    Some(v) => obj._set("multiple", @js.any(v))
    None => ()
  }

  match self.default_value {
    Some(v) => obj._set("defaultValue", @js.any(v))
    None => ()
  }

  match self.value {
    Some(v) => obj._set("value", @js.any(v))
    None => ()
  }

  match self.close_on_select {
    Some(v) => obj._set("closeOnSelect", @js.any(v))
    None => ()
  }

  match self.loop_focus {
    Some(v) => obj._set("loopFocus", @js.any(v))
    None => ()
  }

  match self.deselectable {
    Some(v) => obj._set("deselectable", @js.any(v))
    None => ()
  }

  match self.composite {
    Some(v) => obj._set("composite", @js.any(v))
    None => ()
  }

  match self.dir {
    Some(v) => obj._set("dir", @js.any(v))
    None => ()
  }

  obj
}

// ============================================================
// Select Collection
// ============================================================

///|
/// Select Collection を作成するためのオプション
pub(all) struct SelectCollectionOptions {
  items : @js.Any
  item_to_string : @js.Any?
  item_to_value : @js.Any?
  item_to_disabled : @js.Any?
  group_by : @js.Any?
  group_sort : @js.Any?
}

///|
/// Select Collection を作成
pub fn select_collection(options : SelectCollectionOptions) -> @js.Any {
  let obj = @js.new_object()

  obj._set("items", options.items)

  match options.item_to_string {
    Some(v) => obj._set("itemToString", v)
    None => ()
  }

  match options.item_to_value {
    Some(v) => obj._set("itemToValue", v)
    None => ()
  }

  match options.item_to_disabled {
    Some(v) => obj._set("isItemDisabled", v)
    None => ()
  }

  match options.group_by {
    Some(v) => obj._set("groupBy", v)
    None => ()
  }

  match options.group_sort {
    Some(v) => obj._set("groupSort", v)
    None => ()
  }

  js_select_collection(obj)
}

// ============================================================
// Select Machine
// ============================================================

///|
/// Select Machine を表す不透明型
#external
pub(all) type SelectMachine

///|
/// machine 関数を呼び出して Select Machine を作成
pub fn SelectMachine::create(context : SelectContext) -> SelectMachine {
  let js_options = context.to_js()
  let js_machine = js_select_machine(js_options)
  @js.identity(js_machine)
}

///|
/// Machine を JS 値に変換
pub fn SelectMachine::to_js(self : SelectMachine) -> @js.Any = "%identity"

// ============================================================
// Select Service 作成関数
// ============================================================

///|
/// Select Service を作成（machine から）
pub fn select_create_service(machine : SelectMachine) -> @js.Any {
  machine.to_js()
}

// ============================================================
// Normalize Props (vanilla JS 用)
// ============================================================

// 自作 JS モジュールから invokeWithObject をインポート（getItemProps用）
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any =
  "invokeWithObject"

// 自作 JS モジュールから invokeWithStringArray をインポート
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_string_array(func : @js.Any, arg : @js.Any) -> @js.Any =
  "invokeWithStringArray"

///|
/// JS 関数をオブジェクト引数で呼び出す
fn invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any {
  js_invoke_with_object(func, arg)
}

///|
/// JS 関数を文字列配列引数で呼び出す
fn invoke_with_string_array(func : @js.Any, arg : @js.Any) -> @js.Any {
  js_invoke_with_string_array(func, arg)
}

///|
/// JS 関数を引数なしで呼び出す（既存のcheckbox.mbtで定義済み）
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_no_args(func : @js.Any) -> @js.Any =
  "invokeNoArgs"

///|
/// JS 関数を引数なしで呼び出す
fn invoke_no_args(func : @js.Any) -> @js.Any {
  js_invoke_no_args(func)
}

///|
/// vanilla JS 用の normalize オブジェクトを作成（既存のswitch.mbtで定義済み）
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_create_normalize() -> @js.Any =
  "createNormalize"

///|
/// vanilla JS 用の normalize オブジェクトを作成
fn create_normalize() -> @js.Any {
  js_create_normalize()
}

// ============================================================
// Select API (connect の結果)
// ============================================================

///|
/// Select API（connectが返すオブジェクト）
pub(all) struct SelectApi {
  js_api : @js.Any
}

///|
/// JS API オブジェクトから SelectApi を作成
pub fn SelectApi::from_js(js_api : @js.Any) -> SelectApi {
  { js_api, }
}

///|
/// API を JS 値に変換
pub fn SelectApi::to_js(self : SelectApi) -> @js.Any {
  self.js_api
}

// --- Props 取得メソッド ---

///|
/// rootProps を取得
pub fn SelectApi::get_root_props(self : SelectApi) -> @js.Any {
  let get_root_props = self.js_api._get("getRootProps")
  invoke_no_args(get_root_props)
}

///|
/// labelProps を取得
pub fn SelectApi::get_label_props(self : SelectApi) -> @js.Any {
  let get_label_props = self.js_api._get("getLabelProps")
  invoke_no_args(get_label_props)
}

///|
/// controlProps を取得
pub fn SelectApi::get_control_props(self : SelectApi) -> @js.Any {
  let get_control_props = self.js_api._get("getControlProps")
  invoke_no_args(get_control_props)
}

///|
/// triggerProps を取得
pub fn SelectApi::get_trigger_props(self : SelectApi) -> @js.Any {
  let get_trigger_props = self.js_api._get("getTriggerProps")
  invoke_no_args(get_trigger_props)
}

///|
/// positionerProps を取得
pub fn SelectApi::get_positioner_props(self : SelectApi) -> @js.Any {
  let get_positioner_props = self.js_api._get("getPositionerProps")
  invoke_no_args(get_positioner_props)
}

///|
/// contentProps を取得
pub fn SelectApi::get_content_props(self : SelectApi) -> @js.Any {
  let get_content_props = self.js_api._get("getContentProps")
  invoke_no_args(get_content_props)
}

///|
/// itemProps を取得（itemを引数に渡す）
pub fn SelectApi::get_item_props(self : SelectApi, item : @js.Any) -> @js.Any {
  let get_item_props = self.js_api._get("getItemProps")
  let arg = @js.new_object()
  arg._set("item", item)
  invoke_with_object(get_item_props, arg)
}

///|
/// itemTextProps を取得（itemを引数に渡す）
pub fn SelectApi::get_item_text_props(self : SelectApi, item : @js.Any) -> @js.Any {
  let get_item_text_props = self.js_api._get("getItemTextProps")
  let arg = @js.new_object()
  arg._set("item", item)
  invoke_with_object(get_item_text_props, arg)
}

///|
/// itemIndicatorProps を取得（itemを引数に渡す）
pub fn SelectApi::get_item_indicator_props(self : SelectApi, item : @js.Any) -> @js.Any {
  let get_item_indicator_props = self.js_api._get("getItemIndicatorProps")
  let arg = @js.new_object()
  arg._set("item", item)
  invoke_with_object(get_item_indicator_props, arg)
}

///|
/// itemGroupProps を取得（idを引数に渡す）
pub fn SelectApi::get_item_group_props(self : SelectApi, id : String) -> @js.Any {
  let get_item_group_props = self.js_api._get("getItemGroupProps")
  let arg = @js.new_object()
  arg._set("id", @js.any(id))
  invoke_with_object(get_item_group_props, arg)
}

///|
/// hiddenSelectProps を取得
pub fn SelectApi::get_hidden_select_props(self : SelectApi) -> @js.Any {
  let get_hidden_select_props = self.js_api._get("getHiddenSelectProps")
  invoke_no_args(get_hidden_select_props)
}

///|
/// clearTriggerProps を取得
pub fn SelectApi::get_clear_trigger_props(self : SelectApi) -> @js.Any {
  let get_clear_trigger_props = self.js_api._get("getClearTriggerProps")
  invoke_no_args(get_clear_trigger_props)
}

// --- 状態取得メソッド ---

///|
/// focused 状態を取得
pub fn SelectApi::is_focused(self : SelectApi) -> Bool {
  let focused = self.js_api._get("focused")
  @js.any(focused).cast()
}

///|
/// open 状態を取得
pub fn SelectApi::is_open(self : SelectApi) -> Bool {
  let open = self.js_api._get("open")
  @js.any(open).cast()
}

///|
/// empty 状態を取得
pub fn SelectApi::is_empty(self : SelectApi) -> Bool {
  let empty = self.js_api._get("empty")
  @js.any(empty).cast()
}

///|
/// disabled 状態を取得
pub fn SelectApi::is_disabled(self : SelectApi) -> Bool {
  let disabled = self.js_api._get("disabled")
  @js.any(disabled).cast()
}

///|
/// multiple 状態を取得
pub fn SelectApi::is_multiple(self : SelectApi) -> Bool {
  let multiple = self.js_api._get("multiple")
  @js.any(multiple).cast()
}

///|
/// hasSelectedItems 状態を取得
pub fn SelectApi::has_selected_items(self : SelectApi) -> Bool {
  let has_selected_items = self.js_api._get("hasSelectedItems")
  @js.any(has_selected_items).cast()
}

///|
/// highlightedValue を取得
pub fn SelectApi::get_highlighted_value(self : SelectApi) -> String {
  let highlighted_value = self.js_api._get("highlightedValue")
  @js.any(highlighted_value).cast()
}

///|
/// valueAsString を取得
pub fn SelectApi::get_value_as_string(self : SelectApi) -> String {
  let value_as_string = self.js_api._get("valueAsString")
  @js.any(value_as_string).cast()
}

///|
/// value を取得（配列として）
pub fn SelectApi::get_value(self : SelectApi) -> Array[String] {
  let value = self.js_api._get("value")
  @js.any(value).cast()
}

// --- アクションメソッド ---

// 自作 JS モジュールから invokeWithString をインポート（setValue用）
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_string(func : @js.Any, value : String) -> @js.Any =
  "invokeWithString"

///|
/// JS 関数を文字列引数で呼び出す
fn invoke_with_string(func : @js.Any, value : String) -> @js.Any {
  js_invoke_with_string(func, value)
}

// 自作 JS モジュールから invokeWithBool をインポート（setOpen用）
#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any =
  "invokeWithBool"

///|
/// JS 関数を Bool 引数で呼び出す
fn invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any {
  js_invoke_with_bool(func, value)
}

///|
/// value を設定
pub fn SelectApi::set_value(self : SelectApi, value : Array[String]) -> Unit {
  let set_value = self.js_api._get("setValue")
  invoke_with_string_array(set_value, @js.any(value)) |> ignore
}

///|
/// 特定の値を選択
pub fn SelectApi::select_value(self : SelectApi, value : String) -> Unit {
  let select_value = self.js_api._get("selectValue")
  invoke_with_string(select_value, value) |> ignore
}

///|
/// すべてを選択（multipleモードのみ）
pub fn SelectApi::select_all(self : SelectApi) -> Unit {
  let select_all = self.js_api._get("selectAll")
  invoke_no_args(select_all) |> ignore
}

///|
/// 値をクリア
pub fn SelectApi::clear_value(self : SelectApi) -> Unit {
  let clear_value = self.js_api._get("clearValue")
  invoke_no_args(clear_value) |> ignore
}

///|
/// ハイライト値を設定
pub fn SelectApi::set_highlight_value(self : SelectApi, value : String) -> Unit {
  let set_highlight_value = self.js_api._get("setHighlightValue")
  invoke_with_string(set_highlight_value, value) |> ignore
}

///|
/// ハイライト値をクリア
pub fn SelectApi::clear_highlight_value(self : SelectApi) -> Unit {
  let clear_highlight_value = self.js_api._get("clearHighlightValue")
  invoke_no_args(clear_highlight_value) |> ignore
}

///|
/// open 状態を設定
pub fn SelectApi::set_open(self : SelectApi, open : Bool) -> Unit {
  let set_open = self.js_api._get("setOpen")
  invoke_with_bool(set_open, open) |> ignore
}

///|
/// フォーカスを設定
pub fn SelectApi::focus(self : SelectApi) -> Unit {
  let focus = self.js_api._get("focus")
  invoke_no_args(focus) |> ignore
}

///|
/// 再配置
pub fn SelectApi::reposition(self : SelectApi) -> Unit {
  let reposition = self.js_api._get("reposition")
  invoke_no_args(reposition) |> ignore
}

// ============================================================
// Connect 関数
// ============================================================

///|
/// service を connect して API を取得
/// zag.js: service から state と send を取り出して connect に渡す
pub fn select_connect(service : @js.Any) -> SelectApi {
  let normalize = create_normalize()
  let state = service._get("state")
  let send = service._get("send")
  let js_api = js_select_connect(state, send, normalize)
  SelectApi::from_js(js_api)
}
