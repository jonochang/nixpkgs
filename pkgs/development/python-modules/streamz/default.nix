{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  confluent-kafka,
  dask,
  dask-expr,
  distributed,
  flaky,
  graphviz,
  networkx,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  six,
  toolz,
  tornado,
  zict,
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VXfWkEwuxInBQVQJV3IQXgGVRkiBmYfUZCBMbjyWNPM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    networkx
    six
    toolz
    tornado
    zict
  ];

  nativeCheckInputs = [
    confluent-kafka
    dask
    dask-expr
    distributed
    flaky
    graphviz
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "streamz" ];

  disabledTests = [
    # Error with distutils version: fixture 'cleanup' not found
    "test_separate_thread_without_time"
    "test_await_syntax"
    "test_partition_then_scatter_sync"
    "test_sync"
    "test_sync_2"
    # Test fail in the sandbox
    "test_tcp_async"
    "test_tcp"
    "test_partition_timeout"
    # Tests are flaky
    "test_from_iterable"
    "test_buffer"
  ];

  disabledTestPaths = [
    # Disable kafka tests
    "streamz/tests/test_kafka.py"
  ];

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
