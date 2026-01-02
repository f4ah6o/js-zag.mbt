///|
/// @zag-js/switch のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagSwitch from '@zag-js/switch';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    label: identity,
    input: identity,
  };
};

describe('@zag-js/switch', () => {
  let dom: JSDOM;

  beforeEach(() => {
    // jsdom環境をセットアップ
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/switch', () => {
    expect(zagSwitch).toBeDefined();
    expect(zagSwitch.machine).toBeDefined();
    expect(zagSwitch.connect).toBeDefined();
  });

  it('should create a switch machine', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
    expect(api.checked).toBe(false);
    expect(api.disabled).toBe(false);
  });

  it('should generate root props correctly', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    const rootProps = api.getRootProps();
    expect(rootProps).toBeDefined();
    expect(rootProps.id).toBe('switch:test-switch');
    expect(rootProps.htmlFor).toBe('switch:test-switch:input');
  });

  it('should generate control props correctly', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    const controlProps = api.getControlProps();
    expect(controlProps).toBeDefined();
    expect(controlProps.id).toBe('switch:test-switch:control');
    expect(controlProps['aria-hidden']).toBe(true);
  });

  it('should generate input props correctly', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
      name: 'toggle',
      value: 'on',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    const inputProps = api.getHiddenInputProps();
    expect(inputProps).toBeDefined();
    expect(inputProps.id).toBe('switch:test-switch:input');
    expect(inputProps.type).toBe('checkbox');
    expect(inputProps.name).toBe('toggle');
    expect(inputProps.value).toBe('on');
    expect(inputProps.defaultChecked).toBe(false);
  });

  it('should toggle checked state', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    expect(api.checked).toBe(false);

    // toggleChecked はイベントを送信する
    api.toggleChecked();

    // サービスの状態を確認（zag.js 0.77.1 は再接続が必要）
    expect(service.state.context.checked).toBe(true);

    // 再接続して確認
    const apiAfterToggle = zagSwitch.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterToggle.checked).toBe(true);

    api.setChecked(false);
    expect(service.state.context.checked).toBe(false);
  });

  it('should support disabled state', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      defaultChecked: false,
      disabled: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    expect(api.disabled).toBe(true);

    const inputProps = api.getHiddenInputProps();
    expect(inputProps.disabled).toBe(true);
  });

  it('should support defaultChecked state', () => {
    const service = zagSwitch.machine({
      id: 'test-switch',
      checked: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSwitch.connect(service.state, service.send.bind(service), normalize);

    // service.state.context.checked で実際の状態を確認
    expect(service.state.context.checked).toBe(true);

    const inputProps = api.getHiddenInputProps();
    expect(inputProps.defaultChecked).toBe(true);
  });
});
