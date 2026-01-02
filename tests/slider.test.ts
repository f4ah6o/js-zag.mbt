///|
/// @zag-js/slider のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagSlider from '@zag-js/slider';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    label: identity,
    input: identity,
    button: identity,
  };
};

describe('@zag-js/slider', () => {
  let dom: JSDOM;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/slider', () => {
    expect(zagSlider).toBeDefined();
    expect(zagSlider.machine).toBeDefined();
    expect(zagSlider.connect).toBeDefined();
  });

  it('should create a slider machine', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
    expect(api.value).toEqual([50]);
  });

  it('should generate root props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const rootProps = api.getRootProps();
    expect(rootProps).toBeDefined();
    expect(rootProps.id).toBe('slider:test-slider');
  });

  it('should generate label props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const labelProps = api.getLabelProps();
    expect(labelProps).toBeDefined();
    expect(labelProps.id).toBe('slider:test-slider:label');
  });

  it('should generate track props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const trackProps = api.getTrackProps();
    expect(trackProps).toBeDefined();
  });

  it('should generate thumb props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const thumbProps = api.getThumbProps({ index: 0 });
    expect(thumbProps).toBeDefined();
    expect(thumbProps.role).toBe('slider');
    expect(thumbProps['aria-valuemin']).toBe(0);
    expect(thumbProps['aria-valuemax']).toBe(100);
  });

  it('should generate control props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const controlProps = api.getControlProps();
    expect(controlProps).toBeDefined();
  });

  it('should generate range props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const rangeProps = api.getRangeProps();
    expect(rangeProps).toBeDefined();
  });

  it('should generate hidden input props correctly', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    const hiddenInputProps = api.getHiddenInputProps({ index: 0 });
    expect(hiddenInputProps).toBeDefined();
    // zag.js 0.77.1: type is 'text' with inputMode 'numeric'
    expect(hiddenInputProps.type).toBe('text');
  });

  it('should support min and max options', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [25],
      min: 0,
      max: 50,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    expect(api.value).toEqual([25]);
  });

  it('should support step option', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [20],
      step: 5,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should support disabled option', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
      disabled: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should get thumb value', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [75],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    expect(api.getThumbValue(0)).toBe(75);
  });

  it('should set value', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    api.setValue([80]);
    expect(service.state.context.value).toEqual([80]);
  });

  it('should set thumb value', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    api.setThumbValue(0, 90);
    expect(service.state.context.value).toEqual([90]);
  });

  it('should increment thumb value', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    api.increment(0);
    expect(service.state.context.value).toEqual([51]);
  });

  it('should decrement thumb value', () => {
    const service = zagSlider.machine({
      id: 'test-slider',
      value: [50],
    });
    service.start();

    const normalize = createNormalize();
    const api = zagSlider.connect(service.state, service.send.bind(service), normalize);

    api.decrement(0);
    expect(service.state.context.value).toEqual([49]);
  });
});
