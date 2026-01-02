///|
/// @zag-js/tabs のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagTabs from '@zag-js/tabs';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    button: identity,
  };
};

describe('@zag-js/tabs', () => {
  let dom: JSDOM;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/tabs', () => {
    expect(zagTabs).toBeDefined();
    expect(zagTabs.machine).toBeDefined();
    expect(zagTabs.connect).toBeDefined();
  });

  it('should create a tabs machine', () => {
    const service = zagTabs.machine({
      id: 'test-tabs',
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagTabs.machine({
      id: 'test-tabs',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagTabs.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should generate root props correctly', () => {
    const service = zagTabs.machine({
      id: 'test-tabs',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagTabs.connect(service.state, service.send.bind(service), normalize);

    const rootProps = api.getRootProps();
    expect(rootProps).toBeDefined();
    expect(rootProps.id).toBe('tabs:test-tabs');
  });

  it('should generate trigger props correctly', () => {
    const service = zagTabs.machine({
      id: 'test-tabs',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagTabs.connect(service.state, service.send.bind(service), normalize);

    const triggerProps = api.getTriggerProps({ value: 'tab-1' });
    expect(triggerProps).toBeDefined();
    expect(triggerProps.role).toBe('tab');
    expect(triggerProps.type).toBe('button');
  });

  it('should generate content props correctly', () => {
    const service = zagTabs.machine({
      id: 'test-tabs',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagTabs.connect(service.state, service.send.bind(service), normalize);

    const contentProps = api.getContentProps({ value: 'tab-1' });
    expect(contentProps).toBeDefined();
    expect(contentProps.role).toBe('tabpanel');
  });
});
