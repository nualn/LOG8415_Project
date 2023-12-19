from flask import Flask, request
import random
import pymysql
import time
import json

app = Flask(__name__)

# MySQL Cluster Configuration
with open("cluster_info.json", 'r') as file:
    cluster_info = json.load(file)

mysql_master = {"host": cluster_info["manager_addr"], "user": "test",
                "password": "test", "database": "sakila"}
mysql_slaves = [{"host": cluster_info["node1_addr"], "user": "test", "password": "test", "database": "sakila"},
                {"host": cluster_info["node2_addr"], "user": "test",
                    "password": "test", "database": "sakila"},
                {"host": cluster_info["node3_addr"], "user": "test", "password": "test", "database": "sakila"}]


def connect_to_mysql(server):
    return pymysql.connect(host=server['host'], user=server['user'], password=server['password'], database=server['database'])


def is_write_instruction(query):
    # Determine if the query is a write instruction
    write_keywords = ["INSERT", "UPDATE", "DELETE", "ALTER", "CREATE"]
    return any(keyword in query.upper() for keyword in write_keywords)


def direct_hit(query):
    # Function to handle direct hit for write instructions
    try:
        connection = connect_to_mysql(mysql_master)
        cursor = connection.cursor()
        print(query)
        cursor.execute(query)
        result = cursor.fetchall()
        connection.commit()
        cursor.close()
        connection.close()
        return str(result), 200
    except Exception as e:
        return str(e), 500


@app.route('/direct_hit', methods=['POST'])
def direct_hit_route():
    # Forward request to MySQL master node
    try:
        query = request.data.decode('utf-8')
        return direct_hit(query)
    except Exception as e:
        return str(e), 500


@app.route('/random', methods=['POST'])
def random_route():
    # Forward request to a random slave node
    try:
        query = request.data.decode('utf-8')
        if is_write_instruction(query):
            # Use direct_hit function for write instructions
            return direct_hit(query)

        random_slave = random.choice(mysql_slaves)
        connection = connect_to_mysql(random_slave)
        cursor = connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        connection.commit()
        cursor.close()
        connection.close()
        return str(result), 200
    except Exception as e:
        return str(e), 500


@app.route('/customized', methods=['POST'])
def customized_route():
    # Measure ping time of all servers and forward to the one with less response time
    try:
        query = request.data.decode('utf-8')
        if is_write_instruction(query):
            # Use direct_hit function for write instructions
            return direct_hit(query)

        min_ping_time = float('inf')
        selected_server = None

        for server in mysql_slaves:
            start_time = time.time()
            connection = connect_to_mysql(server)
            connection.ping()
            ping_time = time.time() - start_time
            connection.close()

            if ping_time < min_ping_time:
                min_ping_time = ping_time
                selected_server = server

        if selected_server:
            connection = connect_to_mysql(selected_server)
            cursor = connection.cursor()
            cursor.execute(query)
            result = cursor.fetchall()
            connection.commit()
            cursor.close()
            connection.close()
            return str(result), 200
        else:
            return "No available server", 500
    except Exception as e:
        return str(e), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
