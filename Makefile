.PHONY: test

deps:
			pip install -r requirements.txt; \
			pip install -r test_requirements.txt

lint:
			flake8 hello_world test

test:
			PYTHONPATH=. py.test --verbose -s

USERNAME=milka0411
TAG=$(USERNAME)/hello-world-printer

docker_build:
			docker build -t hello-world-printer .

docker_run:	docker_build
			docker run \
				--name hello-world-printer-dev \
				-p 5000:5000 \
				-d hello-world-printer

docker_push: docker_build
			@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
			docker tag hello-world-printer $(TAG); \
			docker push $(TAG); \
			docker logout;

			#test coverage
			#test_cov – wywłanie coverage z wypisaniem raportu na ekran
			test_cov:
				PYTHONPATH=. py.test --verbose -s --cov=.
			#test_xunit – generacja xunit i coverage
			test_xunit:
				PYTHONPATH=. py.test -s --cov=. --cov-report xml --junit-xml=test_results.xml
