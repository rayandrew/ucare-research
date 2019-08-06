# Kafka Memory Usage

## Installation

1. Install JDK8 and Python3

```bash
sudo ./install-java-python.sh
```

2. Install Gradle

```bash
sudo ./install-gradle.sh
```

3. Source env

```bash
source ./env.sh
```

4. Install kafka

```bash
./install-kafka.sh
```

## Running

1. Source env

```bash
source ./env.sh
```

2. Run Kafka

```bash
./run-kafka.sh N # N is number of servers
```

3. Run reader

```bash
python3 reader.py -n N # N is number of servers
```

4. Plot the data

```bash
jupyter lab # open Visualization.ipynb
```

## Results

![kafka-mem-usage](plot.png)
