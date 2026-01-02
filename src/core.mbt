///|
/// zag.js FFI コア関数
/// js.mbt の設計思想に沿って実装
/// 参考: https://zenn.dev/mizchi/articles/moonbit-js-ffi

// ============================================================
// JavaScript オブジェクト操作ユーティリティ
// ============================================================

///|
/// JavaScript の空オブジェクトを作成
pub fn js_new_object() -> @js.Any {
  @js.new_object()
}

///|
/// プロパティを設定
pub extern "js" fn js_set(obj : @js.Any, key : String, value : @js.Any) -> Unit =
  #| (obj, key, value) => { obj[key] = value }

///|
/// プロパティを取得
pub extern "js" fn js_get(obj : @js.Any, key : String) -> @js.Any =
  #| (obj, key) => obj[key]

///|
/// 配列を作成
pub fn js_array() -> @js.Any {
  @js.new_array()
}

///|
/// 配列に要素を追加
pub extern "js" fn js_array_push(arr : @js.Any, value : @js.Any) -> Unit =
  #| (arr, value) => arr.push(value)

///|
/// console.log に出力
pub extern "js" fn console_log(obj : @js.Any) -> Unit =
  #| (v) => console.log(v)

///|
/// 任意の値をログに出力するヘルパー
pub fn log[T](value : T) -> Unit {
  console_log(@js.any(value))
}

// ============================================================
// Service 操作用 FFI 関数
// ============================================================

///|
/// service.send(event) を呼び出す
pub extern "js" fn js_service_send(service : @js.Any, event : @js.Any) -> Unit =
  #| (service, event) => service.send(event)

///|
/// service.state を取得
pub extern "js" fn js_service_get_state(service : @js.Any) -> @js.Any =
  #| (service) => service.state

///|
/// service.getContext() を呼び出す
pub extern "js" fn js_service_get_context(service : @js.Any) -> @js.Any =
  #| (service) => service.getContext()

///|
/// service.subscribe(callback) を呼び出す
pub extern "js" fn js_service_subscribe(
  service : @js.Any,
  callback : @js.Any
) -> @js.Any =
  #| (service, callback) => service.subscribe(callback)

// ============================================================
// Connect 操作用 FFI 関数
// ============================================================

///|
/// normalize.connect(service, normalize) を呼び出す
pub extern "js" fn js_normalize_connect(
  normalize : @js.Any,
  service : @js.Any,
  normalize_arg : @js.Any
) -> @js.Any =
  #| (normalize, service, normalizeArg) => normalize.connect(service, normalizeArg)

// ============================================================
// 型安全なラッパー
// ============================================================

///|
/// zag.js Service を表す不透明型
#external
pub(all) type Service

///|
/// Service を作成（machine 関数の結果から）
pub fn Service::from_js(js_value : @js.Any) -> Service = "%identity"

///|
/// Service を JS 値に変換
pub fn Service::to_js(self : Service) -> @js.Any = "%identity"

///|
/// Connect API を表す不透明型
#external
pub(all) type Api

///|
/// API を JS 値から作成
pub fn Api::from_js(js_value : @js.Any) -> Api = "%identity"

///|
/// API を JS 値に変換
pub fn Api::to_js(self : Api) -> @js.Any = "%identity"
