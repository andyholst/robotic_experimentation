FROM python:3.8

WORKDIR /app

COPY robot_prototype/ .

RUN pip install -r requirements.txt
RUN python setup.py install

CMD ["python", "-m", "robot_prototype.robot_node"]