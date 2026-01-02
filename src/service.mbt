///|
/// zag.js Service ラッパー
/// MoonBit から使いやすいインターフェースを提供

// ============================================================
// Event 型
// ============================================================

///|
/// イベントを表す構造体
pub(all) struct Event {
  type_ : String
  data : @js.Any?
}

///|
/// 新しいイベントを作成
pub fn Event::new(type_ : String) -> Event {
  { type_, data: None }
}

///|
/// データ付きイベントを作成
pub fn Event::with_data(type_ : String, data : @js.Any) -> Event {
  { type_, data: Some(data) }
}

///|
/// イベントを JS オブジェクトに変換
pub fn Event::to_js(self : Event) -> @js.Any {
  let obj = @js.new_object()
  obj._set("type", @js.any(self.type_))
  match self.data {
    None => ()
    Some(d) => obj._set("data", d)
  }
  obj
}

// ============================================================
// Service ラッパー
// ============================================================

///|
/// zag.js Service のラッパー
pub(all) struct ZagService {
  js_service : @js.Any
}

///|
/// JS の service オブジェクトから ZagService を作成
pub fn ZagService::from_js(js_service : @js.Any) -> ZagService {
  { js_service, }
}

///|
/// イベントを送信
pub fn ZagService::send(self : ZagService, event : Event) -> Unit {
  js_service_send(self.js_service, event.to_js())
}

///|
/// 現在の状態を取得
pub fn ZagService::get_state(self : ZagService) -> @js.Any {
  js_service_get_state(self.js_service)
}

///|
/// コンテキストを取得
pub fn ZagService::get_context(self : ZagService) -> @js.Any {
  js_service_get_context(self.js_service)
}

///|
/// 状態変化を購読
pub fn ZagService::subscribe(
  self : ZagService,
  callback : (@js.Any) -> Unit
) -> @js.Any {
  // js.mbt の from_fn1 を使ってコールバックを JS 関数として渡す
  let js_callback = @js.from_fn1(callback)
  js_service_subscribe(self.js_service, js_callback)
}
