///|
/// @zag-js/dialog のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagDialog from '@zag-js/dialog';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    button: identity,
  };
};

describe('@zag-js/dialog', () => {
  let dom: JSDOM;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/dialog', () => {
    expect(zagDialog).toBeDefined();
    expect(zagDialog.machine).toBeDefined();
    expect(zagDialog.connect).toBeDefined();
  });

  it('should create a dialog machine', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
    expect(api.open).toBe(false);
  });

  it('should generate backdrop props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const backdropProps = api.getBackdropProps();
    expect(backdropProps).toBeDefined();
  });

  it('should generate content props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const contentProps = api.getContentProps();
    expect(contentProps).toBeDefined();
    expect(contentProps.id).toBe('dialog:test-dialog:content');
    expect(contentProps.role).toBe('dialog');
  });

  it('should generate title props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const titleProps = api.getTitleProps();
    expect(titleProps).toBeDefined();
    expect(titleProps.id).toBe('dialog:test-dialog:title');
  });

  it('should generate description props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const descriptionProps = api.getDescriptionProps();
    expect(descriptionProps).toBeDefined();
    expect(descriptionProps.id).toBe('dialog:test-dialog:description');
  });

  it('should generate trigger props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const triggerProps = api.getTriggerProps();
    expect(triggerProps).toBeDefined();
    expect(triggerProps.type).toBe('button');
  });

  it('should generate close trigger props correctly', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    const closeTriggerProps = api.getCloseTriggerProps();
    expect(closeTriggerProps).toBeDefined();
    expect(closeTriggerProps.type).toBe('button');
  });

  it('should support closeOnEscape option', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
      closeOnEscape: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should support trapFocus option', () => {
    const service = zagDialog.machine({
      id: 'test-dialog',
      trapFocus: true,
    });
    service.start();

    const normalize = createNormalize();
    const api = zagDialog.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });
});
