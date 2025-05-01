import { BoxSizes, CreateBox } from '../src/modules/box';

describe('BoxSizes enum', () => {
  it('should have correct numeric and string values', () => {
    expect(BoxSizes.Small).toBe(40);
    expect(BoxSizes.Medium).toBe(80);
    expect(BoxSizes.Large).toBe(120);
    expect(BoxSizes.BOMB).toBe('BOMB');
  });
});

describe('CreateBox class', () => {
  beforeAll(() => {
    jest.spyOn(global.Math, 'random').mockReturnValue(0);
    document.body.innerHTML = '<div class="wrapper"></div>';
  });

  afterAll(() => {
    (global.Math.random as jest.Mock).mockRestore();
  });

  it('should create a box element with correct attributes', () => {
    const id = 1;
    const size = 50;
    const box = new CreateBox<number>({ id, size });
    expect(box.id).toBe(id);
    expect(box.element).toBeInstanceOf(HTMLDivElement);
    expect(box.element.id).toBe(`box-${id}`);
    expect(box.element.classList.contains('box')).toBe(true);
    expect(box.element.style.width).toBe(`${size}px`);
    expect(box.element.style.height).toBe(`${size}px`);
    expect(box.element.style.backgroundColor).toBe('rgb(0, 0, 0)');
  });

  it('setColor should update the element background color', () => {
    const id = 2;
    const size = 60;
    const box = new CreateBox<number>({ id, size });
    box.setColor('red');
    expect(box.element.style.backgroundColor).toBe('red');
  });
});