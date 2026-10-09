#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

#include "matrix.hpp"

// Реализации алгоритмов находятся в отдельных файлах.
Matrix multiplyClassic(const Matrix &matrixA, const Matrix &matrixB);
Matrix multiplyWinogradSimple(const Matrix &matrixA, const Matrix &matrixB);
Matrix multiplyWinograd(const Matrix &matrixA, const Matrix &matrixB);

using Multiply = Matrix (*)(const Matrix &, const Matrix &);

// Размеры матриц и число повторов при замерах.
const size_t minSize = 100;
const size_t maxSize = 500;
const size_t sizeStep = 100;
const int repeats = 10;

// Результат умножения сохраняется сюда, чтобы компилятор не убрал вызов.
volatile int sink = 0;

struct Algorithm {
  std::string name;
  Multiply multiply;
  std::string outputFile;
};

const std::vector<Algorithm> algorithms = {
    {"классический", multiplyClassic, "1.csv"},
    {"Винограда", multiplyWinogradSimple, "2.csv"},
    {"Винограда оптимизированный", multiplyWinograd, "3.csv"},
};

// Проверяет, что матрицы непусты и число столбцов первой равно числу строк второй.
void checkSizes(const Matrix &matrixA, const Matrix &matrixB) {
  if (matrixA.empty() || matrixB.empty() || matrixA[0].empty() || matrixB[0].empty()) {
    throw std::invalid_argument("пустая матрица");
  }
  if (matrixA[0].size() != matrixB.size()) {
    throw std::invalid_argument("несогласованные размеры матриц");
  }
}

Matrix randomMatrix(size_t nRows, size_t nCols, std::mt19937 &generator) {
  std::uniform_int_distribution<int> distribution(-100, 100);
  Matrix matrix(nRows, MatrixRow(nCols));
  for (MatrixRow &row : matrix) {
    for (int &element : row) {
      element = distribution(generator);
    }
  }
  return matrix;
}

// Среднее время умножения квадратных матриц размером size в миллисекундах.
double measure(Multiply multiply, size_t size, std::mt19937 &generator) {
  double total = 0;
  for (int r = 0; r < repeats; ++r) {
    Matrix matrixA = randomMatrix(size, size, generator);
    Matrix matrixB = randomMatrix(size, size, generator);

    auto start = std::chrono::steady_clock::now();
    Matrix result = multiply(matrixA, matrixB);
    auto end = std::chrono::steady_clock::now();

    sink = result[0][0];
    total += std::chrono::duration<double, std::milli>(end - start).count();
  }
  return total / repeats;
}

void runBenchmark() {
  std::mt19937 generator(std::random_device{}());
  for (const Algorithm &algorithm : algorithms) {
    std::ofstream output(algorithm.outputFile);
    for (size_t size = minSize; size <= maxSize; size += sizeStep) {
      double time = measure(algorithm.multiply, size, generator);
      output << size << "," << static_cast<long>(time) << "\n";
      std::cout << algorithm.name << ", " << size << ": " << time << " мс\n";
    }
  }
}

// Тест: две матрицы и ожидаемое произведение.
// Пустое ожидаемое произведение означает, что умножение должно завершиться ошибкой.
struct TestCase {
  Matrix matrixA;
  Matrix matrixB;
  Matrix expected;
};

const std::vector<TestCase> testCases = {
    {{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}},
     {{9, 8, 7}, {6, 5, 4}, {3, 2, 1}},
     {{30, 24, 18}, {84, 69, 54}, {138, 114, 90}}},
    {{{1, 2, 3}, {4, 5, 6}},
     {{7, 8}, {9, 10}, {11, 12}},
     {{58, 64}, {139, 154}}},
    {{{2, 3, 4}},
     {{1}, {2}, {3}},
     {{20}}},
    {{{5}},
     {{-3}},
     {{-15}}},
    {{{1, 0}, {0, 1}},
     {{5, 6}, {7, 8}},
     {{5, 6}, {7, 8}}},
    {{{0, 0}, {0, 0}},
     {{1, 2}, {3, 4}},
     {{0, 0}, {0, 0}}},
    {{{1, 2, 3}, {4, 5, 6}},
     {{1, 2}, {3, 4}},
     {}},
    {{{1}, {2}},
     {{3, 4}},
     {{3, 4}, {6, 8}}},
    {{{-1, 2}, {3, -4}},
     {{2, 0}, {1, -1}},
     {{0, -2}, {2, 4}}},
    {{{2, 3}, {4, 5}},
     {{1, 0}, {0, 1}},
     {{2, 3}, {4, 5}}},
    {{{2, 3}, {4, 5}},
     {{0, 0}, {0, 0}},
     {{0, 0}, {0, 0}}},
    {{{1, 2, 3}, {4, 5, 6}},
     {{1}, {0}, {-1}},
     {{-2}, {-2}}},
    {{{1, 2}},
     {{1, 2, 3}, {4, 5, 6}},
     {{9, 12, 15}}},
    {{{1, 2, 3, 4}, {5, 6, 7, 8}},
     {{1, 0}, {0, 1}, {1, 0}, {0, 1}},
     {{4, 6}, {12, 14}}},
    {{{7, 8}, {9, 10}, {11, 12}},
     {{1, 2, 3}, {4, 5, 6}},
     {{39, 54, 69}, {49, 68, 87}, {59, 82, 105}}},
    {{{2, 0}, {0, 3}},
     {{4, 0}, {0, 5}},
     {{8, 0}, {0, 15}}},
    {{{1, 2}, {0, 3}},
     {{4, 5}, {0, 6}},
     {{4, 17}, {0, 18}}},
    {{{1}, {2}, {3}},
     {{1, -1, 2}},
     {{1, -1, 2}, {2, -2, 4}, {3, -3, 6}}},
    {{{1, 2, 3, 4, 5}},
     {{5}, {4}, {3}, {2}, {1}},
     {{35}}},
    {{{1, 2}, {3, 4}, {5, 6}},
     {{1, 2}, {3, 4}, {5, 6}},
     {}},
    {{},
     {{1, 2}, {3, 4}},
     {}},
};

// Прогоняет все тесты на всех алгоритмах и возвращает число проваленных проверок.
int runTests() {
  int failed = 0;
  for (size_t t = 0; t < testCases.size(); ++t) {
    const TestCase &test = testCases[t];
    for (const Algorithm &algorithm : algorithms) {
      bool passed;
      try {
        checkSizes(test.matrixA, test.matrixB);
        passed = algorithm.multiply(test.matrixA, test.matrixB) == test.expected;
      } catch (const std::invalid_argument &error) {
        std::cout << "Тест " << t + 1 << ": ошибка: " << error.what() << "\n";
        passed = test.expected.empty();
      }
      if (!passed) {
        std::cout << "Тест " << t + 1 << " не пройден, алгоритм " << algorithm.name << "\n";
        ++failed;
      }
    }
  }
  std::cout << "Проваленных проверок: " << failed << "\n";
  return failed;
}

int main(int argc, char *argv[]) {
  if (argc > 1 && std::string(argv[1]) == "--test") {
    return runTests() == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
  }
  runBenchmark();
  return EXIT_SUCCESS;
}
