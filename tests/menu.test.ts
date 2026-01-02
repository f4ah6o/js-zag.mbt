///|
/// @zag-js/menu のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagMenu from '@zag-js/menu';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    button: identity,
  };
};

describe('@zag-js/menu', () => {
  let dom: JSDOM;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/menu', () => {
    expect(zagMenu).toBeDefined();
    expect(zagMenu.machine).toBeDefined();
    expect(zagMenu.connect).toBeDefined();
  });

  it('should create a menu machine', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagMenu.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
    expect(api.open).toBe(false);
  });

  it('should generate trigger props correctly', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagMenu.connect(service.state, service.send.bind(service), normalize);

    const triggerProps = api.getTriggerProps();
    expect(triggerProps).toBeDefined();
    expect(triggerProps.id).toBe('menu:test-menu:trigger');
    expect(triggerProps.type).toBe('button');
  });

  it('should generate content props correctly', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagMenu.connect(service.state, service.send.bind(service), normalize);

    const contentProps = api.getContentProps();
    expect(contentProps).toBeDefined();
    expect(contentProps.id).toBe('menu:test-menu:content');
    expect(contentProps.role).toBe('menu');
  });

  it('should support closeOnSelect option', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
      closeOnSelect: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagMenu.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should support loop option', () => {
    const service = zagMenu.machine({
      id: 'test-menu',
      loop: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagMenu.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should create menu item machine', () => {
    const itemService = zagMenu.machine({
      id: 'test-menu-item',
    });

    expect(itemService).toBeDefined();
  });

  it('should connect menu item and return API', () => {
    const itemService = zagMenu.machine({
      id: 'test-menu-item',
    });
    itemService.start();

    const normalize = createNormalize();
    const itemApi = zagMenu.connect(itemService.state, itemService.send.bind(itemService), normalize);

    expect(itemApi).toBeDefined();
  });
});
