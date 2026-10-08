Matrix multiplyWinograd(const Matrix &matrixA, const Matrix &matrixB) {
  size_t nRows = matrixA.size();
  size_t nInner = matrixB.size();
  size_t nCols = matrixB[0].size();
  size_t half = nInner / 2;

  std::vector<int> rowFactor(nRows, 0);
  for (size_t i = 0; i < nRows; ++i) {
    for (size_t k = 0; k < half * 2; k += 2) {
      rowFactor[i] += matrixA[i][k] * matrixA[i][k + 1];
    }
  }

  std::vector<int> colFactor(nCols, 0);
  for (size_t j = 0; j < nCols; ++j) {
    for (size_t k = 0; k < half * 2; k += 2) {
      colFactor[j] += matrixB[k][j] * matrixB[k + 1][j];
    }
  }

  Matrix result(nRows, MatrixRow(nCols, 0));
  for (size_t i = 0; i < nRows; ++i) {
    for (size_t j = 0; j < nCols; ++j) {
      int sum = -rowFactor[i] - colFactor[j];
      for (size_t k = 0; k < half * 2; k += 2) {
        sum += (matrixA[i][k] + matrixB[k + 1][j]) *
               (matrixA[i][k + 1] + matrixB[k][j]);
      }
      if (nInner % 2 != 0) {
        sum += matrixA[i][nInner - 1] * matrixB[nInner - 1][j];
      }
      result[i][j] = sum;
    }
  }

  return result;
}
