# Параметры EC
- p простое , задающее размер конечного поля
- a, b коэффициенты уравнения эллиптической кривой
- Gx, Gy координаты точки, генерирующаей подгруппу
- d - скаляр

# WASM
```
emcc EC/Project1/*.cpp EC/BigInteger.cpp EC/EllipticCurve.cpp EC/point.cpp -O3 -s WASM=1 \
-s EXPORTED_FUNCTIONS="['_mult', '_multDec', '_decToHex', '_hexToDec']" \
-s EXPORTED_RUNTIME_METHODS="['ccall','cwrap']" \
-o my_example/EC.html \
--shell-file assets/shell_minimal.html \
-s ERROR_ON_UNDEFINED_SYMBOLS=0 -s ASSERTIONS=1
```
- -s WASM=1 — Указывает, что мы хотим получить wasm модуль.
- Мы указали -o EC.html, чтобы компилятор генерировал необходимый JavaScript код и .html файл.
- --shell-file assets/shell_minimal.html чтобы компилятор использовал шаблон для создания HTML страницы запускающей этот пример.

# Описание директории
- assets - папка в которой лежим HTML шаблон и JS файл с вызовом WASM функций
- EC - проект на языке C реализующий умножение точки ЭК на скаляр
- example - скомпилированный в WASM проект с Node.JS сервером (для обхода CORS)


