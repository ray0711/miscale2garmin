FROM python:3
WORKDIR /app

RUN pip3 install paho-mqtt 

COPY bodycomposition ./
COPY Xiaomi_Scale_Body_Metrics.py ./
COPY body_scales.py ./
COPY mqttListener.py ./

CMD python3 /app/mqttListener.py