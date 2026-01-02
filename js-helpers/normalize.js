///|
/// Vanilla JS 用の normalize ヘルパー
/// zag.js の connect 関数に渡す

export function createNormalize() {
  const identity = (props) => props;
  return {
    element: identity,
    label: identity,
    input: identity,
    button: identity,
  };
}

///|
/// 関数を引数なしで呼び出すヘルパー
/// MoonBitからJSの関数を呼び出すために使用
export function invokeNoArgs(fn) {
  return fn();
}

///|
/// 関数をBool引数で呼び出すヘルパー
export function invokeWithBool(fn, value) {
  return fn(value);
}

///|
/// 関数をオブジェクト引数で呼び出すヘルパー
/// Select コンポーネントの getItemProps などで使用
export function invokeWithObject(fn, arg) {
  return fn(arg);
}

///|
/// 関数を文字列引数で呼び出すヘルパー
/// Select コンポーネントの selectValue などで使用
export function invokeWithString(fn, value) {
  return fn(value);
}

///|
/// 関数を文字列配列引数で呼び出すヘルパー
/// Select コンポーネントの setValue で使用
export function invokeWithStringArray(fn, arg) {
  return fn(arg);
}
