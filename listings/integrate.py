"""Вычисление определённых интегралов методами средних прямоугольников, трапеций и Симпсона.

Программа считает абсолютную погрешность каждого метода для нескольких подынтегральных функций и разного числа отрезков разбиения и записывает результаты в CSV-файл.

Использование:
    python integrate.py [--output errors.csv] [--max-power 10]
    python integrate.py --test
"""

import argparse
import csv
import math
import sys
from typing import Callable, NamedTuple

Function = Callable[[float], float]


class Integrand(NamedTuple):
    """Подынтегральная функция с отрезком интегрирования и точным значением интеграла."""

    name: str
    f: Function
    a: float
    b: float
    exact: float


INTEGRANDS = [
    Integrand("4/(1+x^2)", lambda x: 4 / (1 + x * x), 0.0, 1.0, math.pi),
    Integrand("sin x", math.sin, 0.0, math.pi, 2.0),
    Integrand("e^x", math.exp, 0.0, 1.0, math.e - 1),
    Integrand("sqrt x", math.sqrt, 0.0, 1.0, 2 / 3),
]


def rectangles(f: Function, a: float, b: float, n: int) -> float:
    """Составная формула средних прямоугольников на n отрезках."""
    h = (b - a) / n
    return h * sum(f(a + (i + 0.5) * h) for i in range(n))


def trapezoids(f: Function, a: float, b: float, n: int) -> float:
    """Составная формула трапеций на n отрезках."""
    h = (b - a) / n
    inner = sum(f(a + i * h) for i in range(1, n))
    return h * ((f(a) + f(b)) / 2 + inner)


def simpson(f: Function, a: float, b: float, n: int) -> float:
    """Составная формула Симпсона на n отрезках, n должно быть чётным."""
    if n % 2 != 0:
        raise ValueError(f"для формулы Симпсона нужно чётное число отрезков, получено {n}")
    h = (b - a) / n
    odd = sum(f(a + i * h) for i in range(1, n, 2))
    even = sum(f(a + i * h) for i in range(2, n, 2))
    return h / 3 * (f(a) + f(b) + 4 * odd + 2 * even)


METHODS = [rectangles, trapezoids, simpson]


def errors(integrand: Integrand, n: int) -> list[float]:
    """Абсолютные погрешности всех методов для функции integrand на n отрезках."""
    f, a, b = integrand.f, integrand.a, integrand.b
    return [abs(method(f, a, b, n) - integrand.exact) for method in METHODS]


def write_errors(path: str, max_power: int) -> None:
    """Записывает погрешности для n = 2, 4, ..., 2^max_power в CSV-файл path."""
    with open(path, "w", newline="") as file:
        writer = csv.writer(file)
        for index, integrand in enumerate(INTEGRANDS):
            for power in range(1, max_power + 1):
                n = 2**power
                writer.writerow([index, n, *(f"{e:.3e}" for e in errors(integrand, n))])


def run_tests() -> bool:
    """Проверяет методы на многочленах, которые они интегрируют точно, и возвращает признак успеха."""
    cases = [
        ("прямоугольники, линейная функция", rectangles, lambda x: 3 * x + 1, 2, 8.0),
        ("трапеции, линейная функция", trapezoids, lambda x: 3 * x + 1, 2, 8.0),
        ("Симпсон, кубическая функция", simpson, lambda x: x**3 - x, 2, 2.0),
        ("Симпсон, квадратичная функция", simpson, lambda x: x * x, 4, 8 / 3),
    ]
    ok = True
    for name, method, f, n, expected in cases:
        result = method(f, 0.0, 2.0, n)
        passed = math.isclose(result, expected, rel_tol=1e-12)
        ok = ok and passed
        print(f"{'OK  ' if passed else 'FAIL'} {name}: {result} (ожидалось {expected})")
    try:
        simpson(math.sin, 0.0, 1.0, 3)
        print("FAIL Симпсон, нечётное число отрезков: нет ошибки")
        ok = False
    except ValueError:
        print("OK   Симпсон, нечётное число отрезков: ошибка")
    return ok


def main() -> int:
    """Разбирает аргументы командной строки, выполняет тесты или замеры и возвращает код завершения."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--output", default="errors.csv", help="файл для записи погрешностей")
    parser.add_argument("--max-power", type=int, default=10, help="наибольшая степень двойки в числе отрезков")
    parser.add_argument("--test", action="store_true", help="запустить проверки вместо замеров")
    args = parser.parse_args()

    if args.test:
        return 0 if run_tests() else 1
    write_errors(args.output, args.max_power)
    return 0


if __name__ == "__main__":
    sys.exit(main())
