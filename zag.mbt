///|
/// zag - MoonBit ステートマシンライブラリ
/// js.mbt の設計思想に沿って実装

// ============================================================
// Core 型定義
// ============================================================

///|
/// State を識別するための Trait
pub trait StateId {
  to_string(Self) -> String
}

///|
/// 状態の基本構造
pub(all) struct State[S] {
  value : S
  tags : Array[String]
}

///|
/// 新しい State を作成
pub fn[S] State::new(value : S) -> State[S] {
  { value, tags: [] }
}

///|
/// 状態が指定した値と一致するかチェック
pub fn[S : StateId] State::matches(self : State[S], target : S) -> Bool {
  self.value.to_string() == target.to_string()
}

///|
/// 状態の文字列表現を取得
pub fn[S : StateId] State::to_string(self : State[S]) -> String {
  self.value.to_string()
}

// ============================================================
// Event 型定義
// ============================================================

///|
/// イベントの基本構造（zag.js に合わせて文字列ベース）
pub(all) struct Event {
  type_ : String
  data : @js.Any
}

///|
/// 新しい Event を作成
pub fn Event::new(type_ : String) -> Event {
  { type_, data: @js.undefined() }
}

///|
/// データ付きで新しい Event を作成
pub fn Event::with_data(type_ : String, data : @js.Any) -> Event {
  { type_, data }
}

///|
/// イベントタイプの文字列表現を取得
pub fn Event::type_string(self : Event) -> String {
  self.type_
}

// ============================================================
// Bindable（リアクティブ値）
// ============================================================

///|
/// リアクティブな値を管理する
pub(all) struct Bindable[T] {
  mut value : T
  mut subscribers : Array[(T) -> Unit]
}

///|
/// 新しい Bindable を作成
pub fn[T] Bindable::new(initial : T) -> Bindable[T] {
  { value: initial, subscribers: [] }
}

///|
/// 現在の値を取得
pub fn[T] Bindable::get(self : Bindable[T]) -> T {
  self.value
}

///|
/// 値を設定（購読者に通知）
pub fn[T] Bindable::set(self : Bindable[T], value : T) -> Unit {
  self.value = value
  for subscriber in self.subscribers {
    subscriber(value)
  }
}

///|
/// 値の変更を購読
pub fn[T] Bindable::subscribe(
  self : Bindable[T],
  callback : (T) -> Unit
) -> (() -> Unit) {
  self.subscribers.push(callback)
  fn() {
    // 簡易実装：実際には購読解除ロジックが必要
    ()
  }
}

// ============================================================
// Machine 設定
// ============================================================

///|
/// 遷移定義
pub(all) struct TransitionDef[S] {
  target : S?
  guard_fn : String?
  actions : Array[String]
}

///|
/// 新しい TransitionDef を作成
pub fn[S] TransitionDef::new() -> TransitionDef[S] {
  { target: None, guard_fn: None, actions: [] }
}

///|
/// 遷移先を設定
pub fn[S] TransitionDef::to(self : TransitionDef[S], target : S) -> TransitionDef[S] {
  { target: Some(target), guard_fn: self.guard_fn, actions: self.actions }
}

///|
/// 状態ごとの設定
pub(all) struct StateConfig[S] {
  tags : Array[String]
  on : Map[String, Array[TransitionDef[S]]]
  entry : Array[String]
  exit : Array[String]
}

///|
/// 新しい StateConfig を作成
pub fn[S] StateConfig::new() -> StateConfig[S] {
  { tags: [], on: {}, entry: [], exit: [] }
}

///|
/// タグを設定
pub fn[S] StateConfig::with_tags(self : StateConfig[S], tags : Array[String]) -> StateConfig[S] {
  { tags, on: self.on, entry: self.entry, exit: self.exit }
}

///|
/// イベントハンドラを追加（可変 Map を使用）
pub fn[S] StateConfig::on(
  self : StateConfig[S],
  event : String,
  transition : TransitionDef[S]
) -> StateConfig[S] {
  let mut on_map = self.on
  let handlers = match on_map.get(event) {
    None => []
    Some(h) => h
  }
  let new_handlers = []
  for h in handlers {
    new_handlers.push(h)
  }
  new_handlers.push(transition)
  on_map.set(event, new_handlers)
  { tags: self.tags, on: on_map, entry: self.entry, exit: self.exit }
}

///|
/// Entry Action を設定
pub fn[S] StateConfig::with_entry(self : StateConfig[S], actions : Array[String]) -> StateConfig[S] {
  { tags: self.tags, on: self.on, entry: actions, exit: self.exit }
}

///|
/// Exit Action を設定
pub fn[S] StateConfig::with_exit(self : StateConfig[S], actions : Array[String]) -> StateConfig[S] {
  { tags: self.tags, on: self.on, entry: self.entry, exit: actions }
}

// ============================================================
// Machine 定義
// ============================================================

///|
/// Guard 関数の型
pub type GuardFn[C] = (C) -> Bool

///|
/// Action 関数の型
pub type ActionFn[C] = (C, Event) -> Unit

///|
/// 実装（Guards, Actions）
pub(all) struct Implementations[C] {
  guards : Map[String, GuardFn[C]]
  actions : Map[String, ActionFn[C]]
}

///|
/// 新しい Implementations を作成
pub fn[C] Implementations::new() -> Implementations[C] {
  { guards: {}, actions: {} }
}

///|
/// Guard を追加（可変 Map を使用）
pub fn[C] Implementations::with_guard(
  self : Implementations[C],
  name : String,
  guard_fn : GuardFn[C]
) -> Implementations[C] {
  let mut guards_map = self.guards
  guards_map.set(name, guard_fn)
  { guards: guards_map, actions: self.actions }
}

///|
/// Action を追加（可変 Map を使用）
pub fn[C] Implementations::with_action(
  self : Implementations[C],
  name : String,
  action_fn : ActionFn[C]
) -> Implementations[C] {
  let mut actions_map = self.actions
  actions_map.set(name, action_fn)
  { guards: self.guards, actions: actions_map }
}

///|
/// Machine の設定構造
pub(all) struct MachineConfig[S, C] {
  id : String
  initial : S
  context : C
  states : Map[String, StateConfig[S]]
  implementations : Implementations[C]
}

///|
/// Machine を構築するビルダー関数
pub fn[S, C] machine(
  id~ : String,
  initial~ : S,
  context~ : C,
  states~ : Map[String, StateConfig[S]],
  implementations~ : Implementations[C]
) -> MachineConfig[S, C] {
  { id, initial, context, states, implementations }
}

// ============================================================
// Service（実行時）
// ============================================================

///|
/// 実行時サービス
pub(all) struct Service[S, C] {
  id : String
  state : Bindable[State[S]]
  context : Bindable[C]
  config : MachineConfig[S, C]
  mut started : Bool
}

///|
/// Service を作成
pub fn[S, C] Service::create(config : MachineConfig[S, C]) -> Service[S, C] {
  let initial_state = State::new(config.initial)
  {
    id: config.id,
    state: Bindable::new(initial_state),
    context: Bindable::new(config.context),
    config,
    started: false
  }
}

///|
/// Service を開始
pub fn[S : StateId, C] Service::start(self : Service[S, C]) -> Unit {
  if self.started {
    return
  }
  self.started = true

  let state_key = self.config.initial.to_string()
  match self.config.states.get(state_key) {
    None => ()
    Some(state_config) => {
      for action_name in state_config.entry {
        self.execute_action(action_name)
      }
    }
  }
}

///|
/// 現在の状態を取得
pub fn[S, C] Service::get_state(self : Service[S, C]) -> State[S] {
  self.state.get()
}

///|
/// 現在のコンテキストを取得
pub fn[S, C] Service::get_context(self : Service[S, C]) -> C {
  self.context.get()
}

///|
/// イベントを送信
pub fn[S : StateId, C] Service::send(self : Service[S, C], event : Event) -> Unit {
  let current_state = self.state.get()
  let state_key = current_state.value.to_string()
  let event_type = event.type_

  match self.config.states.get(state_key) {
    None => ()
    Some(state_config) => {
      match state_config.on.get(event_type) {
        None => ()
        Some(transitions) => {
          for transition in transitions {
            if self.check_guard(transition.guard_fn) {
              self.execute_transition(transition, event)
              break
            }
          }
        }
      }
    }
  }
}

///|
/// 状態変更を購読
pub fn[S, C] Service::subscribe_state(
  self : Service[S, C],
  callback : (State[S]) -> Unit
) -> (() -> Unit) {
  self.state.subscribe(callback)
}

// 内部ヘルパー関数

///|
/// Guard をチェック
pub fn[S, C] Service::check_guard(self : Service[S, C], guard_key : String?) -> Bool {
  match guard_key {
    None => true
    Some(key) => {
      match self.config.implementations.guards.get(key) {
        None => true
        Some(guard_fn) => guard_fn(self.context.get())
      }
    }
  }
}

///|
/// 遷移を実行
pub fn[S : StateId, C] Service::execute_transition(
  self : Service[S, C],
  transition : TransitionDef[S],
  event : Event
) -> Unit {
  let current_state = self.state.get()
  let current_key = current_state.value.to_string()

  // exit アクションを実行
  match self.config.states.get(current_key) {
    None => ()
    Some(state_config) => {
      for action_name in state_config.exit {
        self.execute_action(action_name)
      }
    }
  }

  // 状態を更新
  let new_value = match transition.target {
    None => current_state.value
    Some(t) => t
  }

  let new_state = State::new(new_value)
  self.state.set(new_state)

  // 遷移アクションを実行
  for action_name in transition.actions {
    self.execute_action_with_event(action_name, event)
  }

  // entry アクションを実行
  let new_key = new_value.to_string()
  match self.config.states.get(new_key) {
    None => ()
    Some(state_config) => {
      for action_name in state_config.entry {
        self.execute_action(action_name)
      }
    }
  }
}

///|
/// Action を実行（イベントなし）
pub fn[S, C] Service::execute_action(self : Service[S, C], action_name : String) -> Unit {
  match self.config.implementations.actions.get(action_name) {
    None => ()
    Some(action_fn) => {
      let dummy_event = Event::new("")
      action_fn(self.context.get(), dummy_event)
    }
  }
}

///|
/// Action を実行（イベント付き）
pub fn[S, C] Service::execute_action_with_event(
  self : Service[S, C],
  action_name : String,
  event : Event
) -> Unit {
  match self.config.implementations.actions.get(action_name) {
    None => ()
    Some(action_fn) => action_fn(self.context.get(), event)
  }
}

// ============================================================
// Connect（DOM 属性生成）
// ============================================================

///|
/// DOM 属性の型
pub type DOMProps = @js.Any

///|
/// Connect の結果 API
pub(all) struct Api[S, C] {
  state : State[S]
  context : C
  send : (Event) -> Unit
  props : DOMProps
}

///|
/// 空の DOMProps を作成
pub fn dom_props_new() -> DOMProps {
  @js.new_object()
}

///|
/// data-state 属性を生成
pub fn data_state_attr(state : String) -> (String, @js.Any) {
  ("data-state", @js.any(state))
}

// ============================================================
// 例: Toggle コンポーネント
// ============================================================

///|
/// Toggle の状態
enum ToggleState {
  On
  Off
}

impl StateId for ToggleState with to_string(self) {
  match self {
    On => "on"
    Off => "off"
  }
}

///|
/// Toggle のコンテキスト
pub(all) struct ToggleContext {
  disabled : Bool
  label : String
}

///|
/// Toggle Machine を作成（例）
pub fn toggle_machine_example(id~ : String) -> MachineConfig[ToggleState, ToggleContext] {
  // off 状態
  let off_state = StateConfig::new()
    |> StateConfig::with_tags(["idle"])
    |> StateConfig::on("TOGGLE", TransitionDef::new().to(On))
    |> StateConfig::on("SET_ON", TransitionDef::new().to(On))

  // on 状態
  let on_state = StateConfig::new()
    |> StateConfig::with_tags(["pressed"])
    |> StateConfig::on("TOGGLE", TransitionDef::new().to(Off))
    |> StateConfig::on("SET_OFF", TransitionDef::new().to(Off))
    |> StateConfig::with_entry(["logOn"])
    |> StateConfig::with_exit(["logOff"])

  // Implementations
  let impls = Implementations::new()
    |> Implementations::with_action("logOn", fn(ctx : ToggleContext, _event : Event) {
      @js.log(@js.any("Toggle turned ON: " + ctx.label))
    })
    |> Implementations::with_action("logOff", fn(ctx : ToggleContext, _event : Event) {
      @js.log(@js.any("Toggle turned OFF: " + ctx.label))
    })

  machine(
    id=id,
    initial=Off,
    context={ disabled: false, label: "Toggle" },
    states={
      "off": off_state,
      "on": on_state,
    },
    implementations=impls,
  )
}

///|
/// Toggle の使用例
pub fn example_toggle() -> Unit {
  let machine = toggle_machine_example(id="my-toggle")
  let service = Service::create(machine)
  service.start()

  // 状態を購読して変更をログに出力
  service.subscribe_state(fn(state) {
    @js.log(@js.any("State changed to: " + state.to_string()))
  }) |> ignore

  // 初期状態を確認
  let initial_state = service.get_state()
  @js.log(@js.any("Initial state: " + initial_state.to_string()))

  // Toggle イベントを送信
  service.send(Event::new("TOGGLE"))

  // 状態を確認
  let new_state = service.get_state()
  @js.log(@js.any("After toggle: " + new_state.to_string()))

  // もう一度 Toggle
  service.send(Event::new("TOGGLE"))

  // 最終状態を確認
  let final_state = service.get_state()
  @js.log(@js.any("Final state: " + final_state.to_string()))
}
