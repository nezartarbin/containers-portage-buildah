FROM python:slim

RUN "bash -c 'python -m pip install jinja2 pyyaml'"

CMD "python template.py"
