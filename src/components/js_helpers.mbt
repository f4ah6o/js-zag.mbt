#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_create_normalize() -> @js.Any =
  "createNormalize"

#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_no_args(func : @js.Any) -> @js.Any =
  "invokeNoArgs"

#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any =
  "invokeWithObject"

#module("@f4ah6o/zag-js-helpers/normalize")
extern "js" fn js_invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any =
  "invokeWithBool"

///|
fn create_normalize() -> @js.Any {
  js_create_normalize()
}

///|
fn invoke_no_args(func : @js.Any) -> @js.Any {
  js_invoke_no_args(func)
}

///|
fn invoke_with_object(func : @js.Any, arg : @js.Any) -> @js.Any {
  js_invoke_with_object(func, arg)
}

///|
fn invoke_with_bool(func : @js.Any, value : Bool) -> @js.Any {
  js_invoke_with_bool(func, value)
}
