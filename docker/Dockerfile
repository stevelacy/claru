FROM factoryx/nodejs:5.1.0

RUN apt-get update && apt-get install libstdc++6

RUN export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/usr/local/lib64:/usr/lib64 && npm rebuild
