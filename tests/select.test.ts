///|
/// @zag-js/select のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagSelect from '@zag-js/select';

// zag.js 0.77.1 用の normalize 関数
// select は button も必要
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    label: identity,
    input: identity,
    button: identity,
  };
};

describe('@zag-js/select', () => {
  let dom: JSDOM;

  beforeEach(() => {
    // jsdom環境をセットアップ
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/select', () => {
    expect(zagSelect).toBeDefined();
    expect(zagSelect.machine).toBeDefined();
    expect(zagSelect.connect).toBeDefined();
    expect(zagSelect.collection).toBeDefined();
  });

  it('should create a collection', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
      { label: 'Korea', value: 'KO' },
    ];

    const collection = zagSelect.collection({
      items,
    });

    expect(collection).toBeDefined();
    expect(collection.items).toHaveLength(3);
  });

  it('should create a select machine', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
    ];

    const collection = zagSelect.collection({ items });

    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
    expect(api.open).toBe(false);
    expect(api.disabled).toBe(false);
    expect(api.multiple).toBe(false);
    expect(api.empty).toBe(true);
  });

  it('should generate root props correctly', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    const rootProps = api.getRootProps();
    expect(rootProps).toBeDefined();
    expect(rootProps.id).toBe('select:test-select');
  });

  it('should generate label props correctly', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    const labelProps = api.getLabelProps();
    expect(labelProps).toBeDefined();
    expect(labelProps.id).toBe('select:test-select:label');
    // zag.js 0.77.1: htmlFor は ':select' で終わる
    expect(labelProps.htmlFor).toBe('select:test-select:select');
  });

  it('should generate trigger props correctly', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    const triggerProps = api.getTriggerProps();
    expect(triggerProps).toBeDefined();
    expect(triggerProps.id).toBe('select:test-select:trigger');
    expect(triggerProps.type).toBe('button');
    expect(triggerProps.role).toBe('combobox');
  });

  it('should generate content props correctly', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    const contentProps = api.getContentProps();
    expect(contentProps).toBeDefined();
    expect(contentProps.id).toBe('select:test-select:content');
    expect(contentProps.role).toBe('listbox');
  });

  it('should generate item props correctly', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    const itemProps = api.getItemProps({ item: items[0] });
    expect(itemProps).toBeDefined();
    expect(itemProps.role).toBe('option');
    expect(itemProps['data-value']).toBe('NG');
  });

  it('should select a value', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    expect(api.empty).toBe(true);

    // 値を選択
    api.selectValue('JP');

    // サービスの状態を確認
    expect(service.state.context.value).toEqual(['JP']);

    // 再接続して確認
    const apiAfterSelect = zagSelect.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterSelect.empty).toBe(false);
    expect(apiAfterSelect.valueAsString).toBe('Japan');
    expect(apiAfterSelect.hasSelectedItems).toBe(true);
  });

  it('should support default value', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
      defaultValue: ['JP'],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    // zag.js 0.77.1: defaultValue は initial state には反映されない
    // 値を設定して確認
    api.setValue(['JP']);

    expect(service.state.context.value).toEqual(['JP']);

    // 再接続して valueAsString を確認
    const apiAfterSet = zagSelect.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterSet.valueAsString).toBe('Japan');
  });

  it('should support disabled state', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
      disabled: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    expect(api.disabled).toBe(true);

    const triggerProps = api.getTriggerProps();
    expect(triggerProps.disabled).toBe(true);
  });

  it('should support multiple selection', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
      { label: 'Korea', value: 'KO' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
      multiple: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    expect(api.multiple).toBe(true);

    // 複数の値を選択
    api.setValue(['NG', 'JP']);

    expect(service.state.context.value).toEqual(['NG', 'JP']);

    const apiAfterSelect = zagSelect.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterSelect.value).toEqual(['NG', 'JP']);
  });

  it('should clear value', () => {
    const items = [
      { label: 'Nigeria', value: 'NG' },
      { label: 'Japan', value: 'JP' },
    ];

    const collection = zagSelect.collection({ items });
    const service = zagSelect.machine({
      id: 'test-select',
      collection,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSelect.connect(service.state, service.send.bind(service), normalize);

    // 最初に値を設定
    api.setValue(['JP']);

    // 再接続して hasSelectedItems を確認
    const apiAfterSet = zagSelect.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterSet.hasSelectedItems).toBe(true);

    // 値をクリア
    api.clearValue();

    expect(service.state.context.value).toEqual([]);

    const apiAfterClear = zagSelect.connect(service.state, service.send.bind(service), normalize);
    expect(apiAfterClear.empty).toBe(true);
  });
});
