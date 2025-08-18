
splash:
	dart run flutter_native_splash:create --path=splash.yaml 

build:
	dart run build_runner watch -d

test:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html



.PHONY: splash build test