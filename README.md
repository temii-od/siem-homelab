
# A Fintech SIEM Homelab

A dockerized Security Information and Event Management (SIEM) lab 
built to simulate and detect real-world attack patterns against a 
fintech payment API.

## The Problem 

Security teams at fintech companies like payment processors and 
digital banks face a constant stream of threats — credential 
stuffing, unauthorized API access, privilege escalation, and 
injection attacks. Without a proper SIEM in place, these attacks 
go undetected until significant damage is done.

## The Solution

This lab simulates a real fintech SOC environment using the ELK 
stack. It ingests logs from a simulated payment API, parses and 
enriches them through a security-aware pipeline, and surfaces 
attack patterns through a live Kibana dashboard — giving analysts 
the visibility they need to detect and respond to threats in 
real time.

## Features
* Dockerized ELK Stack: Elasticsearch, Logstash, and Kibana 
  running in isolated containers with a single command setup
* Fintech Attack Simulation: Bash script generating 200+ 
  realistic log events across attack scenarios
* Security-Aware Pipeline: Logstash pipeline that parses raw 
  logs, extracts fields, and automatically tags suspicious events 
  by severity
* Live Security Dashboard: Four Kibana visualizations giving 
  instant visibility into attack patterns
* OWASP Top 10 Coverage: SQL injection and path traversal 
  attacks simulated and detected
* Network Segmentation: All containers isolated on a private 
  Docker bridge network

## 🎯 Attack Scenarios Simulated

| Attack Type | Description | Response Code |
|---|---|---|
| Credential Stuffing | 50+ login attempts from single attacker IP | 401 |
| Unauthorized Transfer | Repeated payment API abuse after account compromise | 403 |
| Privilege Escalation | Admin endpoint probing by low-privilege user | 403 |
| SQL Injection | `admin'--` payload in login endpoint | 500 |
| Path Traversal | `../../../../etc/passwd` via profile endpoint | 500 |
| Fraudulent Transfer | `amount=99999999` parameter tampering | 500 |
| Normal Traffic | Legitimate user activity as baseline | 200 |



## Tech Stack
* SIEM Platform: ELK Stack (Elasticsearch, Logstash, Kibana)
* Log Ingestion: Logstash with Grok parsing pipeline
* Storage & Search: Elasticsearch 8.13
* Visualization: Kibana 8.13
* Containerization: Docker
* Log Generation: Bash scripting
* Networking: TCP log shipping via Netcat



## 📊 Security Dashboard

The Kibana dashboard includes four visualizations:
- **HTTP Response Code Breakdown** — Donut chart showing 
  distribution of 200/401/403/500 responses revealing that over 
  65% of traffic is malicious
- **Top IP Addresses by Request Count** — Bar chart exposing 
  attacker IP `185.220.101.47` as the dominant traffic source
- **Total Unauthorized Access Attempts** — Real-time metric tile 
  showing total 401 count
- **Top Targeted Endpoints** — Table of most attacked API 
  endpoints including injection and traversal payloads


## Getting Started
Follow these instructions to get the full SIEM lab running locally on your machine.


### Prerequisites
* Docker Engine
* Docker Compose v2
* Git
* Netcat (`nc`)


### 1. Clone the repository
```bash
git clone https://github.com/your-username/siem-homelab.git
cd siem-homelab
```

### 2. Start the ELK Stack
```bash
docker compose up -d
```

wait till all the containers are healthy
```bash
docker compose ps
```

### 3. Generate Attack Simulation Logs
```bash
bash logs/generate_logs.sh
```

### 4. Send Logs to Logstash
```bash
cat logs/sample.log | nc -w 1 localhost 5000
```

### 5. Verify Logs Reached Elasticsearch
```bash
curl "http://localhost:9200/fintech-logs-*/_count
```

### 6. Open Kibana Dashboard
``` 
http://localhost:5601
```


Learned a lot building this. Made with 🛡️ by Temiloluwa




