FROM python:3.6
ENV PYTHONPATH=${PYTHONPATH}:${PWD}
RUN python -m pip install --upgrade pip
RUN pip install poetry

WORKDIR /privacy_aware_parental_control
COPY pyproject.toml /privacy_aware_parental_control

RUN poetry config virtualenvs.create false
RUN poetry install

COPY age_gender_estimation_Privacy.py /privacy_aware_parental_control
COPY age_gender_estimation_Original.py /privacy_aware_parental_control
COPY src /privacy_aware_parental_control
COPY pretrained_models /privacy_aware_parental_control
COPY poetry.lock /privacy_aware_parental_control

CMD \ 
	poetry run black --check . ; \
	poetry run pylint . ; \
	poetry run isort --check --diff . ; \ 
	poetry run flake8 ; \ 
	poetry run coverage run -m pytest age_gender_estimation_Privacy.py && poetry run coverage report -m