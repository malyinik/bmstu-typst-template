Matrix multiplyClassic(const Matrix &matrixA, const Matrix &matrixB) {
  size_t nRowsA = matrixA.size();
  size_t nColsA = matrixA[0].size();
  size_t nColsB = matrixB[0].size();
  Matrix result(nRowsA, MatrixRow(nColsB, 0));

  for (size_t i = 0; i < nRowsA; ++i) {
    for (size_t j = 0; j < nColsB; ++j) {
      for (size_t k = 0; k < nColsA; ++k) {
        result[i][j] += matrixA[i][k] * matrixB[k][j];
      }
    }
  }

  return result;
}
