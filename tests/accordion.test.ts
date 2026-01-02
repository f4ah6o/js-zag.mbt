///|
/// @zag-js/accordion のテスト
/// npmパッケージが正しくインストールされ、動作することを確認

import { describe, it, expect, beforeEach } from 'vitest';
import { JSDOM } from 'jsdom';
import * as zagAccordion from '@zag-js/accordion';

// zag.js 0.77.1 用の normalize 関数
const createNormalize = () => {
  const identity = (props: unknown) => props;
  return {
    element: identity,
    button: identity,
  };
};

describe('@zag-js/accordion', () => {
  let dom: JSDOM;

  beforeEach(() => {
    dom = new JSDOM('<!DOCTYPE html><html><body></body></html>');
    global.document = dom.window.document;
    global.window = dom.window as any;
  });

  it('should import @zag-js/accordion', () => {
    expect(zagAccordion).toBeDefined();
    expect(zagAccordion.machine).toBeDefined();
    expect(zagAccordion.connect).toBeDefined();
  });

  it('should create an accordion machine', () => {
    const service = zagAccordion.machine({
      id: 'test-accordion',
    });

    expect(service).toBeDefined();
    expect(service.state).toBeDefined();
    expect(service.send).toBeDefined();
  });

  it('should connect and return API', () => {
    const service = zagAccordion.machine({
      id: 'test-accordion',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagAccordion.connect(service.state, service.send.bind(service), normalize);

    expect(api).toBeDefined();
  });

  it('should generate root props correctly', () => {
    const service = zagAccordion.machine({
      id: 'test-accordion',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagAccordion.connect(service.state, service.send.bind(service), normalize);

    const rootProps = api.getRootProps();
    expect(rootProps).toBeDefined();
    expect(rootProps.id).toBe('accordion:test-accordion');
  });

  it('should generate item props correctly', () => {
    const service = zagAccordion.machine({
      id: 'test-accordion',
    });
    service.start();

    const normalize = createNormalize();
    const api = zagAccordion.connect(service.state, service.send.bind(service), normalize);

    const itemProps = api.getItemProps({ value: 'item-1' });
    expect(itemProps).toBeDefined();
  });
});
